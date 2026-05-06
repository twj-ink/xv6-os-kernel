
xv6-user/testcases/_judger:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
* After fork, physical page count should remain the same (shared pages).
* After writing to a page in either process, the page should be copied and
* the physical page count should increase by one.
*/

int main() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	0880                	addi	s0,sp,80
    printf("Testing Copy-on-Write\n");
  14:	00001517          	auipc	a0,0x1
  18:	c1450513          	addi	a0,a0,-1004 # c28 <malloc+0xee>
  1c:	00001097          	auipc	ra,0x1
  20:	a66080e7          	jalr	-1434(ra) # a82 <printf>
    
    // Get initial physical page count
    int initial_pages = getpgcnt();
  24:	00000097          	auipc	ra,0x0
  28:	76e080e7          	jalr	1902(ra) # 792 <getpgcnt>
  2c:	89aa                	mv	s3,a0
    printf("Initial physical pages: %d\n", initial_pages);
  2e:	85aa                	mv	a1,a0
  30:	00001517          	auipc	a0,0x1
  34:	c1050513          	addi	a0,a0,-1008 # c40 <malloc+0x106>
  38:	00001097          	auipc	ra,0x1
  3c:	a4a080e7          	jalr	-1462(ra) # a82 <printf>
    
    // Allocate and initialize a page
    char *mem = sbrk(SIZE);
  40:	6505                	lui	a0,0x1
  42:	00000097          	auipc	ra,0x0
  46:	646080e7          	jalr	1606(ra) # 688 <sbrk>
  4a:	892a                	mv	s2,a0
    if (mem == (char*)-1) {
  4c:	57fd                	li	a5,-1
  4e:	4701                	li	a4,0
        printf("sbrk failed\n");
        exit(1);
    }
    
    int write_sum = 0;
  50:	4481                	li	s1,0

    for (int i = 0; i < SIZE; i++) {
  52:	6605                	lui	a2,0x1
    if (mem == (char*)-1) {
  54:	06f50563          	beq	a0,a5,be <main+0xbe>
        mem[i] = i % 256;
  58:	41f7569b          	sraiw	a3,a4,0x1f
  5c:	0186d69b          	srliw	a3,a3,0x18
  60:	00e687bb          	addw	a5,a3,a4
  64:	0ff7f793          	zext.b	a5,a5
  68:	9f95                	subw	a5,a5,a3
  6a:	00e906b3          	add	a3,s2,a4
  6e:	00f68023          	sb	a5,0(a3)
        write_sum += mem[i];
  72:	0ff7f793          	zext.b	a5,a5
  76:	9cbd                	addw	s1,s1,a5
    for (int i = 0; i < SIZE; i++) {
  78:	0705                	addi	a4,a4,1
  7a:	fcc71fe3          	bne	a4,a2,58 <main+0x58>
    }
    
    int after_init_pages = getpgcnt();
  7e:	00000097          	auipc	ra,0x0
  82:	714080e7          	jalr	1812(ra) # 792 <getpgcnt>
  86:	8a2a                	mv	s4,a0
    printf("Physical pages after initialization: %d (should be +1)\n", after_init_pages);
  88:	85aa                	mv	a1,a0
  8a:	00001517          	auipc	a0,0x1
  8e:	be650513          	addi	a0,a0,-1050 # c70 <malloc+0x136>
  92:	00001097          	auipc	ra,0x1
  96:	9f0080e7          	jalr	-1552(ra) # a82 <printf>
    
    if (after_init_pages != initial_pages + 1) {
  9a:	0019859b          	addiw	a1,s3,1
  9e:	03458d63          	beq	a1,s4,d8 <main+0xd8>
        printf("ERROR: Expected %d pages, got %d\n", initial_pages + 1, after_init_pages);
  a2:	8652                	mv	a2,s4
  a4:	00001517          	auipc	a0,0x1
  a8:	c0450513          	addi	a0,a0,-1020 # ca8 <malloc+0x16e>
  ac:	00001097          	auipc	ra,0x1
  b0:	9d6080e7          	jalr	-1578(ra) # a82 <printf>
        exit(1);
  b4:	4505                	li	a0,1
  b6:	00000097          	auipc	ra,0x0
  ba:	54e080e7          	jalr	1358(ra) # 604 <exit>
        printf("sbrk failed\n");
  be:	00001517          	auipc	a0,0x1
  c2:	ba250513          	addi	a0,a0,-1118 # c60 <malloc+0x126>
  c6:	00001097          	auipc	ra,0x1
  ca:	9bc080e7          	jalr	-1604(ra) # a82 <printf>
        exit(1);
  ce:	4505                	li	a0,1
  d0:	00000097          	auipc	ra,0x0
  d4:	534080e7          	jalr	1332(ra) # 604 <exit>
    }

    int sz = getprocsz();
  d8:	00000097          	auipc	ra,0x0
  dc:	6c6080e7          	jalr	1734(ra) # 79e <getprocsz>
  e0:	8aaa                	mv	s5,a0
        + 1             // kernel page table, in `proc_kpagetable`
        + 1 + 2         // kernel stack with mapping, in `proc_kpagetable`
        ;
    
    // Fork a process
    int pid = fork();
  e2:	00000097          	auipc	ra,0x0
  e6:	51a080e7          	jalr	1306(ra) # 5fc <fork>
  ea:	89aa                	mv	s3,a0
    if (pid < 0) {
  ec:	08054c63          	bltz	a0,184 <main+0x184>
        printf("fork failed\n");
        exit(1);
    }
    
    int after_fork_pages = getpgcnt();
  f0:	00000097          	auipc	ra,0x0
  f4:	6a2080e7          	jalr	1698(ra) # 792 <getpgcnt>
  f8:	8b2a                	mv	s6,a0
    printf("Physical pages after fork: %d\n", after_fork_pages);
  fa:	85aa                	mv	a1,a0
  fc:	00001517          	auipc	a0,0x1
 100:	be450513          	addi	a0,a0,-1052 # ce0 <malloc+0x1a6>
 104:	00001097          	auipc	ra,0x1
 108:	97e080e7          	jalr	-1666(ra) # a82 <printf>
        (sz / PGSIZE)   // copy allocated memory pages, in `uvmcopy`
 10c:	6785                	lui	a5,0x1
 10e:	02fac7bb          	divw	a5,s5,a5
    int delta_without_cow = 
 112:	27b1                	addiw	a5,a5,12 # 100c <digits+0xc>
    
    if (after_fork_pages >= after_init_pages + delta_without_cow) {
 114:	014787bb          	addw	a5,a5,s4
 118:	08fb5363          	bge	s6,a5,19e <main+0x19e>
        printf("ERROR: Page count changed too much from %d to %d after fork without write\n", after_init_pages, after_fork_pages);
    }
    
    if (pid == 0) {
 11c:	12099163          	bnez	s3,23e <main+0x23e>
        // Child process
        // Read from the shared page (should not trigger copy)
        int child_before_read = getpgcnt();
 120:	00000097          	auipc	ra,0x0
 124:	672080e7          	jalr	1650(ra) # 792 <getpgcnt>
 128:	8a2a                	mv	s4,a0
        printf("Physical pages before child read: %d\n", child_before_read);
 12a:	85aa                	mv	a1,a0
 12c:	00001517          	auipc	a0,0x1
 130:	c2450513          	addi	a0,a0,-988 # d50 <malloc+0x216>
 134:	00001097          	auipc	ra,0x1
 138:	94e080e7          	jalr	-1714(ra) # a82 <printf>

        int sum = 0;
        for (int i = 0; i < SIZE; i++) {
 13c:	87ca                	mv	a5,s2
 13e:	6685                	lui	a3,0x1
 140:	96ca                	add	a3,a3,s2
            sum += mem[i];
 142:	0007c703          	lbu	a4,0(a5)
 146:	013709bb          	addw	s3,a4,s3
        for (int i = 0; i < SIZE; i++) {
 14a:	0785                	addi	a5,a5,1
 14c:	fed79be3          	bne	a5,a3,142 <main+0x142>
        }
        printf("Child read sum: %d\n", sum);
 150:	85ce                	mv	a1,s3
 152:	00001517          	auipc	a0,0x1
 156:	c2650513          	addi	a0,a0,-986 # d78 <malloc+0x23e>
 15a:	00001097          	auipc	ra,0x1
 15e:	928080e7          	jalr	-1752(ra) # a82 <printf>
        
        if (sum != write_sum) {
 162:	04998963          	beq	s3,s1,1b4 <main+0x1b4>
            printf("ERROR: Data corruption. Sum should be %d, but got %d\n", write_sum, sum);
 166:	864e                	mv	a2,s3
 168:	85a6                	mv	a1,s1
 16a:	00001517          	auipc	a0,0x1
 16e:	c2650513          	addi	a0,a0,-986 # d90 <malloc+0x256>
 172:	00001097          	auipc	ra,0x1
 176:	910080e7          	jalr	-1776(ra) # a82 <printf>
            exit(2);
 17a:	4509                	li	a0,2
 17c:	00000097          	auipc	ra,0x0
 180:	488080e7          	jalr	1160(ra) # 604 <exit>
        printf("fork failed\n");
 184:	00001517          	auipc	a0,0x1
 188:	b4c50513          	addi	a0,a0,-1204 # cd0 <malloc+0x196>
 18c:	00001097          	auipc	ra,0x1
 190:	8f6080e7          	jalr	-1802(ra) # a82 <printf>
        exit(1);
 194:	4505                	li	a0,1
 196:	00000097          	auipc	ra,0x0
 19a:	46e080e7          	jalr	1134(ra) # 604 <exit>
        printf("ERROR: Page count changed too much from %d to %d after fork without write\n", after_init_pages, after_fork_pages);
 19e:	865a                	mv	a2,s6
 1a0:	85d2                	mv	a1,s4
 1a2:	00001517          	auipc	a0,0x1
 1a6:	b5e50513          	addi	a0,a0,-1186 # d00 <malloc+0x1c6>
 1aa:	00001097          	auipc	ra,0x1
 1ae:	8d8080e7          	jalr	-1832(ra) # a82 <printf>
 1b2:	b7ad                	j	11c <main+0x11c>
        }
        
        int child_after_read = getpgcnt();
 1b4:	00000097          	auipc	ra,0x0
 1b8:	5de080e7          	jalr	1502(ra) # 792 <getpgcnt>
 1bc:	84aa                	mv	s1,a0
        printf("Physical pages after child read: %d (should be same)\n", child_after_read);
 1be:	85aa                	mv	a1,a0
 1c0:	00001517          	auipc	a0,0x1
 1c4:	c0850513          	addi	a0,a0,-1016 # dc8 <malloc+0x28e>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	8ba080e7          	jalr	-1862(ra) # a82 <printf>
        
        if (child_after_read != child_before_read) {
 1d0:	009a0f63          	beq	s4,s1,1ee <main+0x1ee>
            printf("ERROR: Page count changed after read\n");
 1d4:	00001517          	auipc	a0,0x1
 1d8:	c2c50513          	addi	a0,a0,-980 # e00 <malloc+0x2c6>
 1dc:	00001097          	auipc	ra,0x1
 1e0:	8a6080e7          	jalr	-1882(ra) # a82 <printf>
            exit(3);
 1e4:	450d                	li	a0,3
 1e6:	00000097          	auipc	ra,0x0
 1ea:	41e080e7          	jalr	1054(ra) # 604 <exit>
        }
        
        // Write to the page (should trigger copy)
        mem[0] = 0xFF;
 1ee:	57fd                	li	a5,-1
 1f0:	00f90023          	sb	a5,0(s2)
        int child_write_pages = getpgcnt();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	59e080e7          	jalr	1438(ra) # 792 <getpgcnt>
 1fc:	84aa                	mv	s1,a0
        printf("Physical pages after child write: %d (should be increased)\n", child_write_pages);
 1fe:	85aa                	mv	a1,a0
 200:	00001517          	auipc	a0,0x1
 204:	c2850513          	addi	a0,a0,-984 # e28 <malloc+0x2ee>
 208:	00001097          	auipc	ra,0x1
 20c:	87a080e7          	jalr	-1926(ra) # a82 <printf>
        
        if (child_write_pages < after_fork_pages + 1) {
 210:	029b4263          	blt	s6,s1,234 <main+0x234>
            printf("ERROR: Expected at least %d pages, got %d\n", after_fork_pages + 1, child_write_pages);
 214:	8626                	mv	a2,s1
 216:	001b059b          	addiw	a1,s6,1
 21a:	00001517          	auipc	a0,0x1
 21e:	c4e50513          	addi	a0,a0,-946 # e68 <malloc+0x32e>
 222:	00001097          	auipc	ra,0x1
 226:	860080e7          	jalr	-1952(ra) # a82 <printf>
            exit(1);
 22a:	4505                	li	a0,1
 22c:	00000097          	auipc	ra,0x0
 230:	3d8080e7          	jalr	984(ra) # 604 <exit>
        }
        
        exit(0);
 234:	4501                	li	a0,0
 236:	00000097          	auipc	ra,0x0
 23a:	3ce080e7          	jalr	974(ra) # 604 <exit>
    } else {
        // Parent process
        int status ;
        wait(&status);
 23e:	fbc40513          	addi	a0,s0,-68
 242:	00000097          	auipc	ra,0x0
 246:	3cc080e7          	jalr	972(ra) # 60e <wait>
        printf("wait status:%d\n", status);
 24a:	fbc42583          	lw	a1,-68(s0)
 24e:	00001517          	auipc	a0,0x1
 252:	c4a50513          	addi	a0,a0,-950 # e98 <malloc+0x35e>
 256:	00001097          	auipc	ra,0x1
 25a:	82c080e7          	jalr	-2004(ra) # a82 <printf>
        int before_write_pages = getpgcnt();
 25e:	00000097          	auipc	ra,0x0
 262:	534080e7          	jalr	1332(ra) # 792 <getpgcnt>
 266:	8a2a                	mv	s4,a0
        
        // Check that parent's page is unchanged
        int sum = 0;
        for (int i = 0; i < SIZE; i++) {
 268:	87ca                	mv	a5,s2
 26a:	6685                	lui	a3,0x1
 26c:	96ca                	add	a3,a3,s2
        int sum = 0;
 26e:	4981                	li	s3,0
            sum += mem[i];
 270:	0007c703          	lbu	a4,0(a5)
 274:	013709bb          	addw	s3,a4,s3
        for (int i = 0; i < SIZE; i++) {
 278:	0785                	addi	a5,a5,1
 27a:	fed79be3          	bne	a5,a3,270 <main+0x270>
        }
        printf("Parent read sum: %d\n", sum);
 27e:	85ce                	mv	a1,s3
 280:	00001517          	auipc	a0,0x1
 284:	c2850513          	addi	a0,a0,-984 # ea8 <malloc+0x36e>
 288:	00000097          	auipc	ra,0x0
 28c:	7fa080e7          	jalr	2042(ra) # a82 <printf>

        if (sum != write_sum) {
 290:	02998163          	beq	s3,s1,2b2 <main+0x2b2>
            printf("ERROR: Data corruption. Sum should be %d, but got %d\n", write_sum, sum);
 294:	864e                	mv	a2,s3
 296:	85a6                	mv	a1,s1
 298:	00001517          	auipc	a0,0x1
 29c:	af850513          	addi	a0,a0,-1288 # d90 <malloc+0x256>
 2a0:	00000097          	auipc	ra,0x0
 2a4:	7e2080e7          	jalr	2018(ra) # a82 <printf>
            exit(1);
 2a8:	4505                	li	a0,1
 2aa:	00000097          	auipc	ra,0x0
 2ae:	35a080e7          	jalr	858(ra) # 604 <exit>
        }
        
        int after_read_pages = getpgcnt();
 2b2:	00000097          	auipc	ra,0x0
 2b6:	4e0080e7          	jalr	1248(ra) # 792 <getpgcnt>
 2ba:	84aa                	mv	s1,a0
        printf("Physical pages after child exit: %d (should be same as before read)\n", after_read_pages);
 2bc:	85aa                	mv	a1,a0
 2be:	00001517          	auipc	a0,0x1
 2c2:	c0250513          	addi	a0,a0,-1022 # ec0 <malloc+0x386>
 2c6:	00000097          	auipc	ra,0x0
 2ca:	7bc080e7          	jalr	1980(ra) # a82 <printf>
        
        if (after_read_pages != before_write_pages) {
 2ce:	029a0163          	beq	s4,s1,2f0 <main+0x2f0>
            printf("ERROR: Expected %d pages, got %d\n", before_write_pages, after_read_pages);
 2d2:	8626                	mv	a2,s1
 2d4:	85d2                	mv	a1,s4
 2d6:	00001517          	auipc	a0,0x1
 2da:	9d250513          	addi	a0,a0,-1582 # ca8 <malloc+0x16e>
 2de:	00000097          	auipc	ra,0x0
 2e2:	7a4080e7          	jalr	1956(ra) # a82 <printf>
            exit(1);
 2e6:	4505                	li	a0,1
 2e8:	00000097          	auipc	ra,0x0
 2ec:	31c080e7          	jalr	796(ra) # 604 <exit>
        }
        
        // Parent writes to the page (should not trigger copy as child is gone)
        mem[0] = 0xAA;
 2f0:	faa00793          	li	a5,-86
 2f4:	00f90023          	sb	a5,0(s2)
        int parent_write_pages = getpgcnt();
 2f8:	00000097          	auipc	ra,0x0
 2fc:	49a080e7          	jalr	1178(ra) # 792 <getpgcnt>
 300:	892a                	mv	s2,a0
        printf("Physical pages after parent write: %d (should be same)\n", parent_write_pages);
 302:	85aa                	mv	a1,a0
 304:	00001517          	auipc	a0,0x1
 308:	c0450513          	addi	a0,a0,-1020 # f08 <malloc+0x3ce>
 30c:	00000097          	auipc	ra,0x0
 310:	776080e7          	jalr	1910(ra) # a82 <printf>
        
        if (parent_write_pages != after_read_pages) {
 314:	01248f63          	beq	s1,s2,332 <main+0x332>
            printf("ERROR: Page count changed after parent write\n");
 318:	00001517          	auipc	a0,0x1
 31c:	c2850513          	addi	a0,a0,-984 # f40 <malloc+0x406>
 320:	00000097          	auipc	ra,0x0
 324:	762080e7          	jalr	1890(ra) # a82 <printf>
            exit(1);
 328:	4505                	li	a0,1
 32a:	00000097          	auipc	ra,0x0
 32e:	2da080e7          	jalr	730(ra) # 604 <exit>
        }
    }
    
    printf("Copy-on-Write Test Completed Successfully\n");
 332:	00001517          	auipc	a0,0x1
 336:	c3e50513          	addi	a0,a0,-962 # f70 <malloc+0x436>
 33a:	00000097          	auipc	ra,0x0
 33e:	748080e7          	jalr	1864(ra) # a82 <printf>
    exit(0);
 342:	4501                	li	a0,0
 344:	00000097          	auipc	ra,0x0
 348:	2c0080e7          	jalr	704(ra) # 604 <exit>

000000000000034c <strcpy>:
#include "kernel/include/fcntl.h"
#include "xv6-user/user.h"

char*
strcpy(char *s, const char *t)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 352:	87aa                	mv	a5,a0
 354:	0585                	addi	a1,a1,1
 356:	0785                	addi	a5,a5,1
 358:	fff5c703          	lbu	a4,-1(a1)
 35c:	fee78fa3          	sb	a4,-1(a5)
 360:	fb75                	bnez	a4,354 <strcpy+0x8>
    ;
  return os;
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strcat>:

char*
strcat(char *s, const char *t)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  char *os = s;
  while(*s)
 36e:	00054783          	lbu	a5,0(a0)
 372:	c385                	beqz	a5,392 <strcat+0x2a>
 374:	87aa                	mv	a5,a0
    s++;
 376:	0785                	addi	a5,a5,1
  while(*s)
 378:	0007c703          	lbu	a4,0(a5)
 37c:	ff6d                	bnez	a4,376 <strcat+0xe>
  while((*s++ = *t++))
 37e:	0585                	addi	a1,a1,1
 380:	0785                	addi	a5,a5,1
 382:	fff5c703          	lbu	a4,-1(a1)
 386:	fee78fa3          	sb	a4,-1(a5)
 38a:	fb75                	bnez	a4,37e <strcat+0x16>
    ;
  return os;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
  while(*s)
 392:	87aa                	mv	a5,a0
 394:	b7ed                	j	37e <strcat+0x16>

0000000000000396 <strcmp>:


int
strcmp(const char *p, const char *q)
{
 396:	1141                	addi	sp,sp,-16
 398:	e422                	sd	s0,8(sp)
 39a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	cb91                	beqz	a5,3b4 <strcmp+0x1e>
 3a2:	0005c703          	lbu	a4,0(a1)
 3a6:	00f71763          	bne	a4,a5,3b4 <strcmp+0x1e>
    p++, q++;
 3aa:	0505                	addi	a0,a0,1
 3ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3ae:	00054783          	lbu	a5,0(a0)
 3b2:	fbe5                	bnez	a5,3a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3b4:	0005c503          	lbu	a0,0(a1)
}
 3b8:	40a7853b          	subw	a0,a5,a0
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret

00000000000003c2 <strlen>:

uint
strlen(const char *s)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3c8:	00054783          	lbu	a5,0(a0)
 3cc:	cf91                	beqz	a5,3e8 <strlen+0x26>
 3ce:	0505                	addi	a0,a0,1
 3d0:	87aa                	mv	a5,a0
 3d2:	4685                	li	a3,1
 3d4:	9e89                	subw	a3,a3,a0
 3d6:	00f6853b          	addw	a0,a3,a5
 3da:	0785                	addi	a5,a5,1
 3dc:	fff7c703          	lbu	a4,-1(a5)
 3e0:	fb7d                	bnez	a4,3d6 <strlen+0x14>
    ;
  return n;
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
  for(n = 0; s[n]; n++)
 3e8:	4501                	li	a0,0
 3ea:	bfe5                	j	3e2 <strlen+0x20>

00000000000003ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e422                	sd	s0,8(sp)
 3f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3f2:	ca19                	beqz	a2,408 <memset+0x1c>
 3f4:	87aa                	mv	a5,a0
 3f6:	1602                	slli	a2,a2,0x20
 3f8:	9201                	srli	a2,a2,0x20
 3fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 402:	0785                	addi	a5,a5,1
 404:	fee79de3          	bne	a5,a4,3fe <memset+0x12>
  }
  return dst;
}
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <strchr>:

char*
strchr(const char *s, char c)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	addi	s0,sp,16
  for(; *s; s++)
 414:	00054783          	lbu	a5,0(a0)
 418:	cb99                	beqz	a5,42e <strchr+0x20>
    if(*s == c)
 41a:	00f58763          	beq	a1,a5,428 <strchr+0x1a>
  for(; *s; s++)
 41e:	0505                	addi	a0,a0,1
 420:	00054783          	lbu	a5,0(a0)
 424:	fbfd                	bnez	a5,41a <strchr+0xc>
      return (char*)s;
  return 0;
 426:	4501                	li	a0,0
}
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
  return 0;
 42e:	4501                	li	a0,0
 430:	bfe5                	j	428 <strchr+0x1a>

0000000000000432 <gets>:

char*
gets(char *buf, int max)
{
 432:	711d                	addi	sp,sp,-96
 434:	ec86                	sd	ra,88(sp)
 436:	e8a2                	sd	s0,80(sp)
 438:	e4a6                	sd	s1,72(sp)
 43a:	e0ca                	sd	s2,64(sp)
 43c:	fc4e                	sd	s3,56(sp)
 43e:	f852                	sd	s4,48(sp)
 440:	f456                	sd	s5,40(sp)
 442:	f05a                	sd	s6,32(sp)
 444:	ec5e                	sd	s7,24(sp)
 446:	e862                	sd	s8,16(sp)
 448:	1080                	addi	s0,sp,96
 44a:	8baa                	mv	s7,a0
 44c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 44e:	892a                	mv	s2,a0
 450:	4481                	li	s1,0
    cc = read(0, &c, 1);
 452:	faf40a93          	addi	s5,s0,-81
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 456:	4b29                	li	s6,10
 458:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 45a:	89a6                	mv	s3,s1
 45c:	2485                	addiw	s1,s1,1
 45e:	0344d763          	bge	s1,s4,48c <gets+0x5a>
    cc = read(0, &c, 1);
 462:	4605                	li	a2,1
 464:	85d6                	mv	a1,s5
 466:	4501                	li	a0,0
 468:	00000097          	auipc	ra,0x0
 46c:	1b8080e7          	jalr	440(ra) # 620 <read>
    if(cc < 1)
 470:	00a05e63          	blez	a0,48c <gets+0x5a>
    buf[i++] = c;
 474:	faf44783          	lbu	a5,-81(s0)
 478:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 47c:	01678763          	beq	a5,s6,48a <gets+0x58>
 480:	0905                	addi	s2,s2,1
 482:	fd879ce3          	bne	a5,s8,45a <gets+0x28>
  for(i=0; i+1 < max; ){
 486:	89a6                	mv	s3,s1
 488:	a011                	j	48c <gets+0x5a>
 48a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 48c:	99de                	add	s3,s3,s7
 48e:	00098023          	sb	zero,0(s3)
  return buf;
}
 492:	855e                	mv	a0,s7
 494:	60e6                	ld	ra,88(sp)
 496:	6446                	ld	s0,80(sp)
 498:	64a6                	ld	s1,72(sp)
 49a:	6906                	ld	s2,64(sp)
 49c:	79e2                	ld	s3,56(sp)
 49e:	7a42                	ld	s4,48(sp)
 4a0:	7aa2                	ld	s5,40(sp)
 4a2:	7b02                	ld	s6,32(sp)
 4a4:	6be2                	ld	s7,24(sp)
 4a6:	6c42                	ld	s8,16(sp)
 4a8:	6125                	addi	sp,sp,96
 4aa:	8082                	ret

00000000000004ac <stat>:

int
stat(const char *n, struct stat *st)
{
 4ac:	1101                	addi	sp,sp,-32
 4ae:	ec06                	sd	ra,24(sp)
 4b0:	e822                	sd	s0,16(sp)
 4b2:	e426                	sd	s1,8(sp)
 4b4:	e04a                	sd	s2,0(sp)
 4b6:	1000                	addi	s0,sp,32
 4b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ba:	4581                	li	a1,0
 4bc:	00000097          	auipc	ra,0x0
 4c0:	194080e7          	jalr	404(ra) # 650 <open>
  if(fd < 0)
 4c4:	02054563          	bltz	a0,4ee <stat+0x42>
 4c8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4ca:	85ca                	mv	a1,s2
 4cc:	00000097          	auipc	ra,0x0
 4d0:	18e080e7          	jalr	398(ra) # 65a <fstat>
 4d4:	892a                	mv	s2,a0
  close(fd);
 4d6:	8526                	mv	a0,s1
 4d8:	00000097          	auipc	ra,0x0
 4dc:	15c080e7          	jalr	348(ra) # 634 <close>
  return r;
}
 4e0:	854a                	mv	a0,s2
 4e2:	60e2                	ld	ra,24(sp)
 4e4:	6442                	ld	s0,16(sp)
 4e6:	64a2                	ld	s1,8(sp)
 4e8:	6902                	ld	s2,0(sp)
 4ea:	6105                	addi	sp,sp,32
 4ec:	8082                	ret
    return -1;
 4ee:	597d                	li	s2,-1
 4f0:	bfc5                	j	4e0 <stat+0x34>

00000000000004f2 <atoi>:

int
atoi(const char *s)
{
 4f2:	1141                	addi	sp,sp,-16
 4f4:	e422                	sd	s0,8(sp)
 4f6:	0800                	addi	s0,sp,16
  int n;
  int neg = 1;
  if (*s == '-') {
 4f8:	00054703          	lbu	a4,0(a0)
 4fc:	02d00793          	li	a5,45
  int neg = 1;
 500:	4585                	li	a1,1
  if (*s == '-') {
 502:	04f70363          	beq	a4,a5,548 <atoi+0x56>
    s++;
    neg = -1;
  }
  n = 0;
  while('0' <= *s && *s <= '9')
 506:	00054703          	lbu	a4,0(a0)
 50a:	fd07079b          	addiw	a5,a4,-48
 50e:	0ff7f793          	zext.b	a5,a5
 512:	46a5                	li	a3,9
 514:	02f6ed63          	bltu	a3,a5,54e <atoi+0x5c>
  n = 0;
 518:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 51a:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 51c:	0505                	addi	a0,a0,1
 51e:	0026979b          	slliw	a5,a3,0x2
 522:	9fb5                	addw	a5,a5,a3
 524:	0017979b          	slliw	a5,a5,0x1
 528:	9fb9                	addw	a5,a5,a4
 52a:	fd07869b          	addiw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 52e:	00054703          	lbu	a4,0(a0)
 532:	fd07079b          	addiw	a5,a4,-48
 536:	0ff7f793          	zext.b	a5,a5
 53a:	fef671e3          	bgeu	a2,a5,51c <atoi+0x2a>
  return n * neg;
}
 53e:	02d5853b          	mulw	a0,a1,a3
 542:	6422                	ld	s0,8(sp)
 544:	0141                	addi	sp,sp,16
 546:	8082                	ret
    s++;
 548:	0505                	addi	a0,a0,1
    neg = -1;
 54a:	55fd                	li	a1,-1
 54c:	bf6d                	j	506 <atoi+0x14>
  n = 0;
 54e:	4681                	li	a3,0
 550:	b7fd                	j	53e <atoi+0x4c>

0000000000000552 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 552:	1141                	addi	sp,sp,-16
 554:	e422                	sd	s0,8(sp)
 556:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 558:	02b57463          	bgeu	a0,a1,580 <memmove+0x2e>
    while(n-- > 0)
 55c:	00c05f63          	blez	a2,57a <memmove+0x28>
 560:	1602                	slli	a2,a2,0x20
 562:	9201                	srli	a2,a2,0x20
 564:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 568:	872a                	mv	a4,a0
      *dst++ = *src++;
 56a:	0585                	addi	a1,a1,1
 56c:	0705                	addi	a4,a4,1
 56e:	fff5c683          	lbu	a3,-1(a1)
 572:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 576:	fee79ae3          	bne	a5,a4,56a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 57a:	6422                	ld	s0,8(sp)
 57c:	0141                	addi	sp,sp,16
 57e:	8082                	ret
    dst += n;
 580:	00c50733          	add	a4,a0,a2
    src += n;
 584:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 586:	fec05ae3          	blez	a2,57a <memmove+0x28>
 58a:	fff6079b          	addiw	a5,a2,-1 # fff <malloc+0x4c5>
 58e:	1782                	slli	a5,a5,0x20
 590:	9381                	srli	a5,a5,0x20
 592:	fff7c793          	not	a5,a5
 596:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 598:	15fd                	addi	a1,a1,-1
 59a:	177d                	addi	a4,a4,-1
 59c:	0005c683          	lbu	a3,0(a1)
 5a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5a4:	fee79ae3          	bne	a5,a4,598 <memmove+0x46>
 5a8:	bfc9                	j	57a <memmove+0x28>

00000000000005aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5aa:	1141                	addi	sp,sp,-16
 5ac:	e422                	sd	s0,8(sp)
 5ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5b0:	ca05                	beqz	a2,5e0 <memcmp+0x36>
 5b2:	fff6069b          	addiw	a3,a2,-1
 5b6:	1682                	slli	a3,a3,0x20
 5b8:	9281                	srli	a3,a3,0x20
 5ba:	0685                	addi	a3,a3,1 # 1001 <digits+0x1>
 5bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5be:	00054783          	lbu	a5,0(a0)
 5c2:	0005c703          	lbu	a4,0(a1)
 5c6:	00e79863          	bne	a5,a4,5d6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5ca:	0505                	addi	a0,a0,1
    p2++;
 5cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5ce:	fed518e3          	bne	a0,a3,5be <memcmp+0x14>
  }
  return 0;
 5d2:	4501                	li	a0,0
 5d4:	a019                	j	5da <memcmp+0x30>
      return *p1 - *p2;
 5d6:	40e7853b          	subw	a0,a5,a4
}
 5da:	6422                	ld	s0,8(sp)
 5dc:	0141                	addi	sp,sp,16
 5de:	8082                	ret
  return 0;
 5e0:	4501                	li	a0,0
 5e2:	bfe5                	j	5da <memcmp+0x30>

00000000000005e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5e4:	1141                	addi	sp,sp,-16
 5e6:	e406                	sd	ra,8(sp)
 5e8:	e022                	sd	s0,0(sp)
 5ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5ec:	00000097          	auipc	ra,0x0
 5f0:	f66080e7          	jalr	-154(ra) # 552 <memmove>
}
 5f4:	60a2                	ld	ra,8(sp)
 5f6:	6402                	ld	s0,0(sp)
 5f8:	0141                	addi	sp,sp,16
 5fa:	8082                	ret

00000000000005fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/include/sysnum.h"
.global fork
fork:
 li a7, SYS_fork
 5fc:	4885                	li	a7,1
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <exit>:
.global exit
exit:
 li a7, SYS_exit
 604:	05d00893          	li	a7,93
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <wait>:
.global wait
wait:
 li a7, SYS_wait
 60e:	488d                	li	a7,3
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 616:	03b00893          	li	a7,59
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <read>:
.global read
read:
 li a7, SYS_read
 620:	03f00893          	li	a7,63
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <write>:
.global write
write:
 li a7, SYS_write
 62a:	04000893          	li	a7,64
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <close>:
.global close
close:
 li a7, SYS_close
 634:	03900893          	li	a7,57
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <kill>:
.global kill
kill:
 li a7, SYS_kill
 63e:	4899                	li	a7,6
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <exec>:
.global exec
exec:
 li a7, SYS_exec
 646:	0dd00893          	li	a7,221
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <open>:
.global open
open:
 li a7, SYS_open
 650:	03700893          	li	a7,55
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 65a:	05000893          	li	a7,80
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 664:	489d                	li	a7,7
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 66c:	03100893          	li	a7,49
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <dup>:
.global dup
dup:
 li a7, SYS_dup
 676:	48dd                	li	a7,23
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 67e:	0ac00893          	li	a7,172
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 688:	48b1                	li	a7,12
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 690:	48b5                	li	a7,13
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 698:	48b9                	li	a7,14
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <test_proc>:
.global test_proc
test_proc:
 li a7, SYS_test_proc
 6a0:	48d9                	li	a7,22
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <dev>:
.global dev
dev:
 li a7, SYS_dev
 6a8:	48d5                	li	a7,21
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <readdir>:
.global readdir
readdir:
 li a7, SYS_readdir
 6b0:	48ed                	li	a7,27
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <getcwd>:
.global getcwd
getcwd:
 li a7, SYS_getcwd
 6b8:	48c5                	li	a7,17
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <remove>:
.global remove
remove:
 li a7, SYS_remove
 6c0:	07500893          	li	a7,117
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <trace>:
.global trace
trace:
 li a7, SYS_trace
 6ca:	48c9                	li	a7,18
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 6d2:	48cd                	li	a7,19
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <rename>:
.global rename
rename:
 li a7, SYS_rename
 6da:	48e9                	li	a7,26
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 6e2:	03000893          	li	a7,48
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <times>:
.global times
times:
 li a7, SYS_times
 6ec:	09900893          	li	a7,153
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <uname>:
.global uname
uname:
 li a7, SYS_uname
 6f6:	0a000893          	li	a7,160
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <clone>:
.global clone
clone:
 li a7, SYS_clone
 700:	0dc00893          	li	a7,220
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <wait4>:
.global wait4
wait4:
 li a7, SYS_wait4
 70a:	10400893          	li	a7,260
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 714:	07c00893          	li	a7,124
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 71e:	0ad00893          	li	a7,173
 ecall
 722:	00000073          	ecall
 ret
 726:	8082                	ret

0000000000000728 <gettimeofday>:
.global gettimeofday
gettimeofday:
 li a7, SYS_gettimeofday
 728:	0a900893          	li	a7,169
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <nanosleep>:
.global nanosleep
nanosleep:
 li a7, SYS_nanosleep
 732:	06500893          	li	a7,101
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <brk>:
.global brk
brk:
 li a7, SYS_brk
 73c:	0d600893          	li	a7,214
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 746:	0de00893          	li	a7,222
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 750:	0d700893          	li	a7,215
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <dup2>:
.global dup2
dup2:
 li a7, SYS_dup2
 75a:	68b5                	lui	a7,0xd
 75c:	4318889b          	addiw	a7,a7,1073 # d431 <__global_pointer$+0xbc20>
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <dup3>:
.global dup3
dup3:
 li a7, SYS_dup3
 766:	48e1                	li	a7,24
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <set_timeslice>:
.global set_timeslice
set_timeslice:
 li a7, SYS_set_timeslice
 76e:	68b5                	lui	a7,0xd
 770:	4328889b          	addiw	a7,a7,1074 # d432 <__global_pointer$+0xbc21>
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 77a:	68b5                	lui	a7,0xd
 77c:	4338889b          	addiw	a7,a7,1075 # d433 <__global_pointer$+0xbc22>
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 786:	68b5                	lui	a7,0xd
 788:	4348889b          	addiw	a7,a7,1076 # d434 <__global_pointer$+0xbc23>
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <getpgcnt>:
.global getpgcnt
getpgcnt:
 li a7, SYS_getpgcnt
 792:	68b9                	lui	a7,0xe
 794:	9038889b          	addiw	a7,a7,-1789 # d903 <__global_pointer$+0xc0f2>
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <getprocsz>:
.global getprocsz
getprocsz:
 li a7, SYS_getprocsz
 79e:	68b9                	lui	a7,0xe
 7a0:	9048889b          	addiw	a7,a7,-1788 # d904 <__global_pointer$+0xc0f3>
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7aa:	1101                	addi	sp,sp,-32
 7ac:	ec06                	sd	ra,24(sp)
 7ae:	e822                	sd	s0,16(sp)
 7b0:	1000                	addi	s0,sp,32
 7b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7b6:	4605                	li	a2,1
 7b8:	fef40593          	addi	a1,s0,-17
 7bc:	00000097          	auipc	ra,0x0
 7c0:	e6e080e7          	jalr	-402(ra) # 62a <write>
}
 7c4:	60e2                	ld	ra,24(sp)
 7c6:	6442                	ld	s0,16(sp)
 7c8:	6105                	addi	sp,sp,32
 7ca:	8082                	ret

00000000000007cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7cc:	7139                	addi	sp,sp,-64
 7ce:	fc06                	sd	ra,56(sp)
 7d0:	f822                	sd	s0,48(sp)
 7d2:	f426                	sd	s1,40(sp)
 7d4:	f04a                	sd	s2,32(sp)
 7d6:	ec4e                	sd	s3,24(sp)
 7d8:	0080                	addi	s0,sp,64
 7da:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7dc:	c299                	beqz	a3,7e2 <printint+0x16>
 7de:	0805c863          	bltz	a1,86e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7e2:	2581                	sext.w	a1,a1
  neg = 0;
 7e4:	4881                	li	a7,0
  }

  i = 0;
 7e6:	fc040993          	addi	s3,s0,-64
  neg = 0;
 7ea:	86ce                	mv	a3,s3
  i = 0;
 7ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7ee:	2601                	sext.w	a2,a2
 7f0:	00001517          	auipc	a0,0x1
 7f4:	81050513          	addi	a0,a0,-2032 # 1000 <digits>
 7f8:	883a                	mv	a6,a4
 7fa:	2705                	addiw	a4,a4,1
 7fc:	02c5f7bb          	remuw	a5,a1,a2
 800:	1782                	slli	a5,a5,0x20
 802:	9381                	srli	a5,a5,0x20
 804:	97aa                	add	a5,a5,a0
 806:	0007c783          	lbu	a5,0(a5)
 80a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 80e:	0005879b          	sext.w	a5,a1
 812:	02c5d5bb          	divuw	a1,a1,a2
 816:	0685                	addi	a3,a3,1
 818:	fec7f0e3          	bgeu	a5,a2,7f8 <printint+0x2c>
  if(neg)
 81c:	00088c63          	beqz	a7,834 <printint+0x68>
    buf[i++] = '-';
 820:	fd070793          	addi	a5,a4,-48
 824:	00878733          	add	a4,a5,s0
 828:	02d00793          	li	a5,45
 82c:	fef70823          	sb	a5,-16(a4)
 830:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 834:	02e05663          	blez	a4,860 <printint+0x94>
 838:	fc040913          	addi	s2,s0,-64
 83c:	993a                	add	s2,s2,a4
 83e:	19fd                	addi	s3,s3,-1
 840:	99ba                	add	s3,s3,a4
 842:	377d                	addiw	a4,a4,-1
 844:	1702                	slli	a4,a4,0x20
 846:	9301                	srli	a4,a4,0x20
 848:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 84c:	fff94583          	lbu	a1,-1(s2)
 850:	8526                	mv	a0,s1
 852:	00000097          	auipc	ra,0x0
 856:	f58080e7          	jalr	-168(ra) # 7aa <putc>
  while(--i >= 0)
 85a:	197d                	addi	s2,s2,-1
 85c:	ff3918e3          	bne	s2,s3,84c <printint+0x80>
}
 860:	70e2                	ld	ra,56(sp)
 862:	7442                	ld	s0,48(sp)
 864:	74a2                	ld	s1,40(sp)
 866:	7902                	ld	s2,32(sp)
 868:	69e2                	ld	s3,24(sp)
 86a:	6121                	addi	sp,sp,64
 86c:	8082                	ret
    x = -xx;
 86e:	40b005bb          	negw	a1,a1
    neg = 1;
 872:	4885                	li	a7,1
    x = -xx;
 874:	bf8d                	j	7e6 <printint+0x1a>

0000000000000876 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 876:	7119                	addi	sp,sp,-128
 878:	fc86                	sd	ra,120(sp)
 87a:	f8a2                	sd	s0,112(sp)
 87c:	f4a6                	sd	s1,104(sp)
 87e:	f0ca                	sd	s2,96(sp)
 880:	ecce                	sd	s3,88(sp)
 882:	e8d2                	sd	s4,80(sp)
 884:	e4d6                	sd	s5,72(sp)
 886:	e0da                	sd	s6,64(sp)
 888:	fc5e                	sd	s7,56(sp)
 88a:	f862                	sd	s8,48(sp)
 88c:	f466                	sd	s9,40(sp)
 88e:	f06a                	sd	s10,32(sp)
 890:	ec6e                	sd	s11,24(sp)
 892:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 894:	0005c903          	lbu	s2,0(a1)
 898:	18090f63          	beqz	s2,a36 <vprintf+0x1c0>
 89c:	8aaa                	mv	s5,a0
 89e:	8b32                	mv	s6,a2
 8a0:	00158493          	addi	s1,a1,1
  state = 0;
 8a4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8a6:	02500a13          	li	s4,37
 8aa:	4c55                	li	s8,21
 8ac:	00000c97          	auipc	s9,0x0
 8b0:	6fcc8c93          	addi	s9,s9,1788 # fa8 <malloc+0x46e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8b4:	02800d93          	li	s11,40
  putc(fd, 'x');
 8b8:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ba:	00000b97          	auipc	s7,0x0
 8be:	746b8b93          	addi	s7,s7,1862 # 1000 <digits>
 8c2:	a839                	j	8e0 <vprintf+0x6a>
        putc(fd, c);
 8c4:	85ca                	mv	a1,s2
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	ee2080e7          	jalr	-286(ra) # 7aa <putc>
 8d0:	a019                	j	8d6 <vprintf+0x60>
    } else if(state == '%'){
 8d2:	01498d63          	beq	s3,s4,8ec <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 8d6:	0485                	addi	s1,s1,1
 8d8:	fff4c903          	lbu	s2,-1(s1)
 8dc:	14090d63          	beqz	s2,a36 <vprintf+0x1c0>
    if(state == 0){
 8e0:	fe0999e3          	bnez	s3,8d2 <vprintf+0x5c>
      if(c == '%'){
 8e4:	ff4910e3          	bne	s2,s4,8c4 <vprintf+0x4e>
        state = '%';
 8e8:	89d2                	mv	s3,s4
 8ea:	b7f5                	j	8d6 <vprintf+0x60>
      if(c == 'd'){
 8ec:	11490c63          	beq	s2,s4,a04 <vprintf+0x18e>
 8f0:	f9d9079b          	addiw	a5,s2,-99
 8f4:	0ff7f793          	zext.b	a5,a5
 8f8:	10fc6e63          	bltu	s8,a5,a14 <vprintf+0x19e>
 8fc:	f9d9079b          	addiw	a5,s2,-99
 900:	0ff7f713          	zext.b	a4,a5
 904:	10ec6863          	bltu	s8,a4,a14 <vprintf+0x19e>
 908:	00271793          	slli	a5,a4,0x2
 90c:	97e6                	add	a5,a5,s9
 90e:	439c                	lw	a5,0(a5)
 910:	97e6                	add	a5,a5,s9
 912:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 914:	008b0913          	addi	s2,s6,8
 918:	4685                	li	a3,1
 91a:	4629                	li	a2,10
 91c:	000b2583          	lw	a1,0(s6)
 920:	8556                	mv	a0,s5
 922:	00000097          	auipc	ra,0x0
 926:	eaa080e7          	jalr	-342(ra) # 7cc <printint>
 92a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 92c:	4981                	li	s3,0
 92e:	b765                	j	8d6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 930:	008b0913          	addi	s2,s6,8
 934:	4681                	li	a3,0
 936:	4629                	li	a2,10
 938:	000b2583          	lw	a1,0(s6)
 93c:	8556                	mv	a0,s5
 93e:	00000097          	auipc	ra,0x0
 942:	e8e080e7          	jalr	-370(ra) # 7cc <printint>
 946:	8b4a                	mv	s6,s2
      state = 0;
 948:	4981                	li	s3,0
 94a:	b771                	j	8d6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 94c:	008b0913          	addi	s2,s6,8
 950:	4681                	li	a3,0
 952:	866a                	mv	a2,s10
 954:	000b2583          	lw	a1,0(s6)
 958:	8556                	mv	a0,s5
 95a:	00000097          	auipc	ra,0x0
 95e:	e72080e7          	jalr	-398(ra) # 7cc <printint>
 962:	8b4a                	mv	s6,s2
      state = 0;
 964:	4981                	li	s3,0
 966:	bf85                	j	8d6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 968:	008b0793          	addi	a5,s6,8
 96c:	f8f43423          	sd	a5,-120(s0)
 970:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 974:	03000593          	li	a1,48
 978:	8556                	mv	a0,s5
 97a:	00000097          	auipc	ra,0x0
 97e:	e30080e7          	jalr	-464(ra) # 7aa <putc>
  putc(fd, 'x');
 982:	07800593          	li	a1,120
 986:	8556                	mv	a0,s5
 988:	00000097          	auipc	ra,0x0
 98c:	e22080e7          	jalr	-478(ra) # 7aa <putc>
 990:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 992:	03c9d793          	srli	a5,s3,0x3c
 996:	97de                	add	a5,a5,s7
 998:	0007c583          	lbu	a1,0(a5)
 99c:	8556                	mv	a0,s5
 99e:	00000097          	auipc	ra,0x0
 9a2:	e0c080e7          	jalr	-500(ra) # 7aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9a6:	0992                	slli	s3,s3,0x4
 9a8:	397d                	addiw	s2,s2,-1
 9aa:	fe0914e3          	bnez	s2,992 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 9ae:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9b2:	4981                	li	s3,0
 9b4:	b70d                	j	8d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 9b6:	008b0913          	addi	s2,s6,8
 9ba:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 9be:	02098163          	beqz	s3,9e0 <vprintf+0x16a>
        while(*s != 0){
 9c2:	0009c583          	lbu	a1,0(s3)
 9c6:	c5ad                	beqz	a1,a30 <vprintf+0x1ba>
          putc(fd, *s);
 9c8:	8556                	mv	a0,s5
 9ca:	00000097          	auipc	ra,0x0
 9ce:	de0080e7          	jalr	-544(ra) # 7aa <putc>
          s++;
 9d2:	0985                	addi	s3,s3,1
        while(*s != 0){
 9d4:	0009c583          	lbu	a1,0(s3)
 9d8:	f9e5                	bnez	a1,9c8 <vprintf+0x152>
        s = va_arg(ap, char*);
 9da:	8b4a                	mv	s6,s2
      state = 0;
 9dc:	4981                	li	s3,0
 9de:	bde5                	j	8d6 <vprintf+0x60>
          s = "(null)";
 9e0:	00000997          	auipc	s3,0x0
 9e4:	5c098993          	addi	s3,s3,1472 # fa0 <malloc+0x466>
        while(*s != 0){
 9e8:	85ee                	mv	a1,s11
 9ea:	bff9                	j	9c8 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 9ec:	008b0913          	addi	s2,s6,8
 9f0:	000b4583          	lbu	a1,0(s6)
 9f4:	8556                	mv	a0,s5
 9f6:	00000097          	auipc	ra,0x0
 9fa:	db4080e7          	jalr	-588(ra) # 7aa <putc>
 9fe:	8b4a                	mv	s6,s2
      state = 0;
 a00:	4981                	li	s3,0
 a02:	bdd1                	j	8d6 <vprintf+0x60>
        putc(fd, c);
 a04:	85d2                	mv	a1,s4
 a06:	8556                	mv	a0,s5
 a08:	00000097          	auipc	ra,0x0
 a0c:	da2080e7          	jalr	-606(ra) # 7aa <putc>
      state = 0;
 a10:	4981                	li	s3,0
 a12:	b5d1                	j	8d6 <vprintf+0x60>
        putc(fd, '%');
 a14:	85d2                	mv	a1,s4
 a16:	8556                	mv	a0,s5
 a18:	00000097          	auipc	ra,0x0
 a1c:	d92080e7          	jalr	-622(ra) # 7aa <putc>
        putc(fd, c);
 a20:	85ca                	mv	a1,s2
 a22:	8556                	mv	a0,s5
 a24:	00000097          	auipc	ra,0x0
 a28:	d86080e7          	jalr	-634(ra) # 7aa <putc>
      state = 0;
 a2c:	4981                	li	s3,0
 a2e:	b565                	j	8d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 a30:	8b4a                	mv	s6,s2
      state = 0;
 a32:	4981                	li	s3,0
 a34:	b54d                	j	8d6 <vprintf+0x60>
    }
  }
}
 a36:	70e6                	ld	ra,120(sp)
 a38:	7446                	ld	s0,112(sp)
 a3a:	74a6                	ld	s1,104(sp)
 a3c:	7906                	ld	s2,96(sp)
 a3e:	69e6                	ld	s3,88(sp)
 a40:	6a46                	ld	s4,80(sp)
 a42:	6aa6                	ld	s5,72(sp)
 a44:	6b06                	ld	s6,64(sp)
 a46:	7be2                	ld	s7,56(sp)
 a48:	7c42                	ld	s8,48(sp)
 a4a:	7ca2                	ld	s9,40(sp)
 a4c:	7d02                	ld	s10,32(sp)
 a4e:	6de2                	ld	s11,24(sp)
 a50:	6109                	addi	sp,sp,128
 a52:	8082                	ret

0000000000000a54 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a54:	715d                	addi	sp,sp,-80
 a56:	ec06                	sd	ra,24(sp)
 a58:	e822                	sd	s0,16(sp)
 a5a:	1000                	addi	s0,sp,32
 a5c:	e010                	sd	a2,0(s0)
 a5e:	e414                	sd	a3,8(s0)
 a60:	e818                	sd	a4,16(s0)
 a62:	ec1c                	sd	a5,24(s0)
 a64:	03043023          	sd	a6,32(s0)
 a68:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a6c:	8622                	mv	a2,s0
 a6e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a72:	00000097          	auipc	ra,0x0
 a76:	e04080e7          	jalr	-508(ra) # 876 <vprintf>
}
 a7a:	60e2                	ld	ra,24(sp)
 a7c:	6442                	ld	s0,16(sp)
 a7e:	6161                	addi	sp,sp,80
 a80:	8082                	ret

0000000000000a82 <printf>:

void
printf(const char *fmt, ...)
{
 a82:	711d                	addi	sp,sp,-96
 a84:	ec06                	sd	ra,24(sp)
 a86:	e822                	sd	s0,16(sp)
 a88:	1000                	addi	s0,sp,32
 a8a:	e40c                	sd	a1,8(s0)
 a8c:	e810                	sd	a2,16(s0)
 a8e:	ec14                	sd	a3,24(s0)
 a90:	f018                	sd	a4,32(s0)
 a92:	f41c                	sd	a5,40(s0)
 a94:	03043823          	sd	a6,48(s0)
 a98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a9c:	00840613          	addi	a2,s0,8
 aa0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 aa4:	85aa                	mv	a1,a0
 aa6:	4505                	li	a0,1
 aa8:	00000097          	auipc	ra,0x0
 aac:	dce080e7          	jalr	-562(ra) # 876 <vprintf>
}
 ab0:	60e2                	ld	ra,24(sp)
 ab2:	6442                	ld	s0,16(sp)
 ab4:	6125                	addi	sp,sp,96
 ab6:	8082                	ret

0000000000000ab8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab8:	1141                	addi	sp,sp,-16
 aba:	e422                	sd	s0,8(sp)
 abc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 abe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac2:	00000797          	auipc	a5,0x0
 ac6:	5567b783          	ld	a5,1366(a5) # 1018 <freep>
 aca:	a02d                	j	af4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 acc:	4618                	lw	a4,8(a2)
 ace:	9f2d                	addw	a4,a4,a1
 ad0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ad4:	6398                	ld	a4,0(a5)
 ad6:	6310                	ld	a2,0(a4)
 ad8:	a83d                	j	b16 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ada:	ff852703          	lw	a4,-8(a0)
 ade:	9f31                	addw	a4,a4,a2
 ae0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ae2:	ff053683          	ld	a3,-16(a0)
 ae6:	a091                	j	b2a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae8:	6398                	ld	a4,0(a5)
 aea:	00e7e463          	bltu	a5,a4,af2 <free+0x3a>
 aee:	00e6ea63          	bltu	a3,a4,b02 <free+0x4a>
{
 af2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af4:	fed7fae3          	bgeu	a5,a3,ae8 <free+0x30>
 af8:	6398                	ld	a4,0(a5)
 afa:	00e6e463          	bltu	a3,a4,b02 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 afe:	fee7eae3          	bltu	a5,a4,af2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b02:	ff852583          	lw	a1,-8(a0)
 b06:	6390                	ld	a2,0(a5)
 b08:	02059813          	slli	a6,a1,0x20
 b0c:	01c85713          	srli	a4,a6,0x1c
 b10:	9736                	add	a4,a4,a3
 b12:	fae60de3          	beq	a2,a4,acc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b16:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b1a:	4790                	lw	a2,8(a5)
 b1c:	02061593          	slli	a1,a2,0x20
 b20:	01c5d713          	srli	a4,a1,0x1c
 b24:	973e                	add	a4,a4,a5
 b26:	fae68ae3          	beq	a3,a4,ada <free+0x22>
    p->s.ptr = bp->s.ptr;
 b2a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b2c:	00000717          	auipc	a4,0x0
 b30:	4ef73623          	sd	a5,1260(a4) # 1018 <freep>
}
 b34:	6422                	ld	s0,8(sp)
 b36:	0141                	addi	sp,sp,16
 b38:	8082                	ret

0000000000000b3a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b3a:	7139                	addi	sp,sp,-64
 b3c:	fc06                	sd	ra,56(sp)
 b3e:	f822                	sd	s0,48(sp)
 b40:	f426                	sd	s1,40(sp)
 b42:	f04a                	sd	s2,32(sp)
 b44:	ec4e                	sd	s3,24(sp)
 b46:	e852                	sd	s4,16(sp)
 b48:	e456                	sd	s5,8(sp)
 b4a:	e05a                	sd	s6,0(sp)
 b4c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b4e:	02051493          	slli	s1,a0,0x20
 b52:	9081                	srli	s1,s1,0x20
 b54:	04bd                	addi	s1,s1,15
 b56:	8091                	srli	s1,s1,0x4
 b58:	00148a1b          	addiw	s4,s1,1
 b5c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b5e:	00000517          	auipc	a0,0x0
 b62:	4ba53503          	ld	a0,1210(a0) # 1018 <freep>
 b66:	c515                	beqz	a0,b92 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b68:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b6a:	4798                	lw	a4,8(a5)
 b6c:	04977163          	bgeu	a4,s1,bae <malloc+0x74>
 b70:	89d2                	mv	s3,s4
 b72:	000a071b          	sext.w	a4,s4
 b76:	6685                	lui	a3,0x1
 b78:	00d77363          	bgeu	a4,a3,b7e <malloc+0x44>
 b7c:	6985                	lui	s3,0x1
 b7e:	00098b1b          	sext.w	s6,s3
  p = sbrk(nu * sizeof(Header));
 b82:	0049999b          	slliw	s3,s3,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b86:	00000917          	auipc	s2,0x0
 b8a:	49290913          	addi	s2,s2,1170 # 1018 <freep>
  if(p == (char*)-1)
 b8e:	5afd                	li	s5,-1
 b90:	a8a5                	j	c08 <malloc+0xce>
    base.s.ptr = freep = prevp = &base;
 b92:	00000797          	auipc	a5,0x0
 b96:	48678793          	addi	a5,a5,1158 # 1018 <freep>
 b9a:	00000717          	auipc	a4,0x0
 b9e:	48670713          	addi	a4,a4,1158 # 1020 <base>
 ba2:	e398                	sd	a4,0(a5)
 ba4:	e798                	sd	a4,8(a5)
    base.s.size = 0;
 ba6:	0007a823          	sw	zero,16(a5)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 baa:	87ba                	mv	a5,a4
 bac:	b7d1                	j	b70 <malloc+0x36>
      if(p->s.size == nunits)
 bae:	02e48c63          	beq	s1,a4,be6 <malloc+0xac>
        p->s.size -= nunits;
 bb2:	4147073b          	subw	a4,a4,s4
 bb6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bb8:	02071693          	slli	a3,a4,0x20
 bbc:	01c6d713          	srli	a4,a3,0x1c
 bc0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bc2:	0147a423          	sw	s4,8(a5)
      freep = prevp;
 bc6:	00000717          	auipc	a4,0x0
 bca:	44a73923          	sd	a0,1106(a4) # 1018 <freep>
      return (void*)(p + 1);
 bce:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bd2:	70e2                	ld	ra,56(sp)
 bd4:	7442                	ld	s0,48(sp)
 bd6:	74a2                	ld	s1,40(sp)
 bd8:	7902                	ld	s2,32(sp)
 bda:	69e2                	ld	s3,24(sp)
 bdc:	6a42                	ld	s4,16(sp)
 bde:	6aa2                	ld	s5,8(sp)
 be0:	6b02                	ld	s6,0(sp)
 be2:	6121                	addi	sp,sp,64
 be4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 be6:	6398                	ld	a4,0(a5)
 be8:	e118                	sd	a4,0(a0)
 bea:	bff1                	j	bc6 <malloc+0x8c>
  hp->s.size = nu;
 bec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bf0:	0541                	addi	a0,a0,16
 bf2:	00000097          	auipc	ra,0x0
 bf6:	ec6080e7          	jalr	-314(ra) # ab8 <free>
  return freep;
 bfa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bfe:	d971                	beqz	a0,bd2 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c00:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c02:	4798                	lw	a4,8(a5)
 c04:	fa9775e3          	bgeu	a4,s1,bae <malloc+0x74>
    if(p == freep)
 c08:	00093703          	ld	a4,0(s2)
 c0c:	853e                	mv	a0,a5
 c0e:	fef719e3          	bne	a4,a5,c00 <malloc+0xc6>
  p = sbrk(nu * sizeof(Header));
 c12:	854e                	mv	a0,s3
 c14:	00000097          	auipc	ra,0x0
 c18:	a74080e7          	jalr	-1420(ra) # 688 <sbrk>
  if(p == (char*)-1)
 c1c:	fd5518e3          	bne	a0,s5,bec <malloc+0xb2>
        return 0;
 c20:	4501                	li	a0,0
 c22:	bf45                	j	bd2 <malloc+0x98>
