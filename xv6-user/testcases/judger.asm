
xv6-user/testcases/_judger:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simple_strcmp>:
    "LRU Test PASSED",
};

const char* error = "ERROR";

int simple_strcmp(const char* s1, const char* s2, int n) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    for (int i = 0; i < n; i++) {
   6:	02c05563          	blez	a2,30 <simple_strcmp+0x30>
   a:	87aa                	mv	a5,a0
   c:	0505                	addi	a0,a0,1
   e:	367d                	addiw	a2,a2,-1
  10:	1602                	slli	a2,a2,0x20
  12:	9201                	srli	a2,a2,0x20
  14:	962a                	add	a2,a2,a0
        if (s1[i] != s2[i]) return 1;
  16:	0007c703          	lbu	a4,0(a5)
  1a:	0005c683          	lbu	a3,0(a1)
  1e:	00e69b63          	bne	a3,a4,34 <simple_strcmp+0x34>
        if (s1[i] == '\0') return 1;
  22:	cf09                	beqz	a4,3c <simple_strcmp+0x3c>
    for (int i = 0; i < n; i++) {
  24:	0785                	addi	a5,a5,1
  26:	0585                	addi	a1,a1,1
  28:	fec797e3          	bne	a5,a2,16 <simple_strcmp+0x16>
    }
    return 0;
  2c:	4501                	li	a0,0
  2e:	a021                	j	36 <simple_strcmp+0x36>
  30:	4501                	li	a0,0
  32:	a011                	j	36 <simple_strcmp+0x36>
        if (s1[i] != s2[i]) return 1;
  34:	4505                	li	a0,1
}
  36:	6422                	ld	s0,8(sp)
  38:	0141                	addi	sp,sp,16
  3a:	8082                	ret
        if (s1[i] == '\0') return 1;
  3c:	4505                	li	a0,1
  3e:	bfe5                	j	36 <simple_strcmp+0x36>

0000000000000040 <find_substring>:

int find_substring(const char* text, const char* pattern) {
  40:	7179                	addi	sp,sp,-48
  42:	f406                	sd	ra,40(sp)
  44:	f022                	sd	s0,32(sp)
  46:	ec26                	sd	s1,24(sp)
  48:	e84a                	sd	s2,16(sp)
  4a:	e44e                	sd	s3,8(sp)
  4c:	e052                	sd	s4,0(sp)
  4e:	1800                	addi	s0,sp,48
    if (text == NULL || pattern == NULL) {
  50:	cd21                	beqz	a0,a8 <find_substring+0x68>
  52:	84aa                	mv	s1,a0
  54:	8a2e                	mv	s4,a1
  56:	c9b9                	beqz	a1,ac <find_substring+0x6c>
        return -1;
    }
    
    int pattern_len = 0;
    while (pattern[pattern_len] != '\0') {
  58:	0005c783          	lbu	a5,0(a1)
  5c:	cbb1                	beqz	a5,b0 <find_substring+0x70>
  5e:	00158713          	addi	a4,a1,1
  62:	87ba                	mv	a5,a4
  64:	4685                	li	a3,1
  66:	9e99                	subw	a3,a3,a4
        pattern_len++;
  68:	00f6893b          	addw	s2,a3,a5
    while (pattern[pattern_len] != '\0') {
  6c:	0785                	addi	a5,a5,1
  6e:	fff7c703          	lbu	a4,-1(a5)
  72:	fb7d                	bnez	a4,68 <find_substring+0x28>
    }
    if (pattern_len == 0) {
  74:	04090363          	beqz	s2,ba <find_substring+0x7a>
        return 0;
    }
    
    int i = 0;
    while (text[i] != '\0') {
  78:	0004c783          	lbu	a5,0(s1)
  7c:	cf85                	beqz	a5,b4 <find_substring+0x74>
    int i = 0;
  7e:	4981                	li	s3,0
        if (text[i + pattern_len - 1] == '\0') {
  80:	012487b3          	add	a5,s1,s2
  84:	fff7c783          	lbu	a5,-1(a5)
  88:	cb85                	beqz	a5,b8 <find_substring+0x78>
            break;
        }
        if (simple_strcmp(text + i, pattern, pattern_len) == 0) {
  8a:	864a                	mv	a2,s2
  8c:	85d2                	mv	a1,s4
  8e:	8526                	mv	a0,s1
  90:	00000097          	auipc	ra,0x0
  94:	f70080e7          	jalr	-144(ra) # 0 <simple_strcmp>
  98:	c915                	beqz	a0,cc <find_substring+0x8c>
            return i;
        }
        i++;
  9a:	2985                	addiw	s3,s3,1
    while (text[i] != '\0') {
  9c:	0485                	addi	s1,s1,1
  9e:	0004c783          	lbu	a5,0(s1)
  a2:	fff9                	bnez	a5,80 <find_substring+0x40>
    }
    return -1; 
  a4:	597d                	li	s2,-1
  a6:	a811                	j	ba <find_substring+0x7a>
        return -1;
  a8:	597d                	li	s2,-1
  aa:	a801                	j	ba <find_substring+0x7a>
  ac:	597d                	li	s2,-1
  ae:	a031                	j	ba <find_substring+0x7a>
        return 0;
  b0:	4901                	li	s2,0
  b2:	a021                	j	ba <find_substring+0x7a>
    return -1; 
  b4:	597d                	li	s2,-1
  b6:	a011                	j	ba <find_substring+0x7a>
  b8:	597d                	li	s2,-1
}
  ba:	854a                	mv	a0,s2
  bc:	70a2                	ld	ra,40(sp)
  be:	7402                	ld	s0,32(sp)
  c0:	64e2                	ld	s1,24(sp)
  c2:	6942                	ld	s2,16(sp)
  c4:	69a2                	ld	s3,8(sp)
  c6:	6a02                	ld	s4,0(sp)
  c8:	6145                	addi	sp,sp,48
  ca:	8082                	ret
  cc:	894e                	mv	s2,s3
  ce:	b7f5                	j	ba <find_substring+0x7a>

00000000000000d0 <main>:


int main(int argc, char* argv[]) {
  d0:	7179                	addi	sp,sp,-48
  d2:	f406                	sd	ra,40(sp)
  d4:	f022                	sd	s0,32(sp)
  d6:	ec26                	sd	s1,24(sp)
  d8:	e84a                	sd	s2,16(sp)
  da:	e44e                	sd	s3,8(sp)
  dc:	1800                	addi	s0,sp,48
  de:	84aa                	mv	s1,a0
  e0:	892e                	mv	s2,a1
    printf("Judger: Starting evaluation\n");
  e2:	00001517          	auipc	a0,0x1
  e6:	9e650513          	addi	a0,a0,-1562 # ac8 <malloc+0xea>
  ea:	00001097          	auipc	ra,0x1
  ee:	83c080e7          	jalr	-1988(ra) # 926 <printf>
    int score = 0;
    
    if (argc == 3) {
  f2:	478d                	li	a5,3
  f4:	02f48863          	beq	s1,a5,124 <main+0x54>
        } else {
            printf("Error: Not found expected output\n");
        }
        
    } else {
        printf("Error: Not matched arguments\n");
  f8:	00001517          	auipc	a0,0x1
  fc:	a6850513          	addi	a0,a0,-1432 # b60 <malloc+0x182>
 100:	00001097          	auipc	ra,0x1
 104:	826080e7          	jalr	-2010(ra) # 926 <printf>
    int score = 0;
 108:	4581                	li	a1,0
    }
    
    printf("SCORE: %d\n", score);
 10a:	00001517          	auipc	a0,0x1
 10e:	a7650513          	addi	a0,a0,-1418 # b80 <malloc+0x1a2>
 112:	00001097          	auipc	ra,0x1
 116:	814080e7          	jalr	-2028(ra) # 926 <printf>
    exit(0);
 11a:	4501                	li	a0,0
 11c:	00000097          	auipc	ra,0x0
 120:	368080e7          	jalr	872(ra) # 484 <exit>
        char* program_name = argv[1];
 124:	00893983          	ld	s3,8(s2)
        char* output = argv[2];
 128:	01093483          	ld	s1,16(s2)
        printf("Test%s output:\n%s\n", program_name, output);
 12c:	8626                	mv	a2,s1
 12e:	85ce                	mv	a1,s3
 130:	00001517          	auipc	a0,0x1
 134:	9b850513          	addi	a0,a0,-1608 # ae8 <malloc+0x10a>
 138:	00000097          	auipc	ra,0x0
 13c:	7ee080e7          	jalr	2030(ra) # 926 <printf>
        switch (program_name[0]) {
 140:	0009c703          	lbu	a4,0(s3)
 144:	03100793          	li	a5,49
 148:	04f70b63          	beq	a4,a5,19e <main+0xce>
 14c:	03200693          	li	a3,50
        int index = -1;
 150:	57fd                	li	a5,-1
        switch (program_name[0]) {
 152:	00d71363          	bne	a4,a3,158 <main+0x88>
                index = 1;
 156:	4785                	li	a5,1
        int res = find_substring(output, expected[index]);
 158:	078e                	slli	a5,a5,0x3
 15a:	00001717          	auipc	a4,0x1
 15e:	ade70713          	addi	a4,a4,-1314 # c38 <expected>
 162:	97ba                	add	a5,a5,a4
 164:	638c                	ld	a1,0(a5)
 166:	8526                	mv	a0,s1
 168:	00000097          	auipc	ra,0x0
 16c:	ed8080e7          	jalr	-296(ra) # 40 <find_substring>
        if (res > 0) {
 170:	04a05463          	blez	a0,1b8 <main+0xe8>
            if (find_substring(output, error) <= 0) {
 174:	00001597          	auipc	a1,0x1
 178:	ad45b583          	ld	a1,-1324(a1) # c48 <error>
 17c:	8526                	mv	a0,s1
 17e:	00000097          	auipc	ra,0x0
 182:	ec2080e7          	jalr	-318(ra) # 40 <find_substring>
 186:	00a05e63          	blez	a0,1a2 <main+0xd2>
                printf("Error: Found ERROR in test case output\n");
 18a:	00001517          	auipc	a0,0x1
 18e:	98650513          	addi	a0,a0,-1658 # b10 <malloc+0x132>
 192:	00000097          	auipc	ra,0x0
 196:	794080e7          	jalr	1940(ra) # 926 <printf>
    int score = 0;
 19a:	4581                	li	a1,0
 19c:	b7bd                	j	10a <main+0x3a>
        switch (program_name[0]) {
 19e:	4781                	li	a5,0
 1a0:	bf65                	j	158 <main+0x88>
                printf("TEST %s PASSED\n", program_name);
 1a2:	85ce                	mv	a1,s3
 1a4:	00001517          	auipc	a0,0x1
 1a8:	95c50513          	addi	a0,a0,-1700 # b00 <malloc+0x122>
 1ac:	00000097          	auipc	ra,0x0
 1b0:	77a080e7          	jalr	1914(ra) # 926 <printf>
                score = 1;
 1b4:	4585                	li	a1,1
 1b6:	bf91                	j	10a <main+0x3a>
            printf("Error: Not found expected output\n");
 1b8:	00001517          	auipc	a0,0x1
 1bc:	98050513          	addi	a0,a0,-1664 # b38 <malloc+0x15a>
 1c0:	00000097          	auipc	ra,0x0
 1c4:	766080e7          	jalr	1894(ra) # 926 <printf>
    int score = 0;
 1c8:	4581                	li	a1,0
 1ca:	b781                	j	10a <main+0x3a>

00000000000001cc <strcpy>:
#include "kernel/include/fcntl.h"
#include "xv6-user/user.h"

char*
strcpy(char *s, const char *t)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d2:	87aa                	mv	a5,a0
 1d4:	0585                	addi	a1,a1,1
 1d6:	0785                	addi	a5,a5,1
 1d8:	fff5c703          	lbu	a4,-1(a1)
 1dc:	fee78fa3          	sb	a4,-1(a5)
 1e0:	fb75                	bnez	a4,1d4 <strcpy+0x8>
    ;
  return os;
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret

00000000000001e8 <strcat>:

char*
strcat(char *s, const char *t)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  char *os = s;
  while(*s)
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	c385                	beqz	a5,212 <strcat+0x2a>
 1f4:	87aa                	mv	a5,a0
    s++;
 1f6:	0785                	addi	a5,a5,1
  while(*s)
 1f8:	0007c703          	lbu	a4,0(a5)
 1fc:	ff6d                	bnez	a4,1f6 <strcat+0xe>
  while((*s++ = *t++))
 1fe:	0585                	addi	a1,a1,1
 200:	0785                	addi	a5,a5,1
 202:	fff5c703          	lbu	a4,-1(a1)
 206:	fee78fa3          	sb	a4,-1(a5)
 20a:	fb75                	bnez	a4,1fe <strcat+0x16>
    ;
  return os;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
  while(*s)
 212:	87aa                	mv	a5,a0
 214:	b7ed                	j	1fe <strcat+0x16>

0000000000000216 <strcmp>:


int
strcmp(const char *p, const char *q)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 21c:	00054783          	lbu	a5,0(a0)
 220:	cb91                	beqz	a5,234 <strcmp+0x1e>
 222:	0005c703          	lbu	a4,0(a1)
 226:	00f71763          	bne	a4,a5,234 <strcmp+0x1e>
    p++, q++;
 22a:	0505                	addi	a0,a0,1
 22c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 22e:	00054783          	lbu	a5,0(a0)
 232:	fbe5                	bnez	a5,222 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 234:	0005c503          	lbu	a0,0(a1)
}
 238:	40a7853b          	subw	a0,a5,a0
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strlen>:

uint
strlen(const char *s)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cf91                	beqz	a5,268 <strlen+0x26>
 24e:	0505                	addi	a0,a0,1
 250:	87aa                	mv	a5,a0
 252:	4685                	li	a3,1
 254:	9e89                	subw	a3,a3,a0
 256:	00f6853b          	addw	a0,a3,a5
 25a:	0785                	addi	a5,a5,1
 25c:	fff7c703          	lbu	a4,-1(a5)
 260:	fb7d                	bnez	a4,256 <strlen+0x14>
    ;
  return n;
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  for(n = 0; s[n]; n++)
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <strlen+0x20>

000000000000026c <memset>:

void*
memset(void *dst, int c, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 272:	ca19                	beqz	a2,288 <memset+0x1c>
 274:	87aa                	mv	a5,a0
 276:	1602                	slli	a2,a2,0x20
 278:	9201                	srli	a2,a2,0x20
 27a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 27e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 282:	0785                	addi	a5,a5,1
 284:	fee79de3          	bne	a5,a4,27e <memset+0x12>
  }
  return dst;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <strchr>:

char*
strchr(const char *s, char c)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  for(; *s; s++)
 294:	00054783          	lbu	a5,0(a0)
 298:	cb99                	beqz	a5,2ae <strchr+0x20>
    if(*s == c)
 29a:	00f58763          	beq	a1,a5,2a8 <strchr+0x1a>
  for(; *s; s++)
 29e:	0505                	addi	a0,a0,1
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fbfd                	bnez	a5,29a <strchr+0xc>
      return (char*)s;
  return 0;
 2a6:	4501                	li	a0,0
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <strchr+0x1a>

00000000000002b2 <gets>:

char*
gets(char *buf, int max)
{
 2b2:	711d                	addi	sp,sp,-96
 2b4:	ec86                	sd	ra,88(sp)
 2b6:	e8a2                	sd	s0,80(sp)
 2b8:	e4a6                	sd	s1,72(sp)
 2ba:	e0ca                	sd	s2,64(sp)
 2bc:	fc4e                	sd	s3,56(sp)
 2be:	f852                	sd	s4,48(sp)
 2c0:	f456                	sd	s5,40(sp)
 2c2:	f05a                	sd	s6,32(sp)
 2c4:	ec5e                	sd	s7,24(sp)
 2c6:	e862                	sd	s8,16(sp)
 2c8:	1080                	addi	s0,sp,96
 2ca:	8baa                	mv	s7,a0
 2cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ce:	892a                	mv	s2,a0
 2d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2d2:	faf40a93          	addi	s5,s0,-81
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d6:	4b29                	li	s6,10
 2d8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 2da:	89a6                	mv	s3,s1
 2dc:	2485                	addiw	s1,s1,1
 2de:	0344d763          	bge	s1,s4,30c <gets+0x5a>
    cc = read(0, &c, 1);
 2e2:	4605                	li	a2,1
 2e4:	85d6                	mv	a1,s5
 2e6:	4501                	li	a0,0
 2e8:	00000097          	auipc	ra,0x0
 2ec:	1b8080e7          	jalr	440(ra) # 4a0 <read>
    if(cc < 1)
 2f0:	00a05e63          	blez	a0,30c <gets+0x5a>
    buf[i++] = c;
 2f4:	faf44783          	lbu	a5,-81(s0)
 2f8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2fc:	01678763          	beq	a5,s6,30a <gets+0x58>
 300:	0905                	addi	s2,s2,1
 302:	fd879ce3          	bne	a5,s8,2da <gets+0x28>
  for(i=0; i+1 < max; ){
 306:	89a6                	mv	s3,s1
 308:	a011                	j	30c <gets+0x5a>
 30a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 30c:	99de                	add	s3,s3,s7
 30e:	00098023          	sb	zero,0(s3)
  return buf;
}
 312:	855e                	mv	a0,s7
 314:	60e6                	ld	ra,88(sp)
 316:	6446                	ld	s0,80(sp)
 318:	64a6                	ld	s1,72(sp)
 31a:	6906                	ld	s2,64(sp)
 31c:	79e2                	ld	s3,56(sp)
 31e:	7a42                	ld	s4,48(sp)
 320:	7aa2                	ld	s5,40(sp)
 322:	7b02                	ld	s6,32(sp)
 324:	6be2                	ld	s7,24(sp)
 326:	6c42                	ld	s8,16(sp)
 328:	6125                	addi	sp,sp,96
 32a:	8082                	ret

000000000000032c <stat>:

int
stat(const char *n, struct stat *st)
{
 32c:	1101                	addi	sp,sp,-32
 32e:	ec06                	sd	ra,24(sp)
 330:	e822                	sd	s0,16(sp)
 332:	e426                	sd	s1,8(sp)
 334:	e04a                	sd	s2,0(sp)
 336:	1000                	addi	s0,sp,32
 338:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33a:	4581                	li	a1,0
 33c:	00000097          	auipc	ra,0x0
 340:	194080e7          	jalr	404(ra) # 4d0 <open>
  if(fd < 0)
 344:	02054563          	bltz	a0,36e <stat+0x42>
 348:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34a:	85ca                	mv	a1,s2
 34c:	00000097          	auipc	ra,0x0
 350:	18e080e7          	jalr	398(ra) # 4da <fstat>
 354:	892a                	mv	s2,a0
  close(fd);
 356:	8526                	mv	a0,s1
 358:	00000097          	auipc	ra,0x0
 35c:	15c080e7          	jalr	348(ra) # 4b4 <close>
  return r;
}
 360:	854a                	mv	a0,s2
 362:	60e2                	ld	ra,24(sp)
 364:	6442                	ld	s0,16(sp)
 366:	64a2                	ld	s1,8(sp)
 368:	6902                	ld	s2,0(sp)
 36a:	6105                	addi	sp,sp,32
 36c:	8082                	ret
    return -1;
 36e:	597d                	li	s2,-1
 370:	bfc5                	j	360 <stat+0x34>

0000000000000372 <atoi>:

int
atoi(const char *s)
{
 372:	1141                	addi	sp,sp,-16
 374:	e422                	sd	s0,8(sp)
 376:	0800                	addi	s0,sp,16
  int n;
  int neg = 1;
  if (*s == '-') {
 378:	00054703          	lbu	a4,0(a0)
 37c:	02d00793          	li	a5,45
  int neg = 1;
 380:	4585                	li	a1,1
  if (*s == '-') {
 382:	04f70363          	beq	a4,a5,3c8 <atoi+0x56>
    s++;
    neg = -1;
  }
  n = 0;
  while('0' <= *s && *s <= '9')
 386:	00054703          	lbu	a4,0(a0)
 38a:	fd07079b          	addiw	a5,a4,-48
 38e:	0ff7f793          	zext.b	a5,a5
 392:	46a5                	li	a3,9
 394:	02f6ed63          	bltu	a3,a5,3ce <atoi+0x5c>
  n = 0;
 398:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 39a:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 39c:	0505                	addi	a0,a0,1
 39e:	0026979b          	slliw	a5,a3,0x2
 3a2:	9fb5                	addw	a5,a5,a3
 3a4:	0017979b          	slliw	a5,a5,0x1
 3a8:	9fb9                	addw	a5,a5,a4
 3aa:	fd07869b          	addiw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 3ae:	00054703          	lbu	a4,0(a0)
 3b2:	fd07079b          	addiw	a5,a4,-48
 3b6:	0ff7f793          	zext.b	a5,a5
 3ba:	fef671e3          	bgeu	a2,a5,39c <atoi+0x2a>
  return n * neg;
}
 3be:	02d5853b          	mulw	a0,a1,a3
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
    s++;
 3c8:	0505                	addi	a0,a0,1
    neg = -1;
 3ca:	55fd                	li	a1,-1
 3cc:	bf6d                	j	386 <atoi+0x14>
  n = 0;
 3ce:	4681                	li	a3,0
 3d0:	b7fd                	j	3be <atoi+0x4c>

00000000000003d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3d8:	02b57463          	bgeu	a0,a1,400 <memmove+0x2e>
    while(n-- > 0)
 3dc:	00c05f63          	blez	a2,3fa <memmove+0x28>
 3e0:	1602                	slli	a2,a2,0x20
 3e2:	9201                	srli	a2,a2,0x20
 3e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3e8:	872a                	mv	a4,a0
      *dst++ = *src++;
 3ea:	0585                	addi	a1,a1,1
 3ec:	0705                	addi	a4,a4,1
 3ee:	fff5c683          	lbu	a3,-1(a1)
 3f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3f6:	fee79ae3          	bne	a5,a4,3ea <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3fa:	6422                	ld	s0,8(sp)
 3fc:	0141                	addi	sp,sp,16
 3fe:	8082                	ret
    dst += n;
 400:	00c50733          	add	a4,a0,a2
    src += n;
 404:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 406:	fec05ae3          	blez	a2,3fa <memmove+0x28>
 40a:	fff6079b          	addiw	a5,a2,-1
 40e:	1782                	slli	a5,a5,0x20
 410:	9381                	srli	a5,a5,0x20
 412:	fff7c793          	not	a5,a5
 416:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 418:	15fd                	addi	a1,a1,-1
 41a:	177d                	addi	a4,a4,-1
 41c:	0005c683          	lbu	a3,0(a1)
 420:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 424:	fee79ae3          	bne	a5,a4,418 <memmove+0x46>
 428:	bfc9                	j	3fa <memmove+0x28>

000000000000042a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 430:	ca05                	beqz	a2,460 <memcmp+0x36>
 432:	fff6069b          	addiw	a3,a2,-1
 436:	1682                	slli	a3,a3,0x20
 438:	9281                	srli	a3,a3,0x20
 43a:	0685                	addi	a3,a3,1
 43c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 43e:	00054783          	lbu	a5,0(a0)
 442:	0005c703          	lbu	a4,0(a1)
 446:	00e79863          	bne	a5,a4,456 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 44a:	0505                	addi	a0,a0,1
    p2++;
 44c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 44e:	fed518e3          	bne	a0,a3,43e <memcmp+0x14>
  }
  return 0;
 452:	4501                	li	a0,0
 454:	a019                	j	45a <memcmp+0x30>
      return *p1 - *p2;
 456:	40e7853b          	subw	a0,a5,a4
}
 45a:	6422                	ld	s0,8(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret
  return 0;
 460:	4501                	li	a0,0
 462:	bfe5                	j	45a <memcmp+0x30>

0000000000000464 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 464:	1141                	addi	sp,sp,-16
 466:	e406                	sd	ra,8(sp)
 468:	e022                	sd	s0,0(sp)
 46a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 46c:	00000097          	auipc	ra,0x0
 470:	f66080e7          	jalr	-154(ra) # 3d2 <memmove>
}
 474:	60a2                	ld	ra,8(sp)
 476:	6402                	ld	s0,0(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret

000000000000047c <fork>:
# generated by usys.pl - do not edit
#include "kernel/include/sysnum.h"
.global fork
fork:
 li a7, SYS_fork
 47c:	4885                	li	a7,1
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <exit>:
.global exit
exit:
 li a7, SYS_exit
 484:	05d00893          	li	a7,93
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <wait>:
.global wait
wait:
 li a7, SYS_wait
 48e:	488d                	li	a7,3
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 496:	03b00893          	li	a7,59
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <read>:
.global read
read:
 li a7, SYS_read
 4a0:	03f00893          	li	a7,63
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <write>:
.global write
write:
 li a7, SYS_write
 4aa:	04000893          	li	a7,64
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <close>:
.global close
close:
 li a7, SYS_close
 4b4:	03900893          	li	a7,57
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <kill>:
.global kill
kill:
 li a7, SYS_kill
 4be:	4899                	li	a7,6
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c6:	0dd00893          	li	a7,221
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <open>:
.global open
open:
 li a7, SYS_open
 4d0:	03700893          	li	a7,55
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4da:	05000893          	li	a7,80
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4e4:	489d                	li	a7,7
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ec:	03100893          	li	a7,49
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4f6:	48dd                	li	a7,23
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4fe:	0ac00893          	li	a7,172
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 508:	48b1                	li	a7,12
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 510:	48b5                	li	a7,13
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 518:	48b9                	li	a7,14
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <test_proc>:
.global test_proc
test_proc:
 li a7, SYS_test_proc
 520:	48d9                	li	a7,22
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <dev>:
.global dev
dev:
 li a7, SYS_dev
 528:	48d5                	li	a7,21
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <readdir>:
.global readdir
readdir:
 li a7, SYS_readdir
 530:	48ed                	li	a7,27
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <getcwd>:
.global getcwd
getcwd:
 li a7, SYS_getcwd
 538:	48c5                	li	a7,17
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <remove>:
.global remove
remove:
 li a7, SYS_remove
 540:	07500893          	li	a7,117
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <trace>:
.global trace
trace:
 li a7, SYS_trace
 54a:	48c9                	li	a7,18
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 552:	48cd                	li	a7,19
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <rename>:
.global rename
rename:
 li a7, SYS_rename
 55a:	48e9                	li	a7,26
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 562:	03000893          	li	a7,48
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <times>:
.global times
times:
 li a7, SYS_times
 56c:	09900893          	li	a7,153
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <uname>:
.global uname
uname:
 li a7, SYS_uname
 576:	0a000893          	li	a7,160
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <clone>:
.global clone
clone:
 li a7, SYS_clone
 580:	0dc00893          	li	a7,220
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <wait4>:
.global wait4
wait4:
 li a7, SYS_wait4
 58a:	10400893          	li	a7,260
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 594:	07c00893          	li	a7,124
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 59e:	0ad00893          	li	a7,173
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <gettimeofday>:
.global gettimeofday
gettimeofday:
 li a7, SYS_gettimeofday
 5a8:	0a900893          	li	a7,169
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <nanosleep>:
.global nanosleep
nanosleep:
 li a7, SYS_nanosleep
 5b2:	06500893          	li	a7,101
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <brk>:
.global brk
brk:
 li a7, SYS_brk
 5bc:	0d600893          	li	a7,214
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 5c6:	0de00893          	li	a7,222
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 5d0:	0d700893          	li	a7,215
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <dup2>:
.global dup2
dup2:
 li a7, SYS_dup2
 5da:	68b5                	lui	a7,0xd
 5dc:	4318889b          	addiw	a7,a7,1073 # d431 <__global_pointer$+0xbff9>
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <dup3>:
.global dup3
dup3:
 li a7, SYS_dup3
 5e6:	48e1                	li	a7,24
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <set_timeslice>:
.global set_timeslice
set_timeslice:
 li a7, SYS_set_timeslice
 5ee:	68b5                	lui	a7,0xd
 5f0:	4328889b          	addiw	a7,a7,1074 # d432 <__global_pointer$+0xbffa>
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 5fa:	68b5                	lui	a7,0xd
 5fc:	4338889b          	addiw	a7,a7,1075 # d433 <__global_pointer$+0xbffb>
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 606:	68b5                	lui	a7,0xd
 608:	4348889b          	addiw	a7,a7,1076 # d434 <__global_pointer$+0xbffc>
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <getpgcnt>:
.global getpgcnt
getpgcnt:
 li a7, SYS_getpgcnt
 612:	68b9                	lui	a7,0xe
 614:	9038889b          	addiw	a7,a7,-1789 # d903 <__global_pointer$+0xc4cb>
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <getprocsz>:
.global getprocsz
getprocsz:
 li a7, SYS_getprocsz
 61e:	68b9                	lui	a7,0xe
 620:	9048889b          	addiw	a7,a7,-1788 # d904 <__global_pointer$+0xc4cc>
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <set_max_page_in_mem>:
.global set_max_page_in_mem
set_max_page_in_mem:
 li a7, SYS_set_max_page_in_mem
 62a:	68b9                	lui	a7,0xe
 62c:	9058889b          	addiw	a7,a7,-1787 # d905 <__global_pointer$+0xc4cd>
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <get_swap_count>:
.global get_swap_count
get_swap_count:
 li a7, SYS_get_swap_count
 636:	68b9                	lui	a7,0xe
 638:	9068889b          	addiw	a7,a7,-1786 # d906 <__global_pointer$+0xc4ce>
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <lru_access_notify>:
.global lru_access_notify
lru_access_notify:
 li a7, SYS_lru_access_notify
 642:	68b9                	lui	a7,0xe
 644:	9078889b          	addiw	a7,a7,-1785 # d907 <__global_pointer$+0xc4cf>
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 64e:	1101                	addi	sp,sp,-32
 650:	ec06                	sd	ra,24(sp)
 652:	e822                	sd	s0,16(sp)
 654:	1000                	addi	s0,sp,32
 656:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 65a:	4605                	li	a2,1
 65c:	fef40593          	addi	a1,s0,-17
 660:	00000097          	auipc	ra,0x0
 664:	e4a080e7          	jalr	-438(ra) # 4aa <write>
}
 668:	60e2                	ld	ra,24(sp)
 66a:	6442                	ld	s0,16(sp)
 66c:	6105                	addi	sp,sp,32
 66e:	8082                	ret

0000000000000670 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	7139                	addi	sp,sp,-64
 672:	fc06                	sd	ra,56(sp)
 674:	f822                	sd	s0,48(sp)
 676:	f426                	sd	s1,40(sp)
 678:	f04a                	sd	s2,32(sp)
 67a:	ec4e                	sd	s3,24(sp)
 67c:	0080                	addi	s0,sp,64
 67e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 680:	c299                	beqz	a3,686 <printint+0x16>
 682:	0805c863          	bltz	a1,712 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 686:	2581                	sext.w	a1,a1
  neg = 0;
 688:	4881                	li	a7,0
  }

  i = 0;
 68a:	fc040993          	addi	s3,s0,-64
  neg = 0;
 68e:	86ce                	mv	a3,s3
  i = 0;
 690:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 692:	2601                	sext.w	a2,a2
 694:	00000517          	auipc	a0,0x0
 698:	58c50513          	addi	a0,a0,1420 # c20 <digits>
 69c:	883a                	mv	a6,a4
 69e:	2705                	addiw	a4,a4,1
 6a0:	02c5f7bb          	remuw	a5,a1,a2
 6a4:	1782                	slli	a5,a5,0x20
 6a6:	9381                	srli	a5,a5,0x20
 6a8:	97aa                	add	a5,a5,a0
 6aa:	0007c783          	lbu	a5,0(a5)
 6ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6b2:	0005879b          	sext.w	a5,a1
 6b6:	02c5d5bb          	divuw	a1,a1,a2
 6ba:	0685                	addi	a3,a3,1
 6bc:	fec7f0e3          	bgeu	a5,a2,69c <printint+0x2c>
  if(neg)
 6c0:	00088c63          	beqz	a7,6d8 <printint+0x68>
    buf[i++] = '-';
 6c4:	fd070793          	addi	a5,a4,-48
 6c8:	00878733          	add	a4,a5,s0
 6cc:	02d00793          	li	a5,45
 6d0:	fef70823          	sb	a5,-16(a4)
 6d4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6d8:	02e05663          	blez	a4,704 <printint+0x94>
 6dc:	fc040913          	addi	s2,s0,-64
 6e0:	993a                	add	s2,s2,a4
 6e2:	19fd                	addi	s3,s3,-1
 6e4:	99ba                	add	s3,s3,a4
 6e6:	377d                	addiw	a4,a4,-1
 6e8:	1702                	slli	a4,a4,0x20
 6ea:	9301                	srli	a4,a4,0x20
 6ec:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6f0:	fff94583          	lbu	a1,-1(s2)
 6f4:	8526                	mv	a0,s1
 6f6:	00000097          	auipc	ra,0x0
 6fa:	f58080e7          	jalr	-168(ra) # 64e <putc>
  while(--i >= 0)
 6fe:	197d                	addi	s2,s2,-1
 700:	ff3918e3          	bne	s2,s3,6f0 <printint+0x80>
}
 704:	70e2                	ld	ra,56(sp)
 706:	7442                	ld	s0,48(sp)
 708:	74a2                	ld	s1,40(sp)
 70a:	7902                	ld	s2,32(sp)
 70c:	69e2                	ld	s3,24(sp)
 70e:	6121                	addi	sp,sp,64
 710:	8082                	ret
    x = -xx;
 712:	40b005bb          	negw	a1,a1
    neg = 1;
 716:	4885                	li	a7,1
    x = -xx;
 718:	bf8d                	j	68a <printint+0x1a>

000000000000071a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 71a:	7119                	addi	sp,sp,-128
 71c:	fc86                	sd	ra,120(sp)
 71e:	f8a2                	sd	s0,112(sp)
 720:	f4a6                	sd	s1,104(sp)
 722:	f0ca                	sd	s2,96(sp)
 724:	ecce                	sd	s3,88(sp)
 726:	e8d2                	sd	s4,80(sp)
 728:	e4d6                	sd	s5,72(sp)
 72a:	e0da                	sd	s6,64(sp)
 72c:	fc5e                	sd	s7,56(sp)
 72e:	f862                	sd	s8,48(sp)
 730:	f466                	sd	s9,40(sp)
 732:	f06a                	sd	s10,32(sp)
 734:	ec6e                	sd	s11,24(sp)
 736:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 738:	0005c903          	lbu	s2,0(a1)
 73c:	18090f63          	beqz	s2,8da <vprintf+0x1c0>
 740:	8aaa                	mv	s5,a0
 742:	8b32                	mv	s6,a2
 744:	00158493          	addi	s1,a1,1
  state = 0;
 748:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 74a:	02500a13          	li	s4,37
 74e:	4c55                	li	s8,21
 750:	00000c97          	auipc	s9,0x0
 754:	478c8c93          	addi	s9,s9,1144 # bc8 <malloc+0x1ea>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 758:	02800d93          	li	s11,40
  putc(fd, 'x');
 75c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75e:	00000b97          	auipc	s7,0x0
 762:	4c2b8b93          	addi	s7,s7,1218 # c20 <digits>
 766:	a839                	j	784 <vprintf+0x6a>
        putc(fd, c);
 768:	85ca                	mv	a1,s2
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	ee2080e7          	jalr	-286(ra) # 64e <putc>
 774:	a019                	j	77a <vprintf+0x60>
    } else if(state == '%'){
 776:	01498d63          	beq	s3,s4,790 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 77a:	0485                	addi	s1,s1,1
 77c:	fff4c903          	lbu	s2,-1(s1)
 780:	14090d63          	beqz	s2,8da <vprintf+0x1c0>
    if(state == 0){
 784:	fe0999e3          	bnez	s3,776 <vprintf+0x5c>
      if(c == '%'){
 788:	ff4910e3          	bne	s2,s4,768 <vprintf+0x4e>
        state = '%';
 78c:	89d2                	mv	s3,s4
 78e:	b7f5                	j	77a <vprintf+0x60>
      if(c == 'd'){
 790:	11490c63          	beq	s2,s4,8a8 <vprintf+0x18e>
 794:	f9d9079b          	addiw	a5,s2,-99
 798:	0ff7f793          	zext.b	a5,a5
 79c:	10fc6e63          	bltu	s8,a5,8b8 <vprintf+0x19e>
 7a0:	f9d9079b          	addiw	a5,s2,-99
 7a4:	0ff7f713          	zext.b	a4,a5
 7a8:	10ec6863          	bltu	s8,a4,8b8 <vprintf+0x19e>
 7ac:	00271793          	slli	a5,a4,0x2
 7b0:	97e6                	add	a5,a5,s9
 7b2:	439c                	lw	a5,0(a5)
 7b4:	97e6                	add	a5,a5,s9
 7b6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7b8:	008b0913          	addi	s2,s6,8
 7bc:	4685                	li	a3,1
 7be:	4629                	li	a2,10
 7c0:	000b2583          	lw	a1,0(s6)
 7c4:	8556                	mv	a0,s5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	eaa080e7          	jalr	-342(ra) # 670 <printint>
 7ce:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b765                	j	77a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d4:	008b0913          	addi	s2,s6,8
 7d8:	4681                	li	a3,0
 7da:	4629                	li	a2,10
 7dc:	000b2583          	lw	a1,0(s6)
 7e0:	8556                	mv	a0,s5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	e8e080e7          	jalr	-370(ra) # 670 <printint>
 7ea:	8b4a                	mv	s6,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b771                	j	77a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7f0:	008b0913          	addi	s2,s6,8
 7f4:	4681                	li	a3,0
 7f6:	866a                	mv	a2,s10
 7f8:	000b2583          	lw	a1,0(s6)
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	e72080e7          	jalr	-398(ra) # 670 <printint>
 806:	8b4a                	mv	s6,s2
      state = 0;
 808:	4981                	li	s3,0
 80a:	bf85                	j	77a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 80c:	008b0793          	addi	a5,s6,8
 810:	f8f43423          	sd	a5,-120(s0)
 814:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 818:	03000593          	li	a1,48
 81c:	8556                	mv	a0,s5
 81e:	00000097          	auipc	ra,0x0
 822:	e30080e7          	jalr	-464(ra) # 64e <putc>
  putc(fd, 'x');
 826:	07800593          	li	a1,120
 82a:	8556                	mv	a0,s5
 82c:	00000097          	auipc	ra,0x0
 830:	e22080e7          	jalr	-478(ra) # 64e <putc>
 834:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 836:	03c9d793          	srli	a5,s3,0x3c
 83a:	97de                	add	a5,a5,s7
 83c:	0007c583          	lbu	a1,0(a5)
 840:	8556                	mv	a0,s5
 842:	00000097          	auipc	ra,0x0
 846:	e0c080e7          	jalr	-500(ra) # 64e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 84a:	0992                	slli	s3,s3,0x4
 84c:	397d                	addiw	s2,s2,-1
 84e:	fe0914e3          	bnez	s2,836 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 852:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 856:	4981                	li	s3,0
 858:	b70d                	j	77a <vprintf+0x60>
        s = va_arg(ap, char*);
 85a:	008b0913          	addi	s2,s6,8
 85e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 862:	02098163          	beqz	s3,884 <vprintf+0x16a>
        while(*s != 0){
 866:	0009c583          	lbu	a1,0(s3)
 86a:	c5ad                	beqz	a1,8d4 <vprintf+0x1ba>
          putc(fd, *s);
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	de0080e7          	jalr	-544(ra) # 64e <putc>
          s++;
 876:	0985                	addi	s3,s3,1
        while(*s != 0){
 878:	0009c583          	lbu	a1,0(s3)
 87c:	f9e5                	bnez	a1,86c <vprintf+0x152>
        s = va_arg(ap, char*);
 87e:	8b4a                	mv	s6,s2
      state = 0;
 880:	4981                	li	s3,0
 882:	bde5                	j	77a <vprintf+0x60>
          s = "(null)";
 884:	00000997          	auipc	s3,0x0
 888:	33c98993          	addi	s3,s3,828 # bc0 <malloc+0x1e2>
        while(*s != 0){
 88c:	85ee                	mv	a1,s11
 88e:	bff9                	j	86c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 890:	008b0913          	addi	s2,s6,8
 894:	000b4583          	lbu	a1,0(s6)
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	db4080e7          	jalr	-588(ra) # 64e <putc>
 8a2:	8b4a                	mv	s6,s2
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	bdd1                	j	77a <vprintf+0x60>
        putc(fd, c);
 8a8:	85d2                	mv	a1,s4
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	da2080e7          	jalr	-606(ra) # 64e <putc>
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	b5d1                	j	77a <vprintf+0x60>
        putc(fd, '%');
 8b8:	85d2                	mv	a1,s4
 8ba:	8556                	mv	a0,s5
 8bc:	00000097          	auipc	ra,0x0
 8c0:	d92080e7          	jalr	-622(ra) # 64e <putc>
        putc(fd, c);
 8c4:	85ca                	mv	a1,s2
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	d86080e7          	jalr	-634(ra) # 64e <putc>
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	b565                	j	77a <vprintf+0x60>
        s = va_arg(ap, char*);
 8d4:	8b4a                	mv	s6,s2
      state = 0;
 8d6:	4981                	li	s3,0
 8d8:	b54d                	j	77a <vprintf+0x60>
    }
  }
}
 8da:	70e6                	ld	ra,120(sp)
 8dc:	7446                	ld	s0,112(sp)
 8de:	74a6                	ld	s1,104(sp)
 8e0:	7906                	ld	s2,96(sp)
 8e2:	69e6                	ld	s3,88(sp)
 8e4:	6a46                	ld	s4,80(sp)
 8e6:	6aa6                	ld	s5,72(sp)
 8e8:	6b06                	ld	s6,64(sp)
 8ea:	7be2                	ld	s7,56(sp)
 8ec:	7c42                	ld	s8,48(sp)
 8ee:	7ca2                	ld	s9,40(sp)
 8f0:	7d02                	ld	s10,32(sp)
 8f2:	6de2                	ld	s11,24(sp)
 8f4:	6109                	addi	sp,sp,128
 8f6:	8082                	ret

00000000000008f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f8:	715d                	addi	sp,sp,-80
 8fa:	ec06                	sd	ra,24(sp)
 8fc:	e822                	sd	s0,16(sp)
 8fe:	1000                	addi	s0,sp,32
 900:	e010                	sd	a2,0(s0)
 902:	e414                	sd	a3,8(s0)
 904:	e818                	sd	a4,16(s0)
 906:	ec1c                	sd	a5,24(s0)
 908:	03043023          	sd	a6,32(s0)
 90c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 910:	8622                	mv	a2,s0
 912:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 916:	00000097          	auipc	ra,0x0
 91a:	e04080e7          	jalr	-508(ra) # 71a <vprintf>
}
 91e:	60e2                	ld	ra,24(sp)
 920:	6442                	ld	s0,16(sp)
 922:	6161                	addi	sp,sp,80
 924:	8082                	ret

0000000000000926 <printf>:

void
printf(const char *fmt, ...)
{
 926:	711d                	addi	sp,sp,-96
 928:	ec06                	sd	ra,24(sp)
 92a:	e822                	sd	s0,16(sp)
 92c:	1000                	addi	s0,sp,32
 92e:	e40c                	sd	a1,8(s0)
 930:	e810                	sd	a2,16(s0)
 932:	ec14                	sd	a3,24(s0)
 934:	f018                	sd	a4,32(s0)
 936:	f41c                	sd	a5,40(s0)
 938:	03043823          	sd	a6,48(s0)
 93c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 940:	00840613          	addi	a2,s0,8
 944:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 948:	85aa                	mv	a1,a0
 94a:	4505                	li	a0,1
 94c:	00000097          	auipc	ra,0x0
 950:	dce080e7          	jalr	-562(ra) # 71a <vprintf>
}
 954:	60e2                	ld	ra,24(sp)
 956:	6442                	ld	s0,16(sp)
 958:	6125                	addi	sp,sp,96
 95a:	8082                	ret

000000000000095c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 95c:	1141                	addi	sp,sp,-16
 95e:	e422                	sd	s0,8(sp)
 960:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 962:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 966:	00000797          	auipc	a5,0x0
 96a:	2ea7b783          	ld	a5,746(a5) # c50 <freep>
 96e:	a02d                	j	998 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 970:	4618                	lw	a4,8(a2)
 972:	9f2d                	addw	a4,a4,a1
 974:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 978:	6398                	ld	a4,0(a5)
 97a:	6310                	ld	a2,0(a4)
 97c:	a83d                	j	9ba <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 97e:	ff852703          	lw	a4,-8(a0)
 982:	9f31                	addw	a4,a4,a2
 984:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 986:	ff053683          	ld	a3,-16(a0)
 98a:	a091                	j	9ce <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98c:	6398                	ld	a4,0(a5)
 98e:	00e7e463          	bltu	a5,a4,996 <free+0x3a>
 992:	00e6ea63          	bltu	a3,a4,9a6 <free+0x4a>
{
 996:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 998:	fed7fae3          	bgeu	a5,a3,98c <free+0x30>
 99c:	6398                	ld	a4,0(a5)
 99e:	00e6e463          	bltu	a3,a4,9a6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a2:	fee7eae3          	bltu	a5,a4,996 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9a6:	ff852583          	lw	a1,-8(a0)
 9aa:	6390                	ld	a2,0(a5)
 9ac:	02059813          	slli	a6,a1,0x20
 9b0:	01c85713          	srli	a4,a6,0x1c
 9b4:	9736                	add	a4,a4,a3
 9b6:	fae60de3          	beq	a2,a4,970 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9ba:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9be:	4790                	lw	a2,8(a5)
 9c0:	02061593          	slli	a1,a2,0x20
 9c4:	01c5d713          	srli	a4,a1,0x1c
 9c8:	973e                	add	a4,a4,a5
 9ca:	fae68ae3          	beq	a3,a4,97e <free+0x22>
    p->s.ptr = bp->s.ptr;
 9ce:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9d0:	00000717          	auipc	a4,0x0
 9d4:	28f73023          	sd	a5,640(a4) # c50 <freep>
}
 9d8:	6422                	ld	s0,8(sp)
 9da:	0141                	addi	sp,sp,16
 9dc:	8082                	ret

00000000000009de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9de:	7139                	addi	sp,sp,-64
 9e0:	fc06                	sd	ra,56(sp)
 9e2:	f822                	sd	s0,48(sp)
 9e4:	f426                	sd	s1,40(sp)
 9e6:	f04a                	sd	s2,32(sp)
 9e8:	ec4e                	sd	s3,24(sp)
 9ea:	e852                	sd	s4,16(sp)
 9ec:	e456                	sd	s5,8(sp)
 9ee:	e05a                	sd	s6,0(sp)
 9f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f2:	02051493          	slli	s1,a0,0x20
 9f6:	9081                	srli	s1,s1,0x20
 9f8:	04bd                	addi	s1,s1,15
 9fa:	8091                	srli	s1,s1,0x4
 9fc:	00148a1b          	addiw	s4,s1,1
 a00:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a02:	00000517          	auipc	a0,0x0
 a06:	24e53503          	ld	a0,590(a0) # c50 <freep>
 a0a:	c515                	beqz	a0,a36 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0e:	4798                	lw	a4,8(a5)
 a10:	04977163          	bgeu	a4,s1,a52 <malloc+0x74>
 a14:	89d2                	mv	s3,s4
 a16:	000a071b          	sext.w	a4,s4
 a1a:	6685                	lui	a3,0x1
 a1c:	00d77363          	bgeu	a4,a3,a22 <malloc+0x44>
 a20:	6985                	lui	s3,0x1
 a22:	00098b1b          	sext.w	s6,s3
  p = sbrk(nu * sizeof(Header));
 a26:	0049999b          	slliw	s3,s3,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a2a:	00000917          	auipc	s2,0x0
 a2e:	22690913          	addi	s2,s2,550 # c50 <freep>
  if(p == (char*)-1)
 a32:	5afd                	li	s5,-1
 a34:	a8a5                	j	aac <malloc+0xce>
    base.s.ptr = freep = prevp = &base;
 a36:	00000797          	auipc	a5,0x0
 a3a:	21a78793          	addi	a5,a5,538 # c50 <freep>
 a3e:	00000717          	auipc	a4,0x0
 a42:	21a70713          	addi	a4,a4,538 # c58 <base>
 a46:	e398                	sd	a4,0(a5)
 a48:	e798                	sd	a4,8(a5)
    base.s.size = 0;
 a4a:	0007a823          	sw	zero,16(a5)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4e:	87ba                	mv	a5,a4
 a50:	b7d1                	j	a14 <malloc+0x36>
      if(p->s.size == nunits)
 a52:	02e48c63          	beq	s1,a4,a8a <malloc+0xac>
        p->s.size -= nunits;
 a56:	4147073b          	subw	a4,a4,s4
 a5a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a5c:	02071693          	slli	a3,a4,0x20
 a60:	01c6d713          	srli	a4,a3,0x1c
 a64:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a66:	0147a423          	sw	s4,8(a5)
      freep = prevp;
 a6a:	00000717          	auipc	a4,0x0
 a6e:	1ea73323          	sd	a0,486(a4) # c50 <freep>
      return (void*)(p + 1);
 a72:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a76:	70e2                	ld	ra,56(sp)
 a78:	7442                	ld	s0,48(sp)
 a7a:	74a2                	ld	s1,40(sp)
 a7c:	7902                	ld	s2,32(sp)
 a7e:	69e2                	ld	s3,24(sp)
 a80:	6a42                	ld	s4,16(sp)
 a82:	6aa2                	ld	s5,8(sp)
 a84:	6b02                	ld	s6,0(sp)
 a86:	6121                	addi	sp,sp,64
 a88:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a8a:	6398                	ld	a4,0(a5)
 a8c:	e118                	sd	a4,0(a0)
 a8e:	bff1                	j	a6a <malloc+0x8c>
  hp->s.size = nu;
 a90:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a94:	0541                	addi	a0,a0,16
 a96:	00000097          	auipc	ra,0x0
 a9a:	ec6080e7          	jalr	-314(ra) # 95c <free>
  return freep;
 a9e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aa2:	d971                	beqz	a0,a76 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa6:	4798                	lw	a4,8(a5)
 aa8:	fa9775e3          	bgeu	a4,s1,a52 <malloc+0x74>
    if(p == freep)
 aac:	00093703          	ld	a4,0(s2)
 ab0:	853e                	mv	a0,a5
 ab2:	fef719e3          	bne	a4,a5,aa4 <malloc+0xc6>
  p = sbrk(nu * sizeof(Header));
 ab6:	854e                	mv	a0,s3
 ab8:	00000097          	auipc	ra,0x0
 abc:	a50080e7          	jalr	-1456(ra) # 508 <sbrk>
  if(p == (char*)-1)
 ac0:	fd5518e3          	bne	a0,s5,a90 <malloc+0xb2>
        return 0;
 ac4:	4501                	li	a0,0
 ac6:	bf45                	j	a76 <malloc+0x98>
