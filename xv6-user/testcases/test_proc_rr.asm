
xv6-user/testcases/_test_proc_rr:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <task>:
#include "test.h"

#define ITERATIONS 1000000
#define LOOP 100

void task(int id) {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	0880                	addi	s0,sp,80
    volatile long long count = 0;
   8:	fe043423          	sd	zero,-24(s0)
   c:	06400593          	li	a1,100
    for(int loop = 0; loop < LOOP; loop++) {
        for(int i = 0; i < ITERATIONS; i++) {
  10:	000f4637          	lui	a2,0xf4
  14:	24060613          	addi	a2,a2,576 # f4240 <__global_pointer$+0xf2f3f>
void task(int id) {
  18:	4781                	li	a5,0
            count += (long long)i * (long long) i;
  1a:	fe843683          	ld	a3,-24(s0)
  1e:	02f78733          	mul	a4,a5,a5
  22:	9736                	add	a4,a4,a3
  24:	fee43423          	sd	a4,-24(s0)
        for(int i = 0; i < ITERATIONS; i++) {
  28:	0785                	addi	a5,a5,1
  2a:	fec798e3          	bne	a5,a2,1a <task+0x1a>
    for(int loop = 0; loop < LOOP; loop++) {
  2e:	35fd                	addiw	a1,a1,-1
  30:	f5e5                	bnez	a1,18 <task+0x18>
  32:	fb040593          	addi	a1,s0,-80
  36:	00001617          	auipc	a2,0x1
  3a:	9f360613          	addi	a2,a2,-1549 # a29 <malloc+0xeb>
            }
        }
    }

    char buffer[50];
    int pos = 0;
  3e:	4701                	li	a4,0
    const char* parts[] = {"RR Scheduler Process ", "0", " completed\n"};
    for (int i = 0; parts[0][i] != '\0'; i++) {
  40:	05200693          	li	a3,82
        buffer[pos++] = parts[0][i];
  44:	87ba                	mv	a5,a4
  46:	2705                	addiw	a4,a4,1
  48:	00d58023          	sb	a3,0(a1)
    for (int i = 0; parts[0][i] != '\0'; i++) {
  4c:	00064683          	lbu	a3,0(a2)
  50:	0585                	addi	a1,a1,1
  52:	0605                	addi	a2,a2,1
  54:	fae5                	bnez	a3,44 <task+0x44>
    }
    buffer[pos++] = '0' + id;
  56:	1741                	addi	a4,a4,-16
  58:	9722                	add	a4,a4,s0
  5a:	0305069b          	addiw	a3,a0,48
  5e:	fcd70023          	sb	a3,-64(a4)
    for (int i = 0; parts[2][i] != '\0'; i++) {
  62:	278d                	addiw	a5,a5,3
  64:	00001697          	auipc	a3,0x1
  68:	9dd68693          	addi	a3,a3,-1571 # a41 <malloc+0x103>
  6c:	02000713          	li	a4,32
        buffer[pos++] = parts[2][i];
  70:	fb040593          	addi	a1,s0,-80
  74:	0007861b          	sext.w	a2,a5
  78:	00f58533          	add	a0,a1,a5
  7c:	fee50fa3          	sb	a4,-1(a0)
    for (int i = 0; parts[2][i] != '\0'; i++) {
  80:	0006c703          	lbu	a4,0(a3)
  84:	0785                	addi	a5,a5,1
  86:	0685                	addi	a3,a3,1
  88:	f775                	bnez	a4,74 <task+0x74>
    }

    write(1, buffer, pos);
  8a:	fb040593          	addi	a1,s0,-80
  8e:	4505                	li	a0,1
  90:	00000097          	auipc	ra,0x0
  94:	3b6080e7          	jalr	950(ra) # 446 <write>
}
  98:	60a6                	ld	ra,72(sp)
  9a:	6406                	ld	s0,64(sp)
  9c:	6161                	addi	sp,sp,80
  9e:	8082                	ret

00000000000000a0 <main>:
* P3 will finish the job first, then P2, and P1 is the last.
* The judge program will check the appearance and order of `Process {\d} completed`
* to make sure you have implemented the Round-Robin algorithm with given timeslice.
*/

int main() {
  a0:	1141                	addi	sp,sp,-16
  a2:	e406                	sd	ra,8(sp)
  a4:	e022                	sd	s0,0(sp)
  a6:	0800                	addi	s0,sp,16
    printf("Testing RR Scheduler - Basic\n");
  a8:	00001517          	auipc	a0,0x1
  ac:	9a850513          	addi	a0,a0,-1624 # a50 <malloc+0x112>
  b0:	00000097          	auipc	ra,0x0
  b4:	7d6080e7          	jalr	2006(ra) # 886 <printf>

    int pid1, pid2, pid3;
    if((pid1=fork())==0) {
  b8:	00000097          	auipc	ra,0x0
  bc:	360080e7          	jalr	864(ra) # 418 <fork>
  c0:	e105                	bnez	a0,e0 <main+0x40>
        set_timeslice(1);
  c2:	4505                	li	a0,1
  c4:	00000097          	auipc	ra,0x0
  c8:	4c6080e7          	jalr	1222(ra) # 58a <set_timeslice>
        task(1);
  cc:	4505                	li	a0,1
  ce:	00000097          	auipc	ra,0x0
  d2:	f32080e7          	jalr	-206(ra) # 0 <task>
        exit(0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	348080e7          	jalr	840(ra) # 420 <exit>
    }
    if((pid2=fork())==0) {
  e0:	00000097          	auipc	ra,0x0
  e4:	338080e7          	jalr	824(ra) # 418 <fork>
  e8:	e105                	bnez	a0,108 <main+0x68>
        set_timeslice(2);
  ea:	4509                	li	a0,2
  ec:	00000097          	auipc	ra,0x0
  f0:	49e080e7          	jalr	1182(ra) # 58a <set_timeslice>
        task(2);
  f4:	4509                	li	a0,2
  f6:	00000097          	auipc	ra,0x0
  fa:	f0a080e7          	jalr	-246(ra) # 0 <task>
        exit(0);
  fe:	4501                	li	a0,0
 100:	00000097          	auipc	ra,0x0
 104:	320080e7          	jalr	800(ra) # 420 <exit>
    }
    if((pid3=fork())==0) {
 108:	00000097          	auipc	ra,0x0
 10c:	310080e7          	jalr	784(ra) # 418 <fork>
 110:	e105                	bnez	a0,130 <main+0x90>
        set_timeslice(3);
 112:	450d                	li	a0,3
 114:	00000097          	auipc	ra,0x0
 118:	476080e7          	jalr	1142(ra) # 58a <set_timeslice>
        task(3);
 11c:	450d                	li	a0,3
 11e:	00000097          	auipc	ra,0x0
 122:	ee2080e7          	jalr	-286(ra) # 0 <task>
        exit(0);
 126:	4501                	li	a0,0
 128:	00000097          	auipc	ra,0x0
 12c:	2f8080e7          	jalr	760(ra) # 420 <exit>
    }
    wait(0);
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	2f8080e7          	jalr	760(ra) # 42a <wait>
    wait(0);
 13a:	4501                	li	a0,0
 13c:	00000097          	auipc	ra,0x0
 140:	2ee080e7          	jalr	750(ra) # 42a <wait>
    wait(0);
 144:	4501                	li	a0,0
 146:	00000097          	auipc	ra,0x0
 14a:	2e4080e7          	jalr	740(ra) # 42a <wait>

    printf("RR Basic Test Completed\n");
 14e:	00001517          	auipc	a0,0x1
 152:	92250513          	addi	a0,a0,-1758 # a70 <malloc+0x132>
 156:	00000097          	auipc	ra,0x0
 15a:	730080e7          	jalr	1840(ra) # 886 <printf>
    exit(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	2c0080e7          	jalr	704(ra) # 420 <exit>

0000000000000168 <strcpy>:
#include "kernel/include/fcntl.h"
#include "xv6-user/user.h"

char*
strcpy(char *s, const char *t)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16e:	87aa                	mv	a5,a0
 170:	0585                	addi	a1,a1,1
 172:	0785                	addi	a5,a5,1
 174:	fff5c703          	lbu	a4,-1(a1)
 178:	fee78fa3          	sb	a4,-1(a5)
 17c:	fb75                	bnez	a4,170 <strcpy+0x8>
    ;
  return os;
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strcat>:

char*
strcat(char *s, const char *t)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  char *os = s;
  while(*s)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	c385                	beqz	a5,1ae <strcat+0x2a>
 190:	87aa                	mv	a5,a0
    s++;
 192:	0785                	addi	a5,a5,1
  while(*s)
 194:	0007c703          	lbu	a4,0(a5)
 198:	ff6d                	bnez	a4,192 <strcat+0xe>
  while((*s++ = *t++))
 19a:	0585                	addi	a1,a1,1
 19c:	0785                	addi	a5,a5,1
 19e:	fff5c703          	lbu	a4,-1(a1)
 1a2:	fee78fa3          	sb	a4,-1(a5)
 1a6:	fb75                	bnez	a4,19a <strcat+0x16>
    ;
  return os;
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret
  while(*s)
 1ae:	87aa                	mv	a5,a0
 1b0:	b7ed                	j	19a <strcat+0x16>

00000000000001b2 <strcmp>:


int
strcmp(const char *p, const char *q)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb91                	beqz	a5,1d0 <strcmp+0x1e>
 1be:	0005c703          	lbu	a4,0(a1)
 1c2:	00f71763          	bne	a4,a5,1d0 <strcmp+0x1e>
    p++, q++;
 1c6:	0505                	addi	a0,a0,1
 1c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbe5                	bnez	a5,1be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d0:	0005c503          	lbu	a0,0(a1)
}
 1d4:	40a7853b          	subw	a0,a5,a0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strlen>:

uint
strlen(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cf91                	beqz	a5,204 <strlen+0x26>
 1ea:	0505                	addi	a0,a0,1
 1ec:	87aa                	mv	a5,a0
 1ee:	4685                	li	a3,1
 1f0:	9e89                	subw	a3,a3,a0
 1f2:	00f6853b          	addw	a0,a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fb7d                	bnez	a4,1f2 <strlen+0x14>
    ;
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
  for(n = 0; s[n]; n++)
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <strlen+0x20>

0000000000000208 <memset>:

void*
memset(void *dst, int c, uint n)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 20e:	ca19                	beqz	a2,224 <memset+0x1c>
 210:	87aa                	mv	a5,a0
 212:	1602                	slli	a2,a2,0x20
 214:	9201                	srli	a2,a2,0x20
 216:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 21a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 21e:	0785                	addi	a5,a5,1
 220:	fee79de3          	bne	a5,a4,21a <memset+0x12>
  }
  return dst;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret

000000000000022a <strchr>:

char*
strchr(const char *s, char c)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 230:	00054783          	lbu	a5,0(a0)
 234:	cb99                	beqz	a5,24a <strchr+0x20>
    if(*s == c)
 236:	00f58763          	beq	a1,a5,244 <strchr+0x1a>
  for(; *s; s++)
 23a:	0505                	addi	a0,a0,1
 23c:	00054783          	lbu	a5,0(a0)
 240:	fbfd                	bnez	a5,236 <strchr+0xc>
      return (char*)s;
  return 0;
 242:	4501                	li	a0,0
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  return 0;
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <strchr+0x1a>

000000000000024e <gets>:

char*
gets(char *buf, int max)
{
 24e:	711d                	addi	sp,sp,-96
 250:	ec86                	sd	ra,88(sp)
 252:	e8a2                	sd	s0,80(sp)
 254:	e4a6                	sd	s1,72(sp)
 256:	e0ca                	sd	s2,64(sp)
 258:	fc4e                	sd	s3,56(sp)
 25a:	f852                	sd	s4,48(sp)
 25c:	f456                	sd	s5,40(sp)
 25e:	f05a                	sd	s6,32(sp)
 260:	ec5e                	sd	s7,24(sp)
 262:	e862                	sd	s8,16(sp)
 264:	1080                	addi	s0,sp,96
 266:	8baa                	mv	s7,a0
 268:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26a:	892a                	mv	s2,a0
 26c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 26e:	faf40a93          	addi	s5,s0,-81
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 272:	4b29                	li	s6,10
 274:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 276:	89a6                	mv	s3,s1
 278:	2485                	addiw	s1,s1,1
 27a:	0344d763          	bge	s1,s4,2a8 <gets+0x5a>
    cc = read(0, &c, 1);
 27e:	4605                	li	a2,1
 280:	85d6                	mv	a1,s5
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	1b8080e7          	jalr	440(ra) # 43c <read>
    if(cc < 1)
 28c:	00a05e63          	blez	a0,2a8 <gets+0x5a>
    buf[i++] = c;
 290:	faf44783          	lbu	a5,-81(s0)
 294:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 298:	01678763          	beq	a5,s6,2a6 <gets+0x58>
 29c:	0905                	addi	s2,s2,1
 29e:	fd879ce3          	bne	a5,s8,276 <gets+0x28>
  for(i=0; i+1 < max; ){
 2a2:	89a6                	mv	s3,s1
 2a4:	a011                	j	2a8 <gets+0x5a>
 2a6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a8:	99de                	add	s3,s3,s7
 2aa:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ae:	855e                	mv	a0,s7
 2b0:	60e6                	ld	ra,88(sp)
 2b2:	6446                	ld	s0,80(sp)
 2b4:	64a6                	ld	s1,72(sp)
 2b6:	6906                	ld	s2,64(sp)
 2b8:	79e2                	ld	s3,56(sp)
 2ba:	7a42                	ld	s4,48(sp)
 2bc:	7aa2                	ld	s5,40(sp)
 2be:	7b02                	ld	s6,32(sp)
 2c0:	6be2                	ld	s7,24(sp)
 2c2:	6c42                	ld	s8,16(sp)
 2c4:	6125                	addi	sp,sp,96
 2c6:	8082                	ret

00000000000002c8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c8:	1101                	addi	sp,sp,-32
 2ca:	ec06                	sd	ra,24(sp)
 2cc:	e822                	sd	s0,16(sp)
 2ce:	e426                	sd	s1,8(sp)
 2d0:	e04a                	sd	s2,0(sp)
 2d2:	1000                	addi	s0,sp,32
 2d4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d6:	4581                	li	a1,0
 2d8:	00000097          	auipc	ra,0x0
 2dc:	194080e7          	jalr	404(ra) # 46c <open>
  if(fd < 0)
 2e0:	02054563          	bltz	a0,30a <stat+0x42>
 2e4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e6:	85ca                	mv	a1,s2
 2e8:	00000097          	auipc	ra,0x0
 2ec:	18e080e7          	jalr	398(ra) # 476 <fstat>
 2f0:	892a                	mv	s2,a0
  close(fd);
 2f2:	8526                	mv	a0,s1
 2f4:	00000097          	auipc	ra,0x0
 2f8:	15c080e7          	jalr	348(ra) # 450 <close>
  return r;
}
 2fc:	854a                	mv	a0,s2
 2fe:	60e2                	ld	ra,24(sp)
 300:	6442                	ld	s0,16(sp)
 302:	64a2                	ld	s1,8(sp)
 304:	6902                	ld	s2,0(sp)
 306:	6105                	addi	sp,sp,32
 308:	8082                	ret
    return -1;
 30a:	597d                	li	s2,-1
 30c:	bfc5                	j	2fc <stat+0x34>

000000000000030e <atoi>:

int
atoi(const char *s)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  int n;
  int neg = 1;
  if (*s == '-') {
 314:	00054703          	lbu	a4,0(a0)
 318:	02d00793          	li	a5,45
  int neg = 1;
 31c:	4585                	li	a1,1
  if (*s == '-') {
 31e:	04f70363          	beq	a4,a5,364 <atoi+0x56>
    s++;
    neg = -1;
  }
  n = 0;
  while('0' <= *s && *s <= '9')
 322:	00054703          	lbu	a4,0(a0)
 326:	fd07079b          	addiw	a5,a4,-48
 32a:	0ff7f793          	zext.b	a5,a5
 32e:	46a5                	li	a3,9
 330:	02f6ed63          	bltu	a3,a5,36a <atoi+0x5c>
  n = 0;
 334:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 336:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 338:	0505                	addi	a0,a0,1
 33a:	0026979b          	slliw	a5,a3,0x2
 33e:	9fb5                	addw	a5,a5,a3
 340:	0017979b          	slliw	a5,a5,0x1
 344:	9fb9                	addw	a5,a5,a4
 346:	fd07869b          	addiw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 34a:	00054703          	lbu	a4,0(a0)
 34e:	fd07079b          	addiw	a5,a4,-48
 352:	0ff7f793          	zext.b	a5,a5
 356:	fef671e3          	bgeu	a2,a5,338 <atoi+0x2a>
  return n * neg;
}
 35a:	02d5853b          	mulw	a0,a1,a3
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
    s++;
 364:	0505                	addi	a0,a0,1
    neg = -1;
 366:	55fd                	li	a1,-1
 368:	bf6d                	j	322 <atoi+0x14>
  n = 0;
 36a:	4681                	li	a3,0
 36c:	b7fd                	j	35a <atoi+0x4c>

000000000000036e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e422                	sd	s0,8(sp)
 372:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 374:	02b57463          	bgeu	a0,a1,39c <memmove+0x2e>
    while(n-- > 0)
 378:	00c05f63          	blez	a2,396 <memmove+0x28>
 37c:	1602                	slli	a2,a2,0x20
 37e:	9201                	srli	a2,a2,0x20
 380:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 384:	872a                	mv	a4,a0
      *dst++ = *src++;
 386:	0585                	addi	a1,a1,1
 388:	0705                	addi	a4,a4,1
 38a:	fff5c683          	lbu	a3,-1(a1)
 38e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 392:	fee79ae3          	bne	a5,a4,386 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 396:	6422                	ld	s0,8(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret
    dst += n;
 39c:	00c50733          	add	a4,a0,a2
    src += n;
 3a0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3a2:	fec05ae3          	blez	a2,396 <memmove+0x28>
 3a6:	fff6079b          	addiw	a5,a2,-1
 3aa:	1782                	slli	a5,a5,0x20
 3ac:	9381                	srli	a5,a5,0x20
 3ae:	fff7c793          	not	a5,a5
 3b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3b4:	15fd                	addi	a1,a1,-1
 3b6:	177d                	addi	a4,a4,-1
 3b8:	0005c683          	lbu	a3,0(a1)
 3bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3c0:	fee79ae3          	bne	a5,a4,3b4 <memmove+0x46>
 3c4:	bfc9                	j	396 <memmove+0x28>

00000000000003c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3cc:	ca05                	beqz	a2,3fc <memcmp+0x36>
 3ce:	fff6069b          	addiw	a3,a2,-1
 3d2:	1682                	slli	a3,a3,0x20
 3d4:	9281                	srli	a3,a3,0x20
 3d6:	0685                	addi	a3,a3,1
 3d8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3da:	00054783          	lbu	a5,0(a0)
 3de:	0005c703          	lbu	a4,0(a1)
 3e2:	00e79863          	bne	a5,a4,3f2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3e6:	0505                	addi	a0,a0,1
    p2++;
 3e8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3ea:	fed518e3          	bne	a0,a3,3da <memcmp+0x14>
  }
  return 0;
 3ee:	4501                	li	a0,0
 3f0:	a019                	j	3f6 <memcmp+0x30>
      return *p1 - *p2;
 3f2:	40e7853b          	subw	a0,a5,a4
}
 3f6:	6422                	ld	s0,8(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret
  return 0;
 3fc:	4501                	li	a0,0
 3fe:	bfe5                	j	3f6 <memcmp+0x30>

0000000000000400 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 400:	1141                	addi	sp,sp,-16
 402:	e406                	sd	ra,8(sp)
 404:	e022                	sd	s0,0(sp)
 406:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 408:	00000097          	auipc	ra,0x0
 40c:	f66080e7          	jalr	-154(ra) # 36e <memmove>
}
 410:	60a2                	ld	ra,8(sp)
 412:	6402                	ld	s0,0(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret

0000000000000418 <fork>:
# generated by usys.pl - do not edit
#include "kernel/include/sysnum.h"
.global fork
fork:
 li a7, SYS_fork
 418:	4885                	li	a7,1
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <exit>:
.global exit
exit:
 li a7, SYS_exit
 420:	05d00893          	li	a7,93
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <wait>:
.global wait
wait:
 li a7, SYS_wait
 42a:	488d                	li	a7,3
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 432:	03b00893          	li	a7,59
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <read>:
.global read
read:
 li a7, SYS_read
 43c:	03f00893          	li	a7,63
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <write>:
.global write
write:
 li a7, SYS_write
 446:	04000893          	li	a7,64
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <close>:
.global close
close:
 li a7, SYS_close
 450:	03900893          	li	a7,57
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <kill>:
.global kill
kill:
 li a7, SYS_kill
 45a:	4899                	li	a7,6
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <exec>:
.global exec
exec:
 li a7, SYS_exec
 462:	0dd00893          	li	a7,221
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <open>:
.global open
open:
 li a7, SYS_open
 46c:	03700893          	li	a7,55
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 476:	05000893          	li	a7,80
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 480:	489d                	li	a7,7
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 488:	03100893          	li	a7,49
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <dup>:
.global dup
dup:
 li a7, SYS_dup
 492:	48dd                	li	a7,23
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 49a:	0ac00893          	li	a7,172
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4a4:	48b1                	li	a7,12
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4ac:	48b5                	li	a7,13
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b4:	48b9                	li	a7,14
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <test_proc>:
.global test_proc
test_proc:
 li a7, SYS_test_proc
 4bc:	48d9                	li	a7,22
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <dev>:
.global dev
dev:
 li a7, SYS_dev
 4c4:	48d5                	li	a7,21
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <readdir>:
.global readdir
readdir:
 li a7, SYS_readdir
 4cc:	48ed                	li	a7,27
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <getcwd>:
.global getcwd
getcwd:
 li a7, SYS_getcwd
 4d4:	48c5                	li	a7,17
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <remove>:
.global remove
remove:
 li a7, SYS_remove
 4dc:	07500893          	li	a7,117
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 4e6:	48c9                	li	a7,18
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4ee:	48cd                	li	a7,19
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <rename>:
.global rename
rename:
 li a7, SYS_rename
 4f6:	48e9                	li	a7,26
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 4fe:	03000893          	li	a7,48
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <times>:
.global times
times:
 li a7, SYS_times
 508:	09900893          	li	a7,153
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <uname>:
.global uname
uname:
 li a7, SYS_uname
 512:	0a000893          	li	a7,160
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <clone>:
.global clone
clone:
 li a7, SYS_clone
 51c:	0dc00893          	li	a7,220
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <wait4>:
.global wait4
wait4:
 li a7, SYS_wait4
 526:	10400893          	li	a7,260
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 530:	07c00893          	li	a7,124
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 53a:	0ad00893          	li	a7,173
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <gettimeofday>:
.global gettimeofday
gettimeofday:
 li a7, SYS_gettimeofday
 544:	0a900893          	li	a7,169
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <nanosleep>:
.global nanosleep
nanosleep:
 li a7, SYS_nanosleep
 54e:	06500893          	li	a7,101
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <brk>:
.global brk
brk:
 li a7, SYS_brk
 558:	0d600893          	li	a7,214
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 562:	0de00893          	li	a7,222
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 56c:	0d700893          	li	a7,215
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <dup2>:
.global dup2
dup2:
 li a7, SYS_dup2
 576:	68b5                	lui	a7,0xd
 578:	4318889b          	addiw	a7,a7,1073 # d431 <__global_pointer$+0xc130>
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <dup3>:
.global dup3
dup3:
 li a7, SYS_dup3
 582:	48e1                	li	a7,24
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <set_timeslice>:
.global set_timeslice
set_timeslice:
 li a7, SYS_set_timeslice
 58a:	68b5                	lui	a7,0xd
 58c:	4328889b          	addiw	a7,a7,1074 # d432 <__global_pointer$+0xc131>
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 596:	68b5                	lui	a7,0xd
 598:	4338889b          	addiw	a7,a7,1075 # d433 <__global_pointer$+0xc132>
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 5a2:	68b5                	lui	a7,0xd
 5a4:	4348889b          	addiw	a7,a7,1076 # d434 <__global_pointer$+0xc133>
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ae:	1101                	addi	sp,sp,-32
 5b0:	ec06                	sd	ra,24(sp)
 5b2:	e822                	sd	s0,16(sp)
 5b4:	1000                	addi	s0,sp,32
 5b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ba:	4605                	li	a2,1
 5bc:	fef40593          	addi	a1,s0,-17
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e86080e7          	jalr	-378(ra) # 446 <write>
}
 5c8:	60e2                	ld	ra,24(sp)
 5ca:	6442                	ld	s0,16(sp)
 5cc:	6105                	addi	sp,sp,32
 5ce:	8082                	ret

00000000000005d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	7139                	addi	sp,sp,-64
 5d2:	fc06                	sd	ra,56(sp)
 5d4:	f822                	sd	s0,48(sp)
 5d6:	f426                	sd	s1,40(sp)
 5d8:	f04a                	sd	s2,32(sp)
 5da:	ec4e                	sd	s3,24(sp)
 5dc:	0080                	addi	s0,sp,64
 5de:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e0:	c299                	beqz	a3,5e6 <printint+0x16>
 5e2:	0805c863          	bltz	a1,672 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5e6:	2581                	sext.w	a1,a1
  neg = 0;
 5e8:	4881                	li	a7,0
  }

  i = 0;
 5ea:	fc040993          	addi	s3,s0,-64
  neg = 0;
 5ee:	86ce                	mv	a3,s3
  i = 0;
 5f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f2:	2601                	sext.w	a2,a2
 5f4:	00000517          	auipc	a0,0x0
 5f8:	4fc50513          	addi	a0,a0,1276 # af0 <digits>
 5fc:	883a                	mv	a6,a4
 5fe:	2705                	addiw	a4,a4,1
 600:	02c5f7bb          	remuw	a5,a1,a2
 604:	1782                	slli	a5,a5,0x20
 606:	9381                	srli	a5,a5,0x20
 608:	97aa                	add	a5,a5,a0
 60a:	0007c783          	lbu	a5,0(a5)
 60e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 612:	0005879b          	sext.w	a5,a1
 616:	02c5d5bb          	divuw	a1,a1,a2
 61a:	0685                	addi	a3,a3,1
 61c:	fec7f0e3          	bgeu	a5,a2,5fc <printint+0x2c>
  if(neg)
 620:	00088c63          	beqz	a7,638 <printint+0x68>
    buf[i++] = '-';
 624:	fd070793          	addi	a5,a4,-48
 628:	00878733          	add	a4,a5,s0
 62c:	02d00793          	li	a5,45
 630:	fef70823          	sb	a5,-16(a4)
 634:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 638:	02e05663          	blez	a4,664 <printint+0x94>
 63c:	fc040913          	addi	s2,s0,-64
 640:	993a                	add	s2,s2,a4
 642:	19fd                	addi	s3,s3,-1
 644:	99ba                	add	s3,s3,a4
 646:	377d                	addiw	a4,a4,-1
 648:	1702                	slli	a4,a4,0x20
 64a:	9301                	srli	a4,a4,0x20
 64c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 650:	fff94583          	lbu	a1,-1(s2)
 654:	8526                	mv	a0,s1
 656:	00000097          	auipc	ra,0x0
 65a:	f58080e7          	jalr	-168(ra) # 5ae <putc>
  while(--i >= 0)
 65e:	197d                	addi	s2,s2,-1
 660:	ff3918e3          	bne	s2,s3,650 <printint+0x80>
}
 664:	70e2                	ld	ra,56(sp)
 666:	7442                	ld	s0,48(sp)
 668:	74a2                	ld	s1,40(sp)
 66a:	7902                	ld	s2,32(sp)
 66c:	69e2                	ld	s3,24(sp)
 66e:	6121                	addi	sp,sp,64
 670:	8082                	ret
    x = -xx;
 672:	40b005bb          	negw	a1,a1
    neg = 1;
 676:	4885                	li	a7,1
    x = -xx;
 678:	bf8d                	j	5ea <printint+0x1a>

000000000000067a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67a:	7119                	addi	sp,sp,-128
 67c:	fc86                	sd	ra,120(sp)
 67e:	f8a2                	sd	s0,112(sp)
 680:	f4a6                	sd	s1,104(sp)
 682:	f0ca                	sd	s2,96(sp)
 684:	ecce                	sd	s3,88(sp)
 686:	e8d2                	sd	s4,80(sp)
 688:	e4d6                	sd	s5,72(sp)
 68a:	e0da                	sd	s6,64(sp)
 68c:	fc5e                	sd	s7,56(sp)
 68e:	f862                	sd	s8,48(sp)
 690:	f466                	sd	s9,40(sp)
 692:	f06a                	sd	s10,32(sp)
 694:	ec6e                	sd	s11,24(sp)
 696:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 698:	0005c903          	lbu	s2,0(a1)
 69c:	18090f63          	beqz	s2,83a <vprintf+0x1c0>
 6a0:	8aaa                	mv	s5,a0
 6a2:	8b32                	mv	s6,a2
 6a4:	00158493          	addi	s1,a1,1
  state = 0;
 6a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6aa:	02500a13          	li	s4,37
 6ae:	4c55                	li	s8,21
 6b0:	00000c97          	auipc	s9,0x0
 6b4:	3e8c8c93          	addi	s9,s9,1000 # a98 <malloc+0x15a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6b8:	02800d93          	li	s11,40
  putc(fd, 'x');
 6bc:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6be:	00000b97          	auipc	s7,0x0
 6c2:	432b8b93          	addi	s7,s7,1074 # af0 <digits>
 6c6:	a839                	j	6e4 <vprintf+0x6a>
        putc(fd, c);
 6c8:	85ca                	mv	a1,s2
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	ee2080e7          	jalr	-286(ra) # 5ae <putc>
 6d4:	a019                	j	6da <vprintf+0x60>
    } else if(state == '%'){
 6d6:	01498d63          	beq	s3,s4,6f0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6da:	0485                	addi	s1,s1,1
 6dc:	fff4c903          	lbu	s2,-1(s1)
 6e0:	14090d63          	beqz	s2,83a <vprintf+0x1c0>
    if(state == 0){
 6e4:	fe0999e3          	bnez	s3,6d6 <vprintf+0x5c>
      if(c == '%'){
 6e8:	ff4910e3          	bne	s2,s4,6c8 <vprintf+0x4e>
        state = '%';
 6ec:	89d2                	mv	s3,s4
 6ee:	b7f5                	j	6da <vprintf+0x60>
      if(c == 'd'){
 6f0:	11490c63          	beq	s2,s4,808 <vprintf+0x18e>
 6f4:	f9d9079b          	addiw	a5,s2,-99
 6f8:	0ff7f793          	zext.b	a5,a5
 6fc:	10fc6e63          	bltu	s8,a5,818 <vprintf+0x19e>
 700:	f9d9079b          	addiw	a5,s2,-99
 704:	0ff7f713          	zext.b	a4,a5
 708:	10ec6863          	bltu	s8,a4,818 <vprintf+0x19e>
 70c:	00271793          	slli	a5,a4,0x2
 710:	97e6                	add	a5,a5,s9
 712:	439c                	lw	a5,0(a5)
 714:	97e6                	add	a5,a5,s9
 716:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 718:	008b0913          	addi	s2,s6,8
 71c:	4685                	li	a3,1
 71e:	4629                	li	a2,10
 720:	000b2583          	lw	a1,0(s6)
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	eaa080e7          	jalr	-342(ra) # 5d0 <printint>
 72e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 730:	4981                	li	s3,0
 732:	b765                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	008b0913          	addi	s2,s6,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000b2583          	lw	a1,0(s6)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	e8e080e7          	jalr	-370(ra) # 5d0 <printint>
 74a:	8b4a                	mv	s6,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b771                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 750:	008b0913          	addi	s2,s6,8
 754:	4681                	li	a3,0
 756:	866a                	mv	a2,s10
 758:	000b2583          	lw	a1,0(s6)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e72080e7          	jalr	-398(ra) # 5d0 <printint>
 766:	8b4a                	mv	s6,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	bf85                	j	6da <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 76c:	008b0793          	addi	a5,s6,8
 770:	f8f43423          	sd	a5,-120(s0)
 774:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 778:	03000593          	li	a1,48
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	e30080e7          	jalr	-464(ra) # 5ae <putc>
  putc(fd, 'x');
 786:	07800593          	li	a1,120
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	e22080e7          	jalr	-478(ra) # 5ae <putc>
 794:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 796:	03c9d793          	srli	a5,s3,0x3c
 79a:	97de                	add	a5,a5,s7
 79c:	0007c583          	lbu	a1,0(a5)
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	e0c080e7          	jalr	-500(ra) # 5ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7aa:	0992                	slli	s3,s3,0x4
 7ac:	397d                	addiw	s2,s2,-1
 7ae:	fe0914e3          	bnez	s2,796 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7b2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b70d                	j	6da <vprintf+0x60>
        s = va_arg(ap, char*);
 7ba:	008b0913          	addi	s2,s6,8
 7be:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7c2:	02098163          	beqz	s3,7e4 <vprintf+0x16a>
        while(*s != 0){
 7c6:	0009c583          	lbu	a1,0(s3)
 7ca:	c5ad                	beqz	a1,834 <vprintf+0x1ba>
          putc(fd, *s);
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	de0080e7          	jalr	-544(ra) # 5ae <putc>
          s++;
 7d6:	0985                	addi	s3,s3,1
        while(*s != 0){
 7d8:	0009c583          	lbu	a1,0(s3)
 7dc:	f9e5                	bnez	a1,7cc <vprintf+0x152>
        s = va_arg(ap, char*);
 7de:	8b4a                	mv	s6,s2
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bde5                	j	6da <vprintf+0x60>
          s = "(null)";
 7e4:	00000997          	auipc	s3,0x0
 7e8:	2ac98993          	addi	s3,s3,684 # a90 <malloc+0x152>
        while(*s != 0){
 7ec:	85ee                	mv	a1,s11
 7ee:	bff9                	j	7cc <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7f0:	008b0913          	addi	s2,s6,8
 7f4:	000b4583          	lbu	a1,0(s6)
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	db4080e7          	jalr	-588(ra) # 5ae <putc>
 802:	8b4a                	mv	s6,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	bdd1                	j	6da <vprintf+0x60>
        putc(fd, c);
 808:	85d2                	mv	a1,s4
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	da2080e7          	jalr	-606(ra) # 5ae <putc>
      state = 0;
 814:	4981                	li	s3,0
 816:	b5d1                	j	6da <vprintf+0x60>
        putc(fd, '%');
 818:	85d2                	mv	a1,s4
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	d92080e7          	jalr	-622(ra) # 5ae <putc>
        putc(fd, c);
 824:	85ca                	mv	a1,s2
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	d86080e7          	jalr	-634(ra) # 5ae <putc>
      state = 0;
 830:	4981                	li	s3,0
 832:	b565                	j	6da <vprintf+0x60>
        s = va_arg(ap, char*);
 834:	8b4a                	mv	s6,s2
      state = 0;
 836:	4981                	li	s3,0
 838:	b54d                	j	6da <vprintf+0x60>
    }
  }
}
 83a:	70e6                	ld	ra,120(sp)
 83c:	7446                	ld	s0,112(sp)
 83e:	74a6                	ld	s1,104(sp)
 840:	7906                	ld	s2,96(sp)
 842:	69e6                	ld	s3,88(sp)
 844:	6a46                	ld	s4,80(sp)
 846:	6aa6                	ld	s5,72(sp)
 848:	6b06                	ld	s6,64(sp)
 84a:	7be2                	ld	s7,56(sp)
 84c:	7c42                	ld	s8,48(sp)
 84e:	7ca2                	ld	s9,40(sp)
 850:	7d02                	ld	s10,32(sp)
 852:	6de2                	ld	s11,24(sp)
 854:	6109                	addi	sp,sp,128
 856:	8082                	ret

0000000000000858 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 858:	715d                	addi	sp,sp,-80
 85a:	ec06                	sd	ra,24(sp)
 85c:	e822                	sd	s0,16(sp)
 85e:	1000                	addi	s0,sp,32
 860:	e010                	sd	a2,0(s0)
 862:	e414                	sd	a3,8(s0)
 864:	e818                	sd	a4,16(s0)
 866:	ec1c                	sd	a5,24(s0)
 868:	03043023          	sd	a6,32(s0)
 86c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	8622                	mv	a2,s0
 872:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 876:	00000097          	auipc	ra,0x0
 87a:	e04080e7          	jalr	-508(ra) # 67a <vprintf>
}
 87e:	60e2                	ld	ra,24(sp)
 880:	6442                	ld	s0,16(sp)
 882:	6161                	addi	sp,sp,80
 884:	8082                	ret

0000000000000886 <printf>:

void
printf(const char *fmt, ...)
{
 886:	711d                	addi	sp,sp,-96
 888:	ec06                	sd	ra,24(sp)
 88a:	e822                	sd	s0,16(sp)
 88c:	1000                	addi	s0,sp,32
 88e:	e40c                	sd	a1,8(s0)
 890:	e810                	sd	a2,16(s0)
 892:	ec14                	sd	a3,24(s0)
 894:	f018                	sd	a4,32(s0)
 896:	f41c                	sd	a5,40(s0)
 898:	03043823          	sd	a6,48(s0)
 89c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a0:	00840613          	addi	a2,s0,8
 8a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a8:	85aa                	mv	a1,a0
 8aa:	4505                	li	a0,1
 8ac:	00000097          	auipc	ra,0x0
 8b0:	dce080e7          	jalr	-562(ra) # 67a <vprintf>
}
 8b4:	60e2                	ld	ra,24(sp)
 8b6:	6442                	ld	s0,16(sp)
 8b8:	6125                	addi	sp,sp,96
 8ba:	8082                	ret

00000000000008bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8bc:	1141                	addi	sp,sp,-16
 8be:	e422                	sd	s0,8(sp)
 8c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c6:	00000797          	auipc	a5,0x0
 8ca:	2427b783          	ld	a5,578(a5) # b08 <freep>
 8ce:	a02d                	j	8f8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d0:	4618                	lw	a4,8(a2)
 8d2:	9f2d                	addw	a4,a4,a1
 8d4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d8:	6398                	ld	a4,0(a5)
 8da:	6310                	ld	a2,0(a4)
 8dc:	a83d                	j	91a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8de:	ff852703          	lw	a4,-8(a0)
 8e2:	9f31                	addw	a4,a4,a2
 8e4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8e6:	ff053683          	ld	a3,-16(a0)
 8ea:	a091                	j	92e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ec:	6398                	ld	a4,0(a5)
 8ee:	00e7e463          	bltu	a5,a4,8f6 <free+0x3a>
 8f2:	00e6ea63          	bltu	a3,a4,906 <free+0x4a>
{
 8f6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f8:	fed7fae3          	bgeu	a5,a3,8ec <free+0x30>
 8fc:	6398                	ld	a4,0(a5)
 8fe:	00e6e463          	bltu	a3,a4,906 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 902:	fee7eae3          	bltu	a5,a4,8f6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 906:	ff852583          	lw	a1,-8(a0)
 90a:	6390                	ld	a2,0(a5)
 90c:	02059813          	slli	a6,a1,0x20
 910:	01c85713          	srli	a4,a6,0x1c
 914:	9736                	add	a4,a4,a3
 916:	fae60de3          	beq	a2,a4,8d0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 91a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 91e:	4790                	lw	a2,8(a5)
 920:	02061593          	slli	a1,a2,0x20
 924:	01c5d713          	srli	a4,a1,0x1c
 928:	973e                	add	a4,a4,a5
 92a:	fae68ae3          	beq	a3,a4,8de <free+0x22>
    p->s.ptr = bp->s.ptr;
 92e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 930:	00000717          	auipc	a4,0x0
 934:	1cf73c23          	sd	a5,472(a4) # b08 <freep>
}
 938:	6422                	ld	s0,8(sp)
 93a:	0141                	addi	sp,sp,16
 93c:	8082                	ret

000000000000093e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 93e:	7139                	addi	sp,sp,-64
 940:	fc06                	sd	ra,56(sp)
 942:	f822                	sd	s0,48(sp)
 944:	f426                	sd	s1,40(sp)
 946:	f04a                	sd	s2,32(sp)
 948:	ec4e                	sd	s3,24(sp)
 94a:	e852                	sd	s4,16(sp)
 94c:	e456                	sd	s5,8(sp)
 94e:	e05a                	sd	s6,0(sp)
 950:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 952:	02051493          	slli	s1,a0,0x20
 956:	9081                	srli	s1,s1,0x20
 958:	04bd                	addi	s1,s1,15
 95a:	8091                	srli	s1,s1,0x4
 95c:	00148a1b          	addiw	s4,s1,1
 960:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 962:	00000517          	auipc	a0,0x0
 966:	1a653503          	ld	a0,422(a0) # b08 <freep>
 96a:	c515                	beqz	a0,996 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96e:	4798                	lw	a4,8(a5)
 970:	04977163          	bgeu	a4,s1,9b2 <malloc+0x74>
 974:	89d2                	mv	s3,s4
 976:	000a071b          	sext.w	a4,s4
 97a:	6685                	lui	a3,0x1
 97c:	00d77363          	bgeu	a4,a3,982 <malloc+0x44>
 980:	6985                	lui	s3,0x1
 982:	00098b1b          	sext.w	s6,s3
  p = sbrk(nu * sizeof(Header));
 986:	0049999b          	slliw	s3,s3,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 98a:	00000917          	auipc	s2,0x0
 98e:	17e90913          	addi	s2,s2,382 # b08 <freep>
  if(p == (char*)-1)
 992:	5afd                	li	s5,-1
 994:	a8a5                	j	a0c <malloc+0xce>
    base.s.ptr = freep = prevp = &base;
 996:	00000797          	auipc	a5,0x0
 99a:	17278793          	addi	a5,a5,370 # b08 <freep>
 99e:	00000717          	auipc	a4,0x0
 9a2:	17270713          	addi	a4,a4,370 # b10 <base>
 9a6:	e398                	sd	a4,0(a5)
 9a8:	e798                	sd	a4,8(a5)
    base.s.size = 0;
 9aa:	0007a823          	sw	zero,16(a5)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	87ba                	mv	a5,a4
 9b0:	b7d1                	j	974 <malloc+0x36>
      if(p->s.size == nunits)
 9b2:	02e48c63          	beq	s1,a4,9ea <malloc+0xac>
        p->s.size -= nunits;
 9b6:	4147073b          	subw	a4,a4,s4
 9ba:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9bc:	02071693          	slli	a3,a4,0x20
 9c0:	01c6d713          	srli	a4,a3,0x1c
 9c4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c6:	0147a423          	sw	s4,8(a5)
      freep = prevp;
 9ca:	00000717          	auipc	a4,0x0
 9ce:	12a73f23          	sd	a0,318(a4) # b08 <freep>
      return (void*)(p + 1);
 9d2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9d6:	70e2                	ld	ra,56(sp)
 9d8:	7442                	ld	s0,48(sp)
 9da:	74a2                	ld	s1,40(sp)
 9dc:	7902                	ld	s2,32(sp)
 9de:	69e2                	ld	s3,24(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
 9e6:	6121                	addi	sp,sp,64
 9e8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ea:	6398                	ld	a4,0(a5)
 9ec:	e118                	sd	a4,0(a0)
 9ee:	bff1                	j	9ca <malloc+0x8c>
  hp->s.size = nu;
 9f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9f4:	0541                	addi	a0,a0,16
 9f6:	00000097          	auipc	ra,0x0
 9fa:	ec6080e7          	jalr	-314(ra) # 8bc <free>
  return freep;
 9fe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a02:	d971                	beqz	a0,9d6 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a06:	4798                	lw	a4,8(a5)
 a08:	fa9775e3          	bgeu	a4,s1,9b2 <malloc+0x74>
    if(p == freep)
 a0c:	00093703          	ld	a4,0(s2)
 a10:	853e                	mv	a0,a5
 a12:	fef719e3          	bne	a4,a5,a04 <malloc+0xc6>
  p = sbrk(nu * sizeof(Header));
 a16:	854e                	mv	a0,s3
 a18:	00000097          	auipc	ra,0x0
 a1c:	a8c080e7          	jalr	-1396(ra) # 4a4 <sbrk>
  if(p == (char*)-1)
 a20:	fd5518e3          	bne	a0,s5,9f0 <malloc+0xb2>
        return 0;
 a24:	4501                	li	a0,0
 a26:	bf45                	j	9d6 <malloc+0x98>
