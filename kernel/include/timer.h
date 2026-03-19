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

// 用long来定义time_t和suseconds_t
#ifndef time_t
#define time_t long
#endif
#ifndef suseconds_t
#define suseconds_t long
#endif

struct timeval {
  time_t      tv_sec;     /* seconds */
  suseconds_t tv_usec;    /* microseconds */
};
struct timezone {
  int tz_minuteswest;     /* minutes west of Greenwich */
  int tz_dsttime;         /* type of DST correction */
};
struct timespec {
  time_t  tv_sec;   /* Seconds */
  time_t  tv_nsec;     /* Nanoseconds [0, 999'999'999] */
};

#endif
