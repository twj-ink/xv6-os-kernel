// init: The initial user-level program

#include "kernel/include/types.h"
#include "kernel/include/stat.h"
#include "kernel/include/file.h"
#include "kernel/include/fcntl.h"
#include "xv6-user/user.h"

// char *argv[] = { "sh", 0 };


char *argv[] = { 0 };

char *tests[] = {
  /* 1 */
  "write",
  "getpid",
  "getcwd",
  "times",
  "uname",
  /* 2 */
  "fork",
  "execve",
  "exit",
  "clone",
  "wait",
  "yield",
  "waitpid",
  "getppid",
  "sleep",
  "gettimeofday",

  /* 3 */
  "brk",
  "mmap",
  "munmap",

  "open",
  // "openat",
};

int cycles = sizeof(tests) / sizeof(tests[0]);


int
main(void)
{
  int pid, wpid;

  // if(open("console", O_RDWR) < 0){
  //   mknod("console", CONSOLE, 0);
  //   open("console", O_RDWR);
  // }
  dev(O_RDWR, CONSOLE, 0);
  dup(0);  // stdout
  dup(0);  // stderr

  for(int i = 0; i < cycles; i++){
    printf("\n[%s]\n", tests[i]);
    pid = fork();
    if(pid < 0){
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
      // exec("sh", argv);
      exec(tests[i], argv);
      printf("init: exec [%s] failed\n", tests[i]);
      exit(1);
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
      if(wpid == pid){
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
        printf("init: wait returned an error\n");
        exit(1);
      } else {
        // it was a parentless process; do nothing.
      }
    }
  }
  shutdown();
  return 0;
}
