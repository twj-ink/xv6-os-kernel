
#include "include/types.h"
#include "include/riscv.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/spinlock.h"
#include "include/proc.h" // fork
#include "include/syscall.h"
#include "include/timer.h"
#include "include/kalloc.h"
#include "include/string.h"
#include "include/printf.h"

#include "include/sbi.h"
#include "include/vm.h"

extern int exec(char *path, char **argv);

uint64
sys_exec(void)
{
  char path[FAT32_MAX_PATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, FAT32_MAX_PATH) < 0 || argaddr(1, &uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv)){
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
      goto bad;
    }
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }

  int ret = exec(path, argv);

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    kfree(argv[i]);
  return -1;
}

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_trace(void)
{
  int mask;
  if(argint(0, &mask) < 0) {
    return -1;
  }
  myproc()->tmask = mask;
  return 0;
}

uint64
sys_shutdown(void)
{
  sbi_shutdown();
  return 0; // not reached
}

/*
 * @function: sys_times
 * @description: times()  stores  the current process 
 * times in the `struct tms` that `buf` points to.
 * @return:  `ticks` on success, (clock_t)-1 on failure.
 */
uint64
sys_times(void)
{
  struct proc *p = myproc();
  uint64 buf_addr;

  if (argaddr(0, &buf_addr) < 0) {
    return -1;
  }

  struct tms tms;
  // fill the tms
  acquire(&p->lock);
  tms.tms_utime = p->proc_tms.tms_utime;
  tms.tms_stime = p->proc_tms.tms_stime;
  tms.tms_cutime = p->proc_tms.tms_cutime;
  tms.tms_cstime = p->proc_tms.tms_cstime;
  release(&p->lock);

  // 获取全局ticks
  acquire(&tickslock);
  uint64 current_ticks = ticks;
  release(&tickslock);

  // 复制结构体到buf中
  if (buf_addr != 0) {
    // int copyout2(uint64 dstva, char *src, uint64 len)
    if (copyout2(buf_addr, (char*) &tms, sizeof(tms)) < 0) {
      return -1;
    }
  }

  return current_ticks;
}

/*
 * @function: sys_uname
 * @signature: int uname(struct utsname *buf);
 * @description: uname()  returns  system  information 
 *  in  the  structure pointed to by `buf`. 
 * @return: 0 on success, -1 on failure.
 */
uint64
sys_uname(void)
{
  struct utsname {
    char sysname[65];    /* Operating system name (e.g., "Linux") */
    char nodename[65];   /* Name within communications network
                            to which the node is attached, if any */
    char release[65];    /* Operating system release
                            (e.g., "2.6.28") */
    char version[65];    /* Operating system version */
    char machine[65];    /* Hardware type identifier */
    char domainname[65]; /* NIS or YP domain name */
  };

  struct utsname info = {
    "xv6",
    "localhost",
    "1.0.0",
    "RISC-V #1",
    "riscv64",
    "localdomain"
  };

  uint64 buf_addr;
  if (argaddr(0, &buf_addr) < 0) {
    return -1;
  }
  
  if (buf_addr != 0) {
    if (copyout2(buf_addr, (char*) &info, sizeof(info)) < 0) {
      return -1;
    }
  }

  return 0;
}

/*
 * @function: sys_clone
 * @description: int clone(int (*fn)(void *_Nullable), void *stack, int flags, void *_Nullable arg, ...)
 * @return: -1 on failure, the thread ID of the child thread on success.
 */
uint64
sys_clone(void)
{
  return clone();
}

uint64 
sys_wait4(void)
{
  // printf("sys_wait4 called\n");
  int wanted_pid, options;
  uint64 status, rusage;
  int child_status;
  int ret;

  if(argint(0, &wanted_pid) < 0 || argaddr(1, &status) < 0 ||
     argint(2, &options) < 0 || argaddr(3, &rusage) < 0)
    return -1;

  (void)wanted_pid;
  (void)rusage;
  if(options != 0)
    return -1;

  ret = wait(status);
  if(ret < 0)
    return -1;

  if(status != 0){
    if(copyin2((char *)&child_status, status, sizeof(child_status)) < 0)
      return -1;
    child_status = (child_status & 0xff) << 8;
    if(copyout2(status, (char *)&child_status, sizeof(child_status)) < 0)
      return -1;
  }
  return ret;
}

//        int brk(void *addr);
uint64
sys_brk(void)
{
  int addr;

  if(argint(0, &addr) < 0)
    return -1;
  
  // brk(0)获取当前堆顶地址
  if (addr == 0) {
    return sys_sbrk();
  } else {
    // sets the end of the data segment to the value specified by addr
    // 也即改变了 addr - curr_sz
    uint64 curr_sz = myproc()->sz;
    if(growproc((uint64)addr - curr_sz) < 0)
      return -1;
    return addr;
  }
}