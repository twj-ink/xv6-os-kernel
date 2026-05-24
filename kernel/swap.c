// 全局交换区实现
// 使用内存数组模拟磁盘交换区，用于 Part 6 页面置换算法

#include "include/types.h"
#include "include/riscv.h"
#include "include/param.h"
#include "include/spinlock.h"
#include "include/memlayout.h"
#include "include/proc.h"
#include "include/vm.h"
#include "include/kalloc.h"
#include "include/swap.h"
#include "include/string.h"
#include "include/printf.h"

static struct {
    struct spinlock lock;
    struct swap_slot slots[MAX_SWAP_SLOTS];
} swap_area;

void
swap_init(void)
{
    initlock(&swap_area.lock, "swap");
    for (int i = 0; i < MAX_SWAP_SLOTS; i++) {
        swap_area.slots[i].used = 0;
        swap_area.slots[i].pid = 0;
        swap_area.slots[i].va = 0;
        memset(swap_area.slots[i].data, 0, PGSIZE);
    }
}

// 从全局交换区分配空闲 slot
// 返回 slot 索引，无空闲返回 -1
int
alloc_global_swap_slot(int pid, uint64 va)
{
    acquire(&swap_area.lock);
    for (int i = 0; i < MAX_SWAP_SLOTS; i++) {
        if (!swap_area.slots[i].used) {
            swap_area.slots[i].used = 1;
            swap_area.slots[i].pid = pid;
            swap_area.slots[i].va = va;
            release(&swap_area.lock);
            return i;
        }
    }
    release(&swap_area.lock);
    return -1;
}

// 释放已使用的 slot
void
free_global_swap_slot(int slot_idx)
{
    if (slot_idx < 0 || slot_idx >= MAX_SWAP_SLOTS)
        return;
    acquire(&swap_area.lock);
    swap_area.slots[slot_idx].used = 0;
    swap_area.slots[slot_idx].pid = 0;
    swap_area.slots[slot_idx].va = 0;
    release(&swap_area.lock);
}

// 通过 pid + va 查找已分配的 slot
// 返回 slot 索引，未找到返回 -1
int
find_swap_slot(int pid, uint64 va)
{
    acquire(&swap_area.lock);
    for (int i = 0; i < MAX_SWAP_SLOTS; i++) {
        if (swap_area.slots[i].used &&
            swap_area.slots[i].pid == pid &&
            swap_area.slots[i].va == va) {
            release(&swap_area.lock);
            return i;
        }
    }
    release(&swap_area.lock);
    return -1;
}

// 将 mmap 区域的一页换出到交换区
void
swap_out(struct proc *p, struct vm_area *vma, int page_idx)
{
    uint64 va = vma->start + page_idx * PGSIZE;

    int slot = alloc_global_swap_slot(p->pid, va);
    if (slot < 0)
        panic("swap_out: no free slot");

    pte_t *pte = walk(p->pagetable, va, 0);
    if (pte == NULL || !(*pte & PTE_V))
        panic("swap_out: page not present");
    uint64 pa = PTE2PA(*pte);
    memmove(swap_area.slots[slot].data, (void*)pa, PGSIZE);

    kfree((void*)pa);
    *pte = 0;

    vma->pages[page_idx].state = PAGE_STATE_SWAPPED;
    vma->pages[page_idx].swap_slot = slot;

    p->page_swap_count++;
}

// 拷贝数据到交换区 slot
void copy_to_swap_slot(int slot, void *data) {
    memmove(swap_area.slots[slot].data, data, PGSIZE);
}

// 从交换区 slot 拷贝数据
void copy_from_swap_slot(int slot, void *data) {
    memmove(data, swap_area.slots[slot].data, PGSIZE);
}

// 将交换区中的一页换回内存
void
swap_in(struct proc *p, struct vm_area *vma, int page_idx)
{
    uint64 va = vma->start + page_idx * PGSIZE;
    int slot = vma->pages[page_idx].swap_slot;

    char *mem = kalloc();
    if (mem == NULL)
        panic("swap_in: kalloc failed");
    memset(mem, 0, PGSIZE);

    memmove(mem, swap_area.slots[slot].data, PGSIZE);

    int perm = PTE_U;
    if (vma->prot & PROT_READ)  perm |= PTE_R;
    if (vma->prot & PROT_WRITE) perm |= PTE_W;
    if (vma->prot & PROT_EXEC)  perm |= PTE_X;

    mappages(p->pagetable, va, PGSIZE, (uint64)mem, perm);
    mappages(p->kpagetable, va, PGSIZE, (uint64)mem, (perm & ~PTE_U));

    free_global_swap_slot(slot);

    vma->pages[page_idx].state = PAGE_STATE_IN_MEM;
    vma->pages[page_idx].swap_slot = -1;
#ifdef ALGO_FIFO
    vma->pages[page_idx].entry_time = ticks;
#elif defined(ALGO_LRU)
    vma->pages[page_idx].last_access = ticks;
#endif
}
