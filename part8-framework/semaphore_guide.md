# Part 8 信号量与 IPC 实现指南

## 一、概述

Part 8 要求实现基于 xv6 `sleep`/`wakeup` 机制的用户态信号量，并通过**生产者-消费者**和**哲学家就餐**两个测试。

### 测试命令

```bash
make run_test CASE=MPMC          # 生产者-消费者
make run_test CASE=PHILOSOPHER   # 哲学家就餐
```

### 预期输出

```
MPMC:        TEST 1 PASSED, SCORE: 1
PHILOSOPHER: TEST 2 PASSED, SCORE: 1
```

---

## 二、信号量实现

### 数据结构 (`kernel/include/semaphore.h`)

```c
#define MAX_SEM 64

struct semaphore {
    int value;      // 信号量当前值
    int used;       // 是否已被创建
    struct spinlock lock;  // 保护 value 的自旋锁
};
```

全局数组 `static struct semaphore sems[MAX_SEM]` 管理所有信号量。

### 核心操作 (`kernel/semaphore.c`)

#### `sem_create(int initial_value)` → 返回 sem_id

从 `sems[]` 数组中找第一个未使用的槽，设置 `value = initial_value`，`used = 1`，初始化锁。

#### `sem_destroy(int sem_id)` → 0 或 -1

将槽标记为 `used = 0`，唤醒所有等待该信号量的进程。

#### `sem_p` (P / wait / down) — 信号量 -1

```c
acquire(&sem.lock);
while (sem.value <= 0)          // 值 ≤ 0 则阻塞
    sleep(&sem, &sem.lock);     // 原子释放锁 + 睡眠
sem.value--;                    // 获资源，减 1
release(&sem.lock);
```

**关键**：`sleep(chan, lk)` 原子地释放 `lk` 并让进程睡眠在 `chan` 上。醒来后重新持有 `lk`。while 循环处理虚假唤醒。

#### `sem_v` (V / signal / up) — 信号量 +1

```c
acquire(&sem.lock);
sem.value++;
wakeup(&sem);           // 唤醒所有等待该 sem 的进程
release(&sem.lock);
```

### 系统调用注册

| 步骤 | 文件 | 内容 |
|------|------|------|
| syscall 号 | `sysnum.h` | `SYS_sem_create 55560` 等 |
| 用户态 stub | `usys.pl` | `entry("sem_create")` 等 |
| 内核声明 | `syscall.c` | `extern uint64 sys_sem_create(void)` + 派发表 |
| 内核实现 | `sysproc.c` | `sys_sem_create` → `sem_create(val)` |

---

## 三、init.c 适配

Part 8 使用 **pipe + judger** 框架（与 Part 4/6 相同）。

### `print_test_program` 增加 Part 8 条目

```c
#ifdef TYPE_PRODUCER
    printf("[MPMC]");  order = "1";
#elif defined(TYPE_PHILOSOPHER)
    printf("[Philosopher Dining]");  order = "2";
```

### `run_scheduler_test` 增加 Part 8 路径

```c
#elif defined(TYPE_PRODUCER) || defined(TYPE_PHILOSOPHER)
    // pipe 捕获测试输出 + judger 评分
    // 与 Part 4/6 模式完全一致
```

order `"1"` / `"2"` 传给 judger，judger 据此选择预期输出字符串进行比对。

---

## 四、Makefile 适配

### Part 4 guard 排除 Part 8

```makefile
ifeq ($(TYPE),)
ifeq ($(ALGO),)
ifeq ($(CASE),)
    # ... Part 4 配置 ...
endif
endif
endif
```

### Part 8 配置

```makefile
CASE ?=
ifneq ($(CASE),)
    ifeq ($(CASE), MPMC)
        override TEST_PROGRAM = test_ipc_producer_consumer
        CFLAGS += -DTYPE_PRODUCER
        USER_CFLAGS += -DTYPE_PRODUCER
    else ifeq ($(CASE), PHILOSOPHER)
        override TEST_PROGRAM = test_ipc_philosopher
        CFLAGS += -DTYPE_PHILOSOPHER
        USER_CFLAGS += -DTYPE_PHILOSOPHER
    endif
    # ... ENABLE_JUDGER, TEST_PROGRAM ...
endif
```

---

## 五、文件清单

| 新增/修改 | 文件 | 说明 |
|-----------|------|------|
| 新增 | `kernel/include/semaphore.h` | 信号量结构体和接口声明 |
| 新增 | `kernel/semaphore.c` | 信号量 `sem_p`/`sem_v`/`sem_create`/`sem_destroy` |
| 修改 | `kernel/include/sysnum.h` | 新增 4 个 syscall 号 |
| 修改 | `xv6-user/usys.pl` | 新增 4 个用户态 stub |
| 修改 | `kernel/syscall.c` | 注册 extern + 派发表 + 名称表 |
| 修改 | `kernel/sysproc.c` | 新增 `sys_sem_create` 等 4 个 wrapper |
| 修改 | `kernel/main.c` | `semaphore_init()` 调用 |
| 修改 | `Makefile` | 加入 `semaphore.o`、Part 8 条件编译、Part 4 guard 排除 CASE |
| 修改 | `xv6-user/init.c` | Part 8 pipe+judger 路径 |
| 修改 | `xv6-user/testcases/judger.c` | Part 8 判题逻辑（搜索预期字符串） |
| 修改 | `xv6-user/testcases/test.h` | Part 8 声明 guard |

## 六、测试流程

```
QEMU boot → init
    │
    ├─ ENABLE_JUDGER=1 → run_scheduler_test()
    │      │
    │      ├─ TYPE_PRODUCER → order="1" → pipe + judger
    │      │    test_ipc_producer_consumer: fork 生产者+消费者
    │      │    sem_p/sem_v 同步，pipe 通信
    │      │    输出 "MPMC test completed successfully!"
    │      │    judger 匹配 → TEST 1 PASSED, SCORE: 1
    │      │
    │      └─ TYPE_PHILOSOPHER → order="2" → pipe + judger
    │           test_ipc_philosopher: fork 5 哲学家
    │           sem_p/sem_v 拿筷子/放筷子
    │           输出 "Dining Philosophers test completed!"
    │           judger 匹配 → TEST 2 PASSED, SCORE: 1
```
