#ifndef __TIMER_H
#define __TIMER_H

#include "types.h"
#include "spinlock.h"

#ifndef clock_t
#define clock_t long
#endif

extern struct spinlock tickslock;
extern uint ticks;

void timerinit();
void set_next_timeout();
void timer_tick();

struct tms {
  clock_t tms_utime;  /* user time */
  clock_t tms_stime;  /* system time */
  clock_t tms_cutime; /* user time of children */
  clock_t tms_cstime; /* system time of children */
};

#endif
