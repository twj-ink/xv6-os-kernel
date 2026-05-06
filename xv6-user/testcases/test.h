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

#endif