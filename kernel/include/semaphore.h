#ifndef __SEMAPHORE_H
#define __SEMAPHORE_H

#include "types.h"
#include "spinlock.h"

#define MAX_SEM 64

struct semaphore {
    int value;
    int used;
    struct spinlock lock;
};

void semaphore_init(void);
int  sem_create(int initial_value);
int  sem_destroy(int sem_id);
int  sem_p(int sem_id);
int  sem_v(int sem_id);

#endif
