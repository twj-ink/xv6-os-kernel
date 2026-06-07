// Part 8: 信号量实现（基于 xv6 的 sleep/wakeup 机制）

#include "include/types.h"
#include "include/riscv.h"
#include "include/param.h"
#include "include/spinlock.h"
#include "include/proc.h"
#include "include/semaphore.h"
#include "include/printf.h"
#include "include/string.h"

static struct semaphore sems[MAX_SEM];

void
semaphore_init(void)
{
    for (int i = 0; i < MAX_SEM; i++) {
        sems[i].used = 0;
        sems[i].value = 0;
    }
}

int
sem_create(int initial_value)
{
    for (int i = 0; i < MAX_SEM; i++) {
        if (!sems[i].used) {
            sems[i].used = 1;
            sems[i].value = initial_value;
            initlock(&sems[i].lock, "sem");
            return i;
        }
    }
    return -1;
}

int
sem_destroy(int sem_id)
{
    if (sem_id < 0 || sem_id >= MAX_SEM || !sems[sem_id].used)
        return -1;
    acquire(&sems[sem_id].lock);
    sems[sem_id].used = 0;
    // 唤醒所有等待该信号量的进程
    wakeup(&sems[sem_id]);
    release(&sems[sem_id].lock);
    return 0;
}

int
sem_p(int sem_id)
{
    if (sem_id < 0 || sem_id >= MAX_SEM || !sems[sem_id].used)
        return -1;

    acquire(&sems[sem_id].lock);
    while (sems[sem_id].value <= 0) {
        sleep(&sems[sem_id], &sems[sem_id].lock);
    }
    sems[sem_id].value--;
    release(&sems[sem_id].lock);
    return 0;
}

int
sem_v(int sem_id)
{
    if (sem_id < 0 || sem_id >= MAX_SEM || !sems[sem_id].used)
        return -1;

    acquire(&sems[sem_id].lock);
    sems[sem_id].value++;
    wakeup(&sems[sem_id]);
    release(&sems[sem_id].lock);
    return 0;
}
