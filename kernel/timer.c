// Timer Interrupt handler


#include "include/types.h"
#include "include/param.h"
#include "include/riscv.h"
#include "include/sbi.h"
#include "include/spinlock.h"
#include "include/timer.h"
#include "include/printf.h"
#include "include/proc.h"
#include "include/memlayout.h"

struct spinlock tickslock;
uint ticks;

void timerinit() {
    initlock(&tickslock, "time");
    #ifdef DEBUG
    printf("timerinit\n");
    #endif
}

void
set_next_timeout() {
    // There is a very strange bug,
    // if comment the `printf` line below
    // the timer will not work.

    // this bug seems to disappear automatically
    // printf("");
    sbi_set_timer(r_time() + INTERVAL);
}

void timer_tick() {
    acquire(&tickslock);
    ticks++;

    /* 更新当前进程的时间统计 */
    struct proc *p = myproc(); // 当前的进程
    if (p && p->state == RUNNING) {
        // 查看是用户态还是内核
        uint64 epc = p->trapframe->epc;

        if (epc >= TRAMPOLINE && epc < TRAMPOLINE + PGSIZE) {
            // 用户
            p->proc_tms.tms_utime++;
        } else {
            // 内核
            p->proc_tms.tms_stime++;
        }  
    }

    wakeup(&ticks);
    release(&tickslock);
    set_next_timeout();
}
