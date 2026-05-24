#ifndef __PROC_H
#define __PROC_H

#include "param.h"
#include "riscv.h"
#include "types.h"
#include "spinlock.h"
#include "file.h"
#include "fat32.h"
#include "trap.h"
#include "timer.h"

#include "vm.h"

// Saved registers for kernel context switches.
struct context {
  uint64 ra;
  uint64 sp;

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

// Per-CPU state.
struct cpu {
  struct proc *proc;          // The process running on this cpu, or null.
  struct context context;     // swtch() here to enter scheduler().
  int noff;                   // Depth of push_off() nesting.
  int intena;                 // Were interrupts enabled before push_off()?
};

extern struct cpu cpus[NCPU];

enum procstate { UNUSED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
  struct spinlock lock;

  // p->lock must be held when using these:
  enum procstate state;        // Process state
  struct proc *parent;         // Parent process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  int xstate;                  // Exit status to be returned to parent's wait
  int pid;                     // Process ID

  /* sys_times所需要的统计时间字段 */
  // clock_t utime;               // 用户态时间
  // clock_t stime;               // 内核态时间
  // clock_t cutime;              // 子进程用户时间总和
  // clock_t cstime;              // 子进程系统时间总和
  struct tms proc_tms;
  clock_t pending_cutime;      // 待转移的用户时间
  clock_t pending_cstime;      // 待转移的系统时间

  // these are private to the process, so p->lock need not be held.
  uint64 kstack;               // Virtual address of kernel stack
  uint64 sz;                   // Size of process memory (bytes)
  pagetable_t pagetable;       // User page table
  pagetable_t kpagetable;      // Kernel page table
  struct trapframe *trapframe; // data page for trampoline.S
  struct context context;      // swtch() here to run process
  struct file *ofile[NOFILE];  // Open files
  struct dirent *cwd;          // Current directory
  char name[16];               // Process name (debugging)
  int tmask;                    // trace mask

  /* vm */
  struct vm_area vma[MAX_VMA];  // VMA数组
  int vma_count;                // 已使用的VMA数量
#if defined(ALGO_FIFO) || defined(ALGO_LRU)
  struct VMA head;              // Part 6 链表式 VMA 头节点
#endif
  int max_page_in_mem;          // 单个进程最多能使用的mmap映射区域的页面数
  int page_swap_count;          // 记录进程在mmap映射区域发生的换出行为次数

  /* scheduler */
#ifdef SCHEDULER_RR
  int timeslice;                // 剩余的时间片
  int base_timeslice;           // 基础的时间片
#endif

#ifdef SCHEDULER_PRIORITY
  int priority;                 // 数值越小，优先级越高
#endif

#ifdef SCHEDULER_MLFQ
  int priority;
  int cpu_ticks;                // 占用cpu的时间
  int sleep_ticks;             // 睡眠时间
  int runtime_ticks;            // 当前周期tick计数
#endif

};

void            reg_info(void);
int             cpuid(void);
void            exit(int);
int             fork(void);
int             growproc(int);
pagetable_t     proc_pagetable(struct proc *);
void            proc_freepagetable(pagetable_t, uint64);
int             kill(int);
struct cpu*     mycpu(void);
struct cpu*     getmycpu(void);
struct proc*    myproc();
void            procinit(void);
void            scheduler(void) __attribute__((noreturn));
void            sched(void);
void            setproc(struct proc*);
void            sleep(void*, struct spinlock*);
void            userinit(void);
int             wait(uint64);
void            wakeup(void*);
void            yield(void);
int             either_copyout(int user_dst, uint64 dst, void *src, uint64 len);
int             either_copyin(void *dst, int user_src, uint64 src, uint64 len);
void            procdump(void);
uint64          procnum(void);
void            test_proc_init(int);

int             clone(void);

#ifdef SCHEDULER_MLFQ
void            update_priority(struct proc *);
#endif


#endif