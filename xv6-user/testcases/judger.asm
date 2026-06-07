
xv6-user/testcases/_judger:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simple_strcmp>:
    int finish_priority;
} priorities;

priorities mlfq_info[MAX_PROCESSES];

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

0000000000000040 <extract_id>:

int extract_id(const char* str, const int max_length) {
  40:	7139                	addi	sp,sp,-64
  42:	fc06                	sd	ra,56(sp)
  44:	f822                	sd	s0,48(sp)
  46:	f426                	sd	s1,40(sp)
  48:	f04a                	sd	s2,32(sp)
  4a:	ec4e                	sd	s3,24(sp)
  4c:	e852                	sd	s4,16(sp)
  4e:	e456                	sd	s5,8(sp)
  50:	e05a                	sd	s6,0(sp)
  52:	0080                	addi	s0,sp,64
  54:	8a2a                	mv	s4,a0
  56:	8aae                	mv	s5,a1
    const char* pattern = "Process ";
    int pattern_len = strlen(pattern);
  58:	00001517          	auipc	a0,0x1
  5c:	f2850513          	addi	a0,a0,-216 # f80 <malloc+0xf0>
  60:	00000097          	auipc	ra,0x0
  64:	664080e7          	jalr	1636(ra) # 6c4 <strlen>
    
    for (int i = 0; str[i] != '\0' && i < max_length; i++) {
  68:	000a4783          	lbu	a5,0(s4)
  6c:	cfb5                	beqz	a5,e8 <extract_id+0xa8>
  6e:	0005099b          	sext.w	s3,a0
  72:	07505d63          	blez	s5,ec <extract_id+0xac>
  76:	84d2                	mv	s1,s4
  78:	4901                	li	s2,0
        if (simple_strcmp(&str[i], pattern, pattern_len) == 0) {
  7a:	00001b17          	auipc	s6,0x1
  7e:	f06b0b13          	addi	s6,s6,-250 # f80 <malloc+0xf0>
  82:	864e                	mv	a2,s3
  84:	85da                	mv	a1,s6
  86:	8526                	mv	a0,s1
  88:	00000097          	auipc	ra,0x0
  8c:	f78080e7          	jalr	-136(ra) # 0 <simple_strcmp>
  90:	c911                	beqz	a0,a4 <extract_id+0x64>
    for (int i = 0; str[i] != '\0' && i < max_length; i++) {
  92:	2905                	addiw	s2,s2,1
  94:	0485                	addi	s1,s1,1
  96:	0004c783          	lbu	a5,0(s1)
  9a:	cbb9                	beqz	a5,f0 <extract_id+0xb0>
  9c:	ff2a93e3          	bne	s5,s2,82 <extract_id+0x42>
                id = id * 10 + (num_start[j] - '0');
            }
            return id;
        }
    }
    return -1;
  a0:	557d                	li	a0,-1
  a2:	a881                	j	f2 <extract_id+0xb2>
            const char* num_start = &str[i + pattern_len];
  a4:	012989bb          	addw	s3,s3,s2
            for (int j = 0; num_start[j] >= '0' && num_start[j] <= '9'; j++) {
  a8:	013a07b3          	add	a5,s4,s3
  ac:	0007c703          	lbu	a4,0(a5)
  b0:	fd07079b          	addiw	a5,a4,-48
  b4:	0ff7f793          	zext.b	a5,a5
  b8:	46a5                	li	a3,9
  ba:	02f6ec63          	bltu	a3,a5,f2 <extract_id+0xb2>
  be:	0985                	addi	s3,s3,1
  c0:	9a4e                	add	s4,s4,s3
                id = id * 10 + (num_start[j] - '0');
  c2:	0025179b          	slliw	a5,a0,0x2
  c6:	9fa9                	addw	a5,a5,a0
  c8:	0017979b          	slliw	a5,a5,0x1
  cc:	fd07071b          	addiw	a4,a4,-48
  d0:	00f7053b          	addw	a0,a4,a5
            for (int j = 0; num_start[j] >= '0' && num_start[j] <= '9'; j++) {
  d4:	000a4703          	lbu	a4,0(s4)
  d8:	0a05                	addi	s4,s4,1
  da:	fd07079b          	addiw	a5,a4,-48
  de:	0ff7f793          	zext.b	a5,a5
  e2:	fef6f0e3          	bgeu	a3,a5,c2 <extract_id+0x82>
  e6:	a031                	j	f2 <extract_id+0xb2>
    return -1;
  e8:	557d                	li	a0,-1
  ea:	a021                	j	f2 <extract_id+0xb2>
  ec:	557d                	li	a0,-1
  ee:	a011                	j	f2 <extract_id+0xb2>
  f0:	557d                	li	a0,-1
}
  f2:	70e2                	ld	ra,56(sp)
  f4:	7442                	ld	s0,48(sp)
  f6:	74a2                	ld	s1,40(sp)
  f8:	7902                	ld	s2,32(sp)
  fa:	69e2                	ld	s3,24(sp)
  fc:	6a42                	ld	s4,16(sp)
  fe:	6aa2                	ld	s5,8(sp)
 100:	6b02                	ld	s6,0(sp)
 102:	6121                	addi	sp,sp,64
 104:	8082                	ret

0000000000000106 <extract_origin_priority>:

int extract_origin_priority(const char* str, const int max_length) {
 106:	7139                	addi	sp,sp,-64
 108:	fc06                	sd	ra,56(sp)
 10a:	f822                	sd	s0,48(sp)
 10c:	f426                	sd	s1,40(sp)
 10e:	f04a                	sd	s2,32(sp)
 110:	ec4e                	sd	s3,24(sp)
 112:	e852                	sd	s4,16(sp)
 114:	e456                	sd	s5,8(sp)
 116:	e05a                	sd	s6,0(sp)
 118:	0080                	addi	s0,sp,64
 11a:	8a2a                	mv	s4,a0
 11c:	8aae                	mv	s5,a1
    const char* pattern = "initial priority ";
    int pattern_len = strlen(pattern);
 11e:	00001517          	auipc	a0,0x1
 122:	e7250513          	addi	a0,a0,-398 # f90 <malloc+0x100>
 126:	00000097          	auipc	ra,0x0
 12a:	59e080e7          	jalr	1438(ra) # 6c4 <strlen>
    
    for (int i = 0; str[i] != '\0' && i < max_length; i++) {
 12e:	000a4783          	lbu	a5,0(s4)
 132:	cfb5                	beqz	a5,1ae <extract_origin_priority+0xa8>
 134:	0005099b          	sext.w	s3,a0
 138:	07505d63          	blez	s5,1b2 <extract_origin_priority+0xac>
 13c:	84d2                	mv	s1,s4
 13e:	4901                	li	s2,0
        if (simple_strcmp(&str[i], pattern, pattern_len) == 0) {
 140:	00001b17          	auipc	s6,0x1
 144:	e50b0b13          	addi	s6,s6,-432 # f90 <malloc+0x100>
 148:	864e                	mv	a2,s3
 14a:	85da                	mv	a1,s6
 14c:	8526                	mv	a0,s1
 14e:	00000097          	auipc	ra,0x0
 152:	eb2080e7          	jalr	-334(ra) # 0 <simple_strcmp>
 156:	c911                	beqz	a0,16a <extract_origin_priority+0x64>
    for (int i = 0; str[i] != '\0' && i < max_length; i++) {
 158:	2905                	addiw	s2,s2,1
 15a:	0485                	addi	s1,s1,1
 15c:	0004c783          	lbu	a5,0(s1)
 160:	cbb9                	beqz	a5,1b6 <extract_origin_priority+0xb0>
 162:	ff2a93e3          	bne	s5,s2,148 <extract_origin_priority+0x42>
                id = id * 10 + (num_start[j] - '0');
            }
            return id;
        }
    }
    return -1;
 166:	557d                	li	a0,-1
 168:	a881                	j	1b8 <extract_origin_priority+0xb2>
            const char* num_start = &str[i + pattern_len];
 16a:	012989bb          	addw	s3,s3,s2
            for (int j = 0; num_start[j] >= '0' && num_start[j] <= '9'; j++) {
 16e:	013a07b3          	add	a5,s4,s3
 172:	0007c703          	lbu	a4,0(a5)
 176:	fd07079b          	addiw	a5,a4,-48
 17a:	0ff7f793          	zext.b	a5,a5
 17e:	46a5                	li	a3,9
 180:	02f6ec63          	bltu	a3,a5,1b8 <extract_origin_priority+0xb2>
 184:	0985                	addi	s3,s3,1
 186:	9a4e                	add	s4,s4,s3
                id = id * 10 + (num_start[j] - '0');
 188:	0025179b          	slliw	a5,a0,0x2
 18c:	9fa9                	addw	a5,a5,a0
 18e:	0017979b          	slliw	a5,a5,0x1
 192:	fd07071b          	addiw	a4,a4,-48
 196:	00f7053b          	addw	a0,a4,a5
            for (int j = 0; num_start[j] >= '0' && num_start[j] <= '9'; j++) {
 19a:	000a4703          	lbu	a4,0(s4)
 19e:	0a05                	addi	s4,s4,1
 1a0:	fd07079b          	addiw	a5,a4,-48
 1a4:	0ff7f793          	zext.b	a5,a5
 1a8:	fef6f0e3          	bgeu	a3,a5,188 <extract_origin_priority+0x82>
 1ac:	a031                	j	1b8 <extract_origin_priority+0xb2>
    return -1;
 1ae:	557d                	li	a0,-1
 1b0:	a021                	j	1b8 <extract_origin_priority+0xb2>
 1b2:	557d                	li	a0,-1
 1b4:	a011                	j	1b8 <extract_origin_priority+0xb2>
 1b6:	557d                	li	a0,-1
}
 1b8:	70e2                	ld	ra,56(sp)
 1ba:	7442                	ld	s0,48(sp)
 1bc:	74a2                	ld	s1,40(sp)
 1be:	7902                	ld	s2,32(sp)
 1c0:	69e2                	ld	s3,24(sp)
 1c2:	6a42                	ld	s4,16(sp)
 1c4:	6aa2                	ld	s5,8(sp)
 1c6:	6b02                	ld	s6,0(sp)
 1c8:	6121                	addi	sp,sp,64
 1ca:	8082                	ret

00000000000001cc <extract_final_priority>:

int extract_final_priority(const char* str, const int max_length) {
 1cc:	7139                	addi	sp,sp,-64
 1ce:	fc06                	sd	ra,56(sp)
 1d0:	f822                	sd	s0,48(sp)
 1d2:	f426                	sd	s1,40(sp)
 1d4:	f04a                	sd	s2,32(sp)
 1d6:	ec4e                	sd	s3,24(sp)
 1d8:	e852                	sd	s4,16(sp)
 1da:	e456                	sd	s5,8(sp)
 1dc:	e05a                	sd	s6,0(sp)
 1de:	0080                	addi	s0,sp,64
 1e0:	8a2a                	mv	s4,a0
 1e2:	8aae                	mv	s5,a1
    const char* pattern = "final priority ";
    int pattern_len = strlen(pattern);
 1e4:	00001517          	auipc	a0,0x1
 1e8:	dc450513          	addi	a0,a0,-572 # fa8 <malloc+0x118>
 1ec:	00000097          	auipc	ra,0x0
 1f0:	4d8080e7          	jalr	1240(ra) # 6c4 <strlen>
    
    for (int i = 0; str[i] != '\0' && i < max_length; i++) {
 1f4:	000a4783          	lbu	a5,0(s4)
 1f8:	cfb5                	beqz	a5,274 <extract_final_priority+0xa8>
 1fa:	0005099b          	sext.w	s3,a0
 1fe:	07505d63          	blez	s5,278 <extract_final_priority+0xac>
 202:	84d2                	mv	s1,s4
 204:	4901                	li	s2,0
        if (simple_strcmp(&str[i], pattern, pattern_len) == 0) {
 206:	00001b17          	auipc	s6,0x1
 20a:	da2b0b13          	addi	s6,s6,-606 # fa8 <malloc+0x118>
 20e:	864e                	mv	a2,s3
 210:	85da                	mv	a1,s6
 212:	8526                	mv	a0,s1
 214:	00000097          	auipc	ra,0x0
 218:	dec080e7          	jalr	-532(ra) # 0 <simple_strcmp>
 21c:	c911                	beqz	a0,230 <extract_final_priority+0x64>
    for (int i = 0; str[i] != '\0' && i < max_length; i++) {
 21e:	2905                	addiw	s2,s2,1
 220:	0485                	addi	s1,s1,1
 222:	0004c783          	lbu	a5,0(s1)
 226:	cbb9                	beqz	a5,27c <extract_final_priority+0xb0>
 228:	ff2a93e3          	bne	s5,s2,20e <extract_final_priority+0x42>
                id = id * 10 + (num_start[j] - '0');
            }
            return id;
        }
    }
    return -1;
 22c:	557d                	li	a0,-1
 22e:	a881                	j	27e <extract_final_priority+0xb2>
            const char* num_start = &str[i + pattern_len];
 230:	012989bb          	addw	s3,s3,s2
            for (int j = 0; num_start[j] >= '0' && num_start[j] <= '9'; j++) {
 234:	013a07b3          	add	a5,s4,s3
 238:	0007c703          	lbu	a4,0(a5)
 23c:	fd07079b          	addiw	a5,a4,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	46a5                	li	a3,9
 246:	02f6ec63          	bltu	a3,a5,27e <extract_final_priority+0xb2>
 24a:	0985                	addi	s3,s3,1
 24c:	9a4e                	add	s4,s4,s3
                id = id * 10 + (num_start[j] - '0');
 24e:	0025179b          	slliw	a5,a0,0x2
 252:	9fa9                	addw	a5,a5,a0
 254:	0017979b          	slliw	a5,a5,0x1
 258:	fd07071b          	addiw	a4,a4,-48
 25c:	00f7053b          	addw	a0,a4,a5
            for (int j = 0; num_start[j] >= '0' && num_start[j] <= '9'; j++) {
 260:	000a4703          	lbu	a4,0(s4)
 264:	0a05                	addi	s4,s4,1
 266:	fd07079b          	addiw	a5,a4,-48
 26a:	0ff7f793          	zext.b	a5,a5
 26e:	fef6f0e3          	bgeu	a3,a5,24e <extract_final_priority+0x82>
 272:	a031                	j	27e <extract_final_priority+0xb2>
    return -1;
 274:	557d                	li	a0,-1
 276:	a021                	j	27e <extract_final_priority+0xb2>
 278:	557d                	li	a0,-1
 27a:	a011                	j	27e <extract_final_priority+0xb2>
 27c:	557d                	li	a0,-1
}
 27e:	70e2                	ld	ra,56(sp)
 280:	7442                	ld	s0,48(sp)
 282:	74a2                	ld	s1,40(sp)
 284:	7902                	ld	s2,32(sp)
 286:	69e2                	ld	s3,24(sp)
 288:	6a42                	ld	s4,16(sp)
 28a:	6aa2                	ld	s5,8(sp)
 28c:	6b02                	ld	s6,0(sp)
 28e:	6121                	addi	sp,sp,64
 290:	8082                	ret

0000000000000292 <check_completion_order>:

int check_completion_order(const char* prefix, const char* output, const int* expected_order, int order_length) {
 292:	7135                	addi	sp,sp,-160
 294:	ed06                	sd	ra,152(sp)
 296:	e922                	sd	s0,144(sp)
 298:	e526                	sd	s1,136(sp)
 29a:	e14a                	sd	s2,128(sp)
 29c:	fcce                	sd	s3,120(sp)
 29e:	f8d2                	sd	s4,112(sp)
 2a0:	f4d6                	sd	s5,104(sp)
 2a2:	f0da                	sd	s6,96(sp)
 2a4:	ecde                	sd	s7,88(sp)
 2a6:	e8e2                	sd	s8,80(sp)
 2a8:	e4e6                	sd	s9,72(sp)
 2aa:	e0ea                	sd	s10,64(sp)
 2ac:	fc6e                	sd	s11,56(sp)
 2ae:	1100                	addi	s0,sp,160
 2b0:	8b2a                	mv	s6,a0
 2b2:	892e                	mv	s2,a1
 2b4:	f6c43423          	sd	a2,-152(s0)
 2b8:	8a36                	mv	s4,a3
    int ids[MAX_PROCESSES];
    int count = 0;
    const char* pattern = prefix;
    int prefix_len = strlen(prefix);
 2ba:	00000097          	auipc	ra,0x0
 2be:	40a080e7          	jalr	1034(ra) # 6c4 <strlen>
    
    for (int i = 0; output[i] != '\0'; i++) {
 2c2:	00094783          	lbu	a5,0(s2)
 2c6:	c3f1                	beqz	a5,38a <check_completion_order+0xf8>
 2c8:	00050a9b          	sext.w	s5,a0
    int count = 0;
 2cc:	4b81                	li	s7,0
        if (simple_strcmp(&output[i], pattern, prefix_len) == 0) {
            const char* completed_ptr = &output[i];
            while (*completed_ptr != '\0') {
                if (simple_strcmp(completed_ptr, "completed", strlen("completed")) == 0) {
 2ce:	00001997          	auipc	s3,0x1
 2d2:	cea98993          	addi	s3,s3,-790 # fb8 <malloc+0x128>
                    int initial_prio = extract_origin_priority(&output[i], len);
                    int final_prio = extract_final_priority(&output[i], len);
                    if (id >= 0 && count <= MAX_PROCESSES) {
                        ids[count] = id;
                    }
                    if (initial_prio != -1 && final_prio != -1) {
 2d6:	5d7d                	li	s10,-1
                    if (id >= 0 && count <= MAX_PROCESSES) {
 2d8:	4d95                	li	s11,5
 2da:	a88d                	j	34c <check_completion_order+0xba>
                    int len = completed_ptr - &output[i];
 2dc:	412484bb          	subw	s1,s1,s2
                    int id = extract_id(&output[i], len);
 2e0:	85a6                	mv	a1,s1
 2e2:	854a                	mv	a0,s2
 2e4:	00000097          	auipc	ra,0x0
 2e8:	d5c080e7          	jalr	-676(ra) # 40 <extract_id>
 2ec:	8c2a                	mv	s8,a0
                    int initial_prio = extract_origin_priority(&output[i], len);
 2ee:	85a6                	mv	a1,s1
 2f0:	854a                	mv	a0,s2
 2f2:	00000097          	auipc	ra,0x0
 2f6:	e14080e7          	jalr	-492(ra) # 106 <extract_origin_priority>
 2fa:	8caa                	mv	s9,a0
                    int final_prio = extract_final_priority(&output[i], len);
 2fc:	85a6                	mv	a1,s1
 2fe:	854a                	mv	a0,s2
 300:	00000097          	auipc	ra,0x0
 304:	ecc080e7          	jalr	-308(ra) # 1cc <extract_final_priority>
                    if (id >= 0 && count <= MAX_PROCESSES) {
 308:	000c4b63          	bltz	s8,31e <check_completion_order+0x8c>
 30c:	017dc963          	blt	s11,s7,31e <check_completion_order+0x8c>
                        ids[count] = id;
 310:	002b9793          	slli	a5,s7,0x2
 314:	f9078793          	addi	a5,a5,-112
 318:	97a2                	add	a5,a5,s0
 31a:	ff87a423          	sw	s8,-24(a5)
                    if (initial_prio != -1 && final_prio != -1) {
 31e:	03ac8263          	beq	s9,s10,342 <check_completion_order+0xb0>
 322:	03a50063          	beq	a0,s10,342 <check_completion_order+0xb0>
                        mlfq_info[count].id = id;
 326:	001b9793          	slli	a5,s7,0x1
 32a:	97de                	add	a5,a5,s7
 32c:	078a                	slli	a5,a5,0x2
 32e:	00001717          	auipc	a4,0x1
 332:	03a70713          	addi	a4,a4,58 # 1368 <mlfq_info>
 336:	97ba                	add	a5,a5,a4
 338:	0187a023          	sw	s8,0(a5)
                        mlfq_info[count].origin_priority = initial_prio;
 33c:	0197a223          	sw	s9,4(a5)
                        mlfq_info[count].finish_priority = final_prio;
 340:	c788                	sw	a0,8(a5)
                    }
                    count++;
 342:	2b85                	addiw	s7,s7,1
    for (int i = 0; output[i] != '\0'; i++) {
 344:	0905                	addi	s2,s2,1
 346:	00094783          	lbu	a5,0(s2)
 34a:	c3a9                	beqz	a5,38c <check_completion_order+0xfa>
        if (simple_strcmp(&output[i], pattern, prefix_len) == 0) {
 34c:	8656                	mv	a2,s5
 34e:	85da                	mv	a1,s6
 350:	854a                	mv	a0,s2
 352:	00000097          	auipc	ra,0x0
 356:	cae080e7          	jalr	-850(ra) # 0 <simple_strcmp>
 35a:	f56d                	bnez	a0,344 <check_completion_order+0xb2>
            while (*completed_ptr != '\0') {
 35c:	00094783          	lbu	a5,0(s2)
 360:	d3f5                	beqz	a5,344 <check_completion_order+0xb2>
 362:	84ca                	mv	s1,s2
                if (simple_strcmp(completed_ptr, "completed", strlen("completed")) == 0) {
 364:	854e                	mv	a0,s3
 366:	00000097          	auipc	ra,0x0
 36a:	35e080e7          	jalr	862(ra) # 6c4 <strlen>
 36e:	0005061b          	sext.w	a2,a0
 372:	85ce                	mv	a1,s3
 374:	8526                	mv	a0,s1
 376:	00000097          	auipc	ra,0x0
 37a:	c8a080e7          	jalr	-886(ra) # 0 <simple_strcmp>
 37e:	dd39                	beqz	a0,2dc <check_completion_order+0x4a>
                    break;
                }
                completed_ptr++;
 380:	0485                	addi	s1,s1,1
            while (*completed_ptr != '\0') {
 382:	0004c783          	lbu	a5,0(s1)
 386:	fff9                	bnez	a5,364 <check_completion_order+0xd2>
 388:	bf75                	j	344 <check_completion_order+0xb2>
    int count = 0;
 38a:	4b81                	li	s7,0
            }
        }
    }

    if (count != order_length) {
        return 0;
 38c:	4501                	li	a0,0
    if (count != order_length) {
 38e:	037a1e63          	bne	s4,s7,3ca <check_completion_order+0x138>
    }

    for (int i = 0; i < order_length; i++) {
 392:	05405b63          	blez	s4,3e8 <check_completion_order+0x156>
 396:	f6843703          	ld	a4,-152(s0)
 39a:	f7840793          	addi	a5,s0,-136
 39e:	fffa061b          	addiw	a2,s4,-1
 3a2:	02061693          	slli	a3,a2,0x20
 3a6:	01e6d613          	srli	a2,a3,0x1e
 3aa:	f7c40693          	addi	a3,s0,-132
 3ae:	9636                	add	a2,a2,a3
 3b0:	a029                	j	3ba <check_completion_order+0x128>
 3b2:	0711                	addi	a4,a4,4
 3b4:	0791                	addi	a5,a5,4
 3b6:	00c78963          	beq	a5,a2,3c8 <check_completion_order+0x136>
        if (expected_order[i] !=0 && ids[i] != expected_order[i]) {
 3ba:	4314                	lw	a3,0(a4)
 3bc:	dafd                	beqz	a3,3b2 <check_completion_order+0x120>
 3be:	438c                	lw	a1,0(a5)
 3c0:	fed589e3          	beq	a1,a3,3b2 <check_completion_order+0x120>
            return 0;
 3c4:	4501                	li	a0,0
 3c6:	a011                	j	3ca <check_completion_order+0x138>
        }
    }
    
    return 1;
 3c8:	4505                	li	a0,1
}
 3ca:	60ea                	ld	ra,152(sp)
 3cc:	644a                	ld	s0,144(sp)
 3ce:	64aa                	ld	s1,136(sp)
 3d0:	690a                	ld	s2,128(sp)
 3d2:	79e6                	ld	s3,120(sp)
 3d4:	7a46                	ld	s4,112(sp)
 3d6:	7aa6                	ld	s5,104(sp)
 3d8:	7b06                	ld	s6,96(sp)
 3da:	6be6                	ld	s7,88(sp)
 3dc:	6c46                	ld	s8,80(sp)
 3de:	6ca6                	ld	s9,72(sp)
 3e0:	6d06                	ld	s10,64(sp)
 3e2:	7de2                	ld	s11,56(sp)
 3e4:	610d                	addi	sp,sp,160
 3e6:	8082                	ret
    return 1;
 3e8:	4505                	li	a0,1
 3ea:	b7c5                	j	3ca <check_completion_order+0x138>

00000000000003ec <test_mlfq_priority_change>:

int test_mlfq_priority_change() {
 3ec:	715d                	addi	sp,sp,-80
 3ee:	e486                	sd	ra,72(sp)
 3f0:	e0a2                	sd	s0,64(sp)
 3f2:	fc26                	sd	s1,56(sp)
 3f4:	f84a                	sd	s2,48(sp)
 3f6:	f44e                	sd	s3,40(sp)
 3f8:	f052                	sd	s4,32(sp)
 3fa:	ec56                	sd	s5,24(sp)
 3fc:	e85a                	sd	s6,16(sp)
 3fe:	e45e                	sd	s7,8(sp)
 400:	0880                	addi	s0,sp,80
    for (int i = 0; i < MAX_PROCESSES; i++) {
 402:	00001497          	auipc	s1,0x1
 406:	f6648493          	addi	s1,s1,-154 # 1368 <mlfq_info>
 40a:	00001a97          	auipc	s5,0x1
 40e:	f9aa8a93          	addi	s5,s5,-102 # 13a4 <mlfq_info+0x3c>
        priorities res = mlfq_info[i];
        if (res.id <= 0 || res.id > MAX_PROCESSES) {
 412:	4911                	li	s2,4
            return 0;
        }
        if (res.origin_priority < 0 || res.finish_priority < 0) {
            return 0;
        }
        switch (res.id) {
 414:	4a0d                	li	s4,3
            case 3:
                if (res.finish_priority <= res.origin_priority) {
                    printf("FAILED: CPU-intensive process %d should have a lower priority than origin priority, but got origin prio %d, finish prio %d\n", res.id, res.origin_priority, res.finish_priority);
                    return 0;
                }
                printf("CPU-intensive process %d have a lower priority from %d to %d\n", res.id, res.origin_priority, res.finish_priority);
 416:	00001b97          	auipc	s7,0x1
 41a:	c32b8b93          	addi	s7,s7,-974 # 1048 <malloc+0x1b8>
            case 4:
                if (res.finish_priority >= res.origin_priority) {
                    printf("FAILED: I/O-intensive process %d should have a higher priority than origin priority, but got origin prio %d, finish prio %d\n", res.id, res.origin_priority, res.finish_priority);
                    return 0;
                }
                printf("I/O-intensive process %d have a higher priority from %d to %d\n", res.id, res.origin_priority, res.finish_priority);
 41e:	00001b17          	auipc	s6,0x1
 422:	ceab0b13          	addi	s6,s6,-790 # 1108 <malloc+0x278>
        switch (res.id) {
 426:	4985                	li	s3,1
 428:	a031                	j	434 <test_mlfq_priority_change+0x48>
 42a:	03358d63          	beq	a1,s3,464 <test_mlfq_priority_change+0x78>
    for (int i = 0; i < MAX_PROCESSES; i++) {
 42e:	04b1                	addi	s1,s1,12
 430:	07548763          	beq	s1,s5,49e <test_mlfq_priority_change+0xb2>
        priorities res = mlfq_info[i];
 434:	408c                	lw	a1,0(s1)
 436:	40d0                	lw	a2,4(s1)
 438:	4494                	lw	a3,8(s1)
        if (res.id <= 0 || res.id > MAX_PROCESSES) {
 43a:	fff5879b          	addiw	a5,a1,-1
 43e:	06f96c63          	bltu	s2,a5,4b6 <test_mlfq_priority_change+0xca>
        if (res.origin_priority < 0 || res.finish_priority < 0) {
 442:	00d667b3          	or	a5,a2,a3
 446:	0607ca63          	bltz	a5,4ba <test_mlfq_priority_change+0xce>
        switch (res.id) {
 44a:	01458d63          	beq	a1,s4,464 <test_mlfq_priority_change+0x78>
 44e:	fd259ee3          	bne	a1,s2,42a <test_mlfq_priority_change+0x3e>
                if (res.finish_priority >= res.origin_priority) {
 452:	02c6db63          	bge	a3,a2,488 <test_mlfq_priority_change+0x9c>
                printf("I/O-intensive process %d have a higher priority from %d to %d\n", res.id, res.origin_priority, res.finish_priority);
 456:	85ca                	mv	a1,s2
 458:	855a                	mv	a0,s6
 45a:	00001097          	auipc	ra,0x1
 45e:	97e080e7          	jalr	-1666(ra) # dd8 <printf>
                break;
 462:	b7f1                	j	42e <test_mlfq_priority_change+0x42>
                if (res.finish_priority <= res.origin_priority) {
 464:	00d65863          	bge	a2,a3,474 <test_mlfq_priority_change+0x88>
                printf("CPU-intensive process %d have a lower priority from %d to %d\n", res.id, res.origin_priority, res.finish_priority);
 468:	855e                	mv	a0,s7
 46a:	00001097          	auipc	ra,0x1
 46e:	96e080e7          	jalr	-1682(ra) # dd8 <printf>
                break;
 472:	bf75                	j	42e <test_mlfq_priority_change+0x42>
                    printf("FAILED: CPU-intensive process %d should have a lower priority than origin priority, but got origin prio %d, finish prio %d\n", res.id, res.origin_priority, res.finish_priority);
 474:	00001517          	auipc	a0,0x1
 478:	b5450513          	addi	a0,a0,-1196 # fc8 <malloc+0x138>
 47c:	00001097          	auipc	ra,0x1
 480:	95c080e7          	jalr	-1700(ra) # dd8 <printf>
                    return 0;
 484:	4501                	li	a0,0
 486:	a829                	j	4a0 <test_mlfq_priority_change+0xb4>
                    printf("FAILED: I/O-intensive process %d should have a higher priority than origin priority, but got origin prio %d, finish prio %d\n", res.id, res.origin_priority, res.finish_priority);
 488:	4591                	li	a1,4
 48a:	00001517          	auipc	a0,0x1
 48e:	bfe50513          	addi	a0,a0,-1026 # 1088 <malloc+0x1f8>
 492:	00001097          	auipc	ra,0x1
 496:	946080e7          	jalr	-1722(ra) # dd8 <printf>
                    return 0;
 49a:	4501                	li	a0,0
 49c:	a011                	j	4a0 <test_mlfq_priority_change+0xb4>
            case 2:
            case 5:
                break;
        }
    }
    return 1;
 49e:	4505                	li	a0,1
}
 4a0:	60a6                	ld	ra,72(sp)
 4a2:	6406                	ld	s0,64(sp)
 4a4:	74e2                	ld	s1,56(sp)
 4a6:	7942                	ld	s2,48(sp)
 4a8:	79a2                	ld	s3,40(sp)
 4aa:	7a02                	ld	s4,32(sp)
 4ac:	6ae2                	ld	s5,24(sp)
 4ae:	6b42                	ld	s6,16(sp)
 4b0:	6ba2                	ld	s7,8(sp)
 4b2:	6161                	addi	sp,sp,80
 4b4:	8082                	ret
 4b6:	4501                	li	a0,0
 4b8:	b7e5                	j	4a0 <test_mlfq_priority_change+0xb4>
 4ba:	4501                	li	a0,0
 4bc:	b7d5                	j	4a0 <test_mlfq_priority_change+0xb4>

00000000000004be <main>:

int main(int argc, char* argv[]) {
 4be:	715d                	addi	sp,sp,-80
 4c0:	e486                	sd	ra,72(sp)
 4c2:	e0a2                	sd	s0,64(sp)
 4c4:	fc26                	sd	s1,56(sp)
 4c6:	f84a                	sd	s2,48(sp)
 4c8:	f44e                	sd	s3,40(sp)
 4ca:	f052                	sd	s4,32(sp)
 4cc:	ec56                	sd	s5,24(sp)
 4ce:	e85a                	sd	s6,16(sp)
 4d0:	e45e                	sd	s7,8(sp)
 4d2:	e062                	sd	s8,0(sp)
 4d4:	0880                	addi	s0,sp,80
 4d6:	84aa                	mv	s1,a0
 4d8:	892e                	mv	s2,a1
    printf("Judger: Starting evaluation\n");
 4da:	00001517          	auipc	a0,0x1
 4de:	c6e50513          	addi	a0,a0,-914 # 1148 <malloc+0x2b8>
 4e2:	00001097          	auipc	ra,0x1
 4e6:	8f6080e7          	jalr	-1802(ra) # dd8 <printf>
    int score = 0;
    
    if (argc == 3) {
 4ea:	478d                	li	a5,3
 4ec:	02f48963          	beq	s1,a5,51e <main+0x60>
            }     
        } else {
            printf("Test%s FAILED\n", program_name);
        }
    } else {
        printf("Error: Not matched arguments\n");
 4f0:	00001517          	auipc	a0,0x1
 4f4:	d1850513          	addi	a0,a0,-744 # 1208 <malloc+0x378>
 4f8:	00001097          	auipc	ra,0x1
 4fc:	8e0080e7          	jalr	-1824(ra) # dd8 <printf>
    int score = 0;
 500:	4481                	li	s1,0
    }
    
    printf("SCORE: %d\n", score);
 502:	85a6                	mv	a1,s1
 504:	00001517          	auipc	a0,0x1
 508:	d2450513          	addi	a0,a0,-732 # 1228 <malloc+0x398>
 50c:	00001097          	auipc	ra,0x1
 510:	8cc080e7          	jalr	-1844(ra) # dd8 <printf>
    exit(0);
 514:	4501                	li	a0,0
 516:	00000097          	auipc	ra,0x0
 51a:	3f0080e7          	jalr	1008(ra) # 906 <exit>
        char* program_name = argv[1];
 51e:	00893a03          	ld	s4,8(s2)
        char* output = argv[2];
 522:	01093b83          	ld	s7,16(s2)
        printf("Test%s output:\n%s\n", program_name, output);
 526:	865e                	mv	a2,s7
 528:	85d2                	mv	a1,s4
 52a:	00001517          	auipc	a0,0x1
 52e:	c3e50513          	addi	a0,a0,-962 # 1168 <malloc+0x2d8>
 532:	00001097          	auipc	ra,0x1
 536:	8a6080e7          	jalr	-1882(ra) # dd8 <printf>
        switch (program_name[0]) {
 53a:	000a4983          	lbu	s3,0(s4)
 53e:	03200793          	li	a5,50
 542:	0af98963          	beq	s3,a5,5f4 <main+0x136>
 546:	03300793          	li	a5,51
 54a:	0af98863          	beq	s3,a5,5fa <main+0x13c>
 54e:	fcf98993          	addi	s3,s3,-49
 552:	013039b3          	snez	s3,s3
 556:	413009b3          	neg	s3,s3
 55a:	4c01                	li	s8,0
        printf("Expected order: ");
 55c:	00001517          	auipc	a0,0x1
 560:	c2450513          	addi	a0,a0,-988 # 1180 <malloc+0x2f0>
 564:	00001097          	auipc	ra,0x1
 568:	874080e7          	jalr	-1932(ra) # dd8 <printf>
        for (int j = 0; j < MAX_PROCESSES; j++) {
 56c:	47d1                	li	a5,20
 56e:	02f987b3          	mul	a5,s3,a5
 572:	00001b17          	auipc	s6,0x1
 576:	d8eb0b13          	addi	s6,s6,-626 # 1300 <expected_order>
 57a:	9b3e                	add	s6,s6,a5
 57c:	895a                	mv	s2,s6
        printf("Expected order: ");
 57e:	4495                	li	s1,5
            printf("%d ", expected_order[index][j]);
 580:	00001a97          	auipc	s5,0x1
 584:	c18a8a93          	addi	s5,s5,-1000 # 1198 <malloc+0x308>
 588:	00092583          	lw	a1,0(s2)
 58c:	8556                	mv	a0,s5
 58e:	00001097          	auipc	ra,0x1
 592:	84a080e7          	jalr	-1974(ra) # dd8 <printf>
        for (int j = 0; j < MAX_PROCESSES; j++) {
 596:	34fd                	addiw	s1,s1,-1
 598:	0911                	addi	s2,s2,4
 59a:	f4fd                	bnez	s1,588 <main+0xca>
        printf("\n");
 59c:	00001517          	auipc	a0,0x1
 5a0:	c0450513          	addi	a0,a0,-1020 # 11a0 <malloc+0x310>
 5a4:	00001097          	auipc	ra,0x1
 5a8:	834080e7          	jalr	-1996(ra) # dd8 <printf>
        if (check_completion_order(prefix[index], output, expected_order[index], expected_order_length[index])) {
 5ac:	00299793          	slli	a5,s3,0x2
 5b0:	00001717          	auipc	a4,0x1
 5b4:	d5070713          	addi	a4,a4,-688 # 1300 <expected_order>
 5b8:	973e                	add	a4,a4,a5
 5ba:	098e                	slli	s3,s3,0x3
 5bc:	00001797          	auipc	a5,0x1
 5c0:	d9478793          	addi	a5,a5,-620 # 1350 <prefix>
 5c4:	97ce                	add	a5,a5,s3
 5c6:	4334                	lw	a3,64(a4)
 5c8:	865a                	mv	a2,s6
 5ca:	85de                	mv	a1,s7
 5cc:	6388                	ld	a0,0(a5)
 5ce:	00000097          	auipc	ra,0x0
 5d2:	cc4080e7          	jalr	-828(ra) # 292 <check_completion_order>
 5d6:	84aa                	mv	s1,a0
 5d8:	c12d                	beqz	a0,63a <main+0x17c>
            if (!need_check_priority_change) {
 5da:	020c1363          	bnez	s8,600 <main+0x142>
                printf("Test%s PASSED\n", program_name);
 5de:	85d2                	mv	a1,s4
 5e0:	00001517          	auipc	a0,0x1
 5e4:	bc850513          	addi	a0,a0,-1080 # 11a8 <malloc+0x318>
 5e8:	00000097          	auipc	ra,0x0
 5ec:	7f0080e7          	jalr	2032(ra) # dd8 <printf>
                score = 1;
 5f0:	4485                	li	s1,1
 5f2:	bf01                	j	502 <main+0x44>
        int need_check_priority_change = 0;
 5f4:	4c01                	li	s8,0
                index = 1;
 5f6:	4985                	li	s3,1
 5f8:	b795                	j	55c <main+0x9e>
                need_check_priority_change = 1;
 5fa:	4c05                	li	s8,1
                index = 2;
 5fc:	4989                	li	s3,2
 5fe:	bfb9                	j	55c <main+0x9e>
                if (test_mlfq_priority_change() == 1) {
 600:	00000097          	auipc	ra,0x0
 604:	dec080e7          	jalr	-532(ra) # 3ec <test_mlfq_priority_change>
 608:	84aa                	mv	s1,a0
 60a:	4785                	li	a5,1
 60c:	00f50d63          	beq	a0,a5,626 <main+0x168>
                    printf("Test%s FAILED priority_changed\n", program_name);
 610:	85d2                	mv	a1,s4
 612:	00001517          	auipc	a0,0x1
 616:	bc650513          	addi	a0,a0,-1082 # 11d8 <malloc+0x348>
 61a:	00000097          	auipc	ra,0x0
 61e:	7be080e7          	jalr	1982(ra) # dd8 <printf>
    int score = 0;
 622:	4481                	li	s1,0
 624:	bdf9                	j	502 <main+0x44>
                    printf("Test%s PASSED priority_changes\n", program_name);
 626:	85d2                	mv	a1,s4
 628:	00001517          	auipc	a0,0x1
 62c:	b9050513          	addi	a0,a0,-1136 # 11b8 <malloc+0x328>
 630:	00000097          	auipc	ra,0x0
 634:	7a8080e7          	jalr	1960(ra) # dd8 <printf>
                    score = 1;
 638:	b5e9                	j	502 <main+0x44>
            printf("Test%s FAILED\n", program_name);
 63a:	85d2                	mv	a1,s4
 63c:	00001517          	auipc	a0,0x1
 640:	bbc50513          	addi	a0,a0,-1092 # 11f8 <malloc+0x368>
 644:	00000097          	auipc	ra,0x0
 648:	794080e7          	jalr	1940(ra) # dd8 <printf>
 64c:	bd5d                	j	502 <main+0x44>

000000000000064e <strcpy>:
#include "kernel/include/fcntl.h"
#include "xv6-user/user.h"

char*
strcpy(char *s, const char *t)
{
 64e:	1141                	addi	sp,sp,-16
 650:	e422                	sd	s0,8(sp)
 652:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 654:	87aa                	mv	a5,a0
 656:	0585                	addi	a1,a1,1
 658:	0785                	addi	a5,a5,1
 65a:	fff5c703          	lbu	a4,-1(a1)
 65e:	fee78fa3          	sb	a4,-1(a5)
 662:	fb75                	bnez	a4,656 <strcpy+0x8>
    ;
  return os;
}
 664:	6422                	ld	s0,8(sp)
 666:	0141                	addi	sp,sp,16
 668:	8082                	ret

000000000000066a <strcat>:

char*
strcat(char *s, const char *t)
{
 66a:	1141                	addi	sp,sp,-16
 66c:	e422                	sd	s0,8(sp)
 66e:	0800                	addi	s0,sp,16
  char *os = s;
  while(*s)
 670:	00054783          	lbu	a5,0(a0)
 674:	c385                	beqz	a5,694 <strcat+0x2a>
 676:	87aa                	mv	a5,a0
    s++;
 678:	0785                	addi	a5,a5,1
  while(*s)
 67a:	0007c703          	lbu	a4,0(a5)
 67e:	ff6d                	bnez	a4,678 <strcat+0xe>
  while((*s++ = *t++))
 680:	0585                	addi	a1,a1,1
 682:	0785                	addi	a5,a5,1
 684:	fff5c703          	lbu	a4,-1(a1)
 688:	fee78fa3          	sb	a4,-1(a5)
 68c:	fb75                	bnez	a4,680 <strcat+0x16>
    ;
  return os;
}
 68e:	6422                	ld	s0,8(sp)
 690:	0141                	addi	sp,sp,16
 692:	8082                	ret
  while(*s)
 694:	87aa                	mv	a5,a0
 696:	b7ed                	j	680 <strcat+0x16>

0000000000000698 <strcmp>:


int
strcmp(const char *p, const char *q)
{
 698:	1141                	addi	sp,sp,-16
 69a:	e422                	sd	s0,8(sp)
 69c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 69e:	00054783          	lbu	a5,0(a0)
 6a2:	cb91                	beqz	a5,6b6 <strcmp+0x1e>
 6a4:	0005c703          	lbu	a4,0(a1)
 6a8:	00f71763          	bne	a4,a5,6b6 <strcmp+0x1e>
    p++, q++;
 6ac:	0505                	addi	a0,a0,1
 6ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 6b0:	00054783          	lbu	a5,0(a0)
 6b4:	fbe5                	bnez	a5,6a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 6b6:	0005c503          	lbu	a0,0(a1)
}
 6ba:	40a7853b          	subw	a0,a5,a0
 6be:	6422                	ld	s0,8(sp)
 6c0:	0141                	addi	sp,sp,16
 6c2:	8082                	ret

00000000000006c4 <strlen>:

uint
strlen(const char *s)
{
 6c4:	1141                	addi	sp,sp,-16
 6c6:	e422                	sd	s0,8(sp)
 6c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 6ca:	00054783          	lbu	a5,0(a0)
 6ce:	cf91                	beqz	a5,6ea <strlen+0x26>
 6d0:	0505                	addi	a0,a0,1
 6d2:	87aa                	mv	a5,a0
 6d4:	4685                	li	a3,1
 6d6:	9e89                	subw	a3,a3,a0
 6d8:	00f6853b          	addw	a0,a3,a5
 6dc:	0785                	addi	a5,a5,1
 6de:	fff7c703          	lbu	a4,-1(a5)
 6e2:	fb7d                	bnez	a4,6d8 <strlen+0x14>
    ;
  return n;
}
 6e4:	6422                	ld	s0,8(sp)
 6e6:	0141                	addi	sp,sp,16
 6e8:	8082                	ret
  for(n = 0; s[n]; n++)
 6ea:	4501                	li	a0,0
 6ec:	bfe5                	j	6e4 <strlen+0x20>

00000000000006ee <memset>:

void*
memset(void *dst, int c, uint n)
{
 6ee:	1141                	addi	sp,sp,-16
 6f0:	e422                	sd	s0,8(sp)
 6f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 6f4:	ca19                	beqz	a2,70a <memset+0x1c>
 6f6:	87aa                	mv	a5,a0
 6f8:	1602                	slli	a2,a2,0x20
 6fa:	9201                	srli	a2,a2,0x20
 6fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 700:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 704:	0785                	addi	a5,a5,1
 706:	fee79de3          	bne	a5,a4,700 <memset+0x12>
  }
  return dst;
}
 70a:	6422                	ld	s0,8(sp)
 70c:	0141                	addi	sp,sp,16
 70e:	8082                	ret

0000000000000710 <strchr>:

char*
strchr(const char *s, char c)
{
 710:	1141                	addi	sp,sp,-16
 712:	e422                	sd	s0,8(sp)
 714:	0800                	addi	s0,sp,16
  for(; *s; s++)
 716:	00054783          	lbu	a5,0(a0)
 71a:	cb99                	beqz	a5,730 <strchr+0x20>
    if(*s == c)
 71c:	00f58763          	beq	a1,a5,72a <strchr+0x1a>
  for(; *s; s++)
 720:	0505                	addi	a0,a0,1
 722:	00054783          	lbu	a5,0(a0)
 726:	fbfd                	bnez	a5,71c <strchr+0xc>
      return (char*)s;
  return 0;
 728:	4501                	li	a0,0
}
 72a:	6422                	ld	s0,8(sp)
 72c:	0141                	addi	sp,sp,16
 72e:	8082                	ret
  return 0;
 730:	4501                	li	a0,0
 732:	bfe5                	j	72a <strchr+0x1a>

0000000000000734 <gets>:

char*
gets(char *buf, int max)
{
 734:	711d                	addi	sp,sp,-96
 736:	ec86                	sd	ra,88(sp)
 738:	e8a2                	sd	s0,80(sp)
 73a:	e4a6                	sd	s1,72(sp)
 73c:	e0ca                	sd	s2,64(sp)
 73e:	fc4e                	sd	s3,56(sp)
 740:	f852                	sd	s4,48(sp)
 742:	f456                	sd	s5,40(sp)
 744:	f05a                	sd	s6,32(sp)
 746:	ec5e                	sd	s7,24(sp)
 748:	e862                	sd	s8,16(sp)
 74a:	1080                	addi	s0,sp,96
 74c:	8baa                	mv	s7,a0
 74e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 750:	892a                	mv	s2,a0
 752:	4481                	li	s1,0
    cc = read(0, &c, 1);
 754:	faf40a93          	addi	s5,s0,-81
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 758:	4b29                	li	s6,10
 75a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 75c:	89a6                	mv	s3,s1
 75e:	2485                	addiw	s1,s1,1
 760:	0344d763          	bge	s1,s4,78e <gets+0x5a>
    cc = read(0, &c, 1);
 764:	4605                	li	a2,1
 766:	85d6                	mv	a1,s5
 768:	4501                	li	a0,0
 76a:	00000097          	auipc	ra,0x0
 76e:	1b8080e7          	jalr	440(ra) # 922 <read>
    if(cc < 1)
 772:	00a05e63          	blez	a0,78e <gets+0x5a>
    buf[i++] = c;
 776:	faf44783          	lbu	a5,-81(s0)
 77a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 77e:	01678763          	beq	a5,s6,78c <gets+0x58>
 782:	0905                	addi	s2,s2,1
 784:	fd879ce3          	bne	a5,s8,75c <gets+0x28>
  for(i=0; i+1 < max; ){
 788:	89a6                	mv	s3,s1
 78a:	a011                	j	78e <gets+0x5a>
 78c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 78e:	99de                	add	s3,s3,s7
 790:	00098023          	sb	zero,0(s3)
  return buf;
}
 794:	855e                	mv	a0,s7
 796:	60e6                	ld	ra,88(sp)
 798:	6446                	ld	s0,80(sp)
 79a:	64a6                	ld	s1,72(sp)
 79c:	6906                	ld	s2,64(sp)
 79e:	79e2                	ld	s3,56(sp)
 7a0:	7a42                	ld	s4,48(sp)
 7a2:	7aa2                	ld	s5,40(sp)
 7a4:	7b02                	ld	s6,32(sp)
 7a6:	6be2                	ld	s7,24(sp)
 7a8:	6c42                	ld	s8,16(sp)
 7aa:	6125                	addi	sp,sp,96
 7ac:	8082                	ret

00000000000007ae <stat>:

int
stat(const char *n, struct stat *st)
{
 7ae:	1101                	addi	sp,sp,-32
 7b0:	ec06                	sd	ra,24(sp)
 7b2:	e822                	sd	s0,16(sp)
 7b4:	e426                	sd	s1,8(sp)
 7b6:	e04a                	sd	s2,0(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7bc:	4581                	li	a1,0
 7be:	00000097          	auipc	ra,0x0
 7c2:	194080e7          	jalr	404(ra) # 952 <open>
  if(fd < 0)
 7c6:	02054563          	bltz	a0,7f0 <stat+0x42>
 7ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 7cc:	85ca                	mv	a1,s2
 7ce:	00000097          	auipc	ra,0x0
 7d2:	18e080e7          	jalr	398(ra) # 95c <fstat>
 7d6:	892a                	mv	s2,a0
  close(fd);
 7d8:	8526                	mv	a0,s1
 7da:	00000097          	auipc	ra,0x0
 7de:	15c080e7          	jalr	348(ra) # 936 <close>
  return r;
}
 7e2:	854a                	mv	a0,s2
 7e4:	60e2                	ld	ra,24(sp)
 7e6:	6442                	ld	s0,16(sp)
 7e8:	64a2                	ld	s1,8(sp)
 7ea:	6902                	ld	s2,0(sp)
 7ec:	6105                	addi	sp,sp,32
 7ee:	8082                	ret
    return -1;
 7f0:	597d                	li	s2,-1
 7f2:	bfc5                	j	7e2 <stat+0x34>

00000000000007f4 <atoi>:

int
atoi(const char *s)
{
 7f4:	1141                	addi	sp,sp,-16
 7f6:	e422                	sd	s0,8(sp)
 7f8:	0800                	addi	s0,sp,16
  int n;
  int neg = 1;
  if (*s == '-') {
 7fa:	00054703          	lbu	a4,0(a0)
 7fe:	02d00793          	li	a5,45
  int neg = 1;
 802:	4585                	li	a1,1
  if (*s == '-') {
 804:	04f70363          	beq	a4,a5,84a <atoi+0x56>
    s++;
    neg = -1;
  }
  n = 0;
  while('0' <= *s && *s <= '9')
 808:	00054703          	lbu	a4,0(a0)
 80c:	fd07079b          	addiw	a5,a4,-48
 810:	0ff7f793          	zext.b	a5,a5
 814:	46a5                	li	a3,9
 816:	02f6ed63          	bltu	a3,a5,850 <atoi+0x5c>
  n = 0;
 81a:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 81c:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 81e:	0505                	addi	a0,a0,1
 820:	0026979b          	slliw	a5,a3,0x2
 824:	9fb5                	addw	a5,a5,a3
 826:	0017979b          	slliw	a5,a5,0x1
 82a:	9fb9                	addw	a5,a5,a4
 82c:	fd07869b          	addiw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 830:	00054703          	lbu	a4,0(a0)
 834:	fd07079b          	addiw	a5,a4,-48
 838:	0ff7f793          	zext.b	a5,a5
 83c:	fef671e3          	bgeu	a2,a5,81e <atoi+0x2a>
  return n * neg;
}
 840:	02d5853b          	mulw	a0,a1,a3
 844:	6422                	ld	s0,8(sp)
 846:	0141                	addi	sp,sp,16
 848:	8082                	ret
    s++;
 84a:	0505                	addi	a0,a0,1
    neg = -1;
 84c:	55fd                	li	a1,-1
 84e:	bf6d                	j	808 <atoi+0x14>
  n = 0;
 850:	4681                	li	a3,0
 852:	b7fd                	j	840 <atoi+0x4c>

0000000000000854 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 854:	1141                	addi	sp,sp,-16
 856:	e422                	sd	s0,8(sp)
 858:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 85a:	02b57463          	bgeu	a0,a1,882 <memmove+0x2e>
    while(n-- > 0)
 85e:	00c05f63          	blez	a2,87c <memmove+0x28>
 862:	1602                	slli	a2,a2,0x20
 864:	9201                	srli	a2,a2,0x20
 866:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 86a:	872a                	mv	a4,a0
      *dst++ = *src++;
 86c:	0585                	addi	a1,a1,1
 86e:	0705                	addi	a4,a4,1
 870:	fff5c683          	lbu	a3,-1(a1)
 874:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 878:	fee79ae3          	bne	a5,a4,86c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 87c:	6422                	ld	s0,8(sp)
 87e:	0141                	addi	sp,sp,16
 880:	8082                	ret
    dst += n;
 882:	00c50733          	add	a4,a0,a2
    src += n;
 886:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 888:	fec05ae3          	blez	a2,87c <memmove+0x28>
 88c:	fff6079b          	addiw	a5,a2,-1
 890:	1782                	slli	a5,a5,0x20
 892:	9381                	srli	a5,a5,0x20
 894:	fff7c793          	not	a5,a5
 898:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 89a:	15fd                	addi	a1,a1,-1
 89c:	177d                	addi	a4,a4,-1
 89e:	0005c683          	lbu	a3,0(a1)
 8a2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8a6:	fee79ae3          	bne	a5,a4,89a <memmove+0x46>
 8aa:	bfc9                	j	87c <memmove+0x28>

00000000000008ac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8ac:	1141                	addi	sp,sp,-16
 8ae:	e422                	sd	s0,8(sp)
 8b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8b2:	ca05                	beqz	a2,8e2 <memcmp+0x36>
 8b4:	fff6069b          	addiw	a3,a2,-1
 8b8:	1682                	slli	a3,a3,0x20
 8ba:	9281                	srli	a3,a3,0x20
 8bc:	0685                	addi	a3,a3,1
 8be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8c0:	00054783          	lbu	a5,0(a0)
 8c4:	0005c703          	lbu	a4,0(a1)
 8c8:	00e79863          	bne	a5,a4,8d8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 8cc:	0505                	addi	a0,a0,1
    p2++;
 8ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 8d0:	fed518e3          	bne	a0,a3,8c0 <memcmp+0x14>
  }
  return 0;
 8d4:	4501                	li	a0,0
 8d6:	a019                	j	8dc <memcmp+0x30>
      return *p1 - *p2;
 8d8:	40e7853b          	subw	a0,a5,a4
}
 8dc:	6422                	ld	s0,8(sp)
 8de:	0141                	addi	sp,sp,16
 8e0:	8082                	ret
  return 0;
 8e2:	4501                	li	a0,0
 8e4:	bfe5                	j	8dc <memcmp+0x30>

00000000000008e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 8e6:	1141                	addi	sp,sp,-16
 8e8:	e406                	sd	ra,8(sp)
 8ea:	e022                	sd	s0,0(sp)
 8ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 8ee:	00000097          	auipc	ra,0x0
 8f2:	f66080e7          	jalr	-154(ra) # 854 <memmove>
}
 8f6:	60a2                	ld	ra,8(sp)
 8f8:	6402                	ld	s0,0(sp)
 8fa:	0141                	addi	sp,sp,16
 8fc:	8082                	ret

00000000000008fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/include/sysnum.h"
.global fork
fork:
 li a7, SYS_fork
 8fe:	4885                	li	a7,1
 ecall
 900:	00000073          	ecall
 ret
 904:	8082                	ret

0000000000000906 <exit>:
.global exit
exit:
 li a7, SYS_exit
 906:	05d00893          	li	a7,93
 ecall
 90a:	00000073          	ecall
 ret
 90e:	8082                	ret

0000000000000910 <wait>:
.global wait
wait:
 li a7, SYS_wait
 910:	488d                	li	a7,3
 ecall
 912:	00000073          	ecall
 ret
 916:	8082                	ret

0000000000000918 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 918:	03b00893          	li	a7,59
 ecall
 91c:	00000073          	ecall
 ret
 920:	8082                	ret

0000000000000922 <read>:
.global read
read:
 li a7, SYS_read
 922:	03f00893          	li	a7,63
 ecall
 926:	00000073          	ecall
 ret
 92a:	8082                	ret

000000000000092c <write>:
.global write
write:
 li a7, SYS_write
 92c:	04000893          	li	a7,64
 ecall
 930:	00000073          	ecall
 ret
 934:	8082                	ret

0000000000000936 <close>:
.global close
close:
 li a7, SYS_close
 936:	03900893          	li	a7,57
 ecall
 93a:	00000073          	ecall
 ret
 93e:	8082                	ret

0000000000000940 <kill>:
.global kill
kill:
 li a7, SYS_kill
 940:	4899                	li	a7,6
 ecall
 942:	00000073          	ecall
 ret
 946:	8082                	ret

0000000000000948 <exec>:
.global exec
exec:
 li a7, SYS_exec
 948:	0dd00893          	li	a7,221
 ecall
 94c:	00000073          	ecall
 ret
 950:	8082                	ret

0000000000000952 <open>:
.global open
open:
 li a7, SYS_open
 952:	03700893          	li	a7,55
 ecall
 956:	00000073          	ecall
 ret
 95a:	8082                	ret

000000000000095c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 95c:	05000893          	li	a7,80
 ecall
 960:	00000073          	ecall
 ret
 964:	8082                	ret

0000000000000966 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 966:	489d                	li	a7,7
 ecall
 968:	00000073          	ecall
 ret
 96c:	8082                	ret

000000000000096e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 96e:	03100893          	li	a7,49
 ecall
 972:	00000073          	ecall
 ret
 976:	8082                	ret

0000000000000978 <dup>:
.global dup
dup:
 li a7, SYS_dup
 978:	48dd                	li	a7,23
 ecall
 97a:	00000073          	ecall
 ret
 97e:	8082                	ret

0000000000000980 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 980:	0ac00893          	li	a7,172
 ecall
 984:	00000073          	ecall
 ret
 988:	8082                	ret

000000000000098a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 98a:	48b1                	li	a7,12
 ecall
 98c:	00000073          	ecall
 ret
 990:	8082                	ret

0000000000000992 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 992:	48b5                	li	a7,13
 ecall
 994:	00000073          	ecall
 ret
 998:	8082                	ret

000000000000099a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 99a:	48b9                	li	a7,14
 ecall
 99c:	00000073          	ecall
 ret
 9a0:	8082                	ret

00000000000009a2 <test_proc>:
.global test_proc
test_proc:
 li a7, SYS_test_proc
 9a2:	48d9                	li	a7,22
 ecall
 9a4:	00000073          	ecall
 ret
 9a8:	8082                	ret

00000000000009aa <dev>:
.global dev
dev:
 li a7, SYS_dev
 9aa:	48d5                	li	a7,21
 ecall
 9ac:	00000073          	ecall
 ret
 9b0:	8082                	ret

00000000000009b2 <readdir>:
.global readdir
readdir:
 li a7, SYS_readdir
 9b2:	48ed                	li	a7,27
 ecall
 9b4:	00000073          	ecall
 ret
 9b8:	8082                	ret

00000000000009ba <getcwd>:
.global getcwd
getcwd:
 li a7, SYS_getcwd
 9ba:	48c5                	li	a7,17
 ecall
 9bc:	00000073          	ecall
 ret
 9c0:	8082                	ret

00000000000009c2 <remove>:
.global remove
remove:
 li a7, SYS_remove
 9c2:	07500893          	li	a7,117
 ecall
 9c6:	00000073          	ecall
 ret
 9ca:	8082                	ret

00000000000009cc <trace>:
.global trace
trace:
 li a7, SYS_trace
 9cc:	48c9                	li	a7,18
 ecall
 9ce:	00000073          	ecall
 ret
 9d2:	8082                	ret

00000000000009d4 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 9d4:	48cd                	li	a7,19
 ecall
 9d6:	00000073          	ecall
 ret
 9da:	8082                	ret

00000000000009dc <rename>:
.global rename
rename:
 li a7, SYS_rename
 9dc:	48e9                	li	a7,26
 ecall
 9de:	00000073          	ecall
 ret
 9e2:	8082                	ret

00000000000009e4 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 9e4:	03000893          	li	a7,48
 ecall
 9e8:	00000073          	ecall
 ret
 9ec:	8082                	ret

00000000000009ee <times>:
.global times
times:
 li a7, SYS_times
 9ee:	09900893          	li	a7,153
 ecall
 9f2:	00000073          	ecall
 ret
 9f6:	8082                	ret

00000000000009f8 <uname>:
.global uname
uname:
 li a7, SYS_uname
 9f8:	0a000893          	li	a7,160
 ecall
 9fc:	00000073          	ecall
 ret
 a00:	8082                	ret

0000000000000a02 <clone>:
.global clone
clone:
 li a7, SYS_clone
 a02:	0dc00893          	li	a7,220
 ecall
 a06:	00000073          	ecall
 ret
 a0a:	8082                	ret

0000000000000a0c <wait4>:
.global wait4
wait4:
 li a7, SYS_wait4
 a0c:	10400893          	li	a7,260
 ecall
 a10:	00000073          	ecall
 ret
 a14:	8082                	ret

0000000000000a16 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 a16:	07c00893          	li	a7,124
 ecall
 a1a:	00000073          	ecall
 ret
 a1e:	8082                	ret

0000000000000a20 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 a20:	0ad00893          	li	a7,173
 ecall
 a24:	00000073          	ecall
 ret
 a28:	8082                	ret

0000000000000a2a <gettimeofday>:
.global gettimeofday
gettimeofday:
 li a7, SYS_gettimeofday
 a2a:	0a900893          	li	a7,169
 ecall
 a2e:	00000073          	ecall
 ret
 a32:	8082                	ret

0000000000000a34 <nanosleep>:
.global nanosleep
nanosleep:
 li a7, SYS_nanosleep
 a34:	06500893          	li	a7,101
 ecall
 a38:	00000073          	ecall
 ret
 a3c:	8082                	ret

0000000000000a3e <brk>:
.global brk
brk:
 li a7, SYS_brk
 a3e:	0d600893          	li	a7,214
 ecall
 a42:	00000073          	ecall
 ret
 a46:	8082                	ret

0000000000000a48 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 a48:	0de00893          	li	a7,222
 ecall
 a4c:	00000073          	ecall
 ret
 a50:	8082                	ret

0000000000000a52 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 a52:	0d700893          	li	a7,215
 ecall
 a56:	00000073          	ecall
 ret
 a5a:	8082                	ret

0000000000000a5c <dup2>:
.global dup2
dup2:
 li a7, SYS_dup2
 a5c:	68b5                	lui	a7,0xd
 a5e:	4318889b          	addiw	a7,a7,1073 # d431 <__global_pointer$+0xb931>
 ecall
 a62:	00000073          	ecall
 ret
 a66:	8082                	ret

0000000000000a68 <dup3>:
.global dup3
dup3:
 li a7, SYS_dup3
 a68:	48e1                	li	a7,24
 ecall
 a6a:	00000073          	ecall
 ret
 a6e:	8082                	ret

0000000000000a70 <set_timeslice>:
.global set_timeslice
set_timeslice:
 li a7, SYS_set_timeslice
 a70:	68b5                	lui	a7,0xd
 a72:	4328889b          	addiw	a7,a7,1074 # d432 <__global_pointer$+0xb932>
 ecall
 a76:	00000073          	ecall
 ret
 a7a:	8082                	ret

0000000000000a7c <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 a7c:	68b5                	lui	a7,0xd
 a7e:	4338889b          	addiw	a7,a7,1075 # d433 <__global_pointer$+0xb933>
 ecall
 a82:	00000073          	ecall
 ret
 a86:	8082                	ret

0000000000000a88 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 a88:	68b5                	lui	a7,0xd
 a8a:	4348889b          	addiw	a7,a7,1076 # d434 <__global_pointer$+0xb934>
 ecall
 a8e:	00000073          	ecall
 ret
 a92:	8082                	ret

0000000000000a94 <getpgcnt>:
.global getpgcnt
getpgcnt:
 li a7, SYS_getpgcnt
 a94:	68b9                	lui	a7,0xe
 a96:	9038889b          	addiw	a7,a7,-1789 # d903 <__global_pointer$+0xbe03>
 ecall
 a9a:	00000073          	ecall
 ret
 a9e:	8082                	ret

0000000000000aa0 <getprocsz>:
.global getprocsz
getprocsz:
 li a7, SYS_getprocsz
 aa0:	68b9                	lui	a7,0xe
 aa2:	9048889b          	addiw	a7,a7,-1788 # d904 <__global_pointer$+0xbe04>
 ecall
 aa6:	00000073          	ecall
 ret
 aaa:	8082                	ret

0000000000000aac <set_max_page_in_mem>:
.global set_max_page_in_mem
set_max_page_in_mem:
 li a7, SYS_set_max_page_in_mem
 aac:	68b9                	lui	a7,0xe
 aae:	9058889b          	addiw	a7,a7,-1787 # d905 <__global_pointer$+0xbe05>
 ecall
 ab2:	00000073          	ecall
 ret
 ab6:	8082                	ret

0000000000000ab8 <get_swap_count>:
.global get_swap_count
get_swap_count:
 li a7, SYS_get_swap_count
 ab8:	68b9                	lui	a7,0xe
 aba:	9068889b          	addiw	a7,a7,-1786 # d906 <__global_pointer$+0xbe06>
 ecall
 abe:	00000073          	ecall
 ret
 ac2:	8082                	ret

0000000000000ac4 <lru_access_notify>:
.global lru_access_notify
lru_access_notify:
 li a7, SYS_lru_access_notify
 ac4:	68b9                	lui	a7,0xe
 ac6:	9078889b          	addiw	a7,a7,-1785 # d907 <__global_pointer$+0xbe07>
 ecall
 aca:	00000073          	ecall
 ret
 ace:	8082                	ret

0000000000000ad0 <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 ad0:	68b9                	lui	a7,0xe
 ad2:	9088889b          	addiw	a7,a7,-1784 # d908 <__global_pointer$+0xbe08>
 ecall
 ad6:	00000073          	ecall
 ret
 ada:	8082                	ret

0000000000000adc <sem_destroy>:
.global sem_destroy
sem_destroy:
 li a7, SYS_sem_destroy
 adc:	68b9                	lui	a7,0xe
 ade:	9098889b          	addiw	a7,a7,-1783 # d909 <__global_pointer$+0xbe09>
 ecall
 ae2:	00000073          	ecall
 ret
 ae6:	8082                	ret

0000000000000ae8 <sem_p>:
.global sem_p
sem_p:
 li a7, SYS_sem_p
 ae8:	68b9                	lui	a7,0xe
 aea:	90a8889b          	addiw	a7,a7,-1782 # d90a <__global_pointer$+0xbe0a>
 ecall
 aee:	00000073          	ecall
 ret
 af2:	8082                	ret

0000000000000af4 <sem_v>:
.global sem_v
sem_v:
 li a7, SYS_sem_v
 af4:	68b9                	lui	a7,0xe
 af6:	90b8889b          	addiw	a7,a7,-1781 # d90b <__global_pointer$+0xbe0b>
 ecall
 afa:	00000073          	ecall
 ret
 afe:	8082                	ret

0000000000000b00 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 b00:	1101                	addi	sp,sp,-32
 b02:	ec06                	sd	ra,24(sp)
 b04:	e822                	sd	s0,16(sp)
 b06:	1000                	addi	s0,sp,32
 b08:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 b0c:	4605                	li	a2,1
 b0e:	fef40593          	addi	a1,s0,-17
 b12:	00000097          	auipc	ra,0x0
 b16:	e1a080e7          	jalr	-486(ra) # 92c <write>
}
 b1a:	60e2                	ld	ra,24(sp)
 b1c:	6442                	ld	s0,16(sp)
 b1e:	6105                	addi	sp,sp,32
 b20:	8082                	ret

0000000000000b22 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 b22:	7139                	addi	sp,sp,-64
 b24:	fc06                	sd	ra,56(sp)
 b26:	f822                	sd	s0,48(sp)
 b28:	f426                	sd	s1,40(sp)
 b2a:	f04a                	sd	s2,32(sp)
 b2c:	ec4e                	sd	s3,24(sp)
 b2e:	0080                	addi	s0,sp,64
 b30:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 b32:	c299                	beqz	a3,b38 <printint+0x16>
 b34:	0805c863          	bltz	a1,bc4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 b38:	2581                	sext.w	a1,a1
  neg = 0;
 b3a:	4881                	li	a7,0
  }

  i = 0;
 b3c:	fc040993          	addi	s3,s0,-64
  neg = 0;
 b40:	86ce                	mv	a3,s3
  i = 0;
 b42:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 b44:	2601                	sext.w	a2,a2
 b46:	00000517          	auipc	a0,0x0
 b4a:	7a250513          	addi	a0,a0,1954 # 12e8 <digits>
 b4e:	883a                	mv	a6,a4
 b50:	2705                	addiw	a4,a4,1
 b52:	02c5f7bb          	remuw	a5,a1,a2
 b56:	1782                	slli	a5,a5,0x20
 b58:	9381                	srli	a5,a5,0x20
 b5a:	97aa                	add	a5,a5,a0
 b5c:	0007c783          	lbu	a5,0(a5)
 b60:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 b64:	0005879b          	sext.w	a5,a1
 b68:	02c5d5bb          	divuw	a1,a1,a2
 b6c:	0685                	addi	a3,a3,1
 b6e:	fec7f0e3          	bgeu	a5,a2,b4e <printint+0x2c>
  if(neg)
 b72:	00088c63          	beqz	a7,b8a <printint+0x68>
    buf[i++] = '-';
 b76:	fd070793          	addi	a5,a4,-48
 b7a:	00878733          	add	a4,a5,s0
 b7e:	02d00793          	li	a5,45
 b82:	fef70823          	sb	a5,-16(a4)
 b86:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 b8a:	02e05663          	blez	a4,bb6 <printint+0x94>
 b8e:	fc040913          	addi	s2,s0,-64
 b92:	993a                	add	s2,s2,a4
 b94:	19fd                	addi	s3,s3,-1
 b96:	99ba                	add	s3,s3,a4
 b98:	377d                	addiw	a4,a4,-1
 b9a:	1702                	slli	a4,a4,0x20
 b9c:	9301                	srli	a4,a4,0x20
 b9e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 ba2:	fff94583          	lbu	a1,-1(s2)
 ba6:	8526                	mv	a0,s1
 ba8:	00000097          	auipc	ra,0x0
 bac:	f58080e7          	jalr	-168(ra) # b00 <putc>
  while(--i >= 0)
 bb0:	197d                	addi	s2,s2,-1
 bb2:	ff3918e3          	bne	s2,s3,ba2 <printint+0x80>
}
 bb6:	70e2                	ld	ra,56(sp)
 bb8:	7442                	ld	s0,48(sp)
 bba:	74a2                	ld	s1,40(sp)
 bbc:	7902                	ld	s2,32(sp)
 bbe:	69e2                	ld	s3,24(sp)
 bc0:	6121                	addi	sp,sp,64
 bc2:	8082                	ret
    x = -xx;
 bc4:	40b005bb          	negw	a1,a1
    neg = 1;
 bc8:	4885                	li	a7,1
    x = -xx;
 bca:	bf8d                	j	b3c <printint+0x1a>

0000000000000bcc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 bcc:	7119                	addi	sp,sp,-128
 bce:	fc86                	sd	ra,120(sp)
 bd0:	f8a2                	sd	s0,112(sp)
 bd2:	f4a6                	sd	s1,104(sp)
 bd4:	f0ca                	sd	s2,96(sp)
 bd6:	ecce                	sd	s3,88(sp)
 bd8:	e8d2                	sd	s4,80(sp)
 bda:	e4d6                	sd	s5,72(sp)
 bdc:	e0da                	sd	s6,64(sp)
 bde:	fc5e                	sd	s7,56(sp)
 be0:	f862                	sd	s8,48(sp)
 be2:	f466                	sd	s9,40(sp)
 be4:	f06a                	sd	s10,32(sp)
 be6:	ec6e                	sd	s11,24(sp)
 be8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 bea:	0005c903          	lbu	s2,0(a1)
 bee:	18090f63          	beqz	s2,d8c <vprintf+0x1c0>
 bf2:	8aaa                	mv	s5,a0
 bf4:	8b32                	mv	s6,a2
 bf6:	00158493          	addi	s1,a1,1
  state = 0;
 bfa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 bfc:	02500a13          	li	s4,37
 c00:	4c55                	li	s8,21
 c02:	00000c97          	auipc	s9,0x0
 c06:	68ec8c93          	addi	s9,s9,1678 # 1290 <malloc+0x400>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 c0a:	02800d93          	li	s11,40
  putc(fd, 'x');
 c0e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 c10:	00000b97          	auipc	s7,0x0
 c14:	6d8b8b93          	addi	s7,s7,1752 # 12e8 <digits>
 c18:	a839                	j	c36 <vprintf+0x6a>
        putc(fd, c);
 c1a:	85ca                	mv	a1,s2
 c1c:	8556                	mv	a0,s5
 c1e:	00000097          	auipc	ra,0x0
 c22:	ee2080e7          	jalr	-286(ra) # b00 <putc>
 c26:	a019                	j	c2c <vprintf+0x60>
    } else if(state == '%'){
 c28:	01498d63          	beq	s3,s4,c42 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 c2c:	0485                	addi	s1,s1,1
 c2e:	fff4c903          	lbu	s2,-1(s1)
 c32:	14090d63          	beqz	s2,d8c <vprintf+0x1c0>
    if(state == 0){
 c36:	fe0999e3          	bnez	s3,c28 <vprintf+0x5c>
      if(c == '%'){
 c3a:	ff4910e3          	bne	s2,s4,c1a <vprintf+0x4e>
        state = '%';
 c3e:	89d2                	mv	s3,s4
 c40:	b7f5                	j	c2c <vprintf+0x60>
      if(c == 'd'){
 c42:	11490c63          	beq	s2,s4,d5a <vprintf+0x18e>
 c46:	f9d9079b          	addiw	a5,s2,-99
 c4a:	0ff7f793          	zext.b	a5,a5
 c4e:	10fc6e63          	bltu	s8,a5,d6a <vprintf+0x19e>
 c52:	f9d9079b          	addiw	a5,s2,-99
 c56:	0ff7f713          	zext.b	a4,a5
 c5a:	10ec6863          	bltu	s8,a4,d6a <vprintf+0x19e>
 c5e:	00271793          	slli	a5,a4,0x2
 c62:	97e6                	add	a5,a5,s9
 c64:	439c                	lw	a5,0(a5)
 c66:	97e6                	add	a5,a5,s9
 c68:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 c6a:	008b0913          	addi	s2,s6,8
 c6e:	4685                	li	a3,1
 c70:	4629                	li	a2,10
 c72:	000b2583          	lw	a1,0(s6)
 c76:	8556                	mv	a0,s5
 c78:	00000097          	auipc	ra,0x0
 c7c:	eaa080e7          	jalr	-342(ra) # b22 <printint>
 c80:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 c82:	4981                	li	s3,0
 c84:	b765                	j	c2c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 c86:	008b0913          	addi	s2,s6,8
 c8a:	4681                	li	a3,0
 c8c:	4629                	li	a2,10
 c8e:	000b2583          	lw	a1,0(s6)
 c92:	8556                	mv	a0,s5
 c94:	00000097          	auipc	ra,0x0
 c98:	e8e080e7          	jalr	-370(ra) # b22 <printint>
 c9c:	8b4a                	mv	s6,s2
      state = 0;
 c9e:	4981                	li	s3,0
 ca0:	b771                	j	c2c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 ca2:	008b0913          	addi	s2,s6,8
 ca6:	4681                	li	a3,0
 ca8:	866a                	mv	a2,s10
 caa:	000b2583          	lw	a1,0(s6)
 cae:	8556                	mv	a0,s5
 cb0:	00000097          	auipc	ra,0x0
 cb4:	e72080e7          	jalr	-398(ra) # b22 <printint>
 cb8:	8b4a                	mv	s6,s2
      state = 0;
 cba:	4981                	li	s3,0
 cbc:	bf85                	j	c2c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 cbe:	008b0793          	addi	a5,s6,8
 cc2:	f8f43423          	sd	a5,-120(s0)
 cc6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 cca:	03000593          	li	a1,48
 cce:	8556                	mv	a0,s5
 cd0:	00000097          	auipc	ra,0x0
 cd4:	e30080e7          	jalr	-464(ra) # b00 <putc>
  putc(fd, 'x');
 cd8:	07800593          	li	a1,120
 cdc:	8556                	mv	a0,s5
 cde:	00000097          	auipc	ra,0x0
 ce2:	e22080e7          	jalr	-478(ra) # b00 <putc>
 ce6:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 ce8:	03c9d793          	srli	a5,s3,0x3c
 cec:	97de                	add	a5,a5,s7
 cee:	0007c583          	lbu	a1,0(a5)
 cf2:	8556                	mv	a0,s5
 cf4:	00000097          	auipc	ra,0x0
 cf8:	e0c080e7          	jalr	-500(ra) # b00 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 cfc:	0992                	slli	s3,s3,0x4
 cfe:	397d                	addiw	s2,s2,-1
 d00:	fe0914e3          	bnez	s2,ce8 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 d04:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 d08:	4981                	li	s3,0
 d0a:	b70d                	j	c2c <vprintf+0x60>
        s = va_arg(ap, char*);
 d0c:	008b0913          	addi	s2,s6,8
 d10:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 d14:	02098163          	beqz	s3,d36 <vprintf+0x16a>
        while(*s != 0){
 d18:	0009c583          	lbu	a1,0(s3)
 d1c:	c5ad                	beqz	a1,d86 <vprintf+0x1ba>
          putc(fd, *s);
 d1e:	8556                	mv	a0,s5
 d20:	00000097          	auipc	ra,0x0
 d24:	de0080e7          	jalr	-544(ra) # b00 <putc>
          s++;
 d28:	0985                	addi	s3,s3,1
        while(*s != 0){
 d2a:	0009c583          	lbu	a1,0(s3)
 d2e:	f9e5                	bnez	a1,d1e <vprintf+0x152>
        s = va_arg(ap, char*);
 d30:	8b4a                	mv	s6,s2
      state = 0;
 d32:	4981                	li	s3,0
 d34:	bde5                	j	c2c <vprintf+0x60>
          s = "(null)";
 d36:	00000997          	auipc	s3,0x0
 d3a:	55298993          	addi	s3,s3,1362 # 1288 <malloc+0x3f8>
        while(*s != 0){
 d3e:	85ee                	mv	a1,s11
 d40:	bff9                	j	d1e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 d42:	008b0913          	addi	s2,s6,8
 d46:	000b4583          	lbu	a1,0(s6)
 d4a:	8556                	mv	a0,s5
 d4c:	00000097          	auipc	ra,0x0
 d50:	db4080e7          	jalr	-588(ra) # b00 <putc>
 d54:	8b4a                	mv	s6,s2
      state = 0;
 d56:	4981                	li	s3,0
 d58:	bdd1                	j	c2c <vprintf+0x60>
        putc(fd, c);
 d5a:	85d2                	mv	a1,s4
 d5c:	8556                	mv	a0,s5
 d5e:	00000097          	auipc	ra,0x0
 d62:	da2080e7          	jalr	-606(ra) # b00 <putc>
      state = 0;
 d66:	4981                	li	s3,0
 d68:	b5d1                	j	c2c <vprintf+0x60>
        putc(fd, '%');
 d6a:	85d2                	mv	a1,s4
 d6c:	8556                	mv	a0,s5
 d6e:	00000097          	auipc	ra,0x0
 d72:	d92080e7          	jalr	-622(ra) # b00 <putc>
        putc(fd, c);
 d76:	85ca                	mv	a1,s2
 d78:	8556                	mv	a0,s5
 d7a:	00000097          	auipc	ra,0x0
 d7e:	d86080e7          	jalr	-634(ra) # b00 <putc>
      state = 0;
 d82:	4981                	li	s3,0
 d84:	b565                	j	c2c <vprintf+0x60>
        s = va_arg(ap, char*);
 d86:	8b4a                	mv	s6,s2
      state = 0;
 d88:	4981                	li	s3,0
 d8a:	b54d                	j	c2c <vprintf+0x60>
    }
  }
}
 d8c:	70e6                	ld	ra,120(sp)
 d8e:	7446                	ld	s0,112(sp)
 d90:	74a6                	ld	s1,104(sp)
 d92:	7906                	ld	s2,96(sp)
 d94:	69e6                	ld	s3,88(sp)
 d96:	6a46                	ld	s4,80(sp)
 d98:	6aa6                	ld	s5,72(sp)
 d9a:	6b06                	ld	s6,64(sp)
 d9c:	7be2                	ld	s7,56(sp)
 d9e:	7c42                	ld	s8,48(sp)
 da0:	7ca2                	ld	s9,40(sp)
 da2:	7d02                	ld	s10,32(sp)
 da4:	6de2                	ld	s11,24(sp)
 da6:	6109                	addi	sp,sp,128
 da8:	8082                	ret

0000000000000daa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 daa:	715d                	addi	sp,sp,-80
 dac:	ec06                	sd	ra,24(sp)
 dae:	e822                	sd	s0,16(sp)
 db0:	1000                	addi	s0,sp,32
 db2:	e010                	sd	a2,0(s0)
 db4:	e414                	sd	a3,8(s0)
 db6:	e818                	sd	a4,16(s0)
 db8:	ec1c                	sd	a5,24(s0)
 dba:	03043023          	sd	a6,32(s0)
 dbe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 dc2:	8622                	mv	a2,s0
 dc4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 dc8:	00000097          	auipc	ra,0x0
 dcc:	e04080e7          	jalr	-508(ra) # bcc <vprintf>
}
 dd0:	60e2                	ld	ra,24(sp)
 dd2:	6442                	ld	s0,16(sp)
 dd4:	6161                	addi	sp,sp,80
 dd6:	8082                	ret

0000000000000dd8 <printf>:

void
printf(const char *fmt, ...)
{
 dd8:	711d                	addi	sp,sp,-96
 dda:	ec06                	sd	ra,24(sp)
 ddc:	e822                	sd	s0,16(sp)
 dde:	1000                	addi	s0,sp,32
 de0:	e40c                	sd	a1,8(s0)
 de2:	e810                	sd	a2,16(s0)
 de4:	ec14                	sd	a3,24(s0)
 de6:	f018                	sd	a4,32(s0)
 de8:	f41c                	sd	a5,40(s0)
 dea:	03043823          	sd	a6,48(s0)
 dee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 df2:	00840613          	addi	a2,s0,8
 df6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 dfa:	85aa                	mv	a1,a0
 dfc:	4505                	li	a0,1
 dfe:	00000097          	auipc	ra,0x0
 e02:	dce080e7          	jalr	-562(ra) # bcc <vprintf>
}
 e06:	60e2                	ld	ra,24(sp)
 e08:	6442                	ld	s0,16(sp)
 e0a:	6125                	addi	sp,sp,96
 e0c:	8082                	ret

0000000000000e0e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e0e:	1141                	addi	sp,sp,-16
 e10:	e422                	sd	s0,8(sp)
 e12:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e14:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e18:	00000797          	auipc	a5,0x0
 e1c:	5a07b783          	ld	a5,1440(a5) # 13b8 <freep>
 e20:	a02d                	j	e4a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 e22:	4618                	lw	a4,8(a2)
 e24:	9f2d                	addw	a4,a4,a1
 e26:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 e2a:	6398                	ld	a4,0(a5)
 e2c:	6310                	ld	a2,0(a4)
 e2e:	a83d                	j	e6c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 e30:	ff852703          	lw	a4,-8(a0)
 e34:	9f31                	addw	a4,a4,a2
 e36:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 e38:	ff053683          	ld	a3,-16(a0)
 e3c:	a091                	j	e80 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e3e:	6398                	ld	a4,0(a5)
 e40:	00e7e463          	bltu	a5,a4,e48 <free+0x3a>
 e44:	00e6ea63          	bltu	a3,a4,e58 <free+0x4a>
{
 e48:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e4a:	fed7fae3          	bgeu	a5,a3,e3e <free+0x30>
 e4e:	6398                	ld	a4,0(a5)
 e50:	00e6e463          	bltu	a3,a4,e58 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e54:	fee7eae3          	bltu	a5,a4,e48 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 e58:	ff852583          	lw	a1,-8(a0)
 e5c:	6390                	ld	a2,0(a5)
 e5e:	02059813          	slli	a6,a1,0x20
 e62:	01c85713          	srli	a4,a6,0x1c
 e66:	9736                	add	a4,a4,a3
 e68:	fae60de3          	beq	a2,a4,e22 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 e6c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 e70:	4790                	lw	a2,8(a5)
 e72:	02061593          	slli	a1,a2,0x20
 e76:	01c5d713          	srli	a4,a1,0x1c
 e7a:	973e                	add	a4,a4,a5
 e7c:	fae68ae3          	beq	a3,a4,e30 <free+0x22>
    p->s.ptr = bp->s.ptr;
 e80:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 e82:	00000717          	auipc	a4,0x0
 e86:	52f73b23          	sd	a5,1334(a4) # 13b8 <freep>
}
 e8a:	6422                	ld	s0,8(sp)
 e8c:	0141                	addi	sp,sp,16
 e8e:	8082                	ret

0000000000000e90 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e90:	7139                	addi	sp,sp,-64
 e92:	fc06                	sd	ra,56(sp)
 e94:	f822                	sd	s0,48(sp)
 e96:	f426                	sd	s1,40(sp)
 e98:	f04a                	sd	s2,32(sp)
 e9a:	ec4e                	sd	s3,24(sp)
 e9c:	e852                	sd	s4,16(sp)
 e9e:	e456                	sd	s5,8(sp)
 ea0:	e05a                	sd	s6,0(sp)
 ea2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ea4:	02051493          	slli	s1,a0,0x20
 ea8:	9081                	srli	s1,s1,0x20
 eaa:	04bd                	addi	s1,s1,15
 eac:	8091                	srli	s1,s1,0x4
 eae:	00148a1b          	addiw	s4,s1,1
 eb2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 eb4:	00000517          	auipc	a0,0x0
 eb8:	50453503          	ld	a0,1284(a0) # 13b8 <freep>
 ebc:	c515                	beqz	a0,ee8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ebe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ec0:	4798                	lw	a4,8(a5)
 ec2:	04977163          	bgeu	a4,s1,f04 <malloc+0x74>
 ec6:	89d2                	mv	s3,s4
 ec8:	000a071b          	sext.w	a4,s4
 ecc:	6685                	lui	a3,0x1
 ece:	00d77363          	bgeu	a4,a3,ed4 <malloc+0x44>
 ed2:	6985                	lui	s3,0x1
 ed4:	00098b1b          	sext.w	s6,s3
  p = sbrk(nu * sizeof(Header));
 ed8:	0049999b          	slliw	s3,s3,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 edc:	00000917          	auipc	s2,0x0
 ee0:	4dc90913          	addi	s2,s2,1244 # 13b8 <freep>
  if(p == (char*)-1)
 ee4:	5afd                	li	s5,-1
 ee6:	a8a5                	j	f5e <malloc+0xce>
    base.s.ptr = freep = prevp = &base;
 ee8:	00000797          	auipc	a5,0x0
 eec:	4d078793          	addi	a5,a5,1232 # 13b8 <freep>
 ef0:	00000717          	auipc	a4,0x0
 ef4:	4d070713          	addi	a4,a4,1232 # 13c0 <base>
 ef8:	e398                	sd	a4,0(a5)
 efa:	e798                	sd	a4,8(a5)
    base.s.size = 0;
 efc:	0007a823          	sw	zero,16(a5)
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f00:	87ba                	mv	a5,a4
 f02:	b7d1                	j	ec6 <malloc+0x36>
      if(p->s.size == nunits)
 f04:	02e48c63          	beq	s1,a4,f3c <malloc+0xac>
        p->s.size -= nunits;
 f08:	4147073b          	subw	a4,a4,s4
 f0c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 f0e:	02071693          	slli	a3,a4,0x20
 f12:	01c6d713          	srli	a4,a3,0x1c
 f16:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 f18:	0147a423          	sw	s4,8(a5)
      freep = prevp;
 f1c:	00000717          	auipc	a4,0x0
 f20:	48a73e23          	sd	a0,1180(a4) # 13b8 <freep>
      return (void*)(p + 1);
 f24:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 f28:	70e2                	ld	ra,56(sp)
 f2a:	7442                	ld	s0,48(sp)
 f2c:	74a2                	ld	s1,40(sp)
 f2e:	7902                	ld	s2,32(sp)
 f30:	69e2                	ld	s3,24(sp)
 f32:	6a42                	ld	s4,16(sp)
 f34:	6aa2                	ld	s5,8(sp)
 f36:	6b02                	ld	s6,0(sp)
 f38:	6121                	addi	sp,sp,64
 f3a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 f3c:	6398                	ld	a4,0(a5)
 f3e:	e118                	sd	a4,0(a0)
 f40:	bff1                	j	f1c <malloc+0x8c>
  hp->s.size = nu;
 f42:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 f46:	0541                	addi	a0,a0,16
 f48:	00000097          	auipc	ra,0x0
 f4c:	ec6080e7          	jalr	-314(ra) # e0e <free>
  return freep;
 f50:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 f54:	d971                	beqz	a0,f28 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f56:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 f58:	4798                	lw	a4,8(a5)
 f5a:	fa9775e3          	bgeu	a4,s1,f04 <malloc+0x74>
    if(p == freep)
 f5e:	00093703          	ld	a4,0(s2)
 f62:	853e                	mv	a0,a5
 f64:	fef719e3          	bne	a4,a5,f56 <malloc+0xc6>
  p = sbrk(nu * sizeof(Header));
 f68:	854e                	mv	a0,s3
 f6a:	00000097          	auipc	ra,0x0
 f6e:	a20080e7          	jalr	-1504(ra) # 98a <sbrk>
  if(p == (char*)-1)
 f72:	fd5518e3          	bne	a0,s5,f42 <malloc+0xb2>
        return 0;
 f76:	4501                	li	a0,0
 f78:	bf45                	j	f28 <malloc+0x98>
