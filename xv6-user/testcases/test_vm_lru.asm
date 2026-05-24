
xv6-user/testcases/_test_vm_lru:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define PAGE_SIZE 4096

/*
* LRU页面替换算法测试
*/
int main() {
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	0100                	addi	s0,sp,128
    printf("Testing LRU Page Replacement Algorithm\n");
  14:	00001517          	auipc	a0,0x1
  18:	adc50513          	addi	a0,a0,-1316 # af0 <malloc+0xee>
  1c:	00001097          	auipc	ra,0x1
  20:	92e080e7          	jalr	-1746(ra) # 94a <printf>
    sleep(5);
  24:	4515                	li	a0,5
  26:	00000097          	auipc	ra,0x0
  2a:	50e080e7          	jalr	1294(ra) # 534 <sleep>
    
    // Set maximum pages in memory to trigger page replacement
    set_max_page_in_mem(4);
  2e:	4511                	li	a0,4
  30:	00000097          	auipc	ra,0x0
  34:	61e080e7          	jalr	1566(ra) # 64e <set_max_page_in_mem>
    printf("Max pages in memory set to: 4\n");
  38:	00001517          	auipc	a0,0x1
  3c:	ae050513          	addi	a0,a0,-1312 # b18 <malloc+0x116>
  40:	00001097          	auipc	ra,0x1
  44:	90a080e7          	jalr	-1782(ra) # 94a <printf>
    
    // Get initial swap count
    int initial_swaps = get_swap_count();
  48:	00000097          	auipc	ra,0x0
  4c:	612080e7          	jalr	1554(ra) # 65a <get_swap_count>
  50:	8b2a                	mv	s6,a0
    printf("Initial swap count: %d\n", initial_swaps);
  52:	85aa                	mv	a1,a0
  54:	00001517          	auipc	a0,0x1
  58:	ae450513          	addi	a0,a0,-1308 # b38 <malloc+0x136>
  5c:	00001097          	auipc	ra,0x1
  60:	8ee080e7          	jalr	-1810(ra) # 94a <printf>
    
    // Allocate memory using mmap (no physical pages allocated initially)
    uint64 mem_addr = mmap(0, TOTAL_PAGES * PAGE_SIZE, 
  64:	4781                	li	a5,0
  66:	577d                	li	a4,-1
  68:	468d                	li	a3,3
  6a:	460d                	li	a2,3
  6c:	65a1                	lui	a1,0x8
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	57a080e7          	jalr	1402(ra) # 5ea <mmap>
                           PROT_READ | PROT_WRITE, 
                           MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    
    if (mem_addr == (uint64)-1) {
  78:	57fd                	li	a5,-1
  7a:	12f50463          	beq	a0,a5,1a2 <main+0x1a2>
  7e:	89aa                	mv	s3,a0
        printf("mmap failed\n");
        exit(1);
    }
    
    char *mem = (char*)mem_addr;
    printf("Memory mapped at address: 0x%x\n", mem_addr);
  80:	85aa                	mv	a1,a0
  82:	00001517          	auipc	a0,0x1
  86:	ade50513          	addi	a0,a0,-1314 # b60 <malloc+0x15e>
  8a:	00001097          	auipc	ra,0x1
  8e:	8c0080e7          	jalr	-1856(ra) # 94a <printf>
    
    // LRU test pattern - exploits temporal locality
    int access_pattern[] = {0, 1, 2, 3, 0, 1, 4, 5, 0, 1, 6, 7, 0, 1, 2, 3};
  92:	00001797          	auipc	a5,0x1
  96:	bde78793          	addi	a5,a5,-1058 # c70 <malloc+0x26e>
  9a:	0007b883          	ld	a7,0(a5)
  9e:	0087b803          	ld	a6,8(a5)
  a2:	6b88                	ld	a0,16(a5)
  a4:	6f8c                	ld	a1,24(a5)
  a6:	7390                	ld	a2,32(a5)
  a8:	7794                	ld	a3,40(a5)
  aa:	7b98                	ld	a4,48(a5)
  ac:	7f9c                	ld	a5,56(a5)
  ae:	f9143023          	sd	a7,-128(s0)
  b2:	f9043423          	sd	a6,-120(s0)
  b6:	f8a43823          	sd	a0,-112(s0)
  ba:	f8b43c23          	sd	a1,-104(s0)
  be:	fac43023          	sd	a2,-96(s0)
  c2:	fad43423          	sd	a3,-88(s0)
  c6:	fae43823          	sd	a4,-80(s0)
  ca:	faf43c23          	sd	a5,-72(s0)
    int pattern_length = sizeof(access_pattern) / sizeof(access_pattern[0]);
    
    printf("Starting LRU access pattern...\n");
  ce:	00001517          	auipc	a0,0x1
  d2:	ab250513          	addi	a0,a0,-1358 # b80 <malloc+0x17e>
  d6:	00001097          	auipc	ra,0x1
  da:	874080e7          	jalr	-1932(ra) # 94a <printf>
    
    for (int i = 0; i < pattern_length; i++) {
  de:	f8040493          	addi	s1,s0,-128
  e2:	fc040a93          	addi	s5,s0,-64
        int page_index = access_pattern[i];
        mem[page_index * PAGE_SIZE] = 'A' + page_index;
        lru_access_notify((uint64)&mem[page_index * PAGE_SIZE]);         // notify kernel the access action
        printf("Accessed page %d\n", page_index);
  e6:	00001a17          	auipc	s4,0x1
  ea:	abaa0a13          	addi	s4,s4,-1350 # ba0 <malloc+0x19e>
        int page_index = access_pattern[i];
  ee:	0004a903          	lw	s2,0(s1)
        mem[page_index * PAGE_SIZE] = 'A' + page_index;
  f2:	00c9151b          	slliw	a0,s2,0xc
  f6:	954e                	add	a0,a0,s3
  f8:	0419079b          	addiw	a5,s2,65
  fc:	00f50023          	sb	a5,0(a0)
        lru_access_notify((uint64)&mem[page_index * PAGE_SIZE]);         // notify kernel the access action
 100:	00000097          	auipc	ra,0x0
 104:	566080e7          	jalr	1382(ra) # 666 <lru_access_notify>
        printf("Accessed page %d\n", page_index);
 108:	85ca                	mv	a1,s2
 10a:	8552                	mv	a0,s4
 10c:	00001097          	auipc	ra,0x1
 110:	83e080e7          	jalr	-1986(ra) # 94a <printf>
        sleep(1);
 114:	4505                	li	a0,1
 116:	00000097          	auipc	ra,0x0
 11a:	41e080e7          	jalr	1054(ra) # 534 <sleep>
    for (int i = 0; i < pattern_length; i++) {
 11e:	0491                	addi	s1,s1,4
 120:	fd5497e3          	bne	s1,s5,ee <main+0xee>
    }
    
    int final_swaps = get_swap_count();
 124:	00000097          	auipc	ra,0x0
 128:	536080e7          	jalr	1334(ra) # 65a <get_swap_count>
    int total_swaps = final_swaps - initial_swaps;
 12c:	41650b3b          	subw	s6,a0,s6
    printf("Total swaps: %d (expected: 6)\n", total_swaps);
 130:	85da                	mv	a1,s6
 132:	00001517          	auipc	a0,0x1
 136:	a8650513          	addi	a0,a0,-1402 # bb8 <malloc+0x1b6>
 13a:	00001097          	auipc	ra,0x1
 13e:	810080e7          	jalr	-2032(ra) # 94a <printf>
 142:	874e                	mv	a4,s3
 144:	04100793          	li	a5,65

    // Check consistency
    for (int i = 0; i < TOTAL_PAGES; i++) {
 148:	6885                	lui	a7,0x1
 14a:	04900813          	li	a6,73
 14e:	fbf7859b          	addiw	a1,a5,-65
        char ch = mem[i * PAGE_SIZE];
        if (ch != 'A' + i) {
 152:	00074683          	lbu	a3,0(a4)
 156:	0007861b          	sext.w	a2,a5
 15a:	06c69163          	bne	a3,a2,1bc <main+0x1bc>
    for (int i = 0; i < TOTAL_PAGES; i++) {
 15e:	2785                	addiw	a5,a5,1
 160:	9746                	add	a4,a4,a7
 162:	ff0796e3          	bne	a5,a6,14e <main+0x14e>
            printf("ERROR: Check consistency for page %d failed, expected %c but got %c\n", i, 'A'+i, ch);
            exit(1);
        }
    }
    printf("Check consistency succeeded\n");
 166:	00001517          	auipc	a0,0x1
 16a:	aba50513          	addi	a0,a0,-1350 # c20 <malloc+0x21e>
 16e:	00000097          	auipc	ra,0x0
 172:	7dc080e7          	jalr	2012(ra) # 94a <printf>
    
    // Clean up
    munmap(mem_addr, TOTAL_PAGES * PAGE_SIZE);
 176:	65a1                	lui	a1,0x8
 178:	854e                	mv	a0,s3
 17a:	00000097          	auipc	ra,0x0
 17e:	47a080e7          	jalr	1146(ra) # 5f4 <munmap>
    
    if (total_swaps == 6) {
 182:	4799                	li	a5,6
 184:	04fb0963          	beq	s6,a5,1d6 <main+0x1d6>
        printf("LRU Test PASSED\n");
        exit(0);
    } else {
        printf("LRU Test FAILED\n");
 188:	00001517          	auipc	a0,0x1
 18c:	ad050513          	addi	a0,a0,-1328 # c58 <malloc+0x256>
 190:	00000097          	auipc	ra,0x0
 194:	7ba080e7          	jalr	1978(ra) # 94a <printf>
        exit(1);
 198:	4505                	li	a0,1
 19a:	00000097          	auipc	ra,0x0
 19e:	30e080e7          	jalr	782(ra) # 4a8 <exit>
        printf("mmap failed\n");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	9ae50513          	addi	a0,a0,-1618 # b50 <malloc+0x14e>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	7a0080e7          	jalr	1952(ra) # 94a <printf>
        exit(1);
 1b2:	4505                	li	a0,1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	2f4080e7          	jalr	756(ra) # 4a8 <exit>
            printf("ERROR: Check consistency for page %d failed, expected %c but got %c\n", i, 'A'+i, ch);
 1bc:	00001517          	auipc	a0,0x1
 1c0:	a1c50513          	addi	a0,a0,-1508 # bd8 <malloc+0x1d6>
 1c4:	00000097          	auipc	ra,0x0
 1c8:	786080e7          	jalr	1926(ra) # 94a <printf>
            exit(1);
 1cc:	4505                	li	a0,1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	2da080e7          	jalr	730(ra) # 4a8 <exit>
        printf("LRU Test PASSED\n");
 1d6:	00001517          	auipc	a0,0x1
 1da:	a6a50513          	addi	a0,a0,-1430 # c40 <malloc+0x23e>
 1de:	00000097          	auipc	ra,0x0
 1e2:	76c080e7          	jalr	1900(ra) # 94a <printf>
        exit(0);
 1e6:	4501                	li	a0,0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	2c0080e7          	jalr	704(ra) # 4a8 <exit>

00000000000001f0 <strcpy>:
#include "kernel/include/fcntl.h"
#include "xv6-user/user.h"

char*
strcpy(char *s, const char *t)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f6:	87aa                	mv	a5,a0
 1f8:	0585                	addi	a1,a1,1 # 8001 <__global_pointer$+0x6ae0>
 1fa:	0785                	addi	a5,a5,1
 1fc:	fff5c703          	lbu	a4,-1(a1)
 200:	fee78fa3          	sb	a4,-1(a5)
 204:	fb75                	bnez	a4,1f8 <strcpy+0x8>
    ;
  return os;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret

000000000000020c <strcat>:

char*
strcat(char *s, const char *t)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
  char *os = s;
  while(*s)
 212:	00054783          	lbu	a5,0(a0)
 216:	c385                	beqz	a5,236 <strcat+0x2a>
 218:	87aa                	mv	a5,a0
    s++;
 21a:	0785                	addi	a5,a5,1
  while(*s)
 21c:	0007c703          	lbu	a4,0(a5)
 220:	ff6d                	bnez	a4,21a <strcat+0xe>
  while((*s++ = *t++))
 222:	0585                	addi	a1,a1,1
 224:	0785                	addi	a5,a5,1
 226:	fff5c703          	lbu	a4,-1(a1)
 22a:	fee78fa3          	sb	a4,-1(a5)
 22e:	fb75                	bnez	a4,222 <strcat+0x16>
    ;
  return os;
}
 230:	6422                	ld	s0,8(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  while(*s)
 236:	87aa                	mv	a5,a0
 238:	b7ed                	j	222 <strcat+0x16>

000000000000023a <strcmp>:


int
strcmp(const char *p, const char *q)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 240:	00054783          	lbu	a5,0(a0)
 244:	cb91                	beqz	a5,258 <strcmp+0x1e>
 246:	0005c703          	lbu	a4,0(a1)
 24a:	00f71763          	bne	a4,a5,258 <strcmp+0x1e>
    p++, q++;
 24e:	0505                	addi	a0,a0,1
 250:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 252:	00054783          	lbu	a5,0(a0)
 256:	fbe5                	bnez	a5,246 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 258:	0005c503          	lbu	a0,0(a1)
}
 25c:	40a7853b          	subw	a0,a5,a0
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <strlen>:

uint
strlen(const char *s)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 26c:	00054783          	lbu	a5,0(a0)
 270:	cf91                	beqz	a5,28c <strlen+0x26>
 272:	0505                	addi	a0,a0,1
 274:	87aa                	mv	a5,a0
 276:	4685                	li	a3,1
 278:	9e89                	subw	a3,a3,a0
 27a:	00f6853b          	addw	a0,a3,a5
 27e:	0785                	addi	a5,a5,1
 280:	fff7c703          	lbu	a4,-1(a5)
 284:	fb7d                	bnez	a4,27a <strlen+0x14>
    ;
  return n;
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  for(n = 0; s[n]; n++)
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <strlen+0x20>

0000000000000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 296:	ca19                	beqz	a2,2ac <memset+0x1c>
 298:	87aa                	mv	a5,a0
 29a:	1602                	slli	a2,a2,0x20
 29c:	9201                	srli	a2,a2,0x20
 29e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2a6:	0785                	addi	a5,a5,1
 2a8:	fee79de3          	bne	a5,a4,2a2 <memset+0x12>
  }
  return dst;
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strchr>:

char*
strchr(const char *s, char c)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cb99                	beqz	a5,2d2 <strchr+0x20>
    if(*s == c)
 2be:	00f58763          	beq	a1,a5,2cc <strchr+0x1a>
  for(; *s; s++)
 2c2:	0505                	addi	a0,a0,1
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	fbfd                	bnez	a5,2be <strchr+0xc>
      return (char*)s;
  return 0;
 2ca:	4501                	li	a0,0
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <strchr+0x1a>

00000000000002d6 <gets>:

char*
gets(char *buf, int max)
{
 2d6:	711d                	addi	sp,sp,-96
 2d8:	ec86                	sd	ra,88(sp)
 2da:	e8a2                	sd	s0,80(sp)
 2dc:	e4a6                	sd	s1,72(sp)
 2de:	e0ca                	sd	s2,64(sp)
 2e0:	fc4e                	sd	s3,56(sp)
 2e2:	f852                	sd	s4,48(sp)
 2e4:	f456                	sd	s5,40(sp)
 2e6:	f05a                	sd	s6,32(sp)
 2e8:	ec5e                	sd	s7,24(sp)
 2ea:	e862                	sd	s8,16(sp)
 2ec:	1080                	addi	s0,sp,96
 2ee:	8baa                	mv	s7,a0
 2f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f2:	892a                	mv	s2,a0
 2f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2f6:	faf40a93          	addi	s5,s0,-81
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2fa:	4b29                	li	s6,10
 2fc:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 2fe:	89a6                	mv	s3,s1
 300:	2485                	addiw	s1,s1,1
 302:	0344d763          	bge	s1,s4,330 <gets+0x5a>
    cc = read(0, &c, 1);
 306:	4605                	li	a2,1
 308:	85d6                	mv	a1,s5
 30a:	4501                	li	a0,0
 30c:	00000097          	auipc	ra,0x0
 310:	1b8080e7          	jalr	440(ra) # 4c4 <read>
    if(cc < 1)
 314:	00a05e63          	blez	a0,330 <gets+0x5a>
    buf[i++] = c;
 318:	faf44783          	lbu	a5,-81(s0)
 31c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 320:	01678763          	beq	a5,s6,32e <gets+0x58>
 324:	0905                	addi	s2,s2,1
 326:	fd879ce3          	bne	a5,s8,2fe <gets+0x28>
  for(i=0; i+1 < max; ){
 32a:	89a6                	mv	s3,s1
 32c:	a011                	j	330 <gets+0x5a>
 32e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 330:	99de                	add	s3,s3,s7
 332:	00098023          	sb	zero,0(s3)
  return buf;
}
 336:	855e                	mv	a0,s7
 338:	60e6                	ld	ra,88(sp)
 33a:	6446                	ld	s0,80(sp)
 33c:	64a6                	ld	s1,72(sp)
 33e:	6906                	ld	s2,64(sp)
 340:	79e2                	ld	s3,56(sp)
 342:	7a42                	ld	s4,48(sp)
 344:	7aa2                	ld	s5,40(sp)
 346:	7b02                	ld	s6,32(sp)
 348:	6be2                	ld	s7,24(sp)
 34a:	6c42                	ld	s8,16(sp)
 34c:	6125                	addi	sp,sp,96
 34e:	8082                	ret

0000000000000350 <stat>:

int
stat(const char *n, struct stat *st)
{
 350:	1101                	addi	sp,sp,-32
 352:	ec06                	sd	ra,24(sp)
 354:	e822                	sd	s0,16(sp)
 356:	e426                	sd	s1,8(sp)
 358:	e04a                	sd	s2,0(sp)
 35a:	1000                	addi	s0,sp,32
 35c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35e:	4581                	li	a1,0
 360:	00000097          	auipc	ra,0x0
 364:	194080e7          	jalr	404(ra) # 4f4 <open>
  if(fd < 0)
 368:	02054563          	bltz	a0,392 <stat+0x42>
 36c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 36e:	85ca                	mv	a1,s2
 370:	00000097          	auipc	ra,0x0
 374:	18e080e7          	jalr	398(ra) # 4fe <fstat>
 378:	892a                	mv	s2,a0
  close(fd);
 37a:	8526                	mv	a0,s1
 37c:	00000097          	auipc	ra,0x0
 380:	15c080e7          	jalr	348(ra) # 4d8 <close>
  return r;
}
 384:	854a                	mv	a0,s2
 386:	60e2                	ld	ra,24(sp)
 388:	6442                	ld	s0,16(sp)
 38a:	64a2                	ld	s1,8(sp)
 38c:	6902                	ld	s2,0(sp)
 38e:	6105                	addi	sp,sp,32
 390:	8082                	ret
    return -1;
 392:	597d                	li	s2,-1
 394:	bfc5                	j	384 <stat+0x34>

0000000000000396 <atoi>:

int
atoi(const char *s)
{
 396:	1141                	addi	sp,sp,-16
 398:	e422                	sd	s0,8(sp)
 39a:	0800                	addi	s0,sp,16
  int n;
  int neg = 1;
  if (*s == '-') {
 39c:	00054703          	lbu	a4,0(a0)
 3a0:	02d00793          	li	a5,45
  int neg = 1;
 3a4:	4585                	li	a1,1
  if (*s == '-') {
 3a6:	04f70363          	beq	a4,a5,3ec <atoi+0x56>
    s++;
    neg = -1;
  }
  n = 0;
  while('0' <= *s && *s <= '9')
 3aa:	00054703          	lbu	a4,0(a0)
 3ae:	fd07079b          	addiw	a5,a4,-48
 3b2:	0ff7f793          	zext.b	a5,a5
 3b6:	46a5                	li	a3,9
 3b8:	02f6ed63          	bltu	a3,a5,3f2 <atoi+0x5c>
  n = 0;
 3bc:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 3be:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 3c0:	0505                	addi	a0,a0,1
 3c2:	0026979b          	slliw	a5,a3,0x2
 3c6:	9fb5                	addw	a5,a5,a3
 3c8:	0017979b          	slliw	a5,a5,0x1
 3cc:	9fb9                	addw	a5,a5,a4
 3ce:	fd07869b          	addiw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 3d2:	00054703          	lbu	a4,0(a0)
 3d6:	fd07079b          	addiw	a5,a4,-48
 3da:	0ff7f793          	zext.b	a5,a5
 3de:	fef671e3          	bgeu	a2,a5,3c0 <atoi+0x2a>
  return n * neg;
}
 3e2:	02d5853b          	mulw	a0,a1,a3
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
    s++;
 3ec:	0505                	addi	a0,a0,1
    neg = -1;
 3ee:	55fd                	li	a1,-1
 3f0:	bf6d                	j	3aa <atoi+0x14>
  n = 0;
 3f2:	4681                	li	a3,0
 3f4:	b7fd                	j	3e2 <atoi+0x4c>

00000000000003f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e422                	sd	s0,8(sp)
 3fa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3fc:	02b57463          	bgeu	a0,a1,424 <memmove+0x2e>
    while(n-- > 0)
 400:	00c05f63          	blez	a2,41e <memmove+0x28>
 404:	1602                	slli	a2,a2,0x20
 406:	9201                	srli	a2,a2,0x20
 408:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 40c:	872a                	mv	a4,a0
      *dst++ = *src++;
 40e:	0585                	addi	a1,a1,1
 410:	0705                	addi	a4,a4,1
 412:	fff5c683          	lbu	a3,-1(a1)
 416:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 41a:	fee79ae3          	bne	a5,a4,40e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret
    dst += n;
 424:	00c50733          	add	a4,a0,a2
    src += n;
 428:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 42a:	fec05ae3          	blez	a2,41e <memmove+0x28>
 42e:	fff6079b          	addiw	a5,a2,-1
 432:	1782                	slli	a5,a5,0x20
 434:	9381                	srli	a5,a5,0x20
 436:	fff7c793          	not	a5,a5
 43a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 43c:	15fd                	addi	a1,a1,-1
 43e:	177d                	addi	a4,a4,-1
 440:	0005c683          	lbu	a3,0(a1)
 444:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 448:	fee79ae3          	bne	a5,a4,43c <memmove+0x46>
 44c:	bfc9                	j	41e <memmove+0x28>

000000000000044e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e422                	sd	s0,8(sp)
 452:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 454:	ca05                	beqz	a2,484 <memcmp+0x36>
 456:	fff6069b          	addiw	a3,a2,-1
 45a:	1682                	slli	a3,a3,0x20
 45c:	9281                	srli	a3,a3,0x20
 45e:	0685                	addi	a3,a3,1
 460:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 462:	00054783          	lbu	a5,0(a0)
 466:	0005c703          	lbu	a4,0(a1)
 46a:	00e79863          	bne	a5,a4,47a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 46e:	0505                	addi	a0,a0,1
    p2++;
 470:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 472:	fed518e3          	bne	a0,a3,462 <memcmp+0x14>
  }
  return 0;
 476:	4501                	li	a0,0
 478:	a019                	j	47e <memcmp+0x30>
      return *p1 - *p2;
 47a:	40e7853b          	subw	a0,a5,a4
}
 47e:	6422                	ld	s0,8(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret
  return 0;
 484:	4501                	li	a0,0
 486:	bfe5                	j	47e <memcmp+0x30>

0000000000000488 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e406                	sd	ra,8(sp)
 48c:	e022                	sd	s0,0(sp)
 48e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 490:	00000097          	auipc	ra,0x0
 494:	f66080e7          	jalr	-154(ra) # 3f6 <memmove>
}
 498:	60a2                	ld	ra,8(sp)
 49a:	6402                	ld	s0,0(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret

00000000000004a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/include/sysnum.h"
.global fork
fork:
 li a7, SYS_fork
 4a0:	4885                	li	a7,1
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a8:	05d00893          	li	a7,93
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b2:	488d                	li	a7,3
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ba:	03b00893          	li	a7,59
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <read>:
.global read
read:
 li a7, SYS_read
 4c4:	03f00893          	li	a7,63
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <write>:
.global write
write:
 li a7, SYS_write
 4ce:	04000893          	li	a7,64
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <close>:
.global close
close:
 li a7, SYS_close
 4d8:	03900893          	li	a7,57
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e2:	4899                	li	a7,6
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ea:	0dd00893          	li	a7,221
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <open>:
.global open
open:
 li a7, SYS_open
 4f4:	03700893          	li	a7,55
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4fe:	05000893          	li	a7,80
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 508:	489d                	li	a7,7
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 510:	03100893          	li	a7,49
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <dup>:
.global dup
dup:
 li a7, SYS_dup
 51a:	48dd                	li	a7,23
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 522:	0ac00893          	li	a7,172
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 52c:	48b1                	li	a7,12
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 534:	48b5                	li	a7,13
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 53c:	48b9                	li	a7,14
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <test_proc>:
.global test_proc
test_proc:
 li a7, SYS_test_proc
 544:	48d9                	li	a7,22
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <dev>:
.global dev
dev:
 li a7, SYS_dev
 54c:	48d5                	li	a7,21
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <readdir>:
.global readdir
readdir:
 li a7, SYS_readdir
 554:	48ed                	li	a7,27
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <getcwd>:
.global getcwd
getcwd:
 li a7, SYS_getcwd
 55c:	48c5                	li	a7,17
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <remove>:
.global remove
remove:
 li a7, SYS_remove
 564:	07500893          	li	a7,117
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <trace>:
.global trace
trace:
 li a7, SYS_trace
 56e:	48c9                	li	a7,18
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 576:	48cd                	li	a7,19
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <rename>:
.global rename
rename:
 li a7, SYS_rename
 57e:	48e9                	li	a7,26
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 586:	03000893          	li	a7,48
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <times>:
.global times
times:
 li a7, SYS_times
 590:	09900893          	li	a7,153
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <uname>:
.global uname
uname:
 li a7, SYS_uname
 59a:	0a000893          	li	a7,160
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <clone>:
.global clone
clone:
 li a7, SYS_clone
 5a4:	0dc00893          	li	a7,220
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <wait4>:
.global wait4
wait4:
 li a7, SYS_wait4
 5ae:	10400893          	li	a7,260
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 5b8:	07c00893          	li	a7,124
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 5c2:	0ad00893          	li	a7,173
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <gettimeofday>:
.global gettimeofday
gettimeofday:
 li a7, SYS_gettimeofday
 5cc:	0a900893          	li	a7,169
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <nanosleep>:
.global nanosleep
nanosleep:
 li a7, SYS_nanosleep
 5d6:	06500893          	li	a7,101
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <brk>:
.global brk
brk:
 li a7, SYS_brk
 5e0:	0d600893          	li	a7,214
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 5ea:	0de00893          	li	a7,222
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 5f4:	0d700893          	li	a7,215
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <dup2>:
.global dup2
dup2:
 li a7, SYS_dup2
 5fe:	68b5                	lui	a7,0xd
 600:	4318889b          	addiw	a7,a7,1073 # d431 <__global_pointer$+0xbf10>
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <dup3>:
.global dup3
dup3:
 li a7, SYS_dup3
 60a:	48e1                	li	a7,24
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <set_timeslice>:
.global set_timeslice
set_timeslice:
 li a7, SYS_set_timeslice
 612:	68b5                	lui	a7,0xd
 614:	4328889b          	addiw	a7,a7,1074 # d432 <__global_pointer$+0xbf11>
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 61e:	68b5                	lui	a7,0xd
 620:	4338889b          	addiw	a7,a7,1075 # d433 <__global_pointer$+0xbf12>
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 62a:	68b5                	lui	a7,0xd
 62c:	4348889b          	addiw	a7,a7,1076 # d434 <__global_pointer$+0xbf13>
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <getpgcnt>:
.global getpgcnt
getpgcnt:
 li a7, SYS_getpgcnt
 636:	68b9                	lui	a7,0xe
 638:	9038889b          	addiw	a7,a7,-1789 # d903 <__global_pointer$+0xc3e2>
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <getprocsz>:
.global getprocsz
getprocsz:
 li a7, SYS_getprocsz
 642:	68b9                	lui	a7,0xe
 644:	9048889b          	addiw	a7,a7,-1788 # d904 <__global_pointer$+0xc3e3>
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <set_max_page_in_mem>:
.global set_max_page_in_mem
set_max_page_in_mem:
 li a7, SYS_set_max_page_in_mem
 64e:	68b9                	lui	a7,0xe
 650:	9058889b          	addiw	a7,a7,-1787 # d905 <__global_pointer$+0xc3e4>
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <get_swap_count>:
.global get_swap_count
get_swap_count:
 li a7, SYS_get_swap_count
 65a:	68b9                	lui	a7,0xe
 65c:	9068889b          	addiw	a7,a7,-1786 # d906 <__global_pointer$+0xc3e5>
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <lru_access_notify>:
.global lru_access_notify
lru_access_notify:
 li a7, SYS_lru_access_notify
 666:	68b9                	lui	a7,0xe
 668:	9078889b          	addiw	a7,a7,-1785 # d907 <__global_pointer$+0xc3e6>
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 672:	1101                	addi	sp,sp,-32
 674:	ec06                	sd	ra,24(sp)
 676:	e822                	sd	s0,16(sp)
 678:	1000                	addi	s0,sp,32
 67a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 67e:	4605                	li	a2,1
 680:	fef40593          	addi	a1,s0,-17
 684:	00000097          	auipc	ra,0x0
 688:	e4a080e7          	jalr	-438(ra) # 4ce <write>
}
 68c:	60e2                	ld	ra,24(sp)
 68e:	6442                	ld	s0,16(sp)
 690:	6105                	addi	sp,sp,32
 692:	8082                	ret

0000000000000694 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 694:	7139                	addi	sp,sp,-64
 696:	fc06                	sd	ra,56(sp)
 698:	f822                	sd	s0,48(sp)
 69a:	f426                	sd	s1,40(sp)
 69c:	f04a                	sd	s2,32(sp)
 69e:	ec4e                	sd	s3,24(sp)
 6a0:	0080                	addi	s0,sp,64
 6a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6a4:	c299                	beqz	a3,6aa <printint+0x16>
 6a6:	0805c863          	bltz	a1,736 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6aa:	2581                	sext.w	a1,a1
  neg = 0;
 6ac:	4881                	li	a7,0
  }

  i = 0;
 6ae:	fc040993          	addi	s3,s0,-64
  neg = 0;
 6b2:	86ce                	mv	a3,s3
  i = 0;
 6b4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6b6:	2601                	sext.w	a2,a2
 6b8:	00000517          	auipc	a0,0x0
 6bc:	65850513          	addi	a0,a0,1624 # d10 <digits>
 6c0:	883a                	mv	a6,a4
 6c2:	2705                	addiw	a4,a4,1
 6c4:	02c5f7bb          	remuw	a5,a1,a2
 6c8:	1782                	slli	a5,a5,0x20
 6ca:	9381                	srli	a5,a5,0x20
 6cc:	97aa                	add	a5,a5,a0
 6ce:	0007c783          	lbu	a5,0(a5)
 6d2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6d6:	0005879b          	sext.w	a5,a1
 6da:	02c5d5bb          	divuw	a1,a1,a2
 6de:	0685                	addi	a3,a3,1
 6e0:	fec7f0e3          	bgeu	a5,a2,6c0 <printint+0x2c>
  if(neg)
 6e4:	00088c63          	beqz	a7,6fc <printint+0x68>
    buf[i++] = '-';
 6e8:	fd070793          	addi	a5,a4,-48
 6ec:	00878733          	add	a4,a5,s0
 6f0:	02d00793          	li	a5,45
 6f4:	fef70823          	sb	a5,-16(a4)
 6f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6fc:	02e05663          	blez	a4,728 <printint+0x94>
 700:	fc040913          	addi	s2,s0,-64
 704:	993a                	add	s2,s2,a4
 706:	19fd                	addi	s3,s3,-1
 708:	99ba                	add	s3,s3,a4
 70a:	377d                	addiw	a4,a4,-1
 70c:	1702                	slli	a4,a4,0x20
 70e:	9301                	srli	a4,a4,0x20
 710:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 714:	fff94583          	lbu	a1,-1(s2)
 718:	8526                	mv	a0,s1
 71a:	00000097          	auipc	ra,0x0
 71e:	f58080e7          	jalr	-168(ra) # 672 <putc>
  while(--i >= 0)
 722:	197d                	addi	s2,s2,-1
 724:	ff3918e3          	bne	s2,s3,714 <printint+0x80>
}
 728:	70e2                	ld	ra,56(sp)
 72a:	7442                	ld	s0,48(sp)
 72c:	74a2                	ld	s1,40(sp)
 72e:	7902                	ld	s2,32(sp)
 730:	69e2                	ld	s3,24(sp)
 732:	6121                	addi	sp,sp,64
 734:	8082                	ret
    x = -xx;
 736:	40b005bb          	negw	a1,a1
    neg = 1;
 73a:	4885                	li	a7,1
    x = -xx;
 73c:	bf8d                	j	6ae <printint+0x1a>

000000000000073e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 73e:	7119                	addi	sp,sp,-128
 740:	fc86                	sd	ra,120(sp)
 742:	f8a2                	sd	s0,112(sp)
 744:	f4a6                	sd	s1,104(sp)
 746:	f0ca                	sd	s2,96(sp)
 748:	ecce                	sd	s3,88(sp)
 74a:	e8d2                	sd	s4,80(sp)
 74c:	e4d6                	sd	s5,72(sp)
 74e:	e0da                	sd	s6,64(sp)
 750:	fc5e                	sd	s7,56(sp)
 752:	f862                	sd	s8,48(sp)
 754:	f466                	sd	s9,40(sp)
 756:	f06a                	sd	s10,32(sp)
 758:	ec6e                	sd	s11,24(sp)
 75a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 75c:	0005c903          	lbu	s2,0(a1)
 760:	18090f63          	beqz	s2,8fe <vprintf+0x1c0>
 764:	8aaa                	mv	s5,a0
 766:	8b32                	mv	s6,a2
 768:	00158493          	addi	s1,a1,1
  state = 0;
 76c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 76e:	02500a13          	li	s4,37
 772:	4c55                	li	s8,21
 774:	00000c97          	auipc	s9,0x0
 778:	544c8c93          	addi	s9,s9,1348 # cb8 <malloc+0x2b6>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 77c:	02800d93          	li	s11,40
  putc(fd, 'x');
 780:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 782:	00000b97          	auipc	s7,0x0
 786:	58eb8b93          	addi	s7,s7,1422 # d10 <digits>
 78a:	a839                	j	7a8 <vprintf+0x6a>
        putc(fd, c);
 78c:	85ca                	mv	a1,s2
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	ee2080e7          	jalr	-286(ra) # 672 <putc>
 798:	a019                	j	79e <vprintf+0x60>
    } else if(state == '%'){
 79a:	01498d63          	beq	s3,s4,7b4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 79e:	0485                	addi	s1,s1,1
 7a0:	fff4c903          	lbu	s2,-1(s1)
 7a4:	14090d63          	beqz	s2,8fe <vprintf+0x1c0>
    if(state == 0){
 7a8:	fe0999e3          	bnez	s3,79a <vprintf+0x5c>
      if(c == '%'){
 7ac:	ff4910e3          	bne	s2,s4,78c <vprintf+0x4e>
        state = '%';
 7b0:	89d2                	mv	s3,s4
 7b2:	b7f5                	j	79e <vprintf+0x60>
      if(c == 'd'){
 7b4:	11490c63          	beq	s2,s4,8cc <vprintf+0x18e>
 7b8:	f9d9079b          	addiw	a5,s2,-99
 7bc:	0ff7f793          	zext.b	a5,a5
 7c0:	10fc6e63          	bltu	s8,a5,8dc <vprintf+0x19e>
 7c4:	f9d9079b          	addiw	a5,s2,-99
 7c8:	0ff7f713          	zext.b	a4,a5
 7cc:	10ec6863          	bltu	s8,a4,8dc <vprintf+0x19e>
 7d0:	00271793          	slli	a5,a4,0x2
 7d4:	97e6                	add	a5,a5,s9
 7d6:	439c                	lw	a5,0(a5)
 7d8:	97e6                	add	a5,a5,s9
 7da:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7dc:	008b0913          	addi	s2,s6,8
 7e0:	4685                	li	a3,1
 7e2:	4629                	li	a2,10
 7e4:	000b2583          	lw	a1,0(s6)
 7e8:	8556                	mv	a0,s5
 7ea:	00000097          	auipc	ra,0x0
 7ee:	eaa080e7          	jalr	-342(ra) # 694 <printint>
 7f2:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	b765                	j	79e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f8:	008b0913          	addi	s2,s6,8
 7fc:	4681                	li	a3,0
 7fe:	4629                	li	a2,10
 800:	000b2583          	lw	a1,0(s6)
 804:	8556                	mv	a0,s5
 806:	00000097          	auipc	ra,0x0
 80a:	e8e080e7          	jalr	-370(ra) # 694 <printint>
 80e:	8b4a                	mv	s6,s2
      state = 0;
 810:	4981                	li	s3,0
 812:	b771                	j	79e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 814:	008b0913          	addi	s2,s6,8
 818:	4681                	li	a3,0
 81a:	866a                	mv	a2,s10
 81c:	000b2583          	lw	a1,0(s6)
 820:	8556                	mv	a0,s5
 822:	00000097          	auipc	ra,0x0
 826:	e72080e7          	jalr	-398(ra) # 694 <printint>
 82a:	8b4a                	mv	s6,s2
      state = 0;
 82c:	4981                	li	s3,0
 82e:	bf85                	j	79e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 830:	008b0793          	addi	a5,s6,8
 834:	f8f43423          	sd	a5,-120(s0)
 838:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 83c:	03000593          	li	a1,48
 840:	8556                	mv	a0,s5
 842:	00000097          	auipc	ra,0x0
 846:	e30080e7          	jalr	-464(ra) # 672 <putc>
  putc(fd, 'x');
 84a:	07800593          	li	a1,120
 84e:	8556                	mv	a0,s5
 850:	00000097          	auipc	ra,0x0
 854:	e22080e7          	jalr	-478(ra) # 672 <putc>
 858:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 85a:	03c9d793          	srli	a5,s3,0x3c
 85e:	97de                	add	a5,a5,s7
 860:	0007c583          	lbu	a1,0(a5)
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	e0c080e7          	jalr	-500(ra) # 672 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 86e:	0992                	slli	s3,s3,0x4
 870:	397d                	addiw	s2,s2,-1
 872:	fe0914e3          	bnez	s2,85a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 876:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 87a:	4981                	li	s3,0
 87c:	b70d                	j	79e <vprintf+0x60>
        s = va_arg(ap, char*);
 87e:	008b0913          	addi	s2,s6,8
 882:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 886:	02098163          	beqz	s3,8a8 <vprintf+0x16a>
        while(*s != 0){
 88a:	0009c583          	lbu	a1,0(s3)
 88e:	c5ad                	beqz	a1,8f8 <vprintf+0x1ba>
          putc(fd, *s);
 890:	8556                	mv	a0,s5
 892:	00000097          	auipc	ra,0x0
 896:	de0080e7          	jalr	-544(ra) # 672 <putc>
          s++;
 89a:	0985                	addi	s3,s3,1
        while(*s != 0){
 89c:	0009c583          	lbu	a1,0(s3)
 8a0:	f9e5                	bnez	a1,890 <vprintf+0x152>
        s = va_arg(ap, char*);
 8a2:	8b4a                	mv	s6,s2
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	bde5                	j	79e <vprintf+0x60>
          s = "(null)";
 8a8:	00000997          	auipc	s3,0x0
 8ac:	40898993          	addi	s3,s3,1032 # cb0 <malloc+0x2ae>
        while(*s != 0){
 8b0:	85ee                	mv	a1,s11
 8b2:	bff9                	j	890 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 8b4:	008b0913          	addi	s2,s6,8
 8b8:	000b4583          	lbu	a1,0(s6)
 8bc:	8556                	mv	a0,s5
 8be:	00000097          	auipc	ra,0x0
 8c2:	db4080e7          	jalr	-588(ra) # 672 <putc>
 8c6:	8b4a                	mv	s6,s2
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	bdd1                	j	79e <vprintf+0x60>
        putc(fd, c);
 8cc:	85d2                	mv	a1,s4
 8ce:	8556                	mv	a0,s5
 8d0:	00000097          	auipc	ra,0x0
 8d4:	da2080e7          	jalr	-606(ra) # 672 <putc>
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	b5d1                	j	79e <vprintf+0x60>
        putc(fd, '%');
 8dc:	85d2                	mv	a1,s4
 8de:	8556                	mv	a0,s5
 8e0:	00000097          	auipc	ra,0x0
 8e4:	d92080e7          	jalr	-622(ra) # 672 <putc>
        putc(fd, c);
 8e8:	85ca                	mv	a1,s2
 8ea:	8556                	mv	a0,s5
 8ec:	00000097          	auipc	ra,0x0
 8f0:	d86080e7          	jalr	-634(ra) # 672 <putc>
      state = 0;
 8f4:	4981                	li	s3,0
 8f6:	b565                	j	79e <vprintf+0x60>
        s = va_arg(ap, char*);
 8f8:	8b4a                	mv	s6,s2
      state = 0;
 8fa:	4981                	li	s3,0
 8fc:	b54d                	j	79e <vprintf+0x60>
    }
  }
}
 8fe:	70e6                	ld	ra,120(sp)
 900:	7446                	ld	s0,112(sp)
 902:	74a6                	ld	s1,104(sp)
 904:	7906                	ld	s2,96(sp)
 906:	69e6                	ld	s3,88(sp)
 908:	6a46                	ld	s4,80(sp)
 90a:	6aa6                	ld	s5,72(sp)
 90c:	6b06                	ld	s6,64(sp)
 90e:	7be2                	ld	s7,56(sp)
 910:	7c42                	ld	s8,48(sp)
 912:	7ca2                	ld	s9,40(sp)
 914:	7d02                	ld	s10,32(sp)
 916:	6de2                	ld	s11,24(sp)
 918:	6109                	addi	sp,sp,128
 91a:	8082                	ret

000000000000091c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 91c:	715d                	addi	sp,sp,-80
 91e:	ec06                	sd	ra,24(sp)
 920:	e822                	sd	s0,16(sp)
 922:	1000                	addi	s0,sp,32
 924:	e010                	sd	a2,0(s0)
 926:	e414                	sd	a3,8(s0)
 928:	e818                	sd	a4,16(s0)
 92a:	ec1c                	sd	a5,24(s0)
 92c:	03043023          	sd	a6,32(s0)
 930:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 934:	8622                	mv	a2,s0
 936:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 93a:	00000097          	auipc	ra,0x0
 93e:	e04080e7          	jalr	-508(ra) # 73e <vprintf>
}
 942:	60e2                	ld	ra,24(sp)
 944:	6442                	ld	s0,16(sp)
 946:	6161                	addi	sp,sp,80
 948:	8082                	ret

000000000000094a <printf>:

void
printf(const char *fmt, ...)
{
 94a:	711d                	addi	sp,sp,-96
 94c:	ec06                	sd	ra,24(sp)
 94e:	e822                	sd	s0,16(sp)
 950:	1000                	addi	s0,sp,32
 952:	e40c                	sd	a1,8(s0)
 954:	e810                	sd	a2,16(s0)
 956:	ec14                	sd	a3,24(s0)
 958:	f018                	sd	a4,32(s0)
 95a:	f41c                	sd	a5,40(s0)
 95c:	03043823          	sd	a6,48(s0)
 960:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 964:	00840613          	addi	a2,s0,8
 968:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 96c:	85aa                	mv	a1,a0
 96e:	4505                	li	a0,1
 970:	00000097          	auipc	ra,0x0
 974:	dce080e7          	jalr	-562(ra) # 73e <vprintf>
}
 978:	60e2                	ld	ra,24(sp)
 97a:	6442                	ld	s0,16(sp)
 97c:	6125                	addi	sp,sp,96
 97e:	8082                	ret

0000000000000980 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 980:	1141                	addi	sp,sp,-16
 982:	e422                	sd	s0,8(sp)
 984:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 986:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98a:	00000797          	auipc	a5,0x0
 98e:	39e7b783          	ld	a5,926(a5) # d28 <freep>
 992:	a02d                	j	9bc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 994:	4618                	lw	a4,8(a2)
 996:	9f2d                	addw	a4,a4,a1
 998:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 99c:	6398                	ld	a4,0(a5)
 99e:	6310                	ld	a2,0(a4)
 9a0:	a83d                	j	9de <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9a2:	ff852703          	lw	a4,-8(a0)
 9a6:	9f31                	addw	a4,a4,a2
 9a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9aa:	ff053683          	ld	a3,-16(a0)
 9ae:	a091                	j	9f2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b0:	6398                	ld	a4,0(a5)
 9b2:	00e7e463          	bltu	a5,a4,9ba <free+0x3a>
 9b6:	00e6ea63          	bltu	a3,a4,9ca <free+0x4a>
{
 9ba:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9bc:	fed7fae3          	bgeu	a5,a3,9b0 <free+0x30>
 9c0:	6398                	ld	a4,0(a5)
 9c2:	00e6e463          	bltu	a3,a4,9ca <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c6:	fee7eae3          	bltu	a5,a4,9ba <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9ca:	ff852583          	lw	a1,-8(a0)
 9ce:	6390                	ld	a2,0(a5)
 9d0:	02059813          	slli	a6,a1,0x20
 9d4:	01c85713          	srli	a4,a6,0x1c
 9d8:	9736                	add	a4,a4,a3
 9da:	fae60de3          	beq	a2,a4,994 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9de:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9e2:	4790                	lw	a2,8(a5)
 9e4:	02061593          	slli	a1,a2,0x20
 9e8:	01c5d713          	srli	a4,a1,0x1c
 9ec:	973e                	add	a4,a4,a5
 9ee:	fae68ae3          	beq	a3,a4,9a2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9f2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9f4:	00000717          	auipc	a4,0x0
 9f8:	32f73a23          	sd	a5,820(a4) # d28 <freep>
}
 9fc:	6422                	ld	s0,8(sp)
 9fe:	0141                	addi	sp,sp,16
 a00:	8082                	ret

0000000000000a02 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a02:	7139                	addi	sp,sp,-64
 a04:	fc06                	sd	ra,56(sp)
 a06:	f822                	sd	s0,48(sp)
 a08:	f426                	sd	s1,40(sp)
 a0a:	f04a                	sd	s2,32(sp)
 a0c:	ec4e                	sd	s3,24(sp)
 a0e:	e852                	sd	s4,16(sp)
 a10:	e456                	sd	s5,8(sp)
 a12:	e05a                	sd	s6,0(sp)
 a14:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a16:	02051493          	slli	s1,a0,0x20
 a1a:	9081                	srli	s1,s1,0x20
 a1c:	04bd                	addi	s1,s1,15
 a1e:	8091                	srli	s1,s1,0x4
 a20:	00148a1b          	addiw	s4,s1,1
 a24:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a26:	00000517          	auipc	a0,0x0
 a2a:	30253503          	ld	a0,770(a0) # d28 <freep>
 a2e:	c515                	beqz	a0,a5a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a30:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a32:	4798                	lw	a4,8(a5)
 a34:	04977163          	bgeu	a4,s1,a76 <malloc+0x74>
 a38:	89d2                	mv	s3,s4
 a3a:	000a071b          	sext.w	a4,s4
 a3e:	6685                	lui	a3,0x1
 a40:	00d77363          	bgeu	a4,a3,a46 <malloc+0x44>
 a44:	6985                	lui	s3,0x1
 a46:	00098b1b          	sext.w	s6,s3
  p = sbrk(nu * sizeof(Header));
 a4a:	0049999b          	slliw	s3,s3,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a4e:	00000917          	auipc	s2,0x0
 a52:	2da90913          	addi	s2,s2,730 # d28 <freep>
  if(p == (char*)-1)
 a56:	5afd                	li	s5,-1
 a58:	a8a5                	j	ad0 <malloc+0xce>
    base.s.ptr = freep = prevp = &base;
 a5a:	00000797          	auipc	a5,0x0
 a5e:	2ce78793          	addi	a5,a5,718 # d28 <freep>
 a62:	00000717          	auipc	a4,0x0
 a66:	2ce70713          	addi	a4,a4,718 # d30 <base>
 a6a:	e398                	sd	a4,0(a5)
 a6c:	e798                	sd	a4,8(a5)
    base.s.size = 0;
 a6e:	0007a823          	sw	zero,16(a5)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a72:	87ba                	mv	a5,a4
 a74:	b7d1                	j	a38 <malloc+0x36>
      if(p->s.size == nunits)
 a76:	02e48c63          	beq	s1,a4,aae <malloc+0xac>
        p->s.size -= nunits;
 a7a:	4147073b          	subw	a4,a4,s4
 a7e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a80:	02071693          	slli	a3,a4,0x20
 a84:	01c6d713          	srli	a4,a3,0x1c
 a88:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a8a:	0147a423          	sw	s4,8(a5)
      freep = prevp;
 a8e:	00000717          	auipc	a4,0x0
 a92:	28a73d23          	sd	a0,666(a4) # d28 <freep>
      return (void*)(p + 1);
 a96:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a9a:	70e2                	ld	ra,56(sp)
 a9c:	7442                	ld	s0,48(sp)
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	7902                	ld	s2,32(sp)
 aa2:	69e2                	ld	s3,24(sp)
 aa4:	6a42                	ld	s4,16(sp)
 aa6:	6aa2                	ld	s5,8(sp)
 aa8:	6b02                	ld	s6,0(sp)
 aaa:	6121                	addi	sp,sp,64
 aac:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 aae:	6398                	ld	a4,0(a5)
 ab0:	e118                	sd	a4,0(a0)
 ab2:	bff1                	j	a8e <malloc+0x8c>
  hp->s.size = nu;
 ab4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ab8:	0541                	addi	a0,a0,16
 aba:	00000097          	auipc	ra,0x0
 abe:	ec6080e7          	jalr	-314(ra) # 980 <free>
  return freep;
 ac2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ac6:	d971                	beqz	a0,a9a <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aca:	4798                	lw	a4,8(a5)
 acc:	fa9775e3          	bgeu	a4,s1,a76 <malloc+0x74>
    if(p == freep)
 ad0:	00093703          	ld	a4,0(s2)
 ad4:	853e                	mv	a0,a5
 ad6:	fef719e3          	bne	a4,a5,ac8 <malloc+0xc6>
  p = sbrk(nu * sizeof(Header));
 ada:	854e                	mv	a0,s3
 adc:	00000097          	auipc	ra,0x0
 ae0:	a50080e7          	jalr	-1456(ra) # 52c <sbrk>
  if(p == (char*)-1)
 ae4:	fd5518e3          	bne	a0,s5,ab4 <malloc+0xb2>
        return 0;
 ae8:	4501                	li	a0,0
 aea:	bf45                	j	a9a <malloc+0x98>
