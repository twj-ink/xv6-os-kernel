# xv6 文件系统概述和相关系统调用

## 文件系统概述

xv6 内核基于 **FAT32** 文件系统，采用三层架构：VFS 层（虚拟文件系统）、FAT32 目录项层、块设备层。

### 核心数据结构

#### `struct dirent`（`kernel/include/fat32.h`）

FAT32 目录项在内存中的表示，是文件系统的核心抽象：

| 字段 | 说明 |
|------|------|
| `filename[256]` | 文件名（支持长文件名，最长 255 字符） |
| `attribute` | FAT32 属性：`ATTR_DIRECTORY(0x10)` / `ATTR_READ_ONLY(0x01)` / `ATTR_ARCHIVE(0x20)` 等 |
| `first_clus` | 起始簇号（FAT32 簇指针入口） |
| `file_size` | 文件大小（字节） |
| `cur_clus / clus_cnt` | 当前簇、簇计数（遍历文件时使用） |
| `off` | 在父目录中的偏移量（用于快速写入） |
| `parent` | 父目录指针（FAT32 无 inode，用指针表示父子关系） |
| `ref` | 引用计数（决定何时回写磁盘） |
| `lock` | 睡眠锁（用于并发保护） |

`struct dirent` 通过引用计数 (`ref`) 和缓存 (`ecache`) 管理生命周期，修改后通过 `eupdate` 回写到磁盘。

#### `struct file`（`kernel/include/file.h`）

进程打开的文件描述符抽象：

| 字段 | 说明 |
|------|------|
| `type` | 类型：`FD_NONE` / `FD_PIPE` / `FD_ENTRY` / `FD_DEVICE` |
| `ref` | 引用计数 |
| `readable / writable` | 读写权限 |
| `pipe` | 管道指针（FD_PIPE 时使用） |
| `ep` | 关联的 dirent（FD_ENTRY 时使用） |
| `off` | 文件读写偏移量 |
| `major` | 设备号（FD_DEVICE 时使用） |

进程通过 `proc->ofile[NOFILE]` 数组持有最多 `NOFILE` 个打开文件。

#### `struct stat`（`kernel/include/stat.h`）

返回给用户空间的文件元信息：`name`（文件名）、`dev`（设备号）、`type`（T_DIR/T_FILE/T_DEVICE）、`size`（字节数）。

#### FAT32 磁盘结构（`kernel/fat32.c`）

- **`short_name_entry_t`**：11 字节短文件名目录项（8+3 格式），含属性、首簇、文件大小等
- **`long_name_entry_t`**：13 字符长文件名目录项，多个连续存储
- 目录项存储在簇链中，通过 FAT 表（文件分配表）链接

### 目录项 API（`kernel/fat32.h` / `kernel/fat32.c`）

#### 路径解析

| 函数 | 作用 |
|------|------|
| `ename(path)` | 从根或 cwd 解析路径，返回目标 dirent |
| `enameparent(path, name)` | 解析父目录，提取文件名到 `name` |
| `enameat(dp, path)` | 从指定目录 `dp` 开始解析路径 |
| `enameparentat(dp, path, name)` | 从指定目录开始解析父路径 |
| `dirlookup(dp, filename, off)` | 在目录 `dp` 中查找名为 `filename` 的子项 |

路径解析遵循：绝对路径（`/` 开头）从根目录开始，相对路径从当前工作目录 (`proc->cwd`) 开始。

#### 生命周期管理

| 函数 | 作用 |
|------|------|
| `edup(entry)` | 增加 dirent 引用计数 |
| `eput(entry)` | 释放 dirent 引用；引用归零时回写并释放 |
| `elock(entry)` | 加锁（睡眠锁） |
| `eunlock(entry)` | 解锁 |
| `ealloc(dp, name, attr)` | 在目录 `dp` 中创建名为 `name` 的新条目，返回已锁定的 dirent |
| `emake(dp, ep, off)` | 将 `ep` 的磁盘目录项写入父目录 `dp` |
| `eremove(entry)` | 从父目录中删除目录项（标记为空） |
| `etrunc(entry)` | 截断文件（释放所有簇） |
| `eupdate(entry)` | 将 dirent 脏数据写回磁盘 |

#### 数据读写

| 函数 | 作用 |
|------|------|
| `eread(ep, user_dst, dst, off, n)` | 从 dirent 的 `off` 处读取 `n` 字节 |
| `ewrite(ep, user_src, src, off, n)` | 向 dirent 的 `off` 处写入 `n` 字节 |
| `enext(dp, ep, off, count)` | 遍历目录 `dp`，读取下一个有效条目到 `ep` |

### 文件层 API（`kernel/file.h` / `kernel/file.c`）

| 函数 | 作用 |
|------|------|
| `filealloc()` | 从全局文件表分配一个 `struct file`（引用计数置 1） |
| `filedup(f)` | 增加文件引用计数 |
| `fileclose(f)` | 减少引用计数；归零时释放关联资源（eput/pipeclose） |
| `fileread(f, addr, n)` | 从文件读取数据（根据类型分发到 eread/piperead/devsw） |
| `filewrite(f, addr, n)` | 向文件写入数据 |
| `filestat(f, addr)` | 获取文件元信息（通过 estat 填充 struct stat） |
| `dirnext(f, addr)` | 遍历目录项，返回下一个 struct stat（用于 getdents） |

### 系统调用与文件层的关系

用户程序 → 系统调用入口（`sysfile.c`） → 文件层 API（`file.c`） → FAT32 API（`fat32.c`） → 磁盘驱动

具体流程：
1. 系统调用解析参数（路径、标志等）
2. 调用 `ename`/`create` 获取或创建目标 dirent
3. 调用 `filealloc` 分配 file 结构 + `fdalloc` 分配 fd
4. 设置 file 的读写权限、偏移量、关联 dirent
5. 后续 `read`/`write` 通过 file → eread/ewrite 操作数据
6. `close` 时 `fileclose` → `eput` 释放 dirent 引用

## 系统调用实现

### `sys_open`（`kernel/sysfile.c`）

打开一个文件或目录。

**参数（通过 trapframe 获取）：**
- `a0`: 路径字符串（用户空间地址）
- `a1`: 打开模式标志（O_RDONLY/O_WRONLY/O_RDWR，可与 O_CREATE/O_TRUNC/O_APPEND/O_DIRECTORY 组合）

**支持 O_DIRECTORY：**
- `O_DIRECTORY`（0x200000）要求目标必须是目录
- 打开目录时，O_DIRECTORY 被视为只读访问（与 O_RDONLY 等效）
- `O_DIRECTORY | O_CREATE` 被拒绝（open 不创建目录）
- 目录只能以只读方式打开，不可写

### `sys_openat`（`kernel/sysfile.c`）

相对于指定目录文件描述符打开文件。

**参数：**
- `dirfd`: 目录文件描述符，`AT_FDCWD`（-100）表示从当前工作目录解析
- `path`: 路径字符串（用户空间地址）
- `flags`: 打开标志（直接透传，Linux 与 xv6 的标志值完全一致）

**AT_FDCWD 处理：**
- `dirfd == AT_FDCWD`：从当前工作目录解析相对路径，委托给 `sys_open`
- `dirfd` 为其他值：从指定目录 fd 解析路径，`sys_openat` 内联完成打开逻辑

**非 AT_FDCWD 实现：**
1. 通过 `fd_get(dirfd, &dirf)` 获取文件结构
2. 验证 fd 指向一个目录（`dirf->type == FD_ENTRY` 且 `ATTR_DIRECTORY`）
3. 通过 `fetchstr` 读取用户空间路径
4. 使用 `enameat(dirf->ep, path)`（非 O_CREATE）或 `enameparentat` + `ealloc`（O_CREATE）解析路径
5. 后续逻辑与 `sys_open` 一致

## 新增路径解析函数（`kernel/fat32.c`）

### `enameat(struct dirent *dp, char *path)`

从指定目录 `dp` 开始解析路径。绝对路径忽略 `dp`，直接调用 `ename` 从根目录解析。

### `enameparentat(struct dirent *dp, char *path, char *name)`

从指定目录 `dp` 开始解析父路径，功能等价于 `enameparent` 但以 `dp` 为起点。

---

### `sys_getdents`（`kernel/sysfile.c`）

读取目录中的条目（get directory entries）。对应 Linux `getdents64` 系统调用，syscall 编号 61。

**参数：**
- `fd`: 指向目录的文件描述符
- `buf`: 用户空间缓冲区地址
- `count`: 缓冲区大小（字节）

**返回：** 写入 `buf` 的字节数；目录读完返回 0；出错返回 -1。

**实现步骤：**
1. 通过 `argfd` 获取文件结构，验证类型是 `FD_ENTRY` 且属性包含 `ATTR_DIRECTORY`
2. 加锁，循环调用 `enext` 读取下一个有效目录条目
3. 每个条目构造为 `linux_dirent64` 结构：

| 偏移 | 大小 | 字段 | 说明 |
|------|------|------|------|
| 0 | 8 字节 | `d_ino` | inode 编号（FAT32 无 inode，填 0） |
| 8 | 8 字节 | `d_off` | 下一条目的文件偏移 |
| 16 | 2 字节 | `d_reclen` | 本条目的总长度（含对齐） |
| 18 | 1 字节 | `d_type` | `DT_DIR`(4) 表示目录，`DT_REG`(8) 表示普通文件 |
| 19 | 变长 | `d_name` | 以 '\0' 结尾的文件名 |

4. `d_reclen` 按 8 字节对齐（`(19 + namelen + 1 + 7) & ~7`）
5. 通过 `copyout2` 将条目写入用户空间
6. 直到缓冲区填满或无更多条目

**与 `sys_readdir` 的区别：**
- `sys_readdir` 返回 `struct stat` 格式的条目（文件名限制 32 字符）
- `sys_getdents` 返回 `linux_dirent64` 格式（支持长文件名，多条目批量读取）
