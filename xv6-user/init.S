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
	.string	"[MLFQ]"
	.align	3
.LC3:
	.string	"3"
	.align	3
.LC4:
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
	lla	a5,.LC3
	sd	a5,.LANCHOR0,a4
	lla	a0,.LC4
	addi	sp,sp,16
	tail	printf@plt
	.size	print_test_program, .-print_test_program
	.section	.rodata.str1.8
	.align	3
.LC5:
	.string	"test_proc_mlfq"
	.align	3
.LC6:
	.string	"init: starting [%s]\n"
	.align	3
.LC7:
	.string	"init: pipe failed\n"
	.align	3
.LC8:
	.string	"init: fork failed\n"
	.align	3
.LC9:
	.string	"init: exec %s failed\n"
	.align	3
.LC10:
	.string	"testing output size:%d, contents:\n\n%s"
	.align	3
.LC11:
	.string	"\ninit: no more child processes, break\n"
	.align	3
.LC12:
	.string	"\ninit: process pid=%d exited\n"
	.align	3
.LC13:
	.string	"\ninit: test execution completed, starting judger\n\n"
	.align	3
.LC14:
	.string	"judger"
	.align	3
.LC15:
	.string	"exec judger failed\n"
	.align	3
.LC16:
	.string	"\ninit: judger completed\n"
	.text
	.align	1
	.globl	run_scheduler_test
	.type	run_scheduler_test, @function
run_scheduler_test:
	addi	sp,sp,-112
	lla	a0,.LC5
	sd	s1,88(sp)
	sd	ra,104(sp)
	sd	s0,96(sp)
	sd	s2,80(sp)
	sd	s3,72(sp)
	sd	s4,64(sp)
	sd	s5,56(sp)
	lla	s1,.LANCHOR0
	call	print_test_program
	ld	a5,0(s1)
	lbu	a4,0(a5)
	li	a5,48
	bne	a4,a5,.L4
.L15:
	li	a0,1
	call	exit@plt
.L4:
	lla	a1,.LC5
	lla	a0,.LC6
	call	printf@plt
	addi	a0,sp,8
	sd	zero,8(sp)
	call	pipe@plt
	li	a5,-1
	bne	a0,a5,.L5
	lla	a0,.LC7
.L16:
	call	printf@plt
	j	.L15
.L5:
	call	fork@plt
	bge	a0,zero,.L6
	lla	a0,.LC8
	call	printf@plt
	lw	a0,8(sp)
	call	close@plt
	lw	a0,12(sp)
	call	close@plt
	j	.L15
.L6:
	bne	a0,zero,.L7
	lw	a0,8(sp)
	call	close@plt
	li	a0,1
	call	close@plt
	lw	a0,12(sp)
	call	dup@plt
	lw	a0,12(sp)
	call	close@plt
	lla	a1,.LANCHOR1
	lla	a0,.LC5
	call	exec@plt
	lla	a1,.LC5
	lla	a0,.LC9
	call	printf@plt
	j	.L15
.L7:
	lw	a0,12(sp)
	li	s0,0
	lla	s2,.LANCHOR1
	call	close@plt
	li	a2,1023
	lla	s3,.LANCHOR1+8
	li	s4,1023
	li	s5,100
.L8:
	lw	a0,8(sp)
	add	a1,s3,s0
	call	read@plt
	bgt	a0,zero,.L10
	add	a5,s2,s0
	mv	a1,s0
	sb	zero,8(a5)
	lla	a2,.LANCHOR1+8
	lla	a0,.LC10
	sw	s0,1032(s2)
	call	printf@plt
	lw	a0,8(sp)
	addi	s0,sp,4
	call	close@plt
	mv	a0,s0
	call	wait@plt
	li	a5,-1
	mv	a1,a0
	bne	a0,a5,.L11
	lla	a0,.LC11
	call	printf@plt
.L12:
	lla	a0,.LC13
	call	printf@plt
	ld	a5,0(s1)
	lla	s2,.LC14
	sd	s2,16(sp)
	sd	a5,24(sp)
	sd	s3,32(sp)
	sd	zero,40(sp)
	call	fork@plt
	bne	a0,zero,.L13
	addi	a1,sp,16
	mv	a0,s2
	call	exec@plt
	lla	a0,.LC15
	j	.L16
.L10:
	addw	s0,s0,a0
	subw	a5,s4,s0
	mv	a2,a5
	bge	a5,s5,.L8
	li	a2,100
	j	.L8
.L11:
	ble	a0,zero,.L12
	lla	a0,.LC12
	call	printf@plt
	j	.L12
.L13:
	mv	a0,s0
	call	wait@plt
	lla	a0,.LC16
	call	printf@plt
	ld	ra,104(sp)
	ld	s0,96(sp)
	ld	s1,88(sp)
	ld	s2,80(sp)
	ld	s3,72(sp)
	ld	s4,64(sp)
	ld	s5,56(sp)
	addi	sp,sp,112
	jr	ra
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
.LC17:
	.string	"0"
	.globl	output_lengths
	.globl	test_outputs
	.globl	cycles
	.globl	syscall_tests
	.align	3
.LC18:
	.string	"open"
	.align	3
.LC19:
	.string	"openat"
	.align	3
.LC20:
	.string	"mkdir_"
	.globl	argv
	.data
	.align	2
	.type	cycles, @object
	.size	cycles, 4
cycles:
	.word	3
	.bss
	.align	3
	.set	.LANCHOR1,. + 0
	.type	argv, @object
	.size	argv, 8
argv:
	.zero	8
	.type	test_outputs, @object
	.size	test_outputs, 1024
test_outputs:
	.zero	1024
	.type	output_lengths, @object
	.size	output_lengths, 4
output_lengths:
	.zero	4
	.section	.data.rel.local,"aw"
	.align	3
	.set	.LANCHOR0,. + 0
	.type	order, @object
	.size	order, 8
order:
	.dword	.LC17
	.type	syscall_tests, @object
	.size	syscall_tests, 24
syscall_tests:
	.dword	.LC18
	.dword	.LC19
	.dword	.LC20
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
