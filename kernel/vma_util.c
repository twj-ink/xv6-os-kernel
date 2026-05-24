// Part 6: 链表式 VMA 分配/释放（参考实现）
// 仅在 ALGO_FIFO 或 ALGO_LRU 时编译

#include "include/types.h"
#include "include/param.h"
#include "include/vm.h"
#include "include/kalloc.h"
#include "include/string.h"

#if defined(ALGO_FIFO) || defined(ALGO_LRU)

struct VMA free_list;

void vma_link_init(void) {
    free_list.vm_next = 0;
}

struct VMA* allocshare(void) {
    struct VMA *vma;
    if (free_list.vm_next != 0) {
        vma = free_list.vm_next;
        free_list.vm_next = vma->vm_next;
        return vma;
    }
    vma = (struct VMA*)kalloc();
    if (vma == 0) return 0;
    memset(vma, 0, PGSIZE);
    return vma;
}

void freeshare(struct VMA *vma) {
    vma->vm_next = free_list.vm_next;
    free_list.vm_next = vma;
}

#endif
