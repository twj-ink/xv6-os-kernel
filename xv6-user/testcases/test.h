#ifndef __TEST_H
#define __TEST_H

#include "kernel/include/types.h"
#include "kernel/include/stat.h"
#include "xv6-user/user.h"

/* Part 4: 调度算法测试 —— set_timeslice / set_priority / get_priority */
#if defined(SCHEDULER_RR) || defined(SCHEDULER_PRIORITY) || defined(SCHEDULER_MLFQ)
int set_timeslice(int);
int set_priority(int);
int get_priority(void);
#endif

/* Part 5: 内存/进程管理测试（TYPE=COW|LAZY） */
#if defined(TEST_COW) || defined(TEST_LAZY)
int getpgcnt(void);
int getprocsz(void);
#endif

/* Part 6: 页面置换算法 */
#if defined(ALGO_FIFO) || defined(ALGO_LRU)
uint64 mmap(uint64 addr, int length, int prot, int flags, int fd, int offset);
int munmap(uint64 addr, int length);
int set_max_page_in_mem(int);
int get_swap_count(void);
int lru_access_notify(uint64 addr);
#endif

#endif

