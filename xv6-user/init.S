	.file	"init.c"
	.option pic
	.option norelax
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"Starting test program: [%s]\n"
	.align	3
.LC1:
	.string	"Scheduler type: "
	.align	3
.LC2:
	.string	"Unknown"
	.align	3
.LC3:
	.string	"\n\n"
	.text
	.align	1
	.globl	print_test_program
	.type	print_test_program, @function
print_test_program:
	addi	sp,sp,-16
	mv	a1,a0
	lla	a0,.LC0
	sd	ra,8(sp)
	call	printf@plt
	lla	a0,.LC1
	call	printf@plt
	lla	a0,.LC2
	call	printf@plt
	ld	ra,8(sp)
	lla	a0,.LC3
	addi	sp,sp,16
	tail	printf@plt
	.size	print_test_program, .-print_test_program
	.section	.rodata.str1.8
	.align	3
.LC4:
	.string	"PASSED"
	.align	3
.LC5:
	.string	"FAILED"
	.align	3
.LC6:
	.string	"test_mem_lazy_allocation"
	.align	3
.LC7:
	.string	"\ninit: starting Part 5 test [%s]\n"
	.align	3
.LC8:
	.string	"init: pipe failed\n"
	.align	3
.LC9:
	.string	"init: fork failed\n"
	.align	3
.LC10:
	.string	"init: exec %s failed\n"
	.align	3
.LC11:
	.string	"testing output size:%d, contents:\n\n%s"
	.align	3
.LC12:
	.string	"\n\ninit: test execution completed, starting judger\n\n"
	.align	3
.LC13:
	.string	"Test%s %s\n"
	.align	3
.LC14:
	.string	"SCORE: %d\n"
	.text
	.align	1
	.globl	run_scheduler_test
	.type	run_scheduler_test, @function
run_scheduler_test:
	addi	sp,sp,-64
	lla	a1,.LC6
	lla	a0,.LC7
	sd	ra,56(sp)
	sd	s0,48(sp)
	sd	s1,40(sp)
	sd	s2,32(sp)
	sd	s3,24(sp)
	call	printf@plt
	addi	a0,sp,8
	sd	zero,8(sp)
	call	pipe@plt
	li	a5,-1
	bne	a0,a5,.L4
	lla	a0,.LC8
	call	printf@plt
.L15:
	li	a0,1
	call	exit@plt
.L4:
	call	fork@plt
	bge	a0,zero,.L5
	lla	a0,.LC9
	call	printf@plt
	lw	a0,8(sp)
	call	close@plt
	lw	a0,12(sp)
	call	close@plt
	j	.L15
.L5:
	bne	a0,zero,.L6
	lw	a0,8(sp)
	call	close@plt
	li	a0,1
	call	close@plt
	lw	a0,12(sp)
	call	dup@plt
	lw	a0,12(sp)
	call	close@plt
	lla	a1,.LANCHOR0+1024
	lla	a0,.LC6
	call	exec@plt
	lla	a1,.LC6
	lla	a0,.LC10
	call	printf@plt
	j	.L15
.L6:
	lw	a0,12(sp)
	li	s0,0
	li	s2,1023
	call	close@plt
	lla	s3,.LANCHOR0
.L7:
	lw	a0,8(sp)
	add	s1,s3,s0
	subw	a2,s2,s0
	mv	a1,s1
	call	read@plt
	bgt	a0,zero,.L8
	lla	a2,.LANCHOR0
	mv	a1,s0
	lla	a0,.LC11
	sb	zero,0(s1)
	call	printf@plt
	lw	a0,8(sp)
	call	close@plt
	addi	a0,sp,4
	call	wait@plt
	lla	a0,.LC12
	call	printf@plt
	lla	a5,.LANCHOR0
	li	a2,67
	li	a1,111
	li	a0,109
	li	a6,112
	li	a7,108
	li	a3,101
	li	t1,116
	li	t3,100
	li	t4,32
	li	t5,83
	li	t6,117
.L9:
	lbu	a4,0(a5)
	bne	a4,zero,.L12
	li	s0,0
	lla	a2,.LC5
.L11:
	lla	a1,.LC6
	lla	a0,.LC13
	call	printf@plt
	mv	a1,s0
	lla	a0,.LC14
	call	printf@plt
	ld	ra,56(sp)
	ld	s0,48(sp)
	ld	s1,40(sp)
	ld	s2,32(sp)
	ld	s3,24(sp)
	addi	sp,sp,64
	jr	ra
.L8:
	addw	s0,s0,a0
	j	.L7
.L12:
	bne	a4,a2,.L10
	lbu	a4,1(a5)
	bne	a4,a1,.L10
	lbu	a4,2(a5)
	bne	a4,a0,.L10
	lbu	a4,3(a5)
	bne	a4,a6,.L10
	lbu	a4,4(a5)
	bne	a4,a7,.L10
	lbu	a4,5(a5)
	bne	a4,a3,.L10
	lbu	a4,6(a5)
	bne	a4,t1,.L10
	lbu	a4,7(a5)
	bne	a4,a3,.L10
	lbu	a4,8(a5)
	bne	a4,t3,.L10
	lbu	a4,9(a5)
	bne	a4,t4,.L10
	lbu	a4,10(a5)
	bne	a4,t5,.L10
	lbu	a4,11(a5)
	beq	a4,t6,.L13
.L10:
	addi	a5,a5,1
	j	.L9
.L13:
	li	s0,1
	lla	a2,.LC4
	j	.L11
	.size	run_scheduler_test, .-run_scheduler_test
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	li	a2,0
	li	a1,1
	li	a0,2
	sd	ra,8(sp)
	call	dev@plt
	li	a0,0
	call	dup@plt
	li	a0,0
	call	dup@plt
	call	run_scheduler_test
	call	shutdown@plt
	ld	ra,8(sp)
	li	a0,0
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.globl	order
	.section	.rodata.str1.8
	.align	3
.LC15:
	.string	"0"
	.globl	output_lengths
	.globl	test_outputs
	.globl	cycles
	.globl	syscall_tests
	.align	3
.LC16:
	.string	"brk"
	.align	3
.LC17:
	.string	"mmap"
	.align	3
.LC18:
	.string	"munmap"
	.globl	argv
	.data
	.align	2
	.type	cycles, @object
	.size	cycles, 4
cycles:
	.word	3
	.bss
	.align	3
	.set	.LANCHOR0,. + 0
	.type	test_outputs, @object
	.size	test_outputs, 1024
test_outputs:
	.zero	1024
	.type	argv, @object
	.size	argv, 8
argv:
	.zero	8
	.type	output_lengths, @object
	.size	output_lengths, 4
output_lengths:
	.zero	4
	.section	.data.rel.local,"aw"
	.align	3
	.type	order, @object
	.size	order, 8
order:
	.dword	.LC15
	.type	syscall_tests, @object
	.size	syscall_tests, 24
syscall_tests:
	.dword	.LC16
	.dword	.LC17
	.dword	.LC18
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
