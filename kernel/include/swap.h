#ifndef __SWAP_H
#define __SWAP_H

#include "types.h"
#include "spinlock.h"
#include "riscv.h"

#define MAX_SWAP_SLOTS 128

struct swap_slot {
    int used;               // 0 = 空闲, 1 = 已使用
    int pid;                // 所属进程 PID
    uint64 va;              // 对应的虚拟地址（页对齐）
    char data[PGSIZE];      // 换出的页面内容
};

struct proc;
struct VMA;

void swap_init(void);
void copy_to_swap_slot(int slot, void *data);
void copy_from_swap_slot(int slot, void *data);
int  alloc_global_swap_slot(int pid, uint64 va);
void free_global_swap_slot(int slot_idx);
int  find_swap_slot(int pid, uint64 va);

void swap_out6(struct proc *p, struct VMA *vma, int page_idx);
void swap_in6(struct proc *p, struct VMA *vma, int page_idx);
int  alloc_global_swap_slot(int pid, uint64 va);
void free_global_swap_slot(int slot_idx);
int  find_swap_slot(int pid, uint64 va);

// 页面置换核心操作
void swap_out(struct proc *p, struct vm_area *vma, int page_idx);
void swap_in(struct proc *p, struct vm_area *vma, int page_idx);

#endif
