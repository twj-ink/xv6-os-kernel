# Part 5 测试框架集成文档

## 目的

为 xv6 内存/进程管理测试（Part 5：COW、LAZY）建立与 Part 4 调度算法测试统一的构建和运行框架。

## 文件改动

### 1. `xv6-user/testcases/test.h`

新增 include guard，用条件编译分隔 Part 4 与 Part 5 的 syscall 声明：

```c
#ifndef __TEST_H
#define __TEST_H

/* Part 4: 调度算法测试 */
#if defined(SCHEDULER_RR) || defined(SCHEDULER_PRIORITY) || defined(SCHEDULER_MLFQ)
int set_timeslice(int);
int set_priority(int);
int get_priority(void);
#endif

/* Part 5: 内存/进程管理测试 */
#if defined(TEST_COW) || defined(TEST_LAZY)
int getpgcnt(void);
int getprocsz(void);
#endif

#endif
```

- Part 4 函数由 Makefile 传入 `-DSCHEDULER_RR` 等宏触发
- Part 5 函数由 Makefile 传入 `-DTEST_COW=1` 或 `-DTEST_LAZY=1` 触发

### 2. `xv6-user/testcases/judger.c`

```c
// Part 4 调度判题逻辑（仅 SCHEDULER_RR / PRIORITY / MLFQ 时编译）
#if defined(SCHEDULER_RR) || defined(SCHEDULER_PRIORITY) || defined(SCHEDULER_MLFQ)
... Part 4 原有代码（pipe + 顺序检查 + 优先级检查）...
#endif

// Part 5 自评测试逻辑（仅 TEST_COW / TEST_LAZY 时编译）
#if defined(TEST_COW) || defined(TEST_LAZY)
#include "test.h"
... COW 测试的 main() 函数 ...
#endif
```

- 两个 `main()` 由编译宏隔离，互不冲突
- Part 5 的测试程序自带评分逻辑，不需要外部 judger

### 3. `xv6-user/init.c`

`run_scheduler_test()` 内部增加 `#ifdef TEST_PART5` 分支：

```c
void run_scheduler_test(void) {
#ifdef TEST_PART5
    // Part 5: 直接 fork + exec 自评测试程序
    pid = fork();
    if(pid == 0) exec(TEST_PROGRAM, argv);
    wait(&status);
#else
    // Part 4: pipe + judger 框架（原逻辑不变）
    ... Part 4 管道捕获+judger 调用的原代码 ...
#endif
}
```

`main()` 保持 `#ifdef ENABLE_JUDGER` 不变——无论是 Part 4 还是 Part 5，都通过 `run_scheduler_test()` 执行。

### 4. `Makefile`

#### 新增 TYPE 变量

```
SCHEDULER_TYPE ?= RR   # Part 4 调度器类型
TYPE ?=                # Part 5 测试类型（COW / LAZY）
```

- `TYPE` 优先级高于 `SCHEDULER_TYPE`
- 当 `TYPE` 非空时走 Part 5 分支，否则走 Part 4 分支

#### 测试程序与编译标志

```makefile
ifneq ($(TYPE),)
    # Part 5
    ifeq ($(TYPE), COW)
        TEST_PROGRAM = test_mem_cow
        CFLAGS += -DTEST_COW=1 -DTEST_PART5=1
    else ifeq ($(TYPE), LAZY)
        TEST_PROGRAM = test_mem_lazy_allocation
        CFLAGS += -DTEST_LAZY=1 -DTEST_PART5=1
    endif
else
    # Part 4（沿用 SCHEDULER_TYPE）
endif
```

#### TESTCASES 条件编译

```makefile
# Part 4 需要 judger，Part 5 不需要
ifeq ($(TYPE),)
TESTCASES = $(TEST)/_judger $(TEST)/_$(TEST_PROGRAM)
else
TESTCASES = $(TEST)/_$(TEST_PROGRAM)
endif
```

#### 运行与快捷命令

```makefile
# 统一入口
make run_test TYPE=COW       # Part 5 COW 测试
make run_test TYPE=LAZY      # Part 5 LAZY 测试

# 快捷命令
make test-cow                # 等价于 make run_test TYPE=COW
make test-lazy               # 等价于 make run_test TYPE=LAZY
```

## 使用方式

```bash
# Part 4（与之前完全一致）
make run_test SCHEDULER_TYPE=RR
make test-rr

# Part 5（新增）
make run_test TYPE=COW
make test-cow
make run_test TYPE=LAZY
make test-lazy
```

## 依赖项

运行 Part 5 测试前需要实现以下 syscall stub 和内核函数：

| syscall | 说明 |
|---------|------|
| `getpgcnt` | 获取当前物理页面数 |
| `getprocsz` | 获取当前进程的虚拟内存大小 |

需要在 `xv6-user/usys.pl` 中添加对应的 entry，在 `kernel/sysfile.c` 中实现 `sys_getpgcnt` 和 `sys_getprocsz`，并在 `kernel/syscall.c` 中注册。
