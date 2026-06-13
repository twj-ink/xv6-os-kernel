# Makefile

gnu官方手册：[make.pdf](https://www.gnu.org/software/make/manual/make.pdf)

这里是我根据手册写的简略介绍：

## 什么是make
首先GNU提供了一个命令工具：`make`，其最大的作用就是能够**自动决定**一个项目需要编译/重新编译哪些源文件。每次修改某些源文件的时候，只需要在终端输入：
```bash
make
```
就能够自动执行所有必要的重新编译了。更具体的，`make`使用文件的元数据和最后一次更改的时间，来决定哪些文件需要更新和重新编译。

## Makefile的规则
我们需要一个文件来告诉`make`到底要做什么，也就是这里介绍的`Makefile`文件，它会告诉`make`命令该如何编译和链接各个源代码。一个简单的书写`makefile`的规则如下：
```text
target ... : prerequisites ...
	command
	...
	...
```

`target`就是一个目标文件，能够是`Object File`，也能够是运行文件。还可以是要执行的某种动作的名称（`A target can also be the name of an action to carry out`），比如`clean`。

`prerequisites`就是要生成那个`target`所须要的文件或是目标，也就是作为输入的文件，往往是多个。也有可能不需要输入文件，比如一个删除规则`clean`就无需这些文件，而仅仅需要下面说的`command`中的东西。

`command`也就是`make`须要运行的命令（随意的Shell命令）。需要注意的是在每一天命令前要有一个`tab`。

当一个`target`是文件的时候，如果它的`prerequisites`中有任何一个文件发生了改动，其都需要被重新编译或链接。

## 一个例子
下面给出一个例子，假设一个工程有3个头文件，和8个C文件，我们要写一个Makefile来告诉make命令怎样编译和链接这几个文件。我们的规则是：  
* 假设这个工程没有编译过，那么我们的全部C文件都要编译并被链接。 
* 假设这个工程的某几个C文件被改动，那么我们仅仅编译被改动的C文件，并链接目标程序。 
* 假设这个工程的头文件被改变了，那么我们须要编译引用了这几个头文件的C文件，并链接目标程序。
我们的Makefile应该是以下的这个样子的：
```
edit : main.o kbd.o command.o display.o \ 
	insert.o search.o files.o utils.o 
	cc -o edit main.o kbd.o command.o display.o \
	insert.o search.o files.o utils.o
	
main.o : main.c defs.h 
	cc -c main.c 
kbd.o : kbd.c defs.h command.h
	cc -c kbd.c 
command.o : command.c defs.h command.h 
	cc -c command.c 
display.o : display.c defs.h buffer.h 
	cc -c display.c 
insert.o : insert.c defs.h buffer.h 
	cc -c insert.c
search.o : search.c defs.h buffer.h
	cc -c search.c 
files.o : files.c defs.h buffer.h command.h 
	cc -c files.c 
utils.o : utils.c defs.h 
	cc -c utils.c 
	
clean : 
	rm edit main.o kbd.o command.o display.o \ 
	insert.o search.o files.o utils.o
```
在该文件夹下直接输入命令`make`就能够生成运行文件edit。假设要删除运行文件和全部的中间目标文件，那么，仅仅要简单地运行一下`make clean`就能够了。其中这个clean不依赖任何文件且仅仅是一个动作，叫做*伪目标*（phony targets）。

## make是如何处理Makefile的
默认行为是：`make`完成`makefile`文件的**第一个目标**。比如对于上述例子，在执行`make`之后，会查找当前文件夹下的`makefile`文件并处理其第一个规则，也就是`edit`；但是在完全处理好这个规则之前，还需要处理这个目标所依赖的那些文件，在该例中就是那些`object files`。也就是说需要先把`prerequisites`处理好，再对目标进行编译或者链接。

## 设置变量来简化Makefile
在上例中`edit`目标需要罗列所有的目标文件两次，在未来如果要添加一个新的目标文件，就有可能忘记添两处。为了消除这个风险和简化内容可以使用**变量**。按照惯例，每个Makefile都应该定义一个名为`objects / OBJECTS / objs / OBJS / obj / OBJ`等等来作为所有目标文件名称的总和，格式为：
```
objects = main.o kbd.o command.o display.o \ 
	insert.o search.o files.o utils.o
```
那么在其他地方想放这些目标文件就只需要写：`$(objects)`来代替即可。
在替换之后，例子就可以简化为：
```
objects = main.o kbd.o command.o display.o \ 
	insert.o search.o files.o utils.o

edit : $(objects)
	cc -o edit $(objects)
	
main.o : main.c defs.h 
	cc -c main.c 
kbd.o : kbd.c defs.h command.h
	cc -c kbd.c 
command.o : command.c defs.h command.h 
	cc -c command.c 
display.o : display.c defs.h buffer.h 
	cc -c display.c 
insert.o : insert.c defs.h buffer.h 
	cc -c insert.c
search.o : search.c defs.h buffer.h
	cc -c search.c 
files.o : files.c defs.h buffer.h command.h 
	cc -c files.c 
utils.o : utils.c defs.h 
	cc -c utils.c 
	
clean : 
	rm edit $(objects)
```

用一个等号来定义的变量，其引用会**推迟到变量被使用的时候才展开**，比如：
```
# 例1
A = foo
B = $(A) bar  # B 的值是字符串 "$(A) bar"，此时并不展开 A
A = later

all:
    @echo $(B)  # 输出: later bar
```
而使用`:=`来定义的变量，会在**定义时立即展开**，比如：
```
# 例2
A := foo
B := $(A) bar  # B 的值在定义时立即展开为 "foo bar"
A := later     # 修改 A 对 B 已无影响

all:
    @echo $(B)  # 输出: foo bar
```
对于项目中的**基础配置、工具路径**等等优先用`:=`防止意外发生。

此外，命令中加上`@`的作用是**禁止回显**，在例1中输出只有B的值，假设没有@的话输出会第一行打印`echo later bar`然后再打印B的值。

## 使用隐式规则来简化Makefile
`make`可以自行推导出这样的命令：`cc -c main.c -o main.o`，也就是说如果需要目标文件`main.o`，那么`make`会自动把`main.c`添加到依赖项中，那么在书写依赖性的时候就可以把`main.c`忽略掉。下面是利用这个规则简化后的常见的`makefile`内容：
```
objects = main.o kbd.o command.o display.o \ 
	insert.o search.o files.o utils.o

edit : $(objects)
	cc -o edit $(objects)
	
main.o : defs.h 
kbd.o : defs.h command.h
command.o : defs.h command.h 
display.o : defs.h buffer.h 
insert.o : defs.h buffer.h 
search.o : defs.h buffer.h
files.o : defs.h buffer.h command.h 
utils.o : defs.h 
	
.PHONY : clean
clean : 
	-rm edit $(objects)
```

除此之外，还有另一种写法，上面这是对每一个目标罗列依赖项；还可以反过来，对每一个依赖性罗列目标：
```
objects = main.o kbd.o command.o display.o \ 
	insert.o search.o files.o utils.o

edit : $(objects)
	cc -o edit $(objects)
	
$(objects) : defs.h 
kbd.o command.o files.o : command.h 
display.o insert.o search.o files.o : buffer.h

.PHONY : clean
clean : 
	-rm edit $(objects)
```

上述内容中多出的`.PHONE : clean`声明其是一个伪目标，意味着`make`不会期望真的有`clean`为名字的文件。假设目录里面**真的有这个文件，且其已经是最新的**，若是**没有**这个声明，就会拒绝执行`clean`规则。`-rm`告诉`make`**即使`rm`命令执行出错（比如要删除的文件不存在），也要继续执行下去**，从而可以友好多次执行`make clean`。

# 阅读Makefile文件内容理解全貌
给了一大堆文件，想要看到底是要干什么，就从`Makefile`文件入手，看看这些代码都是用来干什么的：

## ⭐本地make的完整流程
```
# 本地测试所使用的编译命令
local:
    @$(MAKE) clean
    @$(MAKE) dump
    @$(MAKE) build
    @$(MAKE) fs
    @$(MAKE) run
```
* `make clean`：清理旧文件
* `make dump`：将从`initcode.S`得到的二进制`initcode`嵌入到`/kernel/include/initcode.h`中，转换流程是：`initcode.S`（源码）→ `initcode.o`（目标文件） → `initcode.out`（可执行文件） → `initcode`（二进制文件）。而后将二进制转为C数组嵌入到`.h`中。

* `make build`：第一点是构建内核：包括`/kernel`中的文件，以及在`/kernel/proc.c`中有这样的片段：
```c
// a user program that calls exec("/init")
// od -t xC initcode
uchar initcode[] = {
  #include "include/initcode.h"
};
```
此时这个`initcode`就会编译进内核的数据段中。
第二点是构建用户程序：会生成系统调用入口函数并链接到用户程序中，用户库也会链接到用户程序中。

* `make fs`：创建空白镜像文件并将所有的用户程序复制其中。
* `make run`：启动运行。
	* 首先QEMU模拟的RISC-V CPU从固定地址开始执行，RUSTSBI初始化硬件，然后控制权交给内核的入口点。
	* `/kernel/main.c`中在初始化后会创建第一个用户进程，调用`userinit()`；在该函数中会将`initcode`数组复制到用户内存地址0处。
	* 第一个进程就开始执行用户内存地址0处的代码，也就是从`initcode.S`编译得到的机器码，触发系统调用`exec("/init", ...)`。
	* 内核的`exec()`函数处理这个调用，会从虚拟磁盘`fs.img`中查找`/init`文件，然后开始执行`init.c`的`main()`函数。
	* 在`init.c`中会创建子进程，子进程执行`sh.c`，父进程等待`shell`退出。
	* `exec("sh", ...)`再次触发系统调用，内核从`fs.img`中加载`/sh`，Shell显示提示符`$`等待输入命令。
在希冀平台，由于没有`init.c`，将`init.c`直接全部编码到`initcode.h`中，此时第一个进程执行的用户内存地址0处的代码直接就是`init`程序的入口代码，然后创建shell。



# kernel/syscall.c
这个文件是系统调用处理核心，负责处理用户态程序发出的系统调用请求，是用户空间和内核空间交互的关键桥梁。其中有两个数据结构：

## 数据结构
### 系统调用表
```c
static uint64 (*syscalls[])(void) = {
  [SYS_fork]        sys_fork,
  [SYS_exit]        sys_exit,
  // ... 其他系统调用
};
```
`syscalls[]`是一个数组， `*syscalls[]`说明数组的元素的指针， `(*syscalls[])(void)`说明指针指向函数，函数参数为`void`，  `uint64`说明指针指向的函数返回值是`uint64`，`static`只在当前文件可见。而数组内部的初始方式在C99标准中是**指定初始化器**，简单来说就是：`[index] = value`，好处是可以乱序、跳过某些索引，未指定的索引自动设为`value=0`。在这里省略了等号，如果编译选项加上`-pedantic`则会对此报错。
那么后续如果想加入新的系统调用，在为其设置新的系统调用号之后，就需要在这个表中自行添加上新的系统调用。因为流程是这样的：用户态调用，在寄存器`a7`中保存对应的系统调用号，通过查表得到对应的函数指针，从而执行。

### 系统调用名称表
```c
static char *sysnames[] = {
  [SYS_fork]        "fork",
  [SYS_exit]        "exit",
  // ... 对应名称
};
```
这个是辅助调试的，为系统调用跟踪功能提供可读的名称。

此外，这个文件中还有几个**参数提取函数**：

## 参数提取函数

`argraw(int n)`

```c
static uint64 argraw(int n) {
  struct proc *p = myproc();
  switch (n) {
  case 0: return p->trapframe->a0;
  case 1: return p->trapframe->a1;
  // ...
  }
}
```
直接从进程的陷阱帧中提取来自用户态的寄存器的值，使用这个函数有三种参数类型提取函数：
1. **`argint(int n, int *ip)`** - 提取nth整数参数
2. **`argaddr(int n, uint64 *ip)`** - 提取nth地址参数
3. **`argstr(int n, char *buf, int max)`** - 提取nth字符串参数

## 系统调用处理函数

`syscall()`:

```c
void syscall(void) {
  int num;
  struct proc *p = myproc();
  
  num = p->trapframe->a7;  // 获取系统调用号
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    // 执行系统调用
    p->trapframe->a0 = syscalls[num]();
    
    // 跟踪输出（如果启用）
    if ((p->tmask & (1 << num)) != 0) {
      printf("pid %d: %s -> %d\n", p->pid, sysnames[num], p->trapframe->a0);
    }
  } else {
    // 未知系统调用处理
    printf("pid %d %s: unknown sys call %d\n", p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}
```
执行流程是：用户态调用系统调用时，CPU切换到内核模式，进入`usertrap()`，其中会调用`syscall()`；在`syscall()`中首先从寄存器`a7`中获取系统调用号，然后通过查表找到对应的处理函数并执行；如果启用了跟踪功能，还会打印系统调用的名称和返回值；如果系统调用号无效，则打印错误信息并返回-1。


# kernel/proc.h/.c

在这里定义了进程结构体`struct proc`，以及与进程管理有关的函数。可以理解为：`一个进程 = struct proc + 用户地址空间 + 内核栈`。在结构体中有一些重要的字段比如：

* 并发控制
  * `struct spinlock lock`：自旋锁，原因是xv6是多核系统，多个cpu可能同时访问同一个进程结构，所以需要锁来保护进程结构的访问。具体操作方式是`acquire(&p->lock)`来获取锁，`release(&p->lock)`来释放锁。
* 进程调度相关（需要持有p->lock）
  * `state`：进程状态，如`RUNNING`, `ZOMBIE`等等
  * `parent`：父进程的指针
* 进程私有数据（不需要p->lock，只有cpu访问）
  * `uint64 kstack`：每个进程**独立的内核栈**的地址
  * `uint64 sz`：用户虚拟地址空间的地址大小
  * `pagetable` & `kpagetable`：用户和内核的地址空间页表。在`fork`的时候使用`uvmcopy()`来复制父进程的用户地址空间。
  * `trapframe`：保存用户寄存器。在返回用户态时使用`usertrapret()`来恢复。
  * `context`：保存内核寄存器。

其中`trapframe`中有两类信息：
* 用户态上下文：
  * epc：用户程序计数器，保存了触发系统调用的指令地址。在返回的时候，会从这个地方继续执行。
  * sp：用户栈指针，指向用户栈的栈顶。

# shutdown
1. 添加系统调用号
在`kernel/include/sysnum.h`中添加：
```c
#define SYS_shutdown  48  // linux v6.8.0
```
2. 添加系统调用处理函数
在`kernel/sysproc.c`中添加：
```c
#include "include/sbi.h"

uint64
sys_shutdown(void)
{
	sbi_shutdown();
	return 0;
}
```
3. 注册系统调用
在`kernel/syscall.c`中：
A. 添加声明：
```c
extern uint64 sys_shutdown(void);
```
B. 在系统调用函数指针数组中添加：
```c
static uint64 (*syscalls[])(void) = {
	...
	[SYS_shutdown] sys_shutdown,
};
```
C. 在系统调用名称数组中添加：
```c
static char *syscall_names[] = {
	...
	[SYS_shutdown] "shutdown",
};
```
4. 添加用户态接口
在`xv6-user/user.h`中添加声明：
```c
int shutdown(void);
```
在`xv6-user/usys.pl`中添加：
```c
entry("shutdown");
```

此时就可以在`xv6-user/init.c`中结尾部分添加该函数以完成关闭程序了。

这里面的`syscalls`数组是一个**跳转表**，索引是系统调用号，值是函数指针。首先定义一个系统调用号48，当在用户态调用`shutdown`的时候，CPU自动切换到内核模式，调用`usertrap() -> syscall()`，而在`syscall`函数中细节是这样的：
```c
// kernel/syscall.c
void
syscall(void)
{
  int num;
  struct proc *p = myproc();
  
  // 从用户态的a7寄存器读取系统调用号
  num = p->trapframe->a7;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    // 通过号码索引到对应的处理函数
    p->trapframe->a0 = syscalls[num]();
        // trace
    if ((p->tmask & (1 << num)) != 0) {
      printf("pid %d: %s -> %d\n", p->pid, sysnames[num], p->trapframe->a0);
    }
  } else {
    printf("pid %d %s: unknown sys call %d\n",
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}
```
首先`a7`寄存器会被设置为48，内核的`syscall()`会读取48，用其来索引函数指针，指向`sys_shutdown()`，所以执行这个函数。这是一个基本的逻辑。而将函数具体的实现放在`sysproc.c`中是因为这是专注于**进程相关**系统调用的文件。

# getcwd

原本的代码是：

```c
// kernel/sysfile.c

// get absolute cwd string
uint64
sys_getcwd(void)
{
  uint64 addr;
  if (argaddr(0, &addr) < 0)
    return -1;

  struct dirent *de = myproc()->cwd;
  char path[FAT32_MAX_PATH];
  char *s;
  int len;

  if (de->parent == NULL) {
    s = "/";
  } else {
    s = path + FAT32_MAX_PATH - 1;
    *s = '\0';
    while (de->parent) {
      len = strlen(de->filename);
      s -= len;
      if (s <= path)          // can't reach root "/"
        return -1;
      strncpy(s, de->filename, len);
      *--s = '/';
      de = de->parent;
    }
  }

  // if (copyout(myproc()->pagetable, addr, s, strlen(s) + 1) < 0)
  if (copyout2(addr, s, strlen(s) + 1) < 0)
    return -1;
  
  return 0;
}
```
标准的函数说明应该是：
> `char *getcwd(char buf[.size], size_t size);`
>  These  functions  return  a null-terminated string containing an absolute pathname that is the current working directory of the calling process.  The pathname is returned as the function result and via the  argument  `buf`, if present.
> The  `getcwd()` function copies an absolute pathname of the current working directory to the array pointed to by `buf`, which is of length `size`.
> If the length of the absolute pathname of the current working directory, including the terminating null  byte,exceeds  `size` bytes, `NULL` is returned, and `errno` is set to ERANGE; an application should check for this `error`, and allocate a larger buffer if necessary.

然而原来的代码只是传递了一个参数也就是`buf`，所以我们需要添加一个`size`参数来指定缓冲区的大小，如果路径长度（包括`\0`）超过这个大小就返回`NULL`。其余的逻辑保持不变。修改后的代码如下：

```c
// kernel/sysfile.c

/* @function: sys_getcwd
 * @description: The `getcwd()` function copies an absolute pathname of the current working directory to the array pointed to by `buf`, which is of length `size`.
 * @return: pointer:`buf` on success, `NULL` on failure. 
 */
uint64
sys_getcwd(void)
{
  uint64 addr;
  size_t size;

  // 从用户态获取参数
  if (argaddr(0, &addr) < 0 || argaddr(1, (uint64*) &size) < 0)
    return 0;

  // 保证真的能装下路径
  if (size == 0 || size > FAT32_MAX_PATH) 
    return 0;

  struct dirent *de = myproc()->cwd;
  char path[FAT32_MAX_PATH];
  char *s;
  int len;

  if (de->parent == NULL) {
    s = "/";
  } else {
    s = path + FAT32_MAX_PATH - 1;
    *s = '\0';
    while (de->parent) {
      len = strlen(de->filename);
      s -= len;
      if (s <= path)          // can't reach root "/"
        return 0;
      strncpy(s, de->filename, len);
      *--s = '/';
      de = de->parent;
    }
  }

  // if (copyout(myproc()->pagetable, addr, s, strlen(s) + 1) < 0)
  if (copyout2(addr, s, strlen(s) + 1) < 0)
    return 0;
  
  return addr;
}
```

# times

1. 添加系统调用号
在`kernel/include/sysnum.h`中添加：
```c
#define SYS_times 100  // linux v6.8.0
```

2. 添加系统调用处理函数

注：事实证明，这一步只在`sysproc.c`中添加：
```c
uint64
sys_times(void) 
{
  return 0;
}
```
即可完成测试，说明测试文件很简单。

首先查看文档：

> #include <sys/times.h>
> clock_t times(struct tms *buf);

>  times()  stores  the current process times in the `struct tms` that `buf` points to.  The `struct tms` is as defined in `<sys/times.h>`:
```c
struct tms {
  clock_t tms_utime;  /* user time */
  clock_t tms_stime;  /* system time */
  clock_t tms_cutime; /* user time of children */
  clock_t tms_cstime; /* system time of children */
};
```
参数`buf`是用来存放结果的，返回值在成功时，返回的是从历史的**任意某个时间点**到现在经历的ticks，失败时返回`(clock_t) -1`。

`tms_utime`统计调用进程在**用户态**执行指令所消耗的CPU时间；
`tms_stime`统计调用进程在**内核态**执行指令所消耗的CPU时间；
`tms_cutime`统计该进程的所有已经成功wait了的终止子进程的`tms_utime+tms_cutime`之和；
`tms_cstime`类似定义。

对于后两个字段，仅在父进程的`wait()`或者`waitpid()`系统调用成功返回子进程ID的那一刻，才被累加到父进程的`cutime/cstime`中。也就是说子进程终止的时候不会影响后两个字段，只有父进程**显式调用**`wait()`来认领子进程才能统计进来。而且，如果子进程没用被wait，那么这个子进程的子进程也不会被统计。

该如何实现呢？首先需要在内核中维护一个全局的tick计数器，记录系统启动以来经历的ticks；其次在每个进程的`struct proc`中添加一个`struct tms`类型的字段来存储该进程的时间统计信息；最后在系统调用处理函数中实现逻辑来填充这个结构体并返回ticks。tick计数器在`kernel/timer.c`中已经有了。

* 在`kernel/include/timer.h`定义`struct tms`：
```c
struct tms {
  clock_t tms_utime;  /* user time */
  clock_t tms_stime;  /* system time */
  clock_t tms_cutime; /* user time of children */
  clock_t tms_cstime; /* system time of children */
};
```

* 在`kernel/proc.h`中添加字段：
```c
#include "timer.h"
struct proc {
  ...
  struct tms proc_tms;
  clock_t pending_cutime;
  clock_t pending_cstime;
  ...
}
```
原因是我们应该在每个进程开始运行的时候就开始对其进行时间的统计了，这是进程自身的属性；同时为了进行同步需要把这些字段加到需要使用锁保护的地方。那么需要找到进程初始化的函数来让这些字段初始化为0，在`kernel/proc.c`中：
```c
static struct proc*
allocproc(void)
{
  ...
  /* sys_times初始化 */
  p->proc_tms.tms_utime = 0;
  p->proc_tms.tms_stime = 0;
  p->proc_tms.tms_cutime = 0;
  p->proc_tms.tms_cstime = 0;
  p->pending_cutime = 0;
  p->pending_cstime = 0;
  ...
}
```
但是考虑到复制出子进程的时候父进程的时间会被复制，需要重新归0，所以也要修改一下fork函数，在`kernel/proc.c`中：
```c
int
fork(void) 
{
  ...
  /* sys_times归0 */
  np->proc_tms.tms_utime = 0;
  np->proc_tms.tms_stime = 0;
  np->proc_tms.tms_cutime = 0;
  np->proc_tms.tms_cstime = 0;
  np->pending_cutime = 0;
  np->pending_cstime = 0;
}
```

* 进行全局时钟管理，在`kernel/timer.c`中：
```c
#include "include/memlayout.h"
void timer_tick() {
    acquire(&tickslock);
    ticks++;

    /* 更新当前进程的时间统计 */
    struct proc *p = myproc(); // 当前的进程
    if (p && p->state == RUNNING) {
        // 查看是用户态还是内核
        uint64 epc = p->trapframe->epc;

        if (epc >= TRAMPOLINE && epc < TRAMPOLINE + PGSIZE) {
            // 用户
            p->proc_tms.tms_utime++;
        } else {
            // 内核
            p->proc_tms.tms_stime++;
        }  
    }

    wakeup(&ticks);
    release(&tickslock);
    set_next_timeout();
}
```

* 接下来想一下怎么更新`cutime/cstime`，首先需要让子进程终止，也就是在`exit()`函数中，把这个进程的`utime+cutime`累加到当前进程的`pending_cutime`中， `stime+cstime`累加到当前进程的`pending_cstime`中，仅仅作为保存的作用；然后在父进程调用`wait()`函数的时候才把子进程的这两个字段分别添加到父进程的`cutime/cstime`中。接下来修改`exit()`和`wait()`和`waitpid()`函数，在`kernel/proc.c`中：
```c
void 
exit(int status)
{
  ...
  // 此时已经持有了p->lock，而且不能释放，后续的sched()函数需要这个锁
  /* sys_times */
  p->pending_cutime = p->proc_tms.tms_utime + p->proc_tms.tms_cutime;
  p->pending_cstime = p->proc_tms.tms_stime + p->proc_tms.tms_cstime;
  ...
}

int
wait(uint64 addr)
{
  ...
  if(np->state == ZOMBIE){
  // Found one.
  pid = np->pid;
  if(addr != 0 && copyout2(addr, (char *)&np->xstate, sizeof(np->xstate)) < 0) {
    release(&np->lock);
    release(&p->lock);
    return -1;
  }

  /* sys_times */
  p->cutime += np->pending_cutime;
  p->cstime += np->pending_cstime;
  ...
  }
}
```

* 在`kernel/sysproc.c`中添加完整的系统调用逻辑：
```c
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
```
3. 注册系统调用
在`kernel/syscall.c`中：
A. 添加声明：
```c
extern uint64 sys_times(void);
```
B. 在系统调用函数指针数组中添加：
```c
static uint64 (*syscalls[])(void) = {
	...
	[SYS_times] sys_times,
};
```
C. 在系统调用名称数组中添加：
```c
static char *syscall_names[] = {
	...
	[SYS_times] "times",
};
```
4. 添加用户态接口
在`xv6-user/user.h`中添加声明：
```c
int times(void);
```
在`xv6-user/usys.pl`中添加：
```c
entry("times");
```


# uname

还是四部曲，第一步添加调用号160，第二步在下面详细说，第三步注册系统调用，第四步添加用户态接口。

第二步直接放代码吧：
```c
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
```

# Part2

这一部分里面需要先实现`wait4`和`clone`这俩，因为`fork`,`exit`,`wait`都依赖于这俩。

## wait4

```c
pid_t wait4(pid_t pid, int *_Nullable wstatus, int options,
            struct rusage *_Nullable rusage);
```


## clone

四部曲，第一步添加调用号160，第二步在下面详细说，第三步注册系统调用，第四步添加用户态接口。

```c
int clone(int (*fn)(void *_Nullable), void *stack, int flags,
                void *_Nullable arg, ...  /* pid_t *_Nullable parent_tid,
                                            void *_Nullable tls,
                                            pid_t *_Nullable child_tid */ );
```

## gettimeofday & sleep

## 时钟相关



在`kernel/trap.c`中，会对计时器中断进行处理，调用`kernel/timer.c`中的`timer_tick()`，在该函数中会`ticks++`和`wakeup(&ticks)`，所以选择使用`&ticks`来作为**是否唤醒该线程的标志**。


# PART3

在vm.h中定义vm_area，在proc.h中对proc添加vma数组和用户页表。



s