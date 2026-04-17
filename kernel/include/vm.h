#ifndef __VM_H 
#define __VM_H 

#include "types.h"
#include "riscv.h"

struct proc;

#define MAX_VMA 16
#define PROT_READ       (1 << 0)
#define PROT_WRITE      (1 << 1)
#define PROT_EXEC       (1 << 2)

#define MAP_SHARED      0x01
#define MAP_PRIVATE     0x02
#define MAP_ANONYMOUS   0x20
/* 虚拟内存区域结构 */
struct vm_area {
    uint64 start;  // 起始虚拟地址（页对齐）
    uint64 end;    // 结束虚拟地址（不包含）
    int prot;      // PROT_READ, PROT_WRITE, PROT_EXEC
    int flags;     // MAP_SHARED, MAP_PROVATE, MAP_ANONYMOUS
    struct file *file;  // 映射的文件（匿名映射时为NULL）
    uint64 offset; // 文件偏移（页对齐）
    int used;      // 是否被使用
};

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

#endif 
