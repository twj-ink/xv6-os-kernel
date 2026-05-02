//
// File-system system calls.
// Mostly argument checking, since we don't trust
// user code, and calls into file.c and fs.c.
//


#include "include/types.h"
#include "include/riscv.h"
#include "include/param.h"
#include "include/stat.h"
#include "include/spinlock.h"
#include "include/proc.h"
#include "include/sleeplock.h"
#include "include/file.h"
#include "include/pipe.h"
#include "include/fcntl.h"
#include "include/fat32.h"
#include "include/syscall.h"
#include "include/string.h"
#include "include/printf.h"
#include "include/vm.h"

#include <stddef.h>


// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == NULL)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *p = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}

uint64
sys_dup(void)
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}

uint64
sys_read(void)
{
  struct file *f;
  int n;
  uint64 p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    return -1;
  return fileread(f, p, n);
}

uint64
sys_write(void)
{
  struct file *f;
  int n;
  uint64 p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    return -1;

  return filewrite(f, p, n);
}

uint64
sys_close(void)
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}

uint64
sys_fstat(void)
{
  struct file *f;
  uint64 st; // user pointer to struct stat

  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    return -1;
  return filestat2(f, st);
}

static struct dirent*
create(char *path, short type, int mode)
{
  struct dirent *ep, *dp;
  char name[FAT32_MAX_FILENAME + 1];

  if((dp = enameparent(path, name)) == NULL)
    return NULL;

  if (type == T_DIR) {
    mode = ATTR_DIRECTORY;
  } else if (mode & O_RDONLY) {
    mode = ATTR_READ_ONLY;
  } else {
    mode = 0;  
  }

  elock(dp);
  if ((ep = ealloc(dp, name, mode)) == NULL) {
    eunlock(dp);
    eput(dp);
    return NULL;
  }
  
  if ((type == T_DIR && !(ep->attribute & ATTR_DIRECTORY)) ||
      (type == T_FILE && (ep->attribute & ATTR_DIRECTORY))) {
    eunlock(dp);
    eput(ep);
    eput(dp);
    return NULL;
  }

  eunlock(dp);
  eput(dp);

  elock(ep);
  return ep;
}

uint64
sys_open(void)
{
  char path[FAT32_MAX_PATH];
  int fd, omode;
  struct file *f;
  struct dirent *ep;

  if(argstr(0, path, FAT32_MAX_PATH) < 0 || argint(1, &omode) < 0)
    return -1;

  // O_DIRECTORY | O_CREATE 没有意义（open 不创建目录）
  if((omode & O_CREATE) && (omode & O_DIRECTORY))
    return -1;

  if(omode & O_CREATE){
    ep = create(path, T_FILE, omode);
    if(ep == NULL){
      return -1;
    }
  } else {
    if((ep = ename(path)) == NULL){
      return -1;
    }
    elock(ep);
    // 允许 O_RDONLY 或带 O_DIRECTORY 的只读目录访问
    if((ep->attribute & ATTR_DIRECTORY) && (omode & ~O_DIRECTORY) != O_RDONLY){
      eunlock(ep);
      eput(ep);
      return -1;
    }
    // O_DIRECTORY 要求目标必须是目录
    if((omode & O_DIRECTORY) && !(ep->attribute & ATTR_DIRECTORY)){
      eunlock(ep);
      eput(ep);
      return -1;
    }
  }

  if((f = filealloc()) == NULL || (fd = fdalloc(f)) < 0){
    if (f) {
      fileclose(f);
    }
    eunlock(ep);
    eput(ep);
    return -1;
  }

  if(!(ep->attribute & ATTR_DIRECTORY) && (omode & O_TRUNC)){
    etrunc(ep);
  }

  f->type = FD_ENTRY;
  f->off = (omode & O_APPEND) ? ep->file_size : 0;
  f->ep = ep;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  eunlock(ep);

  return fd;
}


uint64
sys_mkdir(void)
{
  char path[FAT32_MAX_PATH];
  struct dirent *ep;

  if(argstr(0, path, FAT32_MAX_PATH) < 0 || (ep = create(path, T_DIR, 0)) == 0){
    return -1;
  }
  eunlock(ep);
  eput(ep);
  return 0;
}

uint64
sys_chdir(void)
{
  char path[FAT32_MAX_PATH];
  struct dirent *ep;
  struct proc *p = myproc();
  
  if(argstr(0, path, FAT32_MAX_PATH) < 0 || (ep = ename(path)) == NULL){
    return -1;
  }
  elock(ep);
  if(!(ep->attribute & ATTR_DIRECTORY)){
    eunlock(ep);
    eput(ep);
    return -1;
  }
  eunlock(ep);
  eput(p->cwd);
  p->cwd = ep;
  return 0;
}

uint64
sys_pipe(void)
{
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();

  if(argaddr(0, &fdarray) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  // if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
  //    copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
  if(copyout2(fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
     copyout2(fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    p->ofile[fd0] = 0;
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
}

// To open console device.
uint64
sys_dev(void)
{
  int fd, omode;
  int major, minor;
  struct file *f;

  if(argint(0, &omode) < 0 || argint(1, &major) < 0 || argint(2, &minor) < 0){
    return -1;
  }

  if(omode & O_CREATE){
    panic("dev file on FAT");
  }

  if(major < 0 || major >= NDEV)
    return -1;

  if((f = filealloc()) == NULL || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    return -1;
  }

  f->type = FD_DEVICE;
  f->off = 0;
  f->ep = 0;
  f->major = major;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
}

// To support ls command
uint64
sys_readdir(void)
{
  struct file *f;
  uint64 p;

  if(argfd(0, 0, &f) < 0 || argaddr(1, &p) < 0)
    return -1;
  return dirnext(f, p);
}

/*
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
  */

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

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct dirent *dp)
{
  struct dirent ep;
  int count;
  int ret;
  ep.valid = 0;
  ret = enext(dp, &ep, 2 * 32, &count);   // skip the "." and ".."
  return ret == -1;
}

uint64
sys_remove(void)
{
  char path[FAT32_MAX_PATH];
  struct dirent *ep;
  int len;
  if((len = argstr(0, path, FAT32_MAX_PATH)) <= 0)
    return -1;

  char *s = path + len - 1;
  while (s >= path && *s == '/') {
    s--;
  }
  if (s >= path && *s == '.' && (s == path || *--s == '/')) {
    return -1;
  }
  
  if((ep = ename(path)) == NULL){
    return -1;
  }
  elock(ep);
  if((ep->attribute & ATTR_DIRECTORY) && !isdirempty(ep)){
      eunlock(ep);
      eput(ep);
      return -1;
  }
  elock(ep->parent);      // Will this lead to deadlock?
  eremove(ep);
  eunlock(ep->parent);
  eunlock(ep);
  eput(ep);

  return 0;
}

// Must hold too many locks at a time! It's possible to raise a deadlock.
// Because this op takes some steps, we can't promise
uint64
sys_rename(void)
{
  char old[FAT32_MAX_PATH], new[FAT32_MAX_PATH];
  if (argstr(0, old, FAT32_MAX_PATH) < 0 || argstr(1, new, FAT32_MAX_PATH) < 0) {
      return -1;
  }

  struct dirent *src = NULL, *dst = NULL, *pdst = NULL;
  int srclock = 0;
  char *name;
  if ((src = ename(old)) == NULL || (pdst = enameparent(new, old)) == NULL
      || (name = formatname(old)) == NULL) {
    goto fail;          // src doesn't exist || dst parent doesn't exist || illegal new name
  }
  for (struct dirent *ep = pdst; ep != NULL; ep = ep->parent) {
    if (ep == src) {    // In what universe can we move a directory into its child?
      goto fail;
    }
  }

  uint off;
  elock(src);     // must hold child's lock before acquiring parent's, because we do so in other similar cases
  srclock = 1;
  elock(pdst);
  dst = dirlookup(pdst, name, &off);
  if (dst != NULL) {
    eunlock(pdst);
    if (src == dst) {
      goto fail;
    } else if (src->attribute & dst->attribute & ATTR_DIRECTORY) {
      elock(dst);
      if (!isdirempty(dst)) {    // it's ok to overwrite an empty dir
        eunlock(dst);
        goto fail;
      }
      elock(pdst);
    } else {                    // src is not a dir || dst exists and is not an dir
      goto fail;
    }
  }

  if (dst) {
    eremove(dst);
    eunlock(dst);
  }
  memmove(src->filename, name, FAT32_MAX_FILENAME);
  emake(pdst, src, off);
  if (src->parent != pdst) {
    eunlock(pdst);
    elock(src->parent);
  }
  eremove(src);
  eunlock(src->parent);
  struct dirent *psrc = src->parent;  // src must not be root, or it won't pass the for-loop test
  src->parent = edup(pdst);
  src->off = off;
  src->valid = 1;
  eunlock(src);

  eput(psrc);
  if (dst) {
    eput(dst);
  }
  eput(pdst);
  eput(src);

  return 0;

fail:
  if (srclock)
    eunlock(src);
  if (dst)
    eput(dst);
  if (pdst)
    eput(pdst);
  if (src)
    eput(src);
  return -1;
}

/*
 * 从proc->ofile[fd]中获得当前打开文件的file结构
 */
int
fd_get(int fd, struct file **pf)
{
  struct proc *p = myproc();

  if (fd < 0 || fd >= NOFILE || p->ofile[fd] == 0) return -1;
  *pf = p->ofile[fd];
  return 0;
}

uint64
sys_mmap(void)
{
  uint64 start, len, off;
  int prot, flags, fd;
  struct proc *p = myproc();
  struct file *f;
  struct vm_area *vma;

  if(argaddr(0, &start) < 0 || argaddr(1, &len) < 0 ||
     argint(2, &prot) < 0 || argint(3, &flags) < 0 ||
     argint(4, &fd) < 0 || argaddr(5, &off) < 0)
    return -1;

  // [WARNING #1] addr = 0

  // If  addr  is  NULL, then the kernel chooses the (page-aligned) address 
  // at which to create the mapping; this is
  // the most portable method of creating a new mapping.
  if (start == 0) {
    // 直接选择进程的末尾，注意这里要扩展进程自己的空间，否则copyin2会失败
    start = p->sz;
    p->sz += len;
  }
  // If addr is not NULL, then the kernel takes it as  a  hint
  // about  where  to place the mapping; 
  // on Linux, the kernel will pick a nearby page boundary 
  start = PGROUNDUP(start);

  if (len == 0) return -1;
  if (off % PGSIZE != 0) return -1;

  // 如果是匿名映射
  if (flags & MAP_ANONYMOUS) {
    // offset应该是0
    if (off != 0) return -1;
  } else {
    // 关联到一个文件
    if (fd_get(fd, &f) != 0) return -1;
    // 现在已经有file *f了
    if (f->type != FD_ENTRY) return -1;
  }

  // 1. 申请一个 vm_area_struct 结构（vma），内核使用 vma 来管理进程的虚拟内存地址
  vma = alloc_vma(p);
  if (vma == NULL) return -1;
  // 2. 设置 vma 结构各个字段的值。
  vma->start = start;
  vma->end = start + len;
  vma->prot = prot;
  vma->flags = flags;
  vma->offset = off;
  if (!(flags & MAP_ANONYMOUS)) {
    // 处理文件计数
    vma->file = f;
    filedup(f); // 增加引用计数
  } else {
    vma->file = NULL;
  }

  return start;
}

uint64
sys_munmap(void)
{
  uint64 start, len;
  uint64 end;
  struct proc *p = myproc();
  struct vm_area *vma;

  if(argaddr(0, &start) < 0 || argaddr(1, &len) < 0) {
    // printf("111\n");
    return -1;
  }

  // The address addr must be a multiple of the page size (but length need not be).
  if (start % PGSIZE != 0) {
    // printf("222\n");
    return -1;
  }

  // **All** pages containing a part of the indicated range are unmapped, 
  // and subsequent references to these pages will generate SIGSEGV. 
  len = PGROUNDUP(len);
  end = start + len;

  // 1. 查找需要unmap的vma
  vma = find_vma(p, start);
  if (vma == NULL) {/*printf("333\n");*/return -1;}

  // 2. 如果是文件映射且是MAP_SHARED，需要先把内存中的数据写回文件
  if ((vma->flags & MAP_SHARED) && vma->file) {
    // 遍历每一页，用ewrite写回
    for (uint64 addr = start; addr < end; addr += PGSIZE) {
      pte_t *pte = walk(p->pagetable, addr, 0);
      if (pte && (*pte & PTE_V)) {
        uint64 pa = PTE2PA(*pte);
        // 这里没有PTE_D，就直接写回吧！
        uint64 file_offset = vma->offset + (addr - vma->start);
        elock(vma->file->ep);
        ewrite(vma->file->ep, 0, pa, file_offset, PGSIZE);
        eunlock(vma->file->ep);
      }
    }
  }

  // 3. 释放物理内存并解除页表映射
  for (uint64 addr = start; addr < end; addr += PGSIZE) {
    pte_t *pte = walk(p->pagetable, addr, 0);
    if (pte && (*pte & PTE_V)) {
      vmunmap(p->pagetable, addr, 1, 1); // 直接do_free=1吧！由于这里没有实现物理页的refcnt还不能判断
    }
    // 还有内核页表
    pte = walk(p->kpagetable, addr, 0);
    if (pte && (*pte & PTE_V)) {
      vmunmap(p->pagetable, addr, 1, 0); // 内核和用户用的是同一个物理页，不能double free
    }
  }

  // 4. 释放文件引用
  if (vma->file) {
    fileclose(vma->file);
    vma->file = NULL;
  }

  // 5. 释放vma
  vma->used = 0;
  p->vma_count--;

    // printf("112221\n");


  return 0;  
}

uint64
sys_mkdirat(void)
{
  int dirfd;
  uint64 path;
  int mode;
  struct proc *p = myproc();

  if(argint(0, &dirfd) < 0 || argaddr(1, &path) < 0 || argint(2, &mode) < 0){
    return -1;
  }

  if (dirfd == AT_FDCWD) {
    uint64 old_a0;
    old_a0 = p->trapframe->a0;
    p->trapframe->a0 = path;
    uint64 ret = sys_mkdir();
    p->trapframe->a0 = old_a0;
    return ret;
  }

  // 非 AT_FDCWD: 从指定目录 fd 解析路径并创建目录
  struct file *dirf;
  char pathbuf[FAT32_MAX_PATH];
  struct dirent *dp, *ep;
  char name[FAT32_MAX_FILENAME + 1];

  if (fd_get(dirfd, &dirf) < 0)
    return -1;
  if (dirf->type != FD_ENTRY || !(dirf->ep->attribute & ATTR_DIRECTORY))
    return -1;

  if (fetchstr(path, pathbuf, FAT32_MAX_PATH) < 0)
    return -1;

  if ((dp = enameparentat(dirf->ep, pathbuf, name)) == NULL)
    return -1;

  elock(dp);
  if ((ep = ealloc(dp, name, ATTR_DIRECTORY)) == NULL) {
    eunlock(dp);
    eput(dp);
    return -1;
  }
  elock(ep);
  if (!(ep->attribute & ATTR_DIRECTORY)) {
    eunlock(ep);
    eunlock(dp);
    eput(ep);
    eput(dp);
    return -1;
  }
  eunlock(dp);
  eput(dp);
  eunlock(ep);
  eput(ep);

  return 0;
}

uint64
sys_openat(void)
{
  int dirfd, flags;
  uint64 path;
  uint64 old_a0, old_a1, ret;
  struct proc *p = myproc();

  if(argint(0, &dirfd) < 0 || argaddr(1, &path) < 0 ||
     argint(2, &flags) < 0)
    return -1;

  if (dirfd == AT_FDCWD) {
    // AT_FDCWD: 从当前工作目录解析路径，委托给 sys_open
    old_a0 = p->trapframe->a0;
    old_a1 = p->trapframe->a1;
    p->trapframe->a0 = path;
    // Linux 和 xv6 的 open flags 值完全一致，直接透传
    p->trapframe->a1 = flags;
    ret = sys_open();
    p->trapframe->a0 = old_a0;
    p->trapframe->a1 = old_a1;
    return ret;
  }

  // 非 AT_FDCWD: 从指定目录 fd 解析路径
  struct file *dirf;
  char pathbuf[FAT32_MAX_PATH];
  int fd, omode = flags;
  struct file *f;
  struct dirent *ep;

  if (fd_get(dirfd, &dirf) < 0)
    return -1;
  if (dirf->type != FD_ENTRY || !(dirf->ep->attribute & ATTR_DIRECTORY))
    return -1;

  if (fetchstr(path, pathbuf, FAT32_MAX_PATH) < 0)
    return -1;

  // O_DIRECTORY | O_CREATE 没有意义（open 不创建目录）
  if((omode & O_CREATE) && (omode & O_DIRECTORY))
    return -1;

  if(omode & O_CREATE){
    struct dirent *dp;
    char name[FAT32_MAX_FILENAME + 1];
    int mode;

    if((dp = enameparentat(dirf->ep, pathbuf, name)) == NULL)
      return -1;

    mode = 0;   // 默认模式：普通文件
    elock(dp);
    if ((ep = ealloc(dp, name, mode)) == NULL) {
      eunlock(dp);
      eput(dp);
      return -1;
    }
    if ((ep->attribute & ATTR_DIRECTORY)) {
      eunlock(dp);
      eput(ep);
      eput(dp);
      return -1;
    }
    eunlock(dp);
    eput(dp);
    elock(ep);
  } else {
    if((ep = enameat(dirf->ep, pathbuf)) == NULL)
      return -1;
    elock(ep);
    // 允许 O_RDONLY 或带 O_DIRECTORY 的只读目录访问
    if((ep->attribute & ATTR_DIRECTORY) && (omode & ~O_DIRECTORY) != O_RDONLY){
      eunlock(ep);
      eput(ep);
      return -1;
    }
    // O_DIRECTORY 要求目标必须是目录
    if((omode & O_DIRECTORY) && !(ep->attribute & ATTR_DIRECTORY)){
      eunlock(ep);
      eput(ep);
      return -1;
    }
  }

  if((f = filealloc()) == NULL || (fd = fdalloc(f)) < 0){
    if (f) fileclose(f);
    eunlock(ep);
    eput(ep);
    return -1;
  }

  if(!(ep->attribute & ATTR_DIRECTORY) && (omode & O_TRUNC))
    etrunc(ep);

  f->type = FD_ENTRY;
  f->off = (omode & O_APPEND) ? ep->file_size : 0;
  f->ep = ep;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  eunlock(ep);
  return fd;
}

// 分配指定的文件描述符
static int
fdalloc2(struct file *f, int fd)
{
  struct proc *p = myproc();
  
  if(fd < 0 || fd >= NOFILE || p->ofile[fd])
    return -1;
  
  p->ofile[fd] = f;
  return 0;
}


uint64
sys_dup2(void)
{
  struct file *f;
  int oldfd, newfd;

  // 获取参数：旧文件描述符和新的文件描述符
  if(argint(0, &oldfd) < 0 || argint(1, &newfd) < 0)
    return -1;
  
  // 验证文件描述符范围
  if(oldfd < 0 || newfd < 0 || oldfd >= NOFILE || newfd >= NOFILE)
    return -1;
  
  // 获取旧文件描述符对应的文件结构
  if(argfd(0, &oldfd, &f) < 0)
    return -1;
  
  // 如果新旧文件描述符相同，直接返回新fd
  if(oldfd == newfd)
    return newfd;
  
  // 如果新文件描述符已经被占用，先关闭它
  if(myproc()->ofile[newfd]) {
    fileclose(myproc()->ofile[newfd]);
    myproc()->ofile[newfd] = 0;
  }
  
  // 分配新的文件描述符（确保newfd可用）
  if(fdalloc2(f, newfd) < 0)
    return -1;
  
  filedup(f);
  return newfd;
}

uint64
sys_dup3(void)
{
  // struct file *f;
  int oldfd, newfd;
  int flags;
  struct proc *p = myproc();

  uint64 old_a0, old_a1, ret;

  // 获取参数：旧文件描述符和新的文件描述符
  if(argint(0, &oldfd) < 0 || argint(1, &newfd) < 0 || argint(2, &flags) < 0)
    return -1;

  old_a0 = p->trapframe->a0;
  old_a1 = p->trapframe->a1;
  p->trapframe->a0 = oldfd;
  p->trapframe->a1 = newfd;
  ret = sys_dup2();
  p->trapframe->a0 = old_a0;
  p->trapframe->a1 = old_a1;
  return ret;
}

uint64
sys_getdents(void)
{
  struct file *f;
  int fd, count;
  uint64 buf;
  struct dirent de;
  int total = 0;

  if(argfd(0, &fd, &f) < 0 || argaddr(1, &buf) < 0 || argint(2, &count) < 0)
    return -1;

  if(f->type != FD_ENTRY || !(f->ep->attribute & ATTR_DIRECTORY))
    return -1;

  elock(f->ep);

  while (total + 32 < count) {
    int cnt;
    int ret;

    memset(&de, 0, sizeof(de));
    ret = enext(f->ep, &de, f->off, &cnt);
    if (ret <= 0) {
      if (ret == 0) {
        f->off += cnt * 32;
        continue;
      }
      break;
    }
    f->off += cnt * 32;

    int headlen = offsetof(struct dirent64, d_name); 
    int namelen = strlen(de.filename);
    int reclen = headlen + namelen + 1;                      
    reclen = (reclen + 7) & ~7;  

    if (total + reclen > count)
      break;

    char entry[256];
    struct dirent64 *d = (struct dirent64 *)entry;           
    memset(d, 0, reclen);                                    
    d->d_off    = f->off;                                    
    d->d_reclen = reclen;                                    
    d->d_type   = (de.attribute & ATTR_DIRECTORY) ? DT_DIR : DT_REG;                                                      
    safestrcpy(d->d_name, de.filename, reclen - headlen);  

    if (copyout2(buf + total, (char *)d, reclen) < 0) {
      eunlock(f->ep);
      return -1;
    }
    total += reclen;
  }

  eunlock(f->ep);
  return total;
}


uint64
sys_unlinkat(void)
{
  int dirfd, flags;
  uint64 path;
  // struct proc *p = myproc();
  struct file *dirf;
  struct dirent *ep;
  char pathbuf[FAT32_MAX_PATH];

  // 使用 argint 而非 argfd：a0 是 int 类型 dirfd，不是文件描述符
  if (argint(0, &dirfd) < 0 || argaddr(1, &path) < 0 || argint(2, &flags) < 0)
    return -1;

  if (fetchstr(path, pathbuf, FAT32_MAX_PATH) < 0)
    return -1;

  // 禁止删除 "." 和 ".."
  int len = strlen(pathbuf);
  char *s = pathbuf + len - 1;
  while (s >= pathbuf && *s == '/') s--;
  if (s >= pathbuf && *s == '.' && (s == pathbuf || *--s == '/'))
    return -1;

  if (dirfd == AT_FDCWD) {
    ep = ename(pathbuf);
  } else {
    if (fd_get(dirfd, &dirf) < 0)
      return -1;
    if (dirf->type != FD_ENTRY || !(dirf->ep->attribute & ATTR_DIRECTORY))
      return -1;
    ep = enameat(dirf->ep, pathbuf);
  }
  if (ep == NULL)
    return -1;

  elock(ep);
  // 无 AT_REMOVEDIR 时不能删除目录
  if (!(flags & AT_REMOVEDIR) && (ep->attribute & ATTR_DIRECTORY)) {
    eunlock(ep); eput(ep); return -1;
  }
  // 有 AT_REMOVEDIR 时目标必须是目录
  if ((flags & AT_REMOVEDIR) && !(ep->attribute & ATTR_DIRECTORY)) {
    eunlock(ep); eput(ep); return -1;
  }
  // 非空目录不能删除
  if ((ep->attribute & ATTR_DIRECTORY) && !isdirempty(ep)) {
    eunlock(ep); eput(ep); return -1;
  }

  elock(ep->parent);
  eremove(ep);
  eunlock(ep->parent);
  eunlock(ep);
  eput(ep);

  return 0;
}

uint64
sys_mount(void)
{
  uint64 source_addr, target_addr, fstype_addr, data;
  int flags;
  char source[FAT32_MAX_PATH], target[FAT32_MAX_PATH], fstype[32];

  if (argaddr(0, &source_addr) < 0 || argaddr(1, &target_addr) < 0 ||
      argaddr(2, &fstype_addr) < 0 || argint(3, &flags) < 0 ||
      argaddr(4, &data) < 0)
    return -1;

  if (fetchstr(source_addr, source, FAT32_MAX_PATH) < 0 ||
      fetchstr(target_addr, target, FAT32_MAX_PATH) < 0 ||
      fetchstr(fstype_addr, fstype, 32) < 0)
    return -1;

  // 验证挂载点存在且是目录
  struct dirent *ep = ename(target);
  if (ep == NULL)
    return -1;
  elock(ep);
  int is_dir = (ep->attribute & ATTR_DIRECTORY);
  eunlock(ep);
  eput(ep);
  if (!is_dir)
    return -1;

  return 0;
}

uint64
sys_umount2(void)
{
  uint64 target_addr;
  int flags;

  if (argaddr(0, &target_addr) < 0 || argint(1, &flags) < 0)
    return -1;

  return 0;
}