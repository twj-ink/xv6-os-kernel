// init: The initial user-level program

#include "kernel/include/types.h"
#include "kernel/include/stat.h"
#include "kernel/include/file.h"
#include "kernel/include/fcntl.h"
#include "xv6-user/user.h"

// char *argv[] = { "sh", 0 };


char *argv[] = { 0 };

// ========== 系统调用测试部分 ==========
#ifndef DISABLE_SYSCALL_TEST

char *syscall_tests[] = {
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

  /* 7 */
  "dup",
  "dup2",
  "pipe",
  "open",
  "openat",
  "close",
  "getdents",
  "read",
  "mkdir_",
  "chdir",
  "unlink",
  "mount",
  "umount",
  "fstat",

};

int cycles = sizeof(syscall_tests) / sizeof(syscall_tests[0]);
#endif


// ========== 调度器测试部分 ==========
#ifdef ENABLE_JUDGER
#define MAX_OUTPUT_SIZE (1<<10)
#define MAX_CASES 1
#define STDOUT 1
#define MAX_READ_BYTES 100

#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
char test_outputs[MAX_OUTPUT_SIZE];
int output_lengths = 0;
char* order = "0";

void print_test_program(const char* program_name) {
    printf("Starting test program: [%s]\n", program_name);
    printf("Scheduler type: ");
#ifdef SCHEDULER_RR
    printf("[Round Robin]");
    order = "1";
#elif defined(SCHEDULER_PRIORITY)  
    printf("[Priority]");
    order = "2";
#elif defined(SCHEDULER_MLFQ)
    printf("[MLFQ]");
    order = "3";
#else
    printf("Unknown");
#endif
    printf("\n\n");
}

void run_scheduler_test(void) {
    int pid, wpid;
    int status;
    char* program_name = TEST_PROGRAM;
    
    print_test_program(program_name);
    if (order[0]=='0') {
        exit(1);
    }

    printf("init: starting [%s]\n", program_name);
    int pipefd[2] = {0, 0};
    if(pipe(pipefd) == -1) {
        printf("init: pipe failed\n");
        exit(1);
    }
    pid = fork();
    if(pid < 0){
        printf("init: fork failed\n");
        close(pipefd[0]);
        close(pipefd[1]);
        exit(1);
    }
    if(pid == 0){
        close(pipefd[0]);
        // dup2(pipefd[1], 1);  // stdout
        // 使用 dup + close 模拟 dup2
        close(1);                    // 先关闭 stdout
        dup(pipefd[1]);              // dup 会使用最小的可用fd，即1
        close(pipefd[1]);            // 关闭原来的pipefd[1]
        exec(program_name, argv);
        printf("init: exec %s failed\n", program_name);
        exit(1);
    }
    
    close(pipefd[1]);
    int bytes_read = 0;
    int total_bytes = 0;
    int max_read_bytes = MAX(MAX_READ_BYTES, MAX_OUTPUT_SIZE-1-total_bytes);
    while((bytes_read = read(pipefd[0], test_outputs+total_bytes, max_read_bytes)) > 0) {
        total_bytes+=bytes_read;
        max_read_bytes = MAX(MAX_READ_BYTES, MAX_OUTPUT_SIZE-1-total_bytes);
    }
    test_outputs[total_bytes] = '\0';
    output_lengths = total_bytes;
    printf("testing output size:%d, contents:\n\n%s", total_bytes, test_outputs);
    close(pipefd[0]);

    wpid = wait(&status);
    if(wpid == -1) {
        printf("\ninit: no more child processes, break\n");
    } else if(wpid > 0) {
        printf("\ninit: process pid=%d exited\n", wpid); 
    }

    printf("\ninit: test execution completed, starting judger\n\n");
    char *judger_argv[4];
    judger_argv[0] = "judger";
    judger_argv[1] = order;
    judger_argv[2] = test_outputs;
    judger_argv[3] = 0;

    pid = fork();
    if(pid==0) {
        exec("judger", judger_argv);
        printf("exec judger failed\n");
        exit(1);
    }
    wpid = wait(&status);
    printf("\ninit: judger completed\n");
}
#endif

int main(void) {
    dev(O_RDWR, CONSOLE, 0);
    dup(0);  // stdout
    dup(0);  // stderr

#ifdef ENABLE_JUDGER
    // 运行调度器测试
    run_scheduler_test();
#else
    // 运行系统调用测试
    for(int i = 0; i < cycles; i++){
        printf("\n[%s]\n", syscall_tests[i]);
        int pid = fork();
        if(pid < 0){
            printf("init: fork failed\n");
            exit(1);
        }
        if(pid == 0){
            exec(syscall_tests[i], argv);
            printf("init: exec [%s] failed\n", syscall_tests[i]);
            exit(1);
        }

        int wpid;
        for(;;){
            wpid = wait((int *) 0);
            if(wpid == pid){
                break;
            } else if(wpid < 0){
                printf("init: wait returned an error\n");
                exit(1);
            }
        }
    }
#endif

    shutdown();
    return 0;
}