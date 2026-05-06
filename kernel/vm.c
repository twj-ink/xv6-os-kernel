#include "include/param.h"
#include "include/types.h"
#include "include/memlayout.h"
#include "include/elf.h"
#include "include/riscv.h"
#include "include/vm.h"
#include "include/kalloc.h"
#include "include/proc.h"
#include "include/printf.h"
#include "include/string.h"

/*
 * the kernel's page table.
 */
pagetable_t kernel_pagetable;

extern char etext[];  // kernel.ld sets this to end of kernel code.
extern char trampoline[]; // trampoline.S
/*
 * create a direct-map page table for the kernel.
 */
void
kvminit()
{
  kernel_pagetable = (pagetable_t) kalloc();
  // printf("kernel_pagetable: %p\n", kernel_pagetable);

  memset(kernel_pagetable, 0, PGSIZE);

  // uart registers
  kvmmap(UART_V, UART, PGSIZE, PTE_R | PTE_W);
  
  #ifdef QEMU
  // virtio mmio disk interface
  kvmmap(VIRTIO0_V, VIRTIO0, PGSIZE, PTE_R | PTE_W);
  #endif
  // CLINT
  kvmmap(CLINT_V, CLINT, 0x10000, PTE_R | PTE_W);

  // PLIC
  kvmmap(PLIC_V, PLIC, 0x4000, PTE_R | PTE_W);
  kvmmap(PLIC_V + 0x200000, PLIC + 0x200000, 0x4000, PTE_R | PTE_W);

  #ifndef QEMU
  // GPIOHS
  kvmmap(GPIOHS_V, GPIOHS, 0x1000, PTE_R | PTE_W);

  // DMAC
  kvmmap(DMAC_V, DMAC, 0x1000, PTE_R | PTE_W);

  // GPIO
  // kvmmap(GPIO_V, GPIO, 0x1000, PTE_R | PTE_W);

  // SPI_SLAVE
  kvmmap(SPI_SLAVE_V, SPI_SLAVE, 0x1000, PTE_R | PTE_W);

  // FPIOA
  kvmmap(FPIOA_V, FPIOA, 0x1000, PTE_R | PTE_W);

  // SPI0
  kvmmap(SPI0_V, SPI0, 0x1000, PTE_R | PTE_W);

  // SPI1
  kvmmap(SPI1_V, SPI1, 0x1000, PTE_R | PTE_W);

  // SPI2
  kvmmap(SPI2_V, SPI2, 0x1000, PTE_R | PTE_W);

  // SYSCTL
  kvmmap(SYSCTL_V, SYSCTL, 0x1000, PTE_R | PTE_W);
  
  #endif
  
  // map rustsbi
  // kvmmap(RUSTSBI_BASE, RUSTSBI_BASE, KERNBASE - RUSTSBI_BASE, PTE_R | PTE_X);
  // map kernel text executable and read-only.
  kvmmap(KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
  // map kernel data and the physical RAM we'll make use of.
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);

  #ifdef DEBUG
  printf("kvminit\n");
  #endif
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
  w_satp(MAKE_SATP(kernel_pagetable));
  // reg_info();
  sfence_vma();
  #ifdef DEBUG
  printf("kvminithart\n");
  #endif
}

// Return the address of the PTE in page table pagetable
// that corresponds to virtual address va.  If alloc!=0,
// create any required page-table pages.
//
// The risc-v Sv39 scheme has three levels of page-table
// pages. A page-table page contains 512 64-bit PTEs.
// A 64-bit virtual address is split into five fields:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
  
  if(va >= MAXVA)
    panic("walk");

  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == NULL)
        return NULL;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
}

// Look up a virtual address, return the physical address,
// or 0 if not mapped.
// Can only be used to look up user pages.
uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    return NULL;

  pte = walk(pagetable, va, 0);
  if(pte == 0)
    return NULL;
  if((*pte & PTE_V) == 0)
    return NULL;
  if((*pte & PTE_U) == 0)
    return NULL;
  pa = PTE2PA(*pte);
  return pa;
}

// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
void
kvmmap(uint64 va, uint64 pa, uint64 sz, int perm)
{
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    panic("kvmmap");
}

// translate a kernel virtual address to
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
  return kwalkaddr(kernel_pagetable, va);
}

uint64
kwalkaddr(pagetable_t kpt, uint64 va)
{
  uint64 off = va % PGSIZE;
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kpt, va, 0);
  if(pte == 0)
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    panic("kvmpa");
  pa = PTE2PA(*pte);
  return pa+off;
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
  last = PGROUNDDOWN(va + size - 1);
  
  for(;;){
    if((pte = walk(pagetable, a, 1)) == NULL)
      return -1;
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
vmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    panic("vmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("vmunmap: walk");
    if((*pte & PTE_V) == 0) {
      // panic("vmunmap: not mapped");
      // printf("vmunmap: not mapped");
      // [WARNING #3] 这意味着解除映射时，如果某个虚拟地址从未被映射
      // （因为懒分配没实际分配页面），`vmunmap` 会正确跳过。
      continue;
    }
    if(PTE_FLAGS(*pte) == PTE_V)
      panic("vmunmap: not a leaf");
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
  if(pagetable == NULL)
    return NULL;
  memset(pagetable, 0, PGSIZE);
  return pagetable;
}

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, pagetable_t kpagetable, uchar *src, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  // printf("[uvminit]kalloc: %p\n", mem);
  memset(mem, 0, PGSIZE);
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
  mappages(kpagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X);
  memmove(mem, src, sz);
  // for (int i = 0; i < sz; i ++) {
  //   printf("[uvminit]mem: %p, %x\n", mem + i, mem[i]);
  // }
}

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
uvmalloc(pagetable_t pagetable, pagetable_t kpagetable, uint64 oldsz, uint64 newsz)
{
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  for(a = oldsz; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == NULL){
      uvmdealloc(pagetable, kpagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0) {
      kfree(mem);
      uvmdealloc(pagetable, kpagetable, a, oldsz);
      return 0;
    }
    if (mappages(kpagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R) != 0){
      int npages = (a - oldsz) / PGSIZE;
      vmunmap(pagetable, oldsz, npages + 1, 1);   // plus the page allocated above.
      vmunmap(kpagetable, oldsz, npages, 0);
      return 0;
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, pagetable_t kpagetable, uint64 oldsz, uint64 newsz)
{
  if(newsz >= oldsz)
    return oldsz;

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    vmunmap(kpagetable, PGROUNDUP(newsz), npages, 0);
    vmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    }
  }
  kfree((void*)pagetable);
}

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
  if(sz > 0)
    vmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
}

// Given a parent process's page table, copy
// its memory into a child's page table.
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, pagetable_t knew, uint64 sz)
{
/* COW版本 */
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE) {
    if((pte = walk(old, i, 0)) == NULL)
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);

    // 父进程页表：清除写权限，设置COW
    *pte = (*pte & ~PTE_W) | PTE_COW;
    // 增加物理页引用计数
    incref_page(pa);
    // 子进程页表：只读，设置COW，映射到同一个物理页
    flags = PTE_FLAGS(*pte); // 呃，这个就是直接复制父进程的flags
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) {
      kfree((uint64*)pa);
      goto err;
    }
    if(mappages(knew, i, PGSIZE, (uint64)pa, flags & ~PTE_U) != 0){
      goto err;
    }
  }
  return 0;
err:
  vmunmap(knew, 0, i / PGSIZE, 0);
  vmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}


//   pte_t *pte;
//   uint64 pa, i = 0, ki = 0;
//   uint flags;
//   char *mem;

//   while (i < sz){
//     if((pte = walk(old, i, 0)) == NULL)
//       panic("uvmcopy: pte should exist");
//     if((*pte & PTE_V) == 0)
//       panic("uvmcopy: page not present");
//     pa = PTE2PA(*pte);
//     flags = PTE_FLAGS(*pte);
//     if((mem = kalloc()) == NULL)
//       goto err;
//     memmove(mem, (char*)pa, PGSIZE);
//     if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
//       kfree(mem);
//       goto err;
//     }
//     i += PGSIZE;
//     if(mappages(knew, ki, PGSIZE, (uint64)mem, flags & ~PTE_U) != 0){
//       goto err;
//     }
//     ki += PGSIZE;
//   }
//   return 0;

//  err:
//   vmunmap(knew, 0, ki / PGSIZE, 0);
//   vmunmap(new, 0, i / PGSIZE, 1);
//   return -1;


// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
  if(pte == NULL)
    panic("uvmclear");
  *pte &= ~PTE_U;
}

// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    va0 = PGROUNDDOWN(dstva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == NULL)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
  }
  return 0;
}

int
copyout2(uint64 dstva, char *src, uint64 len)
{
  uint64 sz = myproc()->sz;
  if (dstva + len > sz || dstva >= sz) {
    return -1;
  }
  memmove((void *)dstva, src, len);
  return 0;
}

// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == NULL)
      return -1;
    n = PGSIZE - (srcva - va0);
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);

    len -= n;
    dst += n;
    srcva = va0 + PGSIZE;
  }
  return 0;
}

int
copyin2(char *dst, uint64 srcva, uint64 len)
{
  uint64 sz = myproc()->sz;
  if (srcva + len > sz || srcva >= sz) {
    return -1;
  }
  memmove(dst, (void *)srcva, len);
  return 0;
}

// // [WARNING #2] fat32.c: eread()->fat32.c: rw_clus()->proc.c: either_copyin()->vm.c: copyin2()
// // 这个copyin2他妈的会检查地址是不是超过了p->sz，然而mmap的第一个参数addr=0的时候我们默认放在进程空间末尾
// // 导致copyin2会失败，没有东西会读出来，所以修改copyin2不要做范围检查，直接用copyin
// int
// copyin2(char* dst, uint64 srcva, uint64 len) {
//   pagetable_t pagetable = myproc()->pagetable;
//   return copyin(pagetable, dst, srcva, len);
// }

// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == NULL)
      return -1;
    n = PGSIZE - (srcva - va0);
    if(n > max)
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
        got_null = 1;
        break;
      } else {
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    return 0;
  } else {
    return -1;
  }
}

int
copyinstr2(char *dst, uint64 srcva, uint64 max)
{
  int got_null = 0;
  uint64 sz = myproc()->sz;
  while(srcva < sz && max > 0){
    char *p = (char *)srcva;
    if(*p == '\0'){
      *dst = '\0';
      got_null = 1;
      break;
    } else {
      *dst = *p;
    }
    --max;
    srcva++;
    dst++;
  }
  if(got_null){
    return 0;
  } else {
    return -1;
  }
}

// initialize kernel pagetable for each process.
pagetable_t
proc_kpagetable()
{
  pagetable_t kpt = (pagetable_t) kalloc();
  if (kpt == NULL)
    return NULL;
  memmove(kpt, kernel_pagetable, PGSIZE);

  // remap stack and trampoline, because they share the same page table of level 1 and 0
  char *pstack = kalloc();
  if(pstack == NULL)
    goto fail;
  if (mappages(kpt, VKSTACK, PGSIZE, (uint64)pstack, PTE_R | PTE_W) != 0)
    goto fail;
  
  return kpt;

fail:
  kvmfree(kpt, 1);
  return NULL;
}

// only free page table, not physical pages
void
kfreewalk(pagetable_t kpt)
{
  for (int i = 0; i < 512; i++) {
    pte_t pte = kpt[i];
    if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
      kfreewalk((pagetable_t) PTE2PA(pte));
      kpt[i] = 0;
    } else if (pte & PTE_V) {
      break;
    }
  }
  kfree((void *) kpt);
}

void
kvmfreeusr(pagetable_t kpt)
{
  pte_t pte;
  for (int i = 0; i < PX(2, MAXUVA); i++) {
    pte = kpt[i];
    if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
      kfreewalk((pagetable_t) PTE2PA(pte));
      kpt[i] = 0;
    }
  }
}

void
kvmfree(pagetable_t kpt, int stack_free)
{
  if (stack_free) {
    vmunmap(kpt, VKSTACK, 1, 1);
    pte_t pte = kpt[PX(2, VKSTACK)];
    if ((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
      kfreewalk((pagetable_t) PTE2PA(pte));
    }
  }
  kvmfreeusr(kpt);
  kfree(kpt);
}

void vmprint(pagetable_t pagetable)
{
  const int capacity = 512;
  printf("page table %p\n", pagetable);
  for (pte_t *pte = (pte_t *) pagetable; pte < pagetable + capacity; pte++) {
    if (*pte & PTE_V)
    {
      pagetable_t pt2 = (pagetable_t) PTE2PA(*pte); 
      printf("..%d: pte %p pa %p\n", pte - pagetable, *pte, pt2);

      for (pte_t *pte2 = (pte_t *) pt2; pte2 < pt2 + capacity; pte2++) {
        if (*pte2 & PTE_V)
        {
          pagetable_t pt3 = (pagetable_t) PTE2PA(*pte2);
          printf(".. ..%d: pte %p pa %p\n", pte2 - pt2, *pte2, pt3);

          for (pte_t *pte3 = (pte_t *) pt3; pte3 < pt3 + capacity; pte3++)
            if (*pte3 & PTE_V)
              printf(".. .. ..%d: pte %p pa %p\n", pte3 - pt3, *pte3, PTE2PA(*pte3));
        }
      }
    }
  }
  return;
}


// 查找包含进程所需的虚拟地址的vma
struct vm_area* 
find_vma(struct proc *p, uint64 addr) 
{
  for (int i = 0; i < p->vma_count; i++) {
    struct vm_area *vma = &p->vma[i];
    if (vma->used && vma->start <= addr && addr < vma->end) {
      return vma;
    }
  }
  return NULL;
}

struct vm_area* 
alloc_vma(struct proc *p)
{
  if (p->vma_count >= MAX_VMA) {
    return NULL;
  }
  for (int i = 0; i < MAX_VMA; i++) {
    if (!p->vma[i].used) {
      p->vma[i].used = 1;
      p->vma_count++;
      return &p->vma[i];
    }
  }
  return NULL;
}

int
handle_page_fault(struct proc *p, uint64 va, int cause)
{
  struct vm_area *vma = find_vma(p, va);
  uint64 a = PGROUNDDOWN(va);
  char *mem;
  uint64 perm;
  uint64 file_offset;
  
  // 1. 检查 VMA 是否存在
  // if (vma == NULL) {
  //   printf("page fault: no VMA for va=%p\n", va);
  //   return -1;
  // }

  if (vma != NULL) 
  
  {                                             
      // ====== mmap 路径 ======                  
      // 权限检查 + kalloc + 文件读取 + mappages                 
    
    // 2. 检查访问权限
    if (cause == 13) {  // Load page fault (读)
      if (!(vma->prot & PROT_READ)) {
          printf("page fault: read permission denied\n");
          return -1;
      }
    } else if (cause == 15) {  // Store page fault (写)
      if (!(vma->prot & PROT_WRITE)) {
          printf("page fault: write permission denied\n");
          return -1;
      }
    } else {
      printf("page fault: unknown cause %d\n", cause);
      return -1;
    }
    
    // 3. 分配物理页
    mem = kalloc();
    if (mem == NULL) {
      printf("page fault: out of memory\n");
      return -1;
    }
    // 注：先默认是匿名映射，把物理页都清零
    memset(mem, 0, PGSIZE);
    
    // 4. 如果是文件映射，读取文件内容
    // 每次读取一整页，va是当前需求的地址，a是页对齐后的地址，现在需要
    // 把a到a+PGSIZE这一页文件内容读到mem中
    if (vma->file != NULL) {
      // 这里的file_offset就是原本保存的文件偏移+当前页的起始地址-映射的起始地址
      // 比如说如果当前需求的va在第一页内，那么第二项就是0；
      // 如果在第二页内，那么第二项就是一个PGSIZE，从而在文件中读取对应位置的内容
      file_offset = vma->offset + (a - vma->start);
      elock(vma->file->ep);
      eread(vma->file->ep, 0, (uint64)mem, file_offset, PGSIZE);
      eunlock(vma->file->ep);
    }
    
    /* 接下来是建立页表映射，否则页表项的valid依旧是0，也就是说假如不建立页表映射
    * 就会发生无限缺页异常循环
    */
    // 5. 计算用户页表权限
    perm = PTE_U;
    if (vma->prot & PROT_READ)
      perm |= PTE_R;
    if (vma->prot & PROT_WRITE)
      perm |= PTE_W;
    if (vma->prot & PROT_EXEC)
      perm |= PTE_X;
    
    // 6. 映射用户页表
    if (mappages(p->pagetable, a, PGSIZE, (uint64)mem, perm) != 0) {
      printf("page fault: mappages failed\n");
      kfree(mem);
      return -1;
    }
    
    // 7. 同时映射到内核页表（方便内核访问）
    if (mappages(p->kpagetable, a, PGSIZE, (uint64)mem, (perm & ~PTE_U)) != 0) {
      printf("page fault: kernel mappages failed\n");
      vmunmap(p->pagetable, a, 1, 1);
      kfree(mem);
      p->killed = 1;
      return -1;
    }
    
    // printf("page fault: successfully mapped page at %p\n", a);

    return 0;
  }

  else
    // ====== sbrk 懒分配路径 ======
  {
    // 1. 对齐边界
    va = PGROUNDDOWN(va);
    // 2. 检验合法性
    if (va >= p->sz) {
      return -1; // 因为sz已经扩过了
    }
    // 3. 检测是否已经有映射，有就错误了
    pte_t *pte = walk(p->pagetable, va, 0);
    if (pte != NULL && (*pte & PTE_V) != 0) {
      return -1;
    }
    // 4. 分配物理页
    mem = kalloc();
    if (mem == NULL)
        return -1;   // 内存耗尽
    memset(mem, 0, PGSIZE);
    // 5. 设置权限，默认可读写
    perm = PTE_U;
    perm |= PTE_R | PTE_W;
    // 6. 建立页表映射
    if (mappages(p->pagetable, va, PGSIZE, (uint64)mem, perm) < 0) {
      kfree(mem);
      return -1;
    }

    // 7. 映射到内核页表
    if (mappages(p->kpagetable, va, PGSIZE, (uint64)mem, perm) < 0) {
      vmunmap(p->pagetable, va, 1, 0);   // 回滚用户页表
      kfree(mem);
      return -1;
    }

    return 0;
  }

}

/*
 * COW 缺页处理器
 * @return  0 成功处理；-1 不是 COW 页面（交由其他 handler 处理）
 */
int cow_handler(struct proc *p, uint64 va) {
    va = PGROUNDDOWN(va);

    // ① 检查是否有有效 PTE
    pte_t *pte = walk(p->pagetable, va, 0);
    if (pte == NULL || !(*pte & PTE_V))
        return -1;                    // 不是 COW → 交给后续处理

    // ② 检查是否是 COW 页面
    if (!(*pte & PTE_COW))
        return -1;                    // 有映射但不是 COW → 交给后续处理

    uint64 pa = PTE2PA(*pte);
    uint flags = PTE_FLAGS(*pte);
    int ref = get_page_ref(pa);

    if (ref == 1) {
        // ③ refcount == 1：仅当前进程持有，无需复制，直接恢复写权限
        *pte = PA2PTE(pa) | (flags & ~PTE_COW) | PTE_W;
        // 同步内核页表
        pte_t *kpte = walk(p->kpagetable, va, 0);
        if (kpte)
            *kpte = PA2PTE(pa) | ((flags & ~PTE_COW & ~PTE_U) | PTE_W);
        return 0;
    }

    // ④ refcount > 1：有其他进程也在共享，必须复制
    char *mem = kalloc();
    if (mem == NULL) return -1;
    memmove(mem, (char*)pa, PGSIZE);

    // 原物理页 refcount -1（当前进程不再引用它）
    kfree((void*)pa);   // kfree 内部 refcount--，归零才真释放

    // 新页映射：恢复 PTE_W，清除 PTE_COW
    uint newflags = (flags & ~PTE_COW) | PTE_W;
    *pte = PA2PTE((uint64)mem) | newflags;

    // 同步内核页表
    pte_t *kpte = walk(p->kpagetable, va, 0);
    if (kpte)
        *kpte = PA2PTE((uint64)mem) | (newflags & ~PTE_U);

    return 0;
}