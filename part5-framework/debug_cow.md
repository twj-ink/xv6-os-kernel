# Part 5 COW 实现后的 Debug 日记

## 症状

完成 COW 实现后：
1. `make run_test TYPE=LAZY` — 编译通过，QEMU 启动后**无任何输出**（内核在初始化阶段死锁）
2. `make local` — **同样现象**，连基本的 syscall 测试都无法进入

---

## Debug 工具

### 工具 1：grep 定位改动差异

COW 实现之前系统工作正常，实现之后崩溃 → 问题一定在 COW 相关改动中。**缩小嫌疑人范围**：

```bash
grep -rn "pageref\|incref_page\|PTE_COW\|cow_handler\|pa_index" kernel/
```

找出所有新增/修改的代码行（`kernel/kalloc.c`、`kernel/vm.c`、`kernel/trap.c`）。

### 工具 2：逐函数单元排查

锁定嫌疑文件后，不"全局推理"，而是**对每个修改过的函数逐段审计**。

先看核心数据结构是否正确：

```bash
sed -n '15,20p' kernel/kalloc.c
```

输出：
```c
#define MAX_PAGE ((PHYSTOP) / PGSIZE)       // = 0x82000000 / 4096 = 851968
static uint64 pageref[851968];              // ≈ 6.8 MB！
pas_index(pa) = (int)(pa / PGSIZE);         // 0x80200000 / 4096 = 524800
```

立刻发现问题：`pageref[]` 应该是(32MB / 4KB) = 8192 个条目，**不是 851968**。而且 `pa / PGSIZE` 用的是绝对地址，返回的索引是 524800+，远超 8192。

再排查 `kfree` 的控制流：

```bash
sed -n '65,92p' kernel/kalloc.c
```

发现 `pageref[idx] > 0` 的 `if` 块后面没有 `else`——当 `pageref[idx] == 0` 时什么都不做就返回了，且**锁未释放**。

### 工具 3：Docker QEMU + timeout 插桩

在宿主 WSL 上无法直接跑 QEMU，container 内执行：

```bash
docker run --rm -v $(pwd):/xv6 -w /xv6 --privileged=true \
  docker.educg.net/cg/os-contest:2024p6 \
  /bin/bash -c "timeout 5 make run 2>&1"
```

`timeout 5` 可防止 QEMU 死循环阻塞后续命令。正常系统应在 1–2 秒内有 RustSBI 输出；若 5 秒内无输出 ≈ 内核初始化死锁/hang。

### 工具 4：容器清理

同一 `fs.img` 被多个 QEMU 实例争抢时会报 `Failed to get write lock`，需要先杀残留：

```bash
pkill -9 -f qemu-system
docker rm -f $(docker ps -aq)
```

---

## Debug 过程

### 第一轮排查：`kfree` 控制流

**假设**：`kfree` 的逻辑导致 `kinit` 期间死锁。

**分析**：
```
kinit → freerange → 循环调 kfree
kfree: pageref[idx] == 0（初始全零）
       → if (pageref[idx] > 0) // FALSE
       → 跳过整个 if 块
       → acquire(lock) 已获取
       → release(lock) 永远不执行 ← 死锁
```

**修复**：去掉嵌套的 `else`，让 refcount 检查和入链逻辑形成"有 ref→减 1→判断是否真放"然后**统一走到入链**的扁平结构。

**结果**：修复后 `make local` **仍然卡住**——说明这不是唯一的 bug。

### 第二轮排查：`pa_index` 越界

既然 kfree 修了还卡，说明还有别的问题。回到数据结构：

**分析**：
```
物理内存: 0x80000000 ~ 0x82000000 (32 MB)
可管理页数: (PHYSTOP - kernel_end) / 4096 ≈ 8192 页

MAX_PAGE = PHYSTOP / PGSIZE
         = 0x82000000 / 4096
         = 851968          ← 错误！数组膨胀到 6.8 MB！

pa_index(pa) = pa / 4096
  对于 pa=0x80200000 → 524800  ← 远超 8192！
```

`pageref[524800]` 写到了完全不属于 `pageref` 数组的内存区域——可能是内核栈、页表、或其他全局变量。每次 `kfree`/`kalloc` 都在随机破坏内核数据，行为不可预测。

**正确计算**：
```c
pa_index(pa) = (pa - 0x80000000) / 4096   // 结果范围 0..8191
MAX_PAGE = (PHYSTOP - 0x80000000) / 4096  // = 8192
```

**修复**：引入 `PA_BASE` 宏，`pa_index` 计算相对于物理内存起点的偏移。

**结果**：`make local` 和 `make run_test TYPE=LAZY` 都恢复正常。

---

## 关键教训

### 1. 数组越界 bug 在启动阶段才会暴露

`pageref[524800]` 写到了 BSS/data 段之外的区域。在 QEMU 中这些地址可能碰巧可访问，不会立即 panic，而是**静默破坏邻接数据**，表现为随机崩溃或死锁，排查极其困难。

### 2. 不要混用"绝对地址"和"相对偏移"作为数组索引

物理地址 0x80200000 和 0x80000000 在数值上差距巨大。用绝对地址 `pa / PGSIZE` 做索引时，数组大小必须覆盖整个地址空间（0 到 PHYSTOP/PGSIZE = 851968），6.8 MB 的静态数组显然不合理——这一刻就应该意识到索引计算错了。

### 3. 顺序排查比全局推理更高效

先锁定"上次能工作 → 现在不能了 → 中间改了什么"的差异集，再对差异集里的**每个函数逐个审计**，而不是试图在脑中模拟整个内核的行为。

### 4. 两个 bug 互相掩盖

`pa_index` 越界导致随机内存破坏，`kfree` 死锁在一部分执行路径上也会导致 hang。两个 bug 单独排查都很困难，必须用 `grep` 锁定所有改动点，逐条审计不跳过任何一行。
