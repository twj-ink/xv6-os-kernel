
xv6-user/testcases/_test_proc_mlfq:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <write_mlfq_completion>:
#include "test.h"

#define ITERATIONS 1000000
#define LOOP 100

void write_mlfq_completion(int id, int init_prio, int final_prio) {
   0:	7115                	addi	sp,sp,-224
   2:	ed86                	sd	ra,216(sp)
   4:	e9a2                	sd	s0,208(sp)
   6:	1180                	addi	s0,sp,224
    char buffer[100]; 
    int pos = 0;
    
    const char prefix[] = "MLFQ Scheduler Process ";
   8:	00001797          	auipc	a5,0x1
   c:	da078793          	addi	a5,a5,-608 # da8 <malloc+0xee>
  10:	6398                	ld	a4,0(a5)
  12:	f6e43823          	sd	a4,-144(s0)
  16:	6794                	ld	a3,8(a5)
  18:	f6d43c23          	sd	a3,-136(s0)
  1c:	6b9c                	ld	a5,16(a5)
  1e:	f8f43023          	sd	a5,-128(s0)
    for (int i = 0; prefix[i] != '\0'; i++) {
  22:	0ff77713          	zext.b	a4,a4
  26:	c359                	beqz	a4,ac <write_mlfq_completion+0xac>
  28:	f8840813          	addi	a6,s0,-120
  2c:	f7140693          	addi	a3,s0,-143
  30:	87c2                	mv	a5,a6
  32:	4885                	li	a7,1
  34:	410888bb          	subw	a7,a7,a6
        buffer[pos++] = prefix[i];
  38:	00f8883b          	addw	a6,a7,a5
  3c:	00e78023          	sb	a4,0(a5)
    for (int i = 0; prefix[i] != '\0'; i++) {
  40:	0006c703          	lbu	a4,0(a3)
  44:	0785                	addi	a5,a5,1
  46:	0685                	addi	a3,a3,1
  48:	fb65                	bnez	a4,38 <write_mlfq_completion+0x38>
    }
    
    int temp = id;
    if (temp == 0) {
  4a:	c52d                	beqz	a0,b4 <write_mlfq_completion+0xb4>
        buffer[pos++] = '0';
    } else {
        char num_str[10];
        int num_pos = 0;
        while (temp > 0) {
  4c:	f2040693          	addi	a3,s0,-224
        int num_pos = 0;
  50:	4701                	li	a4,0
            num_str[num_pos++] = '0' + (temp % 10);
  52:	48a9                	li	a7,10
        while (temp > 0) {
  54:	4e25                	li	t3,9
  56:	04a05d63          	blez	a0,b0 <write_mlfq_completion+0xb0>
            num_str[num_pos++] = '0' + (temp % 10);
  5a:	833a                	mv	t1,a4
  5c:	2705                	addiw	a4,a4,1
  5e:	031567bb          	remw	a5,a0,a7
  62:	0307879b          	addiw	a5,a5,48
  66:	00f68023          	sb	a5,0(a3)
            temp /= 10;
  6a:	87aa                	mv	a5,a0
  6c:	0315453b          	divw	a0,a0,a7
        while (temp > 0) {
  70:	0685                	addi	a3,a3,1
  72:	fefe44e3          	blt	t3,a5,5a <write_mlfq_completion+0x5a>
        }
        for (int i = num_pos - 1; i >= 0; i--) {
  76:	0e034c63          	bltz	t1,16e <write_mlfq_completion+0x16e>
  7a:	f2040713          	addi	a4,s0,-224
  7e:	971a                	add	a4,a4,t1
  80:	f8840793          	addi	a5,s0,-120
  84:	97c2                	add	a5,a5,a6
  86:	f8940893          	addi	a7,s0,-119
  8a:	98c2                	add	a7,a7,a6
  8c:	02031693          	slli	a3,t1,0x20
  90:	9281                	srli	a3,a3,0x20
  92:	98b6                	add	a7,a7,a3
            buffer[pos++] = num_str[i];
  94:	00074683          	lbu	a3,0(a4)
  98:	00d78023          	sb	a3,0(a5)
        for (int i = num_pos - 1; i >= 0; i--) {
  9c:	177d                	addi	a4,a4,-1
  9e:	0785                	addi	a5,a5,1
  a0:	ff179ae3          	bne	a5,a7,94 <write_mlfq_completion+0x94>
  a4:	2805                	addiw	a6,a6,1
            buffer[pos++] = num_str[i];
  a6:	0068053b          	addw	a0,a6,t1
  aa:	a839                	j	c8 <write_mlfq_completion+0xc8>
    int pos = 0;
  ac:	4801                	li	a6,0
  ae:	bf71                	j	4a <write_mlfq_completion+0x4a>
        while (temp > 0) {
  b0:	8542                	mv	a0,a6
  b2:	a819                	j	c8 <write_mlfq_completion+0xc8>
        buffer[pos++] = '0';
  b4:	0018051b          	addiw	a0,a6,1
  b8:	ff080793          	addi	a5,a6,-16
  bc:	00878833          	add	a6,a5,s0
  c0:	03000793          	li	a5,48
  c4:	f8f80c23          	sb	a5,-104(a6)
        }
    }
    
    const char middle[] = " with initial priority ";
  c8:	00001797          	auipc	a5,0x1
  cc:	cf878793          	addi	a5,a5,-776 # dc0 <malloc+0x106>
  d0:	6398                	ld	a4,0(a5)
  d2:	f4e43c23          	sd	a4,-168(s0)
  d6:	6794                	ld	a3,8(a5)
  d8:	f6d43023          	sd	a3,-160(s0)
  dc:	6b9c                	ld	a5,16(a5)
  de:	f6f43423          	sd	a5,-152(s0)
    for (int i = 0; middle[i] != '\0'; i++) {
  e2:	0ff77713          	zext.b	a4,a4
  e6:	c315                	beqz	a4,10a <write_mlfq_completion+0x10a>
  e8:	0015079b          	addiw	a5,a0,1
  ec:	f5940693          	addi	a3,s0,-167
        buffer[pos++] = middle[i];
  f0:	f8840893          	addi	a7,s0,-120
  f4:	0007851b          	sext.w	a0,a5
  f8:	00f88833          	add	a6,a7,a5
  fc:	fee80fa3          	sb	a4,-1(a6)
    for (int i = 0; middle[i] != '\0'; i++) {
 100:	0006c703          	lbu	a4,0(a3)
 104:	0785                	addi	a5,a5,1
 106:	0685                	addi	a3,a3,1
 108:	f775                	bnez	a4,f4 <write_mlfq_completion+0xf4>
    }
    
    temp = init_prio;
    if (temp == 0) {
 10a:	c5b5                	beqz	a1,176 <write_mlfq_completion+0x176>
        buffer[pos++] = '0';
    } else {
        char num_str[10];
        int num_pos = 0;
        while (temp > 0) {
 10c:	f2040693          	addi	a3,s0,-224
        int num_pos = 0;
 110:	4701                	li	a4,0
            num_str[num_pos++] = '0' + (temp % 10);
 112:	4829                	li	a6,10
        while (temp > 0) {
 114:	4325                	li	t1,9
 116:	04b05e63          	blez	a1,172 <write_mlfq_completion+0x172>
            num_str[num_pos++] = '0' + (temp % 10);
 11a:	88ba                	mv	a7,a4
 11c:	2705                	addiw	a4,a4,1
 11e:	0305e7bb          	remw	a5,a1,a6
 122:	0307879b          	addiw	a5,a5,48
 126:	00f68023          	sb	a5,0(a3)
            temp /= 10;
 12a:	87ae                	mv	a5,a1
 12c:	0305c5bb          	divw	a1,a1,a6
        while (temp > 0) {
 130:	0685                	addi	a3,a3,1
 132:	fef344e3          	blt	t1,a5,11a <write_mlfq_completion+0x11a>
        }
        for (int i = num_pos - 1; i >= 0; i--) {
 136:	1008c063          	bltz	a7,236 <write_mlfq_completion+0x236>
 13a:	f2040713          	addi	a4,s0,-224
 13e:	9746                	add	a4,a4,a7
 140:	f8840793          	addi	a5,s0,-120
 144:	97aa                	add	a5,a5,a0
 146:	f8940593          	addi	a1,s0,-119
 14a:	95aa                	add	a1,a1,a0
 14c:	02089693          	slli	a3,a7,0x20
 150:	9281                	srli	a3,a3,0x20
 152:	95b6                	add	a1,a1,a3
            buffer[pos++] = num_str[i];
 154:	00074683          	lbu	a3,0(a4)
 158:	00d78023          	sb	a3,0(a5)
        for (int i = num_pos - 1; i >= 0; i--) {
 15c:	177d                	addi	a4,a4,-1
 15e:	0785                	addi	a5,a5,1
 160:	feb79ae3          	bne	a5,a1,154 <write_mlfq_completion+0x154>
 164:	0015081b          	addiw	a6,a0,1
            buffer[pos++] = num_str[i];
 168:	0118083b          	addw	a6,a6,a7
 16c:	a839                	j	18a <write_mlfq_completion+0x18a>
        for (int i = num_pos - 1; i >= 0; i--) {
 16e:	8542                	mv	a0,a6
 170:	bfa1                	j	c8 <write_mlfq_completion+0xc8>
        while (temp > 0) {
 172:	882a                	mv	a6,a0
 174:	a819                	j	18a <write_mlfq_completion+0x18a>
        buffer[pos++] = '0';
 176:	0015081b          	addiw	a6,a0,1
 17a:	ff050793          	addi	a5,a0,-16
 17e:	00878533          	add	a0,a5,s0
 182:	03000793          	li	a5,48
 186:	f8f50c23          	sb	a5,-104(a0)
        }
    }
    
    const char connector[] = " and final priority ";
 18a:	00001797          	auipc	a5,0x1
 18e:	c4e78793          	addi	a5,a5,-946 # dd8 <malloc+0x11e>
 192:	6398                	ld	a4,0(a5)
 194:	6794                	ld	a3,8(a5)
 196:	f4e43023          	sd	a4,-192(s0)
 19a:	f4d43423          	sd	a3,-184(s0)
 19e:	4b94                	lw	a3,16(a5)
 1a0:	f4d42823          	sw	a3,-176(s0)
 1a4:	0147c783          	lbu	a5,20(a5)
 1a8:	f4f40a23          	sb	a5,-172(s0)
    for (int i = 0; connector[i] != '\0'; i++) {
 1ac:	0ff77713          	zext.b	a4,a4
 1b0:	c315                	beqz	a4,1d4 <write_mlfq_completion+0x1d4>
 1b2:	0018079b          	addiw	a5,a6,1
 1b6:	f4140693          	addi	a3,s0,-191
        buffer[pos++] = connector[i];
 1ba:	f8840513          	addi	a0,s0,-120
 1be:	0007881b          	sext.w	a6,a5
 1c2:	00f505b3          	add	a1,a0,a5
 1c6:	fee58fa3          	sb	a4,-1(a1)
    for (int i = 0; connector[i] != '\0'; i++) {
 1ca:	0006c703          	lbu	a4,0(a3)
 1ce:	0785                	addi	a5,a5,1
 1d0:	0685                	addi	a3,a3,1
 1d2:	f775                	bnez	a4,1be <write_mlfq_completion+0x1be>
    }
    
    temp = final_prio;
    if (temp == 0) {
 1d4:	c62d                	beqz	a2,23e <write_mlfq_completion+0x23e>
        buffer[pos++] = '0';
    } else {
        char num_str[10];
        int num_pos = 0;
        while (temp > 0) {
 1d6:	f2040693          	addi	a3,s0,-224
        int num_pos = 0;
 1da:	4701                	li	a4,0
            num_str[num_pos++] = '0' + (temp % 10);
 1dc:	45a9                	li	a1,10
        while (temp > 0) {
 1de:	48a5                	li	a7,9
 1e0:	04c05d63          	blez	a2,23a <write_mlfq_completion+0x23a>
            num_str[num_pos++] = '0' + (temp % 10);
 1e4:	853a                	mv	a0,a4
 1e6:	2705                	addiw	a4,a4,1
 1e8:	02b667bb          	remw	a5,a2,a1
 1ec:	0307879b          	addiw	a5,a5,48
 1f0:	00f68023          	sb	a5,0(a3)
            temp /= 10;
 1f4:	87b2                	mv	a5,a2
 1f6:	02b6463b          	divw	a2,a2,a1
        while (temp > 0) {
 1fa:	0685                	addi	a3,a3,1
 1fc:	fef8c4e3          	blt	a7,a5,1e4 <write_mlfq_completion+0x1e4>
        }
        for (int i = num_pos - 1; i >= 0; i--) {
 200:	0a054263          	bltz	a0,2a4 <write_mlfq_completion+0x2a4>
 204:	f2040713          	addi	a4,s0,-224
 208:	972a                	add	a4,a4,a0
 20a:	f8840793          	addi	a5,s0,-120
 20e:	97c2                	add	a5,a5,a6
 210:	f8940613          	addi	a2,s0,-119
 214:	9642                	add	a2,a2,a6
 216:	02051693          	slli	a3,a0,0x20
 21a:	9281                	srli	a3,a3,0x20
 21c:	9636                	add	a2,a2,a3
            buffer[pos++] = num_str[i];
 21e:	00074683          	lbu	a3,0(a4)
 222:	00d78023          	sb	a3,0(a5)
        for (int i = num_pos - 1; i >= 0; i--) {
 226:	177d                	addi	a4,a4,-1
 228:	0785                	addi	a5,a5,1
 22a:	fec79ae3          	bne	a5,a2,21e <write_mlfq_completion+0x21e>
 22e:	0018061b          	addiw	a2,a6,1
            buffer[pos++] = num_str[i];
 232:	9e29                	addw	a2,a2,a0
 234:	a839                	j	252 <write_mlfq_completion+0x252>
        for (int i = num_pos - 1; i >= 0; i--) {
 236:	882a                	mv	a6,a0
 238:	bf89                	j	18a <write_mlfq_completion+0x18a>
        while (temp > 0) {
 23a:	8642                	mv	a2,a6
 23c:	a819                	j	252 <write_mlfq_completion+0x252>
        buffer[pos++] = '0';
 23e:	0018061b          	addiw	a2,a6,1
 242:	ff080793          	addi	a5,a6,-16
 246:	00878833          	add	a6,a5,s0
 24a:	03000793          	li	a5,48
 24e:	f8f80c23          	sb	a5,-104(a6)
        }
    }
    
    const char suffix[] = " completed\n";
 252:	00001797          	auipc	a5,0x1
 256:	b9e78793          	addi	a5,a5,-1122 # df0 <malloc+0x136>
 25a:	6398                	ld	a4,0(a5)
 25c:	f2e43823          	sd	a4,-208(s0)
 260:	479c                	lw	a5,8(a5)
 262:	f2f42c23          	sw	a5,-200(s0)
    for (int i = 0; suffix[i] != '\0'; i++) {
 266:	0ff77713          	zext.b	a4,a4
 26a:	c315                	beqz	a4,28e <write_mlfq_completion+0x28e>
 26c:	0016079b          	addiw	a5,a2,1
 270:	f3140693          	addi	a3,s0,-207
        buffer[pos++] = suffix[i];
 274:	f8840513          	addi	a0,s0,-120
 278:	0007861b          	sext.w	a2,a5
 27c:	00f505b3          	add	a1,a0,a5
 280:	fee58fa3          	sb	a4,-1(a1)
    for (int i = 0; suffix[i] != '\0'; i++) {
 284:	0006c703          	lbu	a4,0(a3)
 288:	0785                	addi	a5,a5,1
 28a:	0685                	addi	a3,a3,1
 28c:	f775                	bnez	a4,278 <write_mlfq_completion+0x278>
    }
    
    write(1, buffer, pos);
 28e:	f8840593          	addi	a1,s0,-120
 292:	4505                	li	a0,1
 294:	00000097          	auipc	ra,0x0
 298:	536080e7          	jalr	1334(ra) # 7ca <write>
}
 29c:	60ee                	ld	ra,216(sp)
 29e:	644e                	ld	s0,208(sp)
 2a0:	612d                	addi	sp,sp,224
 2a2:	8082                	ret
        for (int i = num_pos - 1; i >= 0; i--) {
 2a4:	8642                	mv	a2,a6
 2a6:	b775                	j	252 <write_mlfq_completion+0x252>

00000000000002a8 <cpu_intensive_task>:

void cpu_intensive_task(int id, int priority) {
 2a8:	7179                	addi	sp,sp,-48
 2aa:	f406                	sd	ra,40(sp)
 2ac:	f022                	sd	s0,32(sp)
 2ae:	ec26                	sd	s1,24(sp)
 2b0:	e84a                	sd	s2,16(sp)
 2b2:	1800                	addi	s0,sp,48
 2b4:	84aa                	mv	s1,a0
 2b6:	892e                	mv	s2,a1
    volatile long long count = 0;
 2b8:	fc043c23          	sd	zero,-40(s0)
 2bc:	3e800593          	li	a1,1000
    for(int loop = 0; loop < LOOP*10; loop++) {
        for(int i = 0; i < ITERATIONS; i++) {
 2c0:	000f4637          	lui	a2,0xf4
 2c4:	24060613          	addi	a2,a2,576 # f4240 <__global_pointer$+0xf2b87>
void cpu_intensive_task(int id, int priority) {
 2c8:	4781                	li	a5,0
            count += (long long)i * (long long) i;
 2ca:	fd843683          	ld	a3,-40(s0)
 2ce:	02f78733          	mul	a4,a5,a5
 2d2:	9736                	add	a4,a4,a3
 2d4:	fce43c23          	sd	a4,-40(s0)
        for(int i = 0; i < ITERATIONS; i++) {
 2d8:	0785                	addi	a5,a5,1
 2da:	fec798e3          	bne	a5,a2,2ca <cpu_intensive_task+0x22>
    for(int loop = 0; loop < LOOP*10; loop++) {
 2de:	35fd                	addiw	a1,a1,-1
 2e0:	f5e5                	bnez	a1,2c8 <cpu_intensive_task+0x20>
            if(i % (ITERATIONS/2) == 0) {
                // printf("CPU Process %d (prio %d): iteration %d\n", id, priority, i);
            }
        }
    }
    int final_prio = get_priority();
 2e2:	00000097          	auipc	ra,0x0
 2e6:	63c080e7          	jalr	1596(ra) # 91e <get_priority>
 2ea:	862a                	mv	a2,a0
    write_mlfq_completion(id, priority, final_prio);
 2ec:	85ca                	mv	a1,s2
 2ee:	8526                	mv	a0,s1
 2f0:	00000097          	auipc	ra,0x0
 2f4:	d10080e7          	jalr	-752(ra) # 0 <write_mlfq_completion>
}
 2f8:	70a2                	ld	ra,40(sp)
 2fa:	7402                	ld	s0,32(sp)
 2fc:	64e2                	ld	s1,24(sp)
 2fe:	6942                	ld	s2,16(sp)
 300:	6145                	addi	sp,sp,48
 302:	8082                	ret

0000000000000304 <io_intensive_task>:

void io_intensive_task(int id, int priority) {
 304:	7179                	addi	sp,sp,-48
 306:	f406                	sd	ra,40(sp)
 308:	f022                	sd	s0,32(sp)
 30a:	ec26                	sd	s1,24(sp)
 30c:	e84a                	sd	s2,16(sp)
 30e:	e44e                	sd	s3,8(sp)
 310:	1800                	addi	s0,sp,48
 312:	892a                	mv	s2,a0
 314:	89ae                	mv	s3,a1
 316:	44f9                	li	s1,30
    for(int i = 0; i < 30; i++) {
        // printf("IO Process %d (prio %d): iteration %d\n", id, priority, i);
        sleep(1);  // Simulate I/O operation
 318:	4505                	li	a0,1
 31a:	00000097          	auipc	ra,0x0
 31e:	516080e7          	jalr	1302(ra) # 830 <sleep>
    for(int i = 0; i < 30; i++) {
 322:	34fd                	addiw	s1,s1,-1
 324:	f8f5                	bnez	s1,318 <io_intensive_task+0x14>
    }
    int final_prio = get_priority();
 326:	00000097          	auipc	ra,0x0
 32a:	5f8080e7          	jalr	1528(ra) # 91e <get_priority>
 32e:	862a                	mv	a2,a0
    write_mlfq_completion(id, priority, final_prio);
 330:	85ce                	mv	a1,s3
 332:	854a                	mv	a0,s2
 334:	00000097          	auipc	ra,0x0
 338:	ccc080e7          	jalr	-820(ra) # 0 <write_mlfq_completion>
}
 33c:	70a2                	ld	ra,40(sp)
 33e:	7402                	ld	s0,32(sp)
 340:	64e2                	ld	s1,24(sp)
 342:	6942                	ld	s2,16(sp)
 344:	69a2                	ld	s3,8(sp)
 346:	6145                	addi	sp,sp,48
 348:	8082                	ret

000000000000034a <mixed_task>:

void mixed_task(int id, int priority) {
 34a:	7139                	addi	sp,sp,-64
 34c:	fc06                	sd	ra,56(sp)
 34e:	f822                	sd	s0,48(sp)
 350:	f426                	sd	s1,40(sp)
 352:	f04a                	sd	s2,32(sp)
 354:	ec4e                	sd	s3,24(sp)
 356:	e852                	sd	s4,16(sp)
 358:	0080                	addi	s0,sp,64
 35a:	89aa                	mv	s3,a0
 35c:	8a2e                	mv	s4,a1
    volatile long long count = 0;
 35e:	fc043423          	sd	zero,-56(s0)
 362:	4951                	li	s2,20
    for(int i = 0; i < 20; i++) {
        // Do some computation
        for(int j = 0; j < ITERATIONS/10; j++) {
 364:	64e1                	lui	s1,0x18
 366:	6a048493          	addi	s1,s1,1696 # 186a0 <__global_pointer$+0x16fe7>
void mixed_task(int id, int priority) {
 36a:	4781                	li	a5,0
            count += (long long)j * (long long) j;
 36c:	fc843683          	ld	a3,-56(s0)
 370:	02f78733          	mul	a4,a5,a5
 374:	9736                	add	a4,a4,a3
 376:	fce43423          	sd	a4,-56(s0)
        for(int j = 0; j < ITERATIONS/10; j++) {
 37a:	0785                	addi	a5,a5,1
 37c:	fe9798e3          	bne	a5,s1,36c <mixed_task+0x22>
        }
        // printf("Mixed Process %d (priority %d): iteration %d\n", id, priority, i);
        sleep(1);  // Some I/O
 380:	4505                	li	a0,1
 382:	00000097          	auipc	ra,0x0
 386:	4ae080e7          	jalr	1198(ra) # 830 <sleep>
    for(int i = 0; i < 20; i++) {
 38a:	397d                	addiw	s2,s2,-1
 38c:	fc091fe3          	bnez	s2,36a <mixed_task+0x20>
    }
    int final_prio = get_priority();
 390:	00000097          	auipc	ra,0x0
 394:	58e080e7          	jalr	1422(ra) # 91e <get_priority>
 398:	862a                	mv	a2,a0
    write_mlfq_completion(id, priority, final_prio);
 39a:	85d2                	mv	a1,s4
 39c:	854e                	mv	a0,s3
 39e:	00000097          	auipc	ra,0x0
 3a2:	c62080e7          	jalr	-926(ra) # 0 <write_mlfq_completion>
}
 3a6:	70e2                	ld	ra,56(sp)
 3a8:	7442                	ld	s0,48(sp)
 3aa:	74a2                	ld	s1,40(sp)
 3ac:	7902                	ld	s2,32(sp)
 3ae:	69e2                	ld	s3,24(sp)
 3b0:	6a42                	ld	s4,16(sp)
 3b2:	6121                	addi	sp,sp,64
 3b4:	8082                	ret

00000000000003b6 <main>:
* and the lowest priority CPU-bound (P1) should complete last.
* CPU-intensive process P1 & P3 will have an ending priority lower than initial, 
* while I/O-intensive process P4 will have an higher priority than the initial one.
*/

int main() {
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
    printf("Testing MLFQ Scheduler - Basic\n");
 3be:	00001517          	auipc	a0,0x1
 3c2:	a4250513          	addi	a0,a0,-1470 # e00 <malloc+0x146>
 3c6:	00001097          	auipc	ra,0x1
 3ca:	83c080e7          	jalr	-1988(ra) # c02 <printf>

    int pid1, pid2, pid3, pid4, pid5;
    
    // Low priority CPU-bound (may be demoted)
    if((pid1=fork())==0) {
 3ce:	00000097          	auipc	ra,0x0
 3d2:	3ce080e7          	jalr	974(ra) # 79c <fork>
 3d6:	e10d                	bnez	a0,3f8 <main+0x42>
        set_priority(10);   // Lowest priority (largest number)
 3d8:	4529                	li	a0,10
 3da:	00000097          	auipc	ra,0x0
 3de:	538080e7          	jalr	1336(ra) # 912 <set_priority>
        cpu_intensive_task(1, 10);
 3e2:	45a9                	li	a1,10
 3e4:	4505                	li	a0,1
 3e6:	00000097          	auipc	ra,0x0
 3ea:	ec2080e7          	jalr	-318(ra) # 2a8 <cpu_intensive_task>
        exit(0);
 3ee:	4501                	li	a0,0
 3f0:	00000097          	auipc	ra,0x0
 3f4:	3b4080e7          	jalr	948(ra) # 7a4 <exit>
    }
    
    // Highest priority I/O-bound (should stay in high queues)
    if((pid2=fork())==0) {
 3f8:	00000097          	auipc	ra,0x0
 3fc:	3a4080e7          	jalr	932(ra) # 79c <fork>
 400:	e10d                	bnez	a0,422 <main+0x6c>
        set_priority(1);    // Highest priority (smallest number)
 402:	4505                	li	a0,1
 404:	00000097          	auipc	ra,0x0
 408:	50e080e7          	jalr	1294(ra) # 912 <set_priority>
        io_intensive_task(2, 1);
 40c:	4585                	li	a1,1
 40e:	4509                	li	a0,2
 410:	00000097          	auipc	ra,0x0
 414:	ef4080e7          	jalr	-268(ra) # 304 <io_intensive_task>
        exit(0);
 418:	4501                	li	a0,0
 41a:	00000097          	auipc	ra,0x0
 41e:	38a080e7          	jalr	906(ra) # 7a4 <exit>
    }
    
    // High priority CPU-bound (initially high but may be demoted)
    if((pid3=fork())==0) {
 422:	00000097          	auipc	ra,0x0
 426:	37a080e7          	jalr	890(ra) # 79c <fork>
 42a:	e10d                	bnez	a0,44c <main+0x96>
        set_priority(2);    // High priority
 42c:	4509                	li	a0,2
 42e:	00000097          	auipc	ra,0x0
 432:	4e4080e7          	jalr	1252(ra) # 912 <set_priority>
        cpu_intensive_task(3, 2);
 436:	4589                	li	a1,2
 438:	450d                	li	a0,3
 43a:	00000097          	auipc	ra,0x0
 43e:	e6e080e7          	jalr	-402(ra) # 2a8 <cpu_intensive_task>
        exit(0);
 442:	4501                	li	a0,0
 444:	00000097          	auipc	ra,0x0
 448:	360080e7          	jalr	864(ra) # 7a4 <exit>
    }
    
    // Medium priority I/O-bound (initially low but may be promoted)
    if((pid4=fork())==0) {
 44c:	00000097          	auipc	ra,0x0
 450:	350080e7          	jalr	848(ra) # 79c <fork>
 454:	e10d                	bnez	a0,476 <main+0xc0>
        set_priority(5);    // Medium priority
 456:	4515                	li	a0,5
 458:	00000097          	auipc	ra,0x0
 45c:	4ba080e7          	jalr	1210(ra) # 912 <set_priority>
        io_intensive_task(4, 5);
 460:	4595                	li	a1,5
 462:	4511                	li	a0,4
 464:	00000097          	auipc	ra,0x0
 468:	ea0080e7          	jalr	-352(ra) # 304 <io_intensive_task>
        exit(0);
 46c:	4501                	li	a0,0
 46e:	00000097          	auipc	ra,0x0
 472:	336080e7          	jalr	822(ra) # 7a4 <exit>
    }
    
    // High priority mixed workload
    if((pid5=fork())==0) {
 476:	00000097          	auipc	ra,0x0
 47a:	326080e7          	jalr	806(ra) # 79c <fork>
 47e:	c539                	beqz	a0,4cc <main+0x116>
        mixed_task(5, 3);
        exit(0);
    }

    for (int i = 0; i < 5; i++) {
        wait(0);
 480:	4501                	li	a0,0
 482:	00000097          	auipc	ra,0x0
 486:	32c080e7          	jalr	812(ra) # 7ae <wait>
 48a:	4501                	li	a0,0
 48c:	00000097          	auipc	ra,0x0
 490:	322080e7          	jalr	802(ra) # 7ae <wait>
 494:	4501                	li	a0,0
 496:	00000097          	auipc	ra,0x0
 49a:	318080e7          	jalr	792(ra) # 7ae <wait>
 49e:	4501                	li	a0,0
 4a0:	00000097          	auipc	ra,0x0
 4a4:	30e080e7          	jalr	782(ra) # 7ae <wait>
 4a8:	4501                	li	a0,0
 4aa:	00000097          	auipc	ra,0x0
 4ae:	304080e7          	jalr	772(ra) # 7ae <wait>
    }

    printf("MLFQ with Priorities Test Completed\n");
 4b2:	00001517          	auipc	a0,0x1
 4b6:	96e50513          	addi	a0,a0,-1682 # e20 <malloc+0x166>
 4ba:	00000097          	auipc	ra,0x0
 4be:	748080e7          	jalr	1864(ra) # c02 <printf>
    exit(0);
 4c2:	4501                	li	a0,0
 4c4:	00000097          	auipc	ra,0x0
 4c8:	2e0080e7          	jalr	736(ra) # 7a4 <exit>
        set_priority(3);    // High priority
 4cc:	450d                	li	a0,3
 4ce:	00000097          	auipc	ra,0x0
 4d2:	444080e7          	jalr	1092(ra) # 912 <set_priority>
        mixed_task(5, 3);
 4d6:	458d                	li	a1,3
 4d8:	4515                	li	a0,5
 4da:	00000097          	auipc	ra,0x0
 4de:	e70080e7          	jalr	-400(ra) # 34a <mixed_task>
        exit(0);
 4e2:	4501                	li	a0,0
 4e4:	00000097          	auipc	ra,0x0
 4e8:	2c0080e7          	jalr	704(ra) # 7a4 <exit>

00000000000004ec <strcpy>:
#include "kernel/include/fcntl.h"
#include "xv6-user/user.h"

char*
strcpy(char *s, const char *t)
{
 4ec:	1141                	addi	sp,sp,-16
 4ee:	e422                	sd	s0,8(sp)
 4f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4f2:	87aa                	mv	a5,a0
 4f4:	0585                	addi	a1,a1,1
 4f6:	0785                	addi	a5,a5,1
 4f8:	fff5c703          	lbu	a4,-1(a1)
 4fc:	fee78fa3          	sb	a4,-1(a5)
 500:	fb75                	bnez	a4,4f4 <strcpy+0x8>
    ;
  return os;
}
 502:	6422                	ld	s0,8(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret

0000000000000508 <strcat>:

char*
strcat(char *s, const char *t)
{
 508:	1141                	addi	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	addi	s0,sp,16
  char *os = s;
  while(*s)
 50e:	00054783          	lbu	a5,0(a0)
 512:	c385                	beqz	a5,532 <strcat+0x2a>
 514:	87aa                	mv	a5,a0
    s++;
 516:	0785                	addi	a5,a5,1
  while(*s)
 518:	0007c703          	lbu	a4,0(a5)
 51c:	ff6d                	bnez	a4,516 <strcat+0xe>
  while((*s++ = *t++))
 51e:	0585                	addi	a1,a1,1
 520:	0785                	addi	a5,a5,1
 522:	fff5c703          	lbu	a4,-1(a1)
 526:	fee78fa3          	sb	a4,-1(a5)
 52a:	fb75                	bnez	a4,51e <strcat+0x16>
    ;
  return os;
}
 52c:	6422                	ld	s0,8(sp)
 52e:	0141                	addi	sp,sp,16
 530:	8082                	ret
  while(*s)
 532:	87aa                	mv	a5,a0
 534:	b7ed                	j	51e <strcat+0x16>

0000000000000536 <strcmp>:


int
strcmp(const char *p, const char *q)
{
 536:	1141                	addi	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 53c:	00054783          	lbu	a5,0(a0)
 540:	cb91                	beqz	a5,554 <strcmp+0x1e>
 542:	0005c703          	lbu	a4,0(a1)
 546:	00f71763          	bne	a4,a5,554 <strcmp+0x1e>
    p++, q++;
 54a:	0505                	addi	a0,a0,1
 54c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 54e:	00054783          	lbu	a5,0(a0)
 552:	fbe5                	bnez	a5,542 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 554:	0005c503          	lbu	a0,0(a1)
}
 558:	40a7853b          	subw	a0,a5,a0
 55c:	6422                	ld	s0,8(sp)
 55e:	0141                	addi	sp,sp,16
 560:	8082                	ret

0000000000000562 <strlen>:

uint
strlen(const char *s)
{
 562:	1141                	addi	sp,sp,-16
 564:	e422                	sd	s0,8(sp)
 566:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 568:	00054783          	lbu	a5,0(a0)
 56c:	cf91                	beqz	a5,588 <strlen+0x26>
 56e:	0505                	addi	a0,a0,1
 570:	87aa                	mv	a5,a0
 572:	4685                	li	a3,1
 574:	9e89                	subw	a3,a3,a0
 576:	00f6853b          	addw	a0,a3,a5
 57a:	0785                	addi	a5,a5,1
 57c:	fff7c703          	lbu	a4,-1(a5)
 580:	fb7d                	bnez	a4,576 <strlen+0x14>
    ;
  return n;
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret
  for(n = 0; s[n]; n++)
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <strlen+0x20>

000000000000058c <memset>:

void*
memset(void *dst, int c, uint n)
{
 58c:	1141                	addi	sp,sp,-16
 58e:	e422                	sd	s0,8(sp)
 590:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 592:	ca19                	beqz	a2,5a8 <memset+0x1c>
 594:	87aa                	mv	a5,a0
 596:	1602                	slli	a2,a2,0x20
 598:	9201                	srli	a2,a2,0x20
 59a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 59e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5a2:	0785                	addi	a5,a5,1
 5a4:	fee79de3          	bne	a5,a4,59e <memset+0x12>
  }
  return dst;
}
 5a8:	6422                	ld	s0,8(sp)
 5aa:	0141                	addi	sp,sp,16
 5ac:	8082                	ret

00000000000005ae <strchr>:

char*
strchr(const char *s, char c)
{
 5ae:	1141                	addi	sp,sp,-16
 5b0:	e422                	sd	s0,8(sp)
 5b2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5b4:	00054783          	lbu	a5,0(a0)
 5b8:	cb99                	beqz	a5,5ce <strchr+0x20>
    if(*s == c)
 5ba:	00f58763          	beq	a1,a5,5c8 <strchr+0x1a>
  for(; *s; s++)
 5be:	0505                	addi	a0,a0,1
 5c0:	00054783          	lbu	a5,0(a0)
 5c4:	fbfd                	bnez	a5,5ba <strchr+0xc>
      return (char*)s;
  return 0;
 5c6:	4501                	li	a0,0
}
 5c8:	6422                	ld	s0,8(sp)
 5ca:	0141                	addi	sp,sp,16
 5cc:	8082                	ret
  return 0;
 5ce:	4501                	li	a0,0
 5d0:	bfe5                	j	5c8 <strchr+0x1a>

00000000000005d2 <gets>:

char*
gets(char *buf, int max)
{
 5d2:	711d                	addi	sp,sp,-96
 5d4:	ec86                	sd	ra,88(sp)
 5d6:	e8a2                	sd	s0,80(sp)
 5d8:	e4a6                	sd	s1,72(sp)
 5da:	e0ca                	sd	s2,64(sp)
 5dc:	fc4e                	sd	s3,56(sp)
 5de:	f852                	sd	s4,48(sp)
 5e0:	f456                	sd	s5,40(sp)
 5e2:	f05a                	sd	s6,32(sp)
 5e4:	ec5e                	sd	s7,24(sp)
 5e6:	e862                	sd	s8,16(sp)
 5e8:	1080                	addi	s0,sp,96
 5ea:	8baa                	mv	s7,a0
 5ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5ee:	892a                	mv	s2,a0
 5f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 5f2:	faf40a93          	addi	s5,s0,-81
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5f6:	4b29                	li	s6,10
 5f8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 5fa:	89a6                	mv	s3,s1
 5fc:	2485                	addiw	s1,s1,1
 5fe:	0344d763          	bge	s1,s4,62c <gets+0x5a>
    cc = read(0, &c, 1);
 602:	4605                	li	a2,1
 604:	85d6                	mv	a1,s5
 606:	4501                	li	a0,0
 608:	00000097          	auipc	ra,0x0
 60c:	1b8080e7          	jalr	440(ra) # 7c0 <read>
    if(cc < 1)
 610:	00a05e63          	blez	a0,62c <gets+0x5a>
    buf[i++] = c;
 614:	faf44783          	lbu	a5,-81(s0)
 618:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 61c:	01678763          	beq	a5,s6,62a <gets+0x58>
 620:	0905                	addi	s2,s2,1
 622:	fd879ce3          	bne	a5,s8,5fa <gets+0x28>
  for(i=0; i+1 < max; ){
 626:	89a6                	mv	s3,s1
 628:	a011                	j	62c <gets+0x5a>
 62a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 62c:	99de                	add	s3,s3,s7
 62e:	00098023          	sb	zero,0(s3)
  return buf;
}
 632:	855e                	mv	a0,s7
 634:	60e6                	ld	ra,88(sp)
 636:	6446                	ld	s0,80(sp)
 638:	64a6                	ld	s1,72(sp)
 63a:	6906                	ld	s2,64(sp)
 63c:	79e2                	ld	s3,56(sp)
 63e:	7a42                	ld	s4,48(sp)
 640:	7aa2                	ld	s5,40(sp)
 642:	7b02                	ld	s6,32(sp)
 644:	6be2                	ld	s7,24(sp)
 646:	6c42                	ld	s8,16(sp)
 648:	6125                	addi	sp,sp,96
 64a:	8082                	ret

000000000000064c <stat>:

int
stat(const char *n, struct stat *st)
{
 64c:	1101                	addi	sp,sp,-32
 64e:	ec06                	sd	ra,24(sp)
 650:	e822                	sd	s0,16(sp)
 652:	e426                	sd	s1,8(sp)
 654:	e04a                	sd	s2,0(sp)
 656:	1000                	addi	s0,sp,32
 658:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 65a:	4581                	li	a1,0
 65c:	00000097          	auipc	ra,0x0
 660:	194080e7          	jalr	404(ra) # 7f0 <open>
  if(fd < 0)
 664:	02054563          	bltz	a0,68e <stat+0x42>
 668:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 66a:	85ca                	mv	a1,s2
 66c:	00000097          	auipc	ra,0x0
 670:	18e080e7          	jalr	398(ra) # 7fa <fstat>
 674:	892a                	mv	s2,a0
  close(fd);
 676:	8526                	mv	a0,s1
 678:	00000097          	auipc	ra,0x0
 67c:	15c080e7          	jalr	348(ra) # 7d4 <close>
  return r;
}
 680:	854a                	mv	a0,s2
 682:	60e2                	ld	ra,24(sp)
 684:	6442                	ld	s0,16(sp)
 686:	64a2                	ld	s1,8(sp)
 688:	6902                	ld	s2,0(sp)
 68a:	6105                	addi	sp,sp,32
 68c:	8082                	ret
    return -1;
 68e:	597d                	li	s2,-1
 690:	bfc5                	j	680 <stat+0x34>

0000000000000692 <atoi>:

int
atoi(const char *s)
{
 692:	1141                	addi	sp,sp,-16
 694:	e422                	sd	s0,8(sp)
 696:	0800                	addi	s0,sp,16
  int n;
  int neg = 1;
  if (*s == '-') {
 698:	00054703          	lbu	a4,0(a0)
 69c:	02d00793          	li	a5,45
  int neg = 1;
 6a0:	4585                	li	a1,1
  if (*s == '-') {
 6a2:	04f70363          	beq	a4,a5,6e8 <atoi+0x56>
    s++;
    neg = -1;
  }
  n = 0;
  while('0' <= *s && *s <= '9')
 6a6:	00054703          	lbu	a4,0(a0)
 6aa:	fd07079b          	addiw	a5,a4,-48
 6ae:	0ff7f793          	zext.b	a5,a5
 6b2:	46a5                	li	a3,9
 6b4:	02f6ed63          	bltu	a3,a5,6ee <atoi+0x5c>
  n = 0;
 6b8:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 6ba:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 6bc:	0505                	addi	a0,a0,1
 6be:	0026979b          	slliw	a5,a3,0x2
 6c2:	9fb5                	addw	a5,a5,a3
 6c4:	0017979b          	slliw	a5,a5,0x1
 6c8:	9fb9                	addw	a5,a5,a4
 6ca:	fd07869b          	addiw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 6ce:	00054703          	lbu	a4,0(a0)
 6d2:	fd07079b          	addiw	a5,a4,-48
 6d6:	0ff7f793          	zext.b	a5,a5
 6da:	fef671e3          	bgeu	a2,a5,6bc <atoi+0x2a>
  return n * neg;
}
 6de:	02d5853b          	mulw	a0,a1,a3
 6e2:	6422                	ld	s0,8(sp)
 6e4:	0141                	addi	sp,sp,16
 6e6:	8082                	ret
    s++;
 6e8:	0505                	addi	a0,a0,1
    neg = -1;
 6ea:	55fd                	li	a1,-1
 6ec:	bf6d                	j	6a6 <atoi+0x14>
  n = 0;
 6ee:	4681                	li	a3,0
 6f0:	b7fd                	j	6de <atoi+0x4c>

00000000000006f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6f2:	1141                	addi	sp,sp,-16
 6f4:	e422                	sd	s0,8(sp)
 6f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6f8:	02b57463          	bgeu	a0,a1,720 <memmove+0x2e>
    while(n-- > 0)
 6fc:	00c05f63          	blez	a2,71a <memmove+0x28>
 700:	1602                	slli	a2,a2,0x20
 702:	9201                	srli	a2,a2,0x20
 704:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 708:	872a                	mv	a4,a0
      *dst++ = *src++;
 70a:	0585                	addi	a1,a1,1
 70c:	0705                	addi	a4,a4,1
 70e:	fff5c683          	lbu	a3,-1(a1)
 712:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 716:	fee79ae3          	bne	a5,a4,70a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 71a:	6422                	ld	s0,8(sp)
 71c:	0141                	addi	sp,sp,16
 71e:	8082                	ret
    dst += n;
 720:	00c50733          	add	a4,a0,a2
    src += n;
 724:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 726:	fec05ae3          	blez	a2,71a <memmove+0x28>
 72a:	fff6079b          	addiw	a5,a2,-1
 72e:	1782                	slli	a5,a5,0x20
 730:	9381                	srli	a5,a5,0x20
 732:	fff7c793          	not	a5,a5
 736:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 738:	15fd                	addi	a1,a1,-1
 73a:	177d                	addi	a4,a4,-1
 73c:	0005c683          	lbu	a3,0(a1)
 740:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 744:	fee79ae3          	bne	a5,a4,738 <memmove+0x46>
 748:	bfc9                	j	71a <memmove+0x28>

000000000000074a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 74a:	1141                	addi	sp,sp,-16
 74c:	e422                	sd	s0,8(sp)
 74e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 750:	ca05                	beqz	a2,780 <memcmp+0x36>
 752:	fff6069b          	addiw	a3,a2,-1
 756:	1682                	slli	a3,a3,0x20
 758:	9281                	srli	a3,a3,0x20
 75a:	0685                	addi	a3,a3,1
 75c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 75e:	00054783          	lbu	a5,0(a0)
 762:	0005c703          	lbu	a4,0(a1)
 766:	00e79863          	bne	a5,a4,776 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 76a:	0505                	addi	a0,a0,1
    p2++;
 76c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 76e:	fed518e3          	bne	a0,a3,75e <memcmp+0x14>
  }
  return 0;
 772:	4501                	li	a0,0
 774:	a019                	j	77a <memcmp+0x30>
      return *p1 - *p2;
 776:	40e7853b          	subw	a0,a5,a4
}
 77a:	6422                	ld	s0,8(sp)
 77c:	0141                	addi	sp,sp,16
 77e:	8082                	ret
  return 0;
 780:	4501                	li	a0,0
 782:	bfe5                	j	77a <memcmp+0x30>

0000000000000784 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 784:	1141                	addi	sp,sp,-16
 786:	e406                	sd	ra,8(sp)
 788:	e022                	sd	s0,0(sp)
 78a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 78c:	00000097          	auipc	ra,0x0
 790:	f66080e7          	jalr	-154(ra) # 6f2 <memmove>
}
 794:	60a2                	ld	ra,8(sp)
 796:	6402                	ld	s0,0(sp)
 798:	0141                	addi	sp,sp,16
 79a:	8082                	ret

000000000000079c <fork>:
# generated by usys.pl - do not edit
#include "kernel/include/sysnum.h"
.global fork
fork:
 li a7, SYS_fork
 79c:	4885                	li	a7,1
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7a4:	05d00893          	li	a7,93
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <wait>:
.global wait
wait:
 li a7, SYS_wait
 7ae:	488d                	li	a7,3
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7b6:	03b00893          	li	a7,59
 ecall
 7ba:	00000073          	ecall
 ret
 7be:	8082                	ret

00000000000007c0 <read>:
.global read
read:
 li a7, SYS_read
 7c0:	03f00893          	li	a7,63
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <write>:
.global write
write:
 li a7, SYS_write
 7ca:	04000893          	li	a7,64
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <close>:
.global close
close:
 li a7, SYS_close
 7d4:	03900893          	li	a7,57
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <kill>:
.global kill
kill:
 li a7, SYS_kill
 7de:	4899                	li	a7,6
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7e6:	0dd00893          	li	a7,221
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <open>:
.global open
open:
 li a7, SYS_open
 7f0:	03700893          	li	a7,55
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7fa:	05000893          	li	a7,80
 ecall
 7fe:	00000073          	ecall
 ret
 802:	8082                	ret

0000000000000804 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 804:	489d                	li	a7,7
 ecall
 806:	00000073          	ecall
 ret
 80a:	8082                	ret

000000000000080c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 80c:	03100893          	li	a7,49
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <dup>:
.global dup
dup:
 li a7, SYS_dup
 816:	48dd                	li	a7,23
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 81e:	0ac00893          	li	a7,172
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 828:	48b1                	li	a7,12
 ecall
 82a:	00000073          	ecall
 ret
 82e:	8082                	ret

0000000000000830 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 830:	48b5                	li	a7,13
 ecall
 832:	00000073          	ecall
 ret
 836:	8082                	ret

0000000000000838 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 838:	48b9                	li	a7,14
 ecall
 83a:	00000073          	ecall
 ret
 83e:	8082                	ret

0000000000000840 <test_proc>:
.global test_proc
test_proc:
 li a7, SYS_test_proc
 840:	48d9                	li	a7,22
 ecall
 842:	00000073          	ecall
 ret
 846:	8082                	ret

0000000000000848 <dev>:
.global dev
dev:
 li a7, SYS_dev
 848:	48d5                	li	a7,21
 ecall
 84a:	00000073          	ecall
 ret
 84e:	8082                	ret

0000000000000850 <readdir>:
.global readdir
readdir:
 li a7, SYS_readdir
 850:	48ed                	li	a7,27
 ecall
 852:	00000073          	ecall
 ret
 856:	8082                	ret

0000000000000858 <getcwd>:
.global getcwd
getcwd:
 li a7, SYS_getcwd
 858:	48c5                	li	a7,17
 ecall
 85a:	00000073          	ecall
 ret
 85e:	8082                	ret

0000000000000860 <remove>:
.global remove
remove:
 li a7, SYS_remove
 860:	07500893          	li	a7,117
 ecall
 864:	00000073          	ecall
 ret
 868:	8082                	ret

000000000000086a <trace>:
.global trace
trace:
 li a7, SYS_trace
 86a:	48c9                	li	a7,18
 ecall
 86c:	00000073          	ecall
 ret
 870:	8082                	ret

0000000000000872 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 872:	48cd                	li	a7,19
 ecall
 874:	00000073          	ecall
 ret
 878:	8082                	ret

000000000000087a <rename>:
.global rename
rename:
 li a7, SYS_rename
 87a:	48e9                	li	a7,26
 ecall
 87c:	00000073          	ecall
 ret
 880:	8082                	ret

0000000000000882 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 882:	03000893          	li	a7,48
 ecall
 886:	00000073          	ecall
 ret
 88a:	8082                	ret

000000000000088c <times>:
.global times
times:
 li a7, SYS_times
 88c:	09900893          	li	a7,153
 ecall
 890:	00000073          	ecall
 ret
 894:	8082                	ret

0000000000000896 <uname>:
.global uname
uname:
 li a7, SYS_uname
 896:	0a000893          	li	a7,160
 ecall
 89a:	00000073          	ecall
 ret
 89e:	8082                	ret

00000000000008a0 <clone>:
.global clone
clone:
 li a7, SYS_clone
 8a0:	0dc00893          	li	a7,220
 ecall
 8a4:	00000073          	ecall
 ret
 8a8:	8082                	ret

00000000000008aa <wait4>:
.global wait4
wait4:
 li a7, SYS_wait4
 8aa:	10400893          	li	a7,260
 ecall
 8ae:	00000073          	ecall
 ret
 8b2:	8082                	ret

00000000000008b4 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 8b4:	07c00893          	li	a7,124
 ecall
 8b8:	00000073          	ecall
 ret
 8bc:	8082                	ret

00000000000008be <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 8be:	0ad00893          	li	a7,173
 ecall
 8c2:	00000073          	ecall
 ret
 8c6:	8082                	ret

00000000000008c8 <gettimeofday>:
.global gettimeofday
gettimeofday:
 li a7, SYS_gettimeofday
 8c8:	0a900893          	li	a7,169
 ecall
 8cc:	00000073          	ecall
 ret
 8d0:	8082                	ret

00000000000008d2 <nanosleep>:
.global nanosleep
nanosleep:
 li a7, SYS_nanosleep
 8d2:	06500893          	li	a7,101
 ecall
 8d6:	00000073          	ecall
 ret
 8da:	8082                	ret

00000000000008dc <brk>:
.global brk
brk:
 li a7, SYS_brk
 8dc:	0d600893          	li	a7,214
 ecall
 8e0:	00000073          	ecall
 ret
 8e4:	8082                	ret

00000000000008e6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 8e6:	0de00893          	li	a7,222
 ecall
 8ea:	00000073          	ecall
 ret
 8ee:	8082                	ret

00000000000008f0 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 8f0:	0d700893          	li	a7,215
 ecall
 8f4:	00000073          	ecall
 ret
 8f8:	8082                	ret

00000000000008fa <dup2>:
.global dup2
dup2:
 li a7, SYS_dup2
 8fa:	68b5                	lui	a7,0xd
 8fc:	4318889b          	addiw	a7,a7,1073 # d431 <__global_pointer$+0xbd78>
 ecall
 900:	00000073          	ecall
 ret
 904:	8082                	ret

0000000000000906 <set_timeslice>:
.global set_timeslice
set_timeslice:
 li a7, SYS_set_timeslice
 906:	68b5                	lui	a7,0xd
 908:	4328889b          	addiw	a7,a7,1074 # d432 <__global_pointer$+0xbd79>
 ecall
 90c:	00000073          	ecall
 ret
 910:	8082                	ret

0000000000000912 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 912:	68b5                	lui	a7,0xd
 914:	4338889b          	addiw	a7,a7,1075 # d433 <__global_pointer$+0xbd7a>
 ecall
 918:	00000073          	ecall
 ret
 91c:	8082                	ret

000000000000091e <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 91e:	68b5                	lui	a7,0xd
 920:	4348889b          	addiw	a7,a7,1076 # d434 <__global_pointer$+0xbd7b>
 ecall
 924:	00000073          	ecall
 ret
 928:	8082                	ret

000000000000092a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 92a:	1101                	addi	sp,sp,-32
 92c:	ec06                	sd	ra,24(sp)
 92e:	e822                	sd	s0,16(sp)
 930:	1000                	addi	s0,sp,32
 932:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 936:	4605                	li	a2,1
 938:	fef40593          	addi	a1,s0,-17
 93c:	00000097          	auipc	ra,0x0
 940:	e8e080e7          	jalr	-370(ra) # 7ca <write>
}
 944:	60e2                	ld	ra,24(sp)
 946:	6442                	ld	s0,16(sp)
 948:	6105                	addi	sp,sp,32
 94a:	8082                	ret

000000000000094c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 94c:	7139                	addi	sp,sp,-64
 94e:	fc06                	sd	ra,56(sp)
 950:	f822                	sd	s0,48(sp)
 952:	f426                	sd	s1,40(sp)
 954:	f04a                	sd	s2,32(sp)
 956:	ec4e                	sd	s3,24(sp)
 958:	0080                	addi	s0,sp,64
 95a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 95c:	c299                	beqz	a3,962 <printint+0x16>
 95e:	0805c863          	bltz	a1,9ee <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 962:	2581                	sext.w	a1,a1
  neg = 0;
 964:	4881                	li	a7,0
  }

  i = 0;
 966:	fc040993          	addi	s3,s0,-64
  neg = 0;
 96a:	86ce                	mv	a3,s3
  i = 0;
 96c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 96e:	2601                	sext.w	a2,a2
 970:	00000517          	auipc	a0,0x0
 974:	53850513          	addi	a0,a0,1336 # ea8 <digits>
 978:	883a                	mv	a6,a4
 97a:	2705                	addiw	a4,a4,1
 97c:	02c5f7bb          	remuw	a5,a1,a2
 980:	1782                	slli	a5,a5,0x20
 982:	9381                	srli	a5,a5,0x20
 984:	97aa                	add	a5,a5,a0
 986:	0007c783          	lbu	a5,0(a5)
 98a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 98e:	0005879b          	sext.w	a5,a1
 992:	02c5d5bb          	divuw	a1,a1,a2
 996:	0685                	addi	a3,a3,1
 998:	fec7f0e3          	bgeu	a5,a2,978 <printint+0x2c>
  if(neg)
 99c:	00088c63          	beqz	a7,9b4 <printint+0x68>
    buf[i++] = '-';
 9a0:	fd070793          	addi	a5,a4,-48
 9a4:	00878733          	add	a4,a5,s0
 9a8:	02d00793          	li	a5,45
 9ac:	fef70823          	sb	a5,-16(a4)
 9b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 9b4:	02e05663          	blez	a4,9e0 <printint+0x94>
 9b8:	fc040913          	addi	s2,s0,-64
 9bc:	993a                	add	s2,s2,a4
 9be:	19fd                	addi	s3,s3,-1
 9c0:	99ba                	add	s3,s3,a4
 9c2:	377d                	addiw	a4,a4,-1
 9c4:	1702                	slli	a4,a4,0x20
 9c6:	9301                	srli	a4,a4,0x20
 9c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 9cc:	fff94583          	lbu	a1,-1(s2)
 9d0:	8526                	mv	a0,s1
 9d2:	00000097          	auipc	ra,0x0
 9d6:	f58080e7          	jalr	-168(ra) # 92a <putc>
  while(--i >= 0)
 9da:	197d                	addi	s2,s2,-1
 9dc:	ff3918e3          	bne	s2,s3,9cc <printint+0x80>
}
 9e0:	70e2                	ld	ra,56(sp)
 9e2:	7442                	ld	s0,48(sp)
 9e4:	74a2                	ld	s1,40(sp)
 9e6:	7902                	ld	s2,32(sp)
 9e8:	69e2                	ld	s3,24(sp)
 9ea:	6121                	addi	sp,sp,64
 9ec:	8082                	ret
    x = -xx;
 9ee:	40b005bb          	negw	a1,a1
    neg = 1;
 9f2:	4885                	li	a7,1
    x = -xx;
 9f4:	bf8d                	j	966 <printint+0x1a>

00000000000009f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 9f6:	7119                	addi	sp,sp,-128
 9f8:	fc86                	sd	ra,120(sp)
 9fa:	f8a2                	sd	s0,112(sp)
 9fc:	f4a6                	sd	s1,104(sp)
 9fe:	f0ca                	sd	s2,96(sp)
 a00:	ecce                	sd	s3,88(sp)
 a02:	e8d2                	sd	s4,80(sp)
 a04:	e4d6                	sd	s5,72(sp)
 a06:	e0da                	sd	s6,64(sp)
 a08:	fc5e                	sd	s7,56(sp)
 a0a:	f862                	sd	s8,48(sp)
 a0c:	f466                	sd	s9,40(sp)
 a0e:	f06a                	sd	s10,32(sp)
 a10:	ec6e                	sd	s11,24(sp)
 a12:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 a14:	0005c903          	lbu	s2,0(a1)
 a18:	18090f63          	beqz	s2,bb6 <vprintf+0x1c0>
 a1c:	8aaa                	mv	s5,a0
 a1e:	8b32                	mv	s6,a2
 a20:	00158493          	addi	s1,a1,1
  state = 0;
 a24:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 a26:	02500a13          	li	s4,37
 a2a:	4c55                	li	s8,21
 a2c:	00000c97          	auipc	s9,0x0
 a30:	424c8c93          	addi	s9,s9,1060 # e50 <malloc+0x196>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a34:	02800d93          	li	s11,40
  putc(fd, 'x');
 a38:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a3a:	00000b97          	auipc	s7,0x0
 a3e:	46eb8b93          	addi	s7,s7,1134 # ea8 <digits>
 a42:	a839                	j	a60 <vprintf+0x6a>
        putc(fd, c);
 a44:	85ca                	mv	a1,s2
 a46:	8556                	mv	a0,s5
 a48:	00000097          	auipc	ra,0x0
 a4c:	ee2080e7          	jalr	-286(ra) # 92a <putc>
 a50:	a019                	j	a56 <vprintf+0x60>
    } else if(state == '%'){
 a52:	01498d63          	beq	s3,s4,a6c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 a56:	0485                	addi	s1,s1,1
 a58:	fff4c903          	lbu	s2,-1(s1)
 a5c:	14090d63          	beqz	s2,bb6 <vprintf+0x1c0>
    if(state == 0){
 a60:	fe0999e3          	bnez	s3,a52 <vprintf+0x5c>
      if(c == '%'){
 a64:	ff4910e3          	bne	s2,s4,a44 <vprintf+0x4e>
        state = '%';
 a68:	89d2                	mv	s3,s4
 a6a:	b7f5                	j	a56 <vprintf+0x60>
      if(c == 'd'){
 a6c:	11490c63          	beq	s2,s4,b84 <vprintf+0x18e>
 a70:	f9d9079b          	addiw	a5,s2,-99
 a74:	0ff7f793          	zext.b	a5,a5
 a78:	10fc6e63          	bltu	s8,a5,b94 <vprintf+0x19e>
 a7c:	f9d9079b          	addiw	a5,s2,-99
 a80:	0ff7f713          	zext.b	a4,a5
 a84:	10ec6863          	bltu	s8,a4,b94 <vprintf+0x19e>
 a88:	00271793          	slli	a5,a4,0x2
 a8c:	97e6                	add	a5,a5,s9
 a8e:	439c                	lw	a5,0(a5)
 a90:	97e6                	add	a5,a5,s9
 a92:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 a94:	008b0913          	addi	s2,s6,8
 a98:	4685                	li	a3,1
 a9a:	4629                	li	a2,10
 a9c:	000b2583          	lw	a1,0(s6)
 aa0:	8556                	mv	a0,s5
 aa2:	00000097          	auipc	ra,0x0
 aa6:	eaa080e7          	jalr	-342(ra) # 94c <printint>
 aaa:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 aac:	4981                	li	s3,0
 aae:	b765                	j	a56 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab0:	008b0913          	addi	s2,s6,8
 ab4:	4681                	li	a3,0
 ab6:	4629                	li	a2,10
 ab8:	000b2583          	lw	a1,0(s6)
 abc:	8556                	mv	a0,s5
 abe:	00000097          	auipc	ra,0x0
 ac2:	e8e080e7          	jalr	-370(ra) # 94c <printint>
 ac6:	8b4a                	mv	s6,s2
      state = 0;
 ac8:	4981                	li	s3,0
 aca:	b771                	j	a56 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 acc:	008b0913          	addi	s2,s6,8
 ad0:	4681                	li	a3,0
 ad2:	866a                	mv	a2,s10
 ad4:	000b2583          	lw	a1,0(s6)
 ad8:	8556                	mv	a0,s5
 ada:	00000097          	auipc	ra,0x0
 ade:	e72080e7          	jalr	-398(ra) # 94c <printint>
 ae2:	8b4a                	mv	s6,s2
      state = 0;
 ae4:	4981                	li	s3,0
 ae6:	bf85                	j	a56 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 ae8:	008b0793          	addi	a5,s6,8
 aec:	f8f43423          	sd	a5,-120(s0)
 af0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 af4:	03000593          	li	a1,48
 af8:	8556                	mv	a0,s5
 afa:	00000097          	auipc	ra,0x0
 afe:	e30080e7          	jalr	-464(ra) # 92a <putc>
  putc(fd, 'x');
 b02:	07800593          	li	a1,120
 b06:	8556                	mv	a0,s5
 b08:	00000097          	auipc	ra,0x0
 b0c:	e22080e7          	jalr	-478(ra) # 92a <putc>
 b10:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b12:	03c9d793          	srli	a5,s3,0x3c
 b16:	97de                	add	a5,a5,s7
 b18:	0007c583          	lbu	a1,0(a5)
 b1c:	8556                	mv	a0,s5
 b1e:	00000097          	auipc	ra,0x0
 b22:	e0c080e7          	jalr	-500(ra) # 92a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b26:	0992                	slli	s3,s3,0x4
 b28:	397d                	addiw	s2,s2,-1
 b2a:	fe0914e3          	bnez	s2,b12 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 b2e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 b32:	4981                	li	s3,0
 b34:	b70d                	j	a56 <vprintf+0x60>
        s = va_arg(ap, char*);
 b36:	008b0913          	addi	s2,s6,8
 b3a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 b3e:	02098163          	beqz	s3,b60 <vprintf+0x16a>
        while(*s != 0){
 b42:	0009c583          	lbu	a1,0(s3)
 b46:	c5ad                	beqz	a1,bb0 <vprintf+0x1ba>
          putc(fd, *s);
 b48:	8556                	mv	a0,s5
 b4a:	00000097          	auipc	ra,0x0
 b4e:	de0080e7          	jalr	-544(ra) # 92a <putc>
          s++;
 b52:	0985                	addi	s3,s3,1
        while(*s != 0){
 b54:	0009c583          	lbu	a1,0(s3)
 b58:	f9e5                	bnez	a1,b48 <vprintf+0x152>
        s = va_arg(ap, char*);
 b5a:	8b4a                	mv	s6,s2
      state = 0;
 b5c:	4981                	li	s3,0
 b5e:	bde5                	j	a56 <vprintf+0x60>
          s = "(null)";
 b60:	00000997          	auipc	s3,0x0
 b64:	2e898993          	addi	s3,s3,744 # e48 <malloc+0x18e>
        while(*s != 0){
 b68:	85ee                	mv	a1,s11
 b6a:	bff9                	j	b48 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 b6c:	008b0913          	addi	s2,s6,8
 b70:	000b4583          	lbu	a1,0(s6)
 b74:	8556                	mv	a0,s5
 b76:	00000097          	auipc	ra,0x0
 b7a:	db4080e7          	jalr	-588(ra) # 92a <putc>
 b7e:	8b4a                	mv	s6,s2
      state = 0;
 b80:	4981                	li	s3,0
 b82:	bdd1                	j	a56 <vprintf+0x60>
        putc(fd, c);
 b84:	85d2                	mv	a1,s4
 b86:	8556                	mv	a0,s5
 b88:	00000097          	auipc	ra,0x0
 b8c:	da2080e7          	jalr	-606(ra) # 92a <putc>
      state = 0;
 b90:	4981                	li	s3,0
 b92:	b5d1                	j	a56 <vprintf+0x60>
        putc(fd, '%');
 b94:	85d2                	mv	a1,s4
 b96:	8556                	mv	a0,s5
 b98:	00000097          	auipc	ra,0x0
 b9c:	d92080e7          	jalr	-622(ra) # 92a <putc>
        putc(fd, c);
 ba0:	85ca                	mv	a1,s2
 ba2:	8556                	mv	a0,s5
 ba4:	00000097          	auipc	ra,0x0
 ba8:	d86080e7          	jalr	-634(ra) # 92a <putc>
      state = 0;
 bac:	4981                	li	s3,0
 bae:	b565                	j	a56 <vprintf+0x60>
        s = va_arg(ap, char*);
 bb0:	8b4a                	mv	s6,s2
      state = 0;
 bb2:	4981                	li	s3,0
 bb4:	b54d                	j	a56 <vprintf+0x60>
    }
  }
}
 bb6:	70e6                	ld	ra,120(sp)
 bb8:	7446                	ld	s0,112(sp)
 bba:	74a6                	ld	s1,104(sp)
 bbc:	7906                	ld	s2,96(sp)
 bbe:	69e6                	ld	s3,88(sp)
 bc0:	6a46                	ld	s4,80(sp)
 bc2:	6aa6                	ld	s5,72(sp)
 bc4:	6b06                	ld	s6,64(sp)
 bc6:	7be2                	ld	s7,56(sp)
 bc8:	7c42                	ld	s8,48(sp)
 bca:	7ca2                	ld	s9,40(sp)
 bcc:	7d02                	ld	s10,32(sp)
 bce:	6de2                	ld	s11,24(sp)
 bd0:	6109                	addi	sp,sp,128
 bd2:	8082                	ret

0000000000000bd4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bd4:	715d                	addi	sp,sp,-80
 bd6:	ec06                	sd	ra,24(sp)
 bd8:	e822                	sd	s0,16(sp)
 bda:	1000                	addi	s0,sp,32
 bdc:	e010                	sd	a2,0(s0)
 bde:	e414                	sd	a3,8(s0)
 be0:	e818                	sd	a4,16(s0)
 be2:	ec1c                	sd	a5,24(s0)
 be4:	03043023          	sd	a6,32(s0)
 be8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 bec:	8622                	mv	a2,s0
 bee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bf2:	00000097          	auipc	ra,0x0
 bf6:	e04080e7          	jalr	-508(ra) # 9f6 <vprintf>
}
 bfa:	60e2                	ld	ra,24(sp)
 bfc:	6442                	ld	s0,16(sp)
 bfe:	6161                	addi	sp,sp,80
 c00:	8082                	ret

0000000000000c02 <printf>:

void
printf(const char *fmt, ...)
{
 c02:	711d                	addi	sp,sp,-96
 c04:	ec06                	sd	ra,24(sp)
 c06:	e822                	sd	s0,16(sp)
 c08:	1000                	addi	s0,sp,32
 c0a:	e40c                	sd	a1,8(s0)
 c0c:	e810                	sd	a2,16(s0)
 c0e:	ec14                	sd	a3,24(s0)
 c10:	f018                	sd	a4,32(s0)
 c12:	f41c                	sd	a5,40(s0)
 c14:	03043823          	sd	a6,48(s0)
 c18:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c1c:	00840613          	addi	a2,s0,8
 c20:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c24:	85aa                	mv	a1,a0
 c26:	4505                	li	a0,1
 c28:	00000097          	auipc	ra,0x0
 c2c:	dce080e7          	jalr	-562(ra) # 9f6 <vprintf>
}
 c30:	60e2                	ld	ra,24(sp)
 c32:	6442                	ld	s0,16(sp)
 c34:	6125                	addi	sp,sp,96
 c36:	8082                	ret

0000000000000c38 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c38:	1141                	addi	sp,sp,-16
 c3a:	e422                	sd	s0,8(sp)
 c3c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c3e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c42:	00000797          	auipc	a5,0x0
 c46:	27e7b783          	ld	a5,638(a5) # ec0 <freep>
 c4a:	a02d                	j	c74 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c4c:	4618                	lw	a4,8(a2)
 c4e:	9f2d                	addw	a4,a4,a1
 c50:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c54:	6398                	ld	a4,0(a5)
 c56:	6310                	ld	a2,0(a4)
 c58:	a83d                	j	c96 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c5a:	ff852703          	lw	a4,-8(a0)
 c5e:	9f31                	addw	a4,a4,a2
 c60:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c62:	ff053683          	ld	a3,-16(a0)
 c66:	a091                	j	caa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c68:	6398                	ld	a4,0(a5)
 c6a:	00e7e463          	bltu	a5,a4,c72 <free+0x3a>
 c6e:	00e6ea63          	bltu	a3,a4,c82 <free+0x4a>
{
 c72:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c74:	fed7fae3          	bgeu	a5,a3,c68 <free+0x30>
 c78:	6398                	ld	a4,0(a5)
 c7a:	00e6e463          	bltu	a3,a4,c82 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c7e:	fee7eae3          	bltu	a5,a4,c72 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c82:	ff852583          	lw	a1,-8(a0)
 c86:	6390                	ld	a2,0(a5)
 c88:	02059813          	slli	a6,a1,0x20
 c8c:	01c85713          	srli	a4,a6,0x1c
 c90:	9736                	add	a4,a4,a3
 c92:	fae60de3          	beq	a2,a4,c4c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c96:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c9a:	4790                	lw	a2,8(a5)
 c9c:	02061593          	slli	a1,a2,0x20
 ca0:	01c5d713          	srli	a4,a1,0x1c
 ca4:	973e                	add	a4,a4,a5
 ca6:	fae68ae3          	beq	a3,a4,c5a <free+0x22>
    p->s.ptr = bp->s.ptr;
 caa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 cac:	00000717          	auipc	a4,0x0
 cb0:	20f73a23          	sd	a5,532(a4) # ec0 <freep>
}
 cb4:	6422                	ld	s0,8(sp)
 cb6:	0141                	addi	sp,sp,16
 cb8:	8082                	ret

0000000000000cba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 cba:	7139                	addi	sp,sp,-64
 cbc:	fc06                	sd	ra,56(sp)
 cbe:	f822                	sd	s0,48(sp)
 cc0:	f426                	sd	s1,40(sp)
 cc2:	f04a                	sd	s2,32(sp)
 cc4:	ec4e                	sd	s3,24(sp)
 cc6:	e852                	sd	s4,16(sp)
 cc8:	e456                	sd	s5,8(sp)
 cca:	e05a                	sd	s6,0(sp)
 ccc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cce:	02051493          	slli	s1,a0,0x20
 cd2:	9081                	srli	s1,s1,0x20
 cd4:	04bd                	addi	s1,s1,15
 cd6:	8091                	srli	s1,s1,0x4
 cd8:	00148a1b          	addiw	s4,s1,1
 cdc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 cde:	00000517          	auipc	a0,0x0
 ce2:	1e253503          	ld	a0,482(a0) # ec0 <freep>
 ce6:	c515                	beqz	a0,d12 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cea:	4798                	lw	a4,8(a5)
 cec:	04977163          	bgeu	a4,s1,d2e <malloc+0x74>
 cf0:	89d2                	mv	s3,s4
 cf2:	000a071b          	sext.w	a4,s4
 cf6:	6685                	lui	a3,0x1
 cf8:	00d77363          	bgeu	a4,a3,cfe <malloc+0x44>
 cfc:	6985                	lui	s3,0x1
 cfe:	00098b1b          	sext.w	s6,s3
  p = sbrk(nu * sizeof(Header));
 d02:	0049999b          	slliw	s3,s3,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d06:	00000917          	auipc	s2,0x0
 d0a:	1ba90913          	addi	s2,s2,442 # ec0 <freep>
  if(p == (char*)-1)
 d0e:	5afd                	li	s5,-1
 d10:	a8a5                	j	d88 <malloc+0xce>
    base.s.ptr = freep = prevp = &base;
 d12:	00000797          	auipc	a5,0x0
 d16:	1ae78793          	addi	a5,a5,430 # ec0 <freep>
 d1a:	00000717          	auipc	a4,0x0
 d1e:	1ae70713          	addi	a4,a4,430 # ec8 <base>
 d22:	e398                	sd	a4,0(a5)
 d24:	e798                	sd	a4,8(a5)
    base.s.size = 0;
 d26:	0007a823          	sw	zero,16(a5)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d2a:	87ba                	mv	a5,a4
 d2c:	b7d1                	j	cf0 <malloc+0x36>
      if(p->s.size == nunits)
 d2e:	02e48c63          	beq	s1,a4,d66 <malloc+0xac>
        p->s.size -= nunits;
 d32:	4147073b          	subw	a4,a4,s4
 d36:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d38:	02071693          	slli	a3,a4,0x20
 d3c:	01c6d713          	srli	a4,a3,0x1c
 d40:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d42:	0147a423          	sw	s4,8(a5)
      freep = prevp;
 d46:	00000717          	auipc	a4,0x0
 d4a:	16a73d23          	sd	a0,378(a4) # ec0 <freep>
      return (void*)(p + 1);
 d4e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d52:	70e2                	ld	ra,56(sp)
 d54:	7442                	ld	s0,48(sp)
 d56:	74a2                	ld	s1,40(sp)
 d58:	7902                	ld	s2,32(sp)
 d5a:	69e2                	ld	s3,24(sp)
 d5c:	6a42                	ld	s4,16(sp)
 d5e:	6aa2                	ld	s5,8(sp)
 d60:	6b02                	ld	s6,0(sp)
 d62:	6121                	addi	sp,sp,64
 d64:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d66:	6398                	ld	a4,0(a5)
 d68:	e118                	sd	a4,0(a0)
 d6a:	bff1                	j	d46 <malloc+0x8c>
  hp->s.size = nu;
 d6c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d70:	0541                	addi	a0,a0,16
 d72:	00000097          	auipc	ra,0x0
 d76:	ec6080e7          	jalr	-314(ra) # c38 <free>
  return freep;
 d7a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d7e:	d971                	beqz	a0,d52 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d80:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d82:	4798                	lw	a4,8(a5)
 d84:	fa9775e3          	bgeu	a4,s1,d2e <malloc+0x74>
    if(p == freep)
 d88:	00093703          	ld	a4,0(s2)
 d8c:	853e                	mv	a0,a5
 d8e:	fef719e3          	bne	a4,a5,d80 <malloc+0xc6>
  p = sbrk(nu * sizeof(Header));
 d92:	854e                	mv	a0,s3
 d94:	00000097          	auipc	ra,0x0
 d98:	a94080e7          	jalr	-1388(ra) # 828 <sbrk>
  if(p == (char*)-1)
 d9c:	fd5518e3          	bne	a0,s5,d6c <malloc+0xb2>
        return 0;
 da0:	4501                	li	a0,0
 da2:	bf45                	j	d52 <malloc+0x98>
