# Part 5 Lazy Allocation 实现指南

## 一、背景知识

### 1.1 什么是 "懒分配" (Lazy Allocation)

正常情况下，用户程序调用 `sbrk(n)` 扩展堆空间后，内核会**立即**分配物理页面并建立页表映射：

```
sbrk(16KB) → growproc → uvmalloc → kalloc × 4 → 映射 4 个页面到用户页表 + 内核页表
```

懒分配改变这个行为：`sbrk` 时**只增大 `proc->sz`**，不分配物理页面。真实的页面分配推迟到进程**第一次访问**该地址时，由缺页异常（Page Fault）触发。

```
sbrk(16KB) → growproc → 只修改 proc->sz += 16KB   （不分配物理内存！）

后来:  read/write va=0x12000  →  Page Fault
       →  PF handler 检查 va 是否在 [old_sz, new_sz) 区间
       →  合法 → kalloc 分配新页面 → 映射到页表 → 返回用户态重试
```

### 1.2 相关硬件机制

RISC-V 的 `scause` 寄存器在陷入时记录异常原因：

| scause 值 | 含义 |
|-----------|------|
| 13 | Load page fault（读取未映射的地址） |
| 15 | Store/AMO page fault（写入未映射的地址） |

`stval` 寄存器记录触发异常的**虚拟地址**（即用户尝试访问的那个地址）。

xv6 在 `trap.c:usertrap()` 中已经有对 scause 13/15 的处理框架。

### 1.3 相关数据结构

```c
// kalloc.c — 物理内存分配器
struct {
    struct spinlock lock;
    struct run *freelist;    // 空闲页链表
    uint64 npage;            // 空闲页数量 ← 关键！getpgcnt 将用到
} kmem;

// vm.c — 页表操作
// PTE_V    — 页面存在（valid）标志
// walk     — 遍历页表，获取 / 创建 PTE
// mappages — 建立 va→pa 映射
// vmunmap  — 解除映射，可选是否释放物理页面
```

### 1.4 当前代码现状

| 函数 | 文件 | 当前行为 |
|------|------|---------|
| `growproc(n > 0)` | `proc.c:386` | 调用 `uvmalloc` 立即分配+映射 |
| `usertrap()` | `trap.c:53` | 已检测 scause 13/15，调用 `handle_page_fault` |
| `handle_page_fault` | `vm.c:696` | 空壳，需要完善 |
| `vmunmap` | `vm.c:225` | 跳过不存在的 PTE（`*pte & PTE_V == 0` → `continue`） |
| `kfree / kalloc` | `kalloc.c` | 已追踪 `kmem.npage` |
| `sys_getpgcnt` | `sysproc.c:531` | 返回占位值 |

---

## 二、实现步骤

### 步骤 1：实现 `sys_getpgcnt`（统计已分配物理页数）

**文件**：`kernel/kalloc.c` + `kernel/sysproc.c`

**原理**：
- `kmem.npage` 当前记录的是**空闲页**数量（`kfree` 时 +1，`kalloc` 时 -1）
- `freerange` 初始化时，把 `kernel_end` 到 `PHYSTOP` 之间的全部页面调用 `kfree` 入链
- 总物理页数 = 初始化时 kmem.npage 的初始值，或通过 `(PHYSTOP - kernel_end) / PGSIZE` 计算
- **已分配页数 = 总页数 - 空闲页数**

**具体改动**：

在 `kalloc.h` 中声明：
```c
uint64 get_allocated_pages(void);
```

在 `kalloc.c` 中添加：
```c
// 总物理内存页数（初始化后不再变化）
static uint64 total_pages = 0;

void kinit() {
    // ... 现有代码 ...
    freerange(kernel_end, (void*)PHYSTOP);
    // freerange 之后 kmem.npage == total_pages
    total_pages = kmem.npage;
}

uint64 get_allocated_pages(void) {
    uint64 npage;
    acquire(&kmem.lock);
    npage = total_pages - kmem.npage;
    release(&kmem.lock);
    return npage;
}
```

**注意**：`freerange` 内部循环调用 `kfree`，每次 `kfree` 执行 `kmem.npage++`。所以 `freerange` 执行完毕后，`kmem.npage == 总物理页数`。此时 `total_pages = kmem.npage` 即可，不需要额外计算。

在 `sysproc.c` 中把占位的 `sys_getpgcnt` 改为：
```c
uint64 sys_getpgcnt(void) {
    return get_allocated_pages();
}
```

**关键理解**：这个函数是"懒分配"的探测器——`sbrk` 不分配页面时 `getpgcnt` 不变，触发 PF 分配了页面后 `getpgcnt` 会 +1。测试程序通过调用它来验证懒分配的正确性。

---

### 步骤 2：修改 `growproc`（sbrk 不再分配物理页面）

**文件**：`kernel/proc.c:growproc()`

**当前代码**（`n > 0` 时立即分配）：
```c
growproc(int n) {
    uint sz;
    struct proc *p = myproc();
    sz = p->sz;
    if (n > 0) {
        if ((sz = uvmalloc(p->pagetable, p->kpagetable, sz, sz + n)) == 0)
            return -1;  // ← 会 kalloc + 映射所有页面
    } else if (n < 0) {
        sz = uvmdealloc(p->pagetable, p->kpagetable, sz, sz + n);
    }
    p->sz = sz;
    return 0;
}
```

**修改后**：
```c
growproc(int n) {
    struct proc *p = myproc();
    if (n > 0) {
        // 懒分配：只增大 proc->sz，不分配物理页面
        p->sz += n;
    } else if (n < 0) {
        p->sz = uvmdealloc(p->pagetable, p->kpagetable, p->sz, p->sz + n);
    }
    return 0;
}
```

**对比**：

```
之前: sbrk(16KB)  →  growproc(4096*4)  →  uvmalloc()  →  kalloc × 4, mappages × 8
                                            ↑ 立即分配

之后: sbrk(16KB)  →  growproc(4096*4)  →  p->sz += 4096*4
                                            ↑ 只改了变量
```

此时 `p->sz` 增大了，但新地址范围内页表没有任何映射（PTE_V == 0）。**后续任何对该区域的读写都会触发 Page Fault**。

---

### 步骤 3：完善 `vmunmap` 适配懒分配

**文件**：`kernel/vm.c:vmunmap()`

**当前状态**：`vmunmap` 已经处理了"页面未映射"的情况（第 236-241 行）：

```c
if ((*pte & PTE_V) == 0) {
    continue;   // 跳过，不 panic
}
```

这意味着解除映射时，如果某个虚拟地址从未被映射（因为懒分配没实际分配页面），`vmunmap` 会正确跳过。**这个函数不需要额外修改**。

但需要确保 `uvmdealloc`（在 `shrink` 时调用）也能正确处理未映射的页面。`uvmdealloc` 内部调用 `vmunmap(pagetable, newsz, (oldsz-newsz)/PGSIZE, 1)`，其中 `do_free=1`。对于懒分配的未映射页面，`vmunmap` 已经会跳过（`continue`），且 `kfree` 不会被调用——这是正确的行为。

---

### 步骤 4：实现 `handle_page_fault`（陷缺页异常处理器）

**文件**：`kernel/vm.c`

这是懒分配的核心——每个触发 PF 的合法地址在此被补救：分配页面，映射到页表。

**当前代码**（`vm.c:696`）：
```c
int handle_page_fault(struct proc *p, uint64 va, int cause) {
    // 空壳
    return -1;
}
```

**需要实现的逻辑**：

```c
int handle_page_fault(struct proc *p, uint64 va, int cause) {
    // 1. 对齐 va 到页面边界
    va = PGROUNDDOWN(va);

    // 2. 校验地址合法性：va 必须在 [0, p->sz) 范围内
    //    p->sz 是 sbrk 扩展后的进程内存上限
    if (va >= p->sz)
        return -1;

    // 3. 检查该地址是否已经有映射
    //    如果已经有 PTE_V，说明不是懒分配导致的 PF，是真正的错误
    pte_t *pte = walk(p->pagetable, va, 0);
    if (pte != NULL && (*pte & PTE_V))
        return -1;   // 已映射的地址不会触发 PF，走到这里说明出了别的 bug

    // 4. 分配一个新页面
    char *mem = kalloc();
    if (mem == NULL)
        return -1;   // 内存耗尽
    memset(mem, 0, PGSIZE);

    // 5. 设置权限：默认用户可读写
    //    cause==15 是写操作，需要 PTE_W
    //    这里统一给 PTE_R | PTE_W | PTE_U
    int perm = PTE_U;
    perm |= PTE_R | PTE_W;

    // 6. 映射到用户页表
    if (mappages(p->pagetable, va, PGSIZE, (uint64)mem, perm) < 0) {
        kfree(mem);
        return -1;
    }

    // 7. 映射到内核页表
    if (mappages(p->kpagetable, va, PGSIZE, (uint64)mem, perm) < 0) {
        vmunmap(p->pagetable, va, 1, 0);   // 回滚用户页表
        kfree(mem);
        return -1;
    }

    return 0;
}
```

**流程图**：

```
用户态: 访问 va=0x12000（尚未映射）
    │
    ▼
硬件: page fault → scause=13(load) or 15(store)
    │
    ▼
trap.c: usertrap() 检查 scause==13||15 → 调用 handle_page_fault(p, stval, scause)
    │
    ▼
handle_page_fault:
    ① 对齐 va 到 PGSIZE 边界
    ② va < p->sz ? ──No──→ return -1 → exit(-1)
       │
       Yes
       ▼
    ③ pte = walk(p->pagetable, va, 0)
       pte 存在且 PTE_V ? ──Yes──→ return -1（不应该发生）
       │
       No（未映射，符合预期）
       ▼
    ④ mem = kalloc() → 分配物理页
    ⑤ mappages(p->pagetable, va, ..., mem, PTE_R|PTE_W|PTE_U)
    ⑥ mappages(p->kpagetable, va, ..., mem, PTE_R|PTE_W|PTE_U)
    return 0
       │
       ▼
    返回用户态，重新执行访问指令（这次成功）
```

---

### 步骤 5：`sys_getprocsz`

**文件**：`kernel/sysproc.c`

已经实现好了占位版本（`sysproc.c:537-541`），返回 `p->sz`：

```c
uint64 sys_getprocsz(void) {
    return myproc()->sz;
}
```

这个不需要改动——`p->sz` 在 `growproc` 中已被正确更新。

---

## 三、测试程序预期行为

测试程序 `test_mem_lazy_allocation` 的逻辑（`judger.c:TEST_COW/TEST_LAZY` 分支）：

```
1. getpgcnt() → initial          ← 基准线
2. sbrk(16KB) → 返回旧的 sz      ← 懒分配：不分配物理页面
3. getpgcnt() → after_sbrk       ← 应与 initial 相同（+0）
4. write 第 1 页 → PF 触发       ← page 1 分配
5. getpgcnt() → +1               ← 已分配页 +1
6. write 第 2 页 → PF 触发       ← page 2 分配
7. getpgcnt() → +1（累计 +2）
8. write 第 3 页 → PF 触发       ← page 3 分配
9. getpgcnt() → +1（累计 +3）
```

预期输出：
```
Testing Lazy Allocation
Initial physical pages: N
Physical pages after sbrk: N     (should be same as initial)
Physical pages after first access: N+1  (should be +1)
Physical pages after second access: N+2
Physical pages after third access: N+3
Lazy Allocation Test Completed Successfully
```

## 四、修改文件清单

| 文件 | 修改内容 |
|------|---------|
| `kernel/kalloc.c` | 新增 `total_pages` 变量；`kinit` 中记录总页数；实现 `get_allocated_pages()` |
| `kernel/include/kalloc.h` | 声明 `get_allocated_pages()` |
| `kernel/proc.c` | `growproc(n>0)` 改为只增大 `p->sz`，不调用 `uvmalloc` |
| `kernel/vm.c` | 实现 `handle_page_fault()`：校验地址 + kalloc + mappages |
| `kernel/sysproc.c` | `sys_getpgcnt` 替换占位值为调用 `get_allocated_pages()` |
