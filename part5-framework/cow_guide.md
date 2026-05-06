# Part 5 Copy-on-Write (COW) 实现指南

## 一、背景知识

### 1.1 什么是 Copy-on-Write

`fork()` 创建一个与父进程完全相同的子进程。按传统的做法，fork 要把父进程的**每一页物理内存都复制一份**给子进程。在本框架的原生实现中，一次 fork 会新增约 **16 页**的物理内存分配。

COW 的核心思想：**fork 时不复制，让父子共享同一份物理页。只有当其中一个进程真正写入该页时，才触发复制**。

```
fork（无 COW）:
  父 N 页 ──全部复制──→ 子 N 页（新分配 N 页）

fork（COW）:
  父 N 页 ──共享──→ 子 N 页（不新分配）
  任一方写入某页 → PF → 只复制被写的那页 → +1 页
```

### 1.2 为什么需要 refcount

fork 共享后，一个物理页被多个进程的 PTE 引用。某个进程退出时不能直接 `kfree` 该页，否则会破坏另一个进程仍在使用的共享数据。因此需要**每页一个引用计数**：

```
fork:     页 P  refcount = 2 （父子各持一份 PTE 引用）
子写触发COW: 页 P  refcount = 1 （子拿到新页，原页只剩父）
子 exit:   页 P  refcount = 1 （父还在用，kfree 检查后不释放）
           页 Q  refcount = 0 （子的新页，kfree 真正回收）
父写:      页 P  refcount = 1 （仅自己）→ 不用复制，直接恢复写权限
```

### 1.3 COW 只作用于数据页面

本测试只需要对**数据页面**实现 COW，就能节省 fork 时的页面复制开销（原生 fork 会增加约 16 页，COW 后只增加 fork 基础设施的少量页面）。trampoline / 只读段等可以不做优化。

---

## 二、实现步骤

### 步骤 1：定义 PTE_COW + 页引用计数

#### 1a. 新增 PTE 标志位

**`kernel/include/riscv.h`**：使用 RSW 保留位 bit 8：

```c
#define PTE_COW (1L << 8)  // copy-on-write page
```

#### 1b. 页引用计数

**`kernel/kalloc.c`**：添加 per-page 引用计数数组、页号索引函数，以及增/减/查询接口：

```c
// 每页一个引用计数（以物理页号索引，PHYSTOP / PGSIZE = 最大页数）
#define MAX_PAGE ((PHYSTOP) / PGSIZE)
static uint16 pageref[MAX_PAGE];

static inline int pa_index(uint64 pa) {
    return (int)(pa / PGSIZE);
}
```

**修改 `kalloc`**：分配时将新页计数置为 1：

```c
void *kalloc(void) {
    struct run *r;
    acquire(&kmem.lock);
    r = kmem.freelist;
    if (r) {
        kmem.freelist = r->next;
        kmem.npage--;
    }
    release(&kmem.lock);
    if (r) {
        pageref[pa_index((uint64)r)] = 1;   // 新分配，引用为 1
        memset((char*)r, 5, PGSIZE);
    }
    return (void*)r;
}
```

**修改 `kfree`**：引用计数 > 1 时不真正释放，只减计数：

```c
void kfree(void *pa) {
    struct run *r;
    if (((uint64)pa % PGSIZE) != 0 || (char*)pa < kernel_end || (uint64)pa >= PHYSTOP)
        panic("kfree");

    int idx = pa_index((uint64)pa);
    acquire(&kmem.lock);
    if (pageref[idx] > 0) {
        pageref[idx]--;               // 先减计数
        if (pageref[idx] > 0) {       // 还有其他人引用
            release(&kmem.lock);
            return;                   // 不真正回收
        }
    }
    // 计数归零：真正回收
    pageref[idx] = 1;                 // 重置，入链后自己持有一次引用
    kmem.npage++;
    memset(pa, 1, PGSIZE);
    r = (struct run *)pa;
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);
}
```

**新增引用计数操作函数**：

```c
void incref_page(uint64 pa) {
    acquire(&kmem.lock);
    pageref[pa_index(pa)]++;
    release(&kmem.lock);
}

int get_page_ref(uint64 pa) {
    return pageref[pa_index(pa)];
}
```

无需单独的 `decref_page`，因为 `kfree` 内部已经实现了"减 1 再判断是否释放"的逻辑。

**`kernel/include/kalloc.h`**：声明新增函数：

```c
void incref_page(uint64 pa);
int  get_page_ref(uint64 pa);
```

---

### 步骤 2：修改 fork — uvmcopy 实现 COW 共享

**`kernel/vm.c:uvmcopy`**：将原来的"分配新页 + memmove 复制数据 + 映射"三件套，改为"共享原页 + increment refcount + 清写权限 + 设 COW 标志"。

```c
int uvmcopy(pagetable_t old, pagetable_t new, pagetable_t knew, uint64 sz) {
    pte_t *pte;
    uint64 pa, i;

    for (i = 0; i < sz; i += PGSIZE) {
        if ((pte = walk(old, i, 0)) == NULL)
            panic("uvmcopy: pte should exist");
        if ((*pte & PTE_V) == 0)
            panic("uvmcopy: page not present");
        pa = PTE2PA(*pte);

        // ① 父进程页表：清除写权限，设置 COW 标志
        *pte = (*pte & ~PTE_W) | PTE_COW;

        // ② 增加物理页引用计数（fork 共享意味着多了一个引用者）
        incref_page(pa);

        // ③ 子进程页表：映射到同一个物理页（只读 + COW）
        uint flags = PTE_FLAGS(*pte);
        if (mappages(new, i, PGSIZE, pa, flags) != 0)
            goto err;

        // ④ 内核页表也映射同一物理页（清除 U 位）
        if (mappages(knew, i, PGSIZE, pa, (flags & ~PTE_U)) != 0)
            goto err;
    }
    return 0;

err:
    // 错误时需回滚：解除已映射的页，恢复父页表的写权限和 COW 标志
    // ...
    return -1;
}
```

**对比**：

```
fork 前:  父有 1 个数据页 → kalloc 时 refcount = 1

旧 uvmcopy:
  kalloc 新页 → memmove(pa_old→pa_new, PGSIZE) → mappages → refcount 仍是 1+1
  结果: 2 个物理页，各 refcount=1

新 uvmcopy:
  *pte |= PTE_COW; *pte &= ~PTE_W; incref_page(pa);
  mappages(child_pagetable, pa, flags);
  结果: 1 个物理页，refcount=2
```

**fork 时的页面增量**：原实现 fork 会新增约 16 页（代码/数据/堆/栈的全拷贝），COW 后只增加 `allocproc` 等基础结构的页面（< 10 页），大幅减少内存开销。

---

### 步骤 3：新增 cow_handler + 在 trap.c 中调用

**`kernel/vm.c`**：新增 `cow_handler` 函数——独立的 COW 缺页处理逻辑：

```c
/*
 * COW 缺页处理器
 * @return  0 成功处理；-1 不是 COW 页面（交由其他 handler 处理）
 */
int cow_handler(struct proc *p, uint64 va) {
    va = PGROUNDDOWN(va);

    // ① 检查是否有有效 PTE
    pte_t *pte = walk(p->pagetable, va, 0);
    if (pte == NULL || !(*pte & PTE_V))
        return -1;                    // 不是 COW → 交给后续处理

    // ② 检查是否是 COW 页面
    if (!(*pte & PTE_COW))
        return -1;                    // 有映射但不是 COW → 交给后续处理

    uint64 pa = PTE2PA(*pte);
    uint flags = PTE_FLAGS(*pte);
    int ref = get_page_ref(pa);

    if (ref == 1) {
        // ③ refcount == 1：仅当前进程持有，无需复制，直接恢复写权限
        *pte = PA2PTE(pa) | (flags & ~PTE_COW) | PTE_W;
        // 同步内核页表
        pte_t *kpte = walk(p->kpagetable, va, 0);
        if (kpte)
            *kpte = PA2PTE(pa) | ((flags & ~PTE_COW & ~PTE_U) | PTE_W);
        return 0;
    }

    // ④ refcount > 1：有其他进程也在共享，必须复制
    char *mem = kalloc();
    if (mem == NULL) return -1;
    memmove(mem, (char*)pa, PGSIZE);

    // 原物理页 refcount -1（当前进程不再引用它）
    kfree((void*)pa);   // kfree 内部 refcount--，归零才真释放

    // 新页映射：恢复 PTE_W，清除 PTE_COW
    uint newflags = (flags & ~PTE_COW) | PTE_W;
    *pte = PA2PTE((uint64)mem) | newflags;

    // 同步内核页表
    pte_t *kpte = walk(p->kpagetable, va, 0);
    if (kpte)
        *kpte = PA2PTE((uint64)mem) | (newflags & ~PTE_U);

    return 0;
}
```

**`kernel/include/defs.h`（或 `vm.h`）**：声明：

```c
int cow_handler(struct proc *p, uint64 va);
```

**`kernel/trap.c:usertrap`**：在缺页异常处理分支中，先调用 `cow_handler`，再回退到 `handle_page_fault`：

```c
/* 缺页异常 */
else if (r_scause() == 15 || r_scause() == 13) {
    uint64 va = r_stval();
    uint64 cause = r_scause();

    // 先尝试 COW 处理
    if (cow_handler(p, va) == 0) {
        // COW 成功处理，无需额外动作
    }
    // 再尝试 VMA / lazy allocation 处理
    else if (handle_page_fault(p, va, cause) < 0) {
        printf("page fault at addr: %p, cause: %d\n", va, cause);
        exit(-1);
    }
}
```

**为何分离 `cow_handler` 和 `handle_page_fault`**：COW 页面有有效的 PTE（PTE_V 置位），它的物理页已经存在只是缺少写权限。而 mmap/sbrk 懒分配的 PF 根本没有 PTE —— 两者本质不同，独立处理更清晰。

---

### 步骤 4：进程退出时的 COW 页回收

**`kernel/vm.c:vmunmap`**：无需修改。`kfree` 内部已处理 refcount：

- 若 `pageref > 1` → 只减 1，不释放物理页（共享页还有人在用）
- 若 `pageref == 1` → 减到 0，真正入链回收
- 若 `pageref == 0` → 非 COW 页的正常释放路径

fork → vmunmap 中的 `kfree(pa)` 对 refcount=2 的共享页只执行 `refcount--`，不会错误回收。

---

## 三、测试预期行为

### 测试流程

```
① sbrk(4KB) → 分配 1 页 → 写入数据
   getpgcnt: initial + 1

② fork()
   COW: 共享页，不复制内容
   getpgcnt: 远小于 fork 前 + 16（无 COW 时的增量）

③ ┌─ 子进程 ────────────────────────────┐
   │ 读共享页 → PTE_R 允许，不触发 PF     │
   │ getpgcnt: 与读取前一致（无新分配）  │
   │ 写入共享页 → PF                      │
   │  cow_handler: COW页, ref=2 → 复制    │
   │ getpgcnt: +1 （发生一次 COW 分配）   │
   │ exit(0) → kfree 回收子的新页 (-1)    │
   └──────────────────────────────────────┘
   父 wait()

④ 父读共享页 → PTE_R 允许，数据一致（未损坏）
   getpgcnt: 与读取前一致（无新分配）

⑤ 父写共享页 → PF
   cow_handler: COW页, ref=1（子已退出）
   → 不复制，直接恢复写权限
   getpgcnt: 与写入前一致（无新分配）✓
```

### 预期输出

```
Testing Copy-on-Write
Initial physical pages: N
Physical pages after initialization: N+1 (should be +1)
Physical pages after fork: N+X  (X << 16, COW 节省大量页面)
Physical pages before child read: N+X
Child read sum: 32640               (数据与写入时一致)
Physical pages after child read: N+X (should be same)
Physical pages after child write: N+X+1 (should be increased)
wait status:0
Parent read sum: 32640              (数据与写入时一致)
Physical pages after child exit: N+X   (should be same as before read)
Physical pages after parent write: N+X (should be same)
Copy-on-Write Test Completed Successfully
```

---

## 四、与 Lazy Allocation 的共存

`trap.c:usertrap` 中的 PF 处理有两条独立路径，按优先级依次尝试：

```
scause == 13 || 15  →  r_stval() 获取 va
    │
    ├─ cow_handler(p, va) == 0？
    │      → COW 页面：复制或恢复写权限
    │      ← PTE 有 V + COW 位
    │
    └─ handle_page_fault(p, va, cause) == 0？
           ├─ find_vma 有结果 → mmap（文件/匿名映射）
           └─ 无 VMA, va < p->sz → sbrk 懒分配
```

COW 先判断（页面已有映射），mmap/sbrk 后判断（页面不存在映射）。互不冲突。

---

## 五、文件修改清单

| 文件 | 修改内容 |
|------|---------|
| `kernel/include/riscv.h` | 新增 `#define PTE_COW (1L << 8)` |
| `kernel/kalloc.c` | 新增 `pageref[]` 数组；`kalloc` 设 refcount=1；`kfree` 加 refcount 守护；新增 `incref_page`/`get_page_ref` |
| `kernel/include/kalloc.h` | 声明 `incref_page`/`get_page_ref` |
| `kernel/vm.c:uvmcopy` | 数据页不复制：清 PTE_W + 设 PTE_COW + `incref_page`，子进程映射同一物理地址 |
| `kernel/vm.c:cow_handler` | 新增函数：判断 COW 页 → ref==1 恢复写权限，ref>1 分配新页 + 拷贝数据 |
| `kernel/trap.c:usertrap` | PF 分支：先调 `cow_handler`，失败再调 `handle_page_fault` |
| `kernel/vm.c:vmunmap` | 无需修改（`kfree` 已处理 refcount） |
