#ifndef __VM_H 
#define __VM_H 

#include "types.h"
#include "riscv.h"

struct proc;

#define MAX_VMA 16
#define MAX_VMA_PAGES 32
#define PROT_READ       (1 << 0)
#define PROT_WRITE      (1 << 1)
#define PROT_EXEC       (1 << 2)

#define MAP_SHARED      0x01
#define MAP_PRIVATE     0x02
#define MAP_ANONYMOUS   0x20

/* vma的page的元数据 */
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

/* 虚拟内存区域结构 */
struct vm_area {
    uint64 start;  // 起始虚拟地址（页对齐）
    uint64 end;    // 结束虚拟地址（不包含）
    int prot;      // PROT_READ, PROT_WRITE, PROT_EXEC
    int flags;     // MAP_SHARED, MAP_PROVATE, MAP_ANONYMOUS
    struct file *file;  // 映射的文件（匿名映射时为NULL）
    uint64 offset; // 文件偏移（页对齐）
    int used;      // 是否被使用

    struct vma_page *pages;     // 指向动态分配的 vma_page 数组（长度 = npages）
    int npages;                 // 该 VMA 覆盖的页数
};

/* Part 6: 页面置换测试所用的链表式 VMA */
#if defined(ALGO_FIFO) || defined(ALGO_LRU)
struct VMA {
    uint64 vm_start;
    uint64 vm_end;
    int prot;
    int flags;
    uint64 vm_off;
    struct VMA *vm_next, *vm_prev;
    struct vma_page pages[MAX_VMA_PAGES];   // per-page 元数据
    int npages;                              // 页数
};

struct VMA* allocshare(void);
void        freeshare(struct VMA *vma);
void        swap_out6(struct proc *p, struct VMA *vma, int page_idx);
void        swap_in6(struct proc *p, struct VMA *vma, int page_idx);
int         select_victim_page6(struct VMA *vma);
#endif

void            kvminit(void);
void            kvminithart(void);
uint64          kvmpa(uint64);
void            kvmmap(uint64, uint64, uint64, int);
int             mappages(pagetable_t, uint64, uint64, uint64, int);
pagetable_t     uvmcreate(void);
// void            uvminit(pagetable_t, uchar *, uint);
void            uvminit(pagetable_t, pagetable_t, uchar *, uint);
uint64          uvmalloc(pagetable_t, pagetable_t, uint64, uint64);
uint64          uvmdealloc(pagetable_t, pagetable_t, uint64, uint64);
// int             uvmcopy(pagetable_t, pagetable_t, uint64);
int             uvmcopy(pagetable_t, pagetable_t, pagetable_t, uint64);
void            uvmfree(pagetable_t, uint64);
// void            uvmunmap(pagetable_t, uint64, uint64, int);
void            vmunmap(pagetable_t, uint64, uint64, int);
void            uvmclear(pagetable_t, uint64);
uint64          walkaddr(pagetable_t, uint64);
int             copyout(pagetable_t, uint64, char *, uint64);
int             copyin(pagetable_t, char *, uint64, uint64);
int             copyinstr(pagetable_t, char *, uint64, uint64);
pagetable_t     proc_kpagetable(void);
void            kvmfreeusr(pagetable_t kpt);
void            kvmfree(pagetable_t kpagetable, int stack_free);
uint64          kwalkaddr(pagetable_t pagetable, uint64 va);
int             copyout2(uint64 dstva, char *src, uint64 len);
int             copyin2(char *dst, uint64 srcva, uint64 len);
int             copyinstr2(char *dst, uint64 srcva, uint64 max);
void            vmprint(pagetable_t pagetable);
pte_t *         walk(pagetable_t pagetable, uint64 va, int alloc);

struct vm_area* find_vma(struct proc *p, uint64 addr);
struct vm_area* alloc_vma(struct proc *p);
int handle_page_fault(struct proc *p, uint64 va, int cause);
int cow_handler(struct proc *p, uint64 va);
int select_victim_page(struct vm_area *vma);


#endif 
