# Part 6 页面置换算法实现指南

## 一、概述

Part 6 要实现对 mmap 匿名映射区域的**页面置换**，支持 FIFO 和 LRU 两种算法。

核心场景：进程通过 `mmap` 匿名映射了一大片虚拟地址空间（如 32KB = 8 页），但物理内存有限。`set_max_page_in_mem(4)` 限制该进程的 mmap 区域最多同时在内存中持有 **4 页**。当访问第 5 个不同页时，必须选出"最该被换出"的页，将其内容写入交换区，腾出物理页给新访问的页。

---

## 二、数据结构设计

### 2.1 进程字段（`kernel/include/proc.h`）

在 `struct proc` 中新增：

```c
int max_page_in_mem;    // mmap 区域最多能同时在内存中的页数（0 = 不限）
int page_swap_count;     // 换出行为累计次数
```

在 `allocproc()` 中初始化为 0。

### 2.2 VMA 页面级跟踪（`kernel/include/vm.h`）

`struct vm_area` 需要知道它所覆盖的**每一页**的当前状态。新增 per-page 元数据结构：

```c
#define PAGE_STATE_UNUSED   0   // 未访问过（页表无映射）
#define PAGE_STATE_IN_MEM   1   // 已分配物理页，在内存中
#define PAGE_STATE_SWAPPED  2   // 已换出到交换区

struct vma_page {
    uint64 va;              // 该页的起始虚拟地址
    int state;              // PAGE_STATE_UNUSED / _IN_MEM / _SWAPPED
    int swap_slot;          // 在交换区中的 slot 索引（仅 STATE_SWAPPED 时有效）
    uint64 entry_time;      // 进入"在内存中"状态的时刻（用于 FIFO）
    uint64 last_access;     // 末次访问时刻（用于 LRU，由 lru_access_notify 更新）
};
```

然后在 `struct vm_area` 末尾添加：

```c
struct vma_page *pages;     // 指向动态分配的 vma_page 数组（长度 = npages）
int npages;                 // 该 VMA 覆盖的页数
```

`struct vma_page` 和 `pages[]` 数组直接嵌入 `vm_area` 结构体中（见 2.2 节结构定义），因此**无需单独分配**。mmap 创建 VMA 后只需初始化：

```c
// mmap 映射创建 VMA 后，初始化 per-page 元数据
vma->npages = len / PGSIZE;
for (int i = 0; i < vma->npages; i++) {
    vma->pages[i].state = PAGE_STATE_UNUSED;
    vma->pages[i].swap_slot = -1;
    vma->pages[i].entry_time = 0;
    vma->pages[i].last_access = 0;
}
```

> `pages[i].va` 不需要存储，通过 `vma->start + i * PGSIZE` 即可算出。嵌入数组在 VMA 内，伴随 VMA 的整个生命周期，无需额外的 kalloc/kfree。

### 2.3 全局交换区（新建 `kernel/swap.c` + `kernel/include/swap.h`）

```c
// swap.h
#define MAX_SWAP_SLOTS 128

struct swap_slot {
    int used;               // 0 = 空闲, 1 = 已使用
    int pid;                // 所属进程 PID
    uint64 va;              // 对应的虚拟地址（页对齐）
    char data[PGSIZE];      // 换出的页面内容（4KB，PGSIZE 来自 riscv.h）
};

struct {
    struct spinlock lock;
    struct swap_slot slots[MAX_SWAP_SLOTS];
} swap_area;
```

#### 接口

```c
// 初始化交换区
void swap_init(void);

// 分配空闲 slot，返回 slot 索引；无空闲返回 -1
int alloc_global_swap_slot(int pid, uint64 va);

// 释放 slot
void free_global_swap_slot(int slot_idx);

// 通过 pid + va 查找 slot 索引
int find_swap_slot(int pid, uint64 va);
```

---

## 三、系统调用

### 3.1 `sys_set_max_page_in_mem`

```c
// 设置当前进程 mmap 区域的最大驻留页数
uint64 sys_set_max_page_in_mem(void) {
    int n;
    if (argint(0, &n) < 0) return -1;
    myproc()->max_page_in_mem = n;
    return 0;
}
```

### 3.2 `sys_get_swap_count`

```c
// 返回当前进程的累计换出次数
uint64 sys_get_swap_count(void) {
    return myproc()->page_swap_count;
}
```

### 3.3 `sys_lru_access_notify`（仅 LRU 需要）

```c
uint64 sys_lru_access_notify(void) {
    uint64 addr;
    if (argaddr(0, &addr) < 0) return -1;

    struct proc *p = myproc();
    struct vm_area *vma = find_vma(p, addr);
    if (vma == NULL) return -1;

    // 找到对应页的 vma_page 条目，更新 last_access
    int page_idx = (PGROUNDDOWN(addr) - vma->start) / PGSIZE;
    if (page_idx >= 0 && page_idx < vma->npages) {
        vma->pages[page_idx].last_access = ticks;  // 使用全局 ticks 作为时钟
    }
    return 0;
}
```

> LRU 算法的时钟源：`ticks` 是 xv6 内核中由时钟中断递增的全局计数器，精度为 tick（约 10ms），足以区分页面访问的先后顺序。声明 `extern uint ticks;` 即可使用。FIFO 的 `entry_time` 同样使用 `ticks`。

---

## 四、核心算法

### 4.1 页面计数与"是否需要换出"的判断

在 `handle_page_fault` 的 mmap 路径中，分配新页面前，需要检查是否已经达到 `max_page_in_mem` 的阈值：

```c
// 在 handle_page_fault 中，分配物理页前
int in_mem_count = 0;
for (int i = 0; i < vma->npages; i++) {
    if (vma->pages[i].state == PAGE_STATE_IN_MEM)
        in_mem_count++;
}

if (p->max_page_in_mem > 0 && in_mem_count >= p->max_page_in_mem) {
    // 需要换出一页
    int victim = select_victim(vma);
    swap_out(p, vma, victim);
    // 现在 in_mem_count - 1，有空位了
}
// 然后 kalloc + mappages 正常流程
```

### 4.2 FIFO 算法

**选择受害页** `select_victim_page_fifo`：

```c
int select_victim_page_fifo(struct vm_area *vma) {
    int victim = -1;
    uint64 earliest = ~0ULL;  // 最大值

    for (int i = 0; i < vma->npages; i++) {
        if (vma->pages[i].state == PAGE_STATE_IN_MEM) {
            if (vma->pages[i].entry_time < earliest) {
                earliest = vma->pages[i].entry_time;
                victim = i;
            }
        }
    }
    return victim;  // 返回最早进入内存那页的索引
}
```

**换出** `swap_out`：

```c
void swap_out(struct proc *p, struct vm_area *vma, int page_idx) {
    uint64 va = vma->pages[page_idx].va;

    // ① 分配交换区 slot
    int slot = alloc_global_swap_slot(p->pid, va);
    if (slot < 0) panic("swap_out: no free slot");

    // ② 拷贝物理页内容 → 交换区
    pte_t *pte = walk(p->pagetable, va, 0);
    uint64 pa = PTE2PA(*pte);
    memmove(swap_area.slots[slot].data, (void*)pa, PGSIZE);

    // ③ 释放物理页、清除页表映射
    kfree((void*)pa);
    *pte = 0;

    // ④ 更新 vma_page 状态
    vma->pages[page_idx].state = PAGE_STATE_SWAPPED;
    vma->pages[page_idx].swap_slot = slot;

    // ⑤ 累加换出计数
    p->page_swap_count++;
}
```

**换入** `swap_in`：

```c
void swap_in(struct proc *p, struct vm_area *vma, int page_idx) {
    uint64 va = vma->pages[page_idx].va;
    int slot = vma->pages[page_idx].swap_slot;

    // ① 分配新物理页
    char *mem = kalloc();
    if (mem == NULL) panic("swap_in: kalloc failed");

    // ② 拷贝交换区内容 → 新物理页
    memmove(mem, swap_area.slots[slot].data, PGSIZE);

    // ③ 映射到页表
    int perm = PTE_R | PTE_W | PTE_U;
    mappages(p->pagetable, va, PGSIZE, (uint64)mem, perm);
    mappages(p->kpagetable, va, PGSIZE, (uint64)mem, perm);

    // ④ 释放交换区 slot
    free_global_swap_slot(slot);

    // ⑤ 更新 vma_page 状态
    vma->pages[page_idx].state = PAGE_STATE_IN_MEM;
    vma->pages[page_idx].swap_slot = -1;
    vma->pages[page_idx].entry_time = ticks;    // 记录进入时刻
}
```

**FIFO 测试预期**：8 页连续访问模式 `{0,1,2,3,0,1,4,5,0,1,6,7,0,1,2,3}`，`max_page_in_mem=4`。预期共发生 **8 次**换出。

### 4.3 LRU 算法

**选择受害页** `select_victim_page_lru`：

```c
int select_victim_page_lru(struct vm_area *vma) {
    int victim = -1;
    uint64 earliest = ~0ULL;

    for (int i = 0; i < vma->npages; i++) {
        if (vma->pages[i].state == PAGE_STATE_IN_MEM) {
            if (vma->pages[i].last_access < earliest) {
                earliest = vma->pages[i].last_access;
                victim = i;
            }
        }
    }
    return victim;  // 返回最久未访问那页的索引
}
```

> `swap_out` / `swap_in` 与 FIFO 通用，唯一的区别：**FIFO 用 `entry_time` 选 victim，LRU 用 `last_access` 选 victim**。

**LRU 访问时间更新**：测试程序每次写入 mmap 内存后，会调用 `lru_access_notify(addr)`。内核在该函数中更新对应页的 `last_access = ticks`。同时，在 `swap_in` 和首次分配时（PF handler 中）也应设置 `last_access = ticks`。

**LRU 测试预期**：同 8 页访问模式，加上 `lru_access_notify`。预期 **6 次**换出（因为 LRU 利用局部性，常用页保留在内存中）。

---

## 五、handle_page_fault 流程整合

在 `handle_page_fault` 的 mmap 分支中，找到 VMA 之后，加入 Part 6 的页面置换逻辑。完整代码如下：

```c
// handle_page_fault 中的 mmap 分支（找到 vma 之后）
int page_idx = (PGROUNDDOWN(va) - vma->start) / PGSIZE;

#if defined(ALGO_FIFO) || defined(ALGO_LRU)
    // ① 如果该页已被换出，先换入
    if (vma->pages[page_idx].state == PAGE_STATE_SWAPPED) {
        swap_in(p, vma, page_idx);
        return 0;   // 换入成功，返回用户态重试
    }

    // ② 统计当前有多少页在内存中
    int in_mem = 0;
    for (int i = 0; i < vma->npages; i++)
        if (vma->pages[i].state == PAGE_STATE_IN_MEM)
            in_mem++;

    // ③ 如果达到上限，选 victim 换出
    if (p->max_page_in_mem > 0 && in_mem >= p->max_page_in_mem) {
        int victim = select_victim_page(vma);
        if (victim >= 0)
            swap_out(p, vma, victim);
    }
#endif

    // ④ 分配物理页 + 映射（原有逻辑）
    char *mem = kalloc();
    // ... mappages（用户 + 内核页表）...

    // ⑤ 更新 per-page 元数据
#if defined(ALGO_FIFO)
    vma->pages[page_idx].entry_time = ticks;
#elif defined(ALGO_LRU)
    vma->pages[page_idx].last_access = ticks;
#endif
    vma->pages[page_idx].state = PAGE_STATE_IN_MEM;
```

**步骤 ① 是关键**：如果访问的页之前被换出了（`state == SWAPPED`），必须先调用 `swap_in` 从交换区把它拉回内存、重建页表映射，然后直接返回。用户态会重新执行访问指令，此时页表已有效，不再触发 PF。
```

### 条件编译

在 `handle_page_fault` 中，FIFO 和 LRU 的分支可用编译宏隔离：

```c
#ifdef ALGO_FIFO
    // 使用 select_victim_page_fifo, 比较 entry_time
#elif defined(ALGO_LRU)
    // 使用 select_victim_page_lru, 比较 last_access
#endif
```

---

## 六、`switch` 操作符选择

`select_victim` 可以通过一个统一的接口 + 宏来实现代码共享，避免重复 `swap_out` / `swap_in`：

```c
// 共用 swap_out / swap_in，仅 select_victim 不同
#if defined(ALGO_FIFO) || defined(ALGO_LRU)
int select_victim_page(struct vm_area *vma) {
    int victim = -1;
    uint64 best = ~0ULL;
    for (int i = 0; i < vma->npages; i++) {
        if (vma->pages[i].state != PAGE_STATE_IN_MEM) continue;
        uint64 val;
#ifdef ALGO_FIFO
        val = vma->pages[i].entry_time;
#elif defined(ALGO_LRU)
        val = vma->pages[i].last_access;
#endif
        if (val < best) { best = val; victim = i; }
    }
    return victim;
}
#endif
```

---

## 七、与其他模块的交互

| 场景 | 操作 |
|------|------|
| `mmap` | 创建 VMA → 分配 `pages[]` 数组 → 全部初始化为 `PAGE_STATE_UNUSED` |
| `munmap` | 遍历 VMA 的 pages：`IN_MEM` → `kfree` 物理页；`SWAPPED` → `free_global_swap_slot`；释放 `pages[]` 数组 |
| `fork` / `exit` | fork 时子进程的 VMA 页面状态与父进程共享 COW 逻辑；exit 时释放 mmap 区域资源（同 munmap） |

---

## 八、初始化与注册

1. 在 `main.c` 的 `main()` 中调用 `swap_init()`
2. 在 `syscall.c` 中注册三个新系统调用：
   ```c
   [SYS_set_max_page_in_mem] sys_set_max_page_in_mem,
   [SYS_get_swap_count]      sys_get_swap_count,
   [SYS_lru_access_notify]   sys_lru_access_notify,
   ```
3. 在 `sysproc.c` 中实现三个 syscall 函数（`#if defined(ALGO_FIFO) || defined(ALGO_LRU)` 保护）
4. 在 `sysnum.h` 中已定义好 syscall 号（55557, 55558, 55559）
