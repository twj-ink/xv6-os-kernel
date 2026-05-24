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
	.string	"[LRU]"
	.align	3
.LC3:
	.string	"2"
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
	.string	"test_vm_lru"
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
	.string	"\ninit: process pid=%d exited\n"
	.align	3
.LC12:
	.string	"\ninit: test execution completed, starting judger\n\n"
	.align	3
.LC13:
	.string	"judger"
	.align	3
.LC14:
	.string	"exec judger failed\n"
	.align	3
.LC15:
	.string	"\ninit: judger completed\n"
	.text
	.align	1
	.globl	run_scheduler_test
	.type	run_scheduler_test, @function
run_scheduler_test:
	addi	sp,sp,-96
	lla	a0,.LC5
	sd	s3,56(sp)
	sd	ra,88(sp)
	sd	s0,80(sp)
	sd	s1,72(sp)
	sd	s2,64(sp)
	lla	s3,.LANCHOR0
	call	print_test_program
	ld	a5,0(s3)
	lbu	a4,0(a5)
	li	a5,48
	bne	a4,a5,.L4
.L12:
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
.L13:
	call	printf@plt
	j	.L12
.L5:
	call	fork@plt
	bge	a0,zero,.L6
	lla	a0,.LC8
	call	printf@plt
	lw	a0,8(sp)
	call	close@plt
	lw	a0,12(sp)
	call	close@plt
	j	.L12
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
	j	.L12
.L7:
	lw	a0,12(sp)
	li	s0,0
	li	s1,1023
	call	close@plt
	lla	s2,.LANCHOR1+8
.L8:
	lw	a0,8(sp)
	subw	a2,s1,s0
	add	a1,s2,s0
	call	read@plt
	bgt	a0,zero,.L9
	lla	a5,.LANCHOR1
	add	a5,a5,s0
	sb	zero,8(a5)
	lla	a2,.LANCHOR1+8
	mv	a1,s0
	lla	a0,.LC10
	call	printf@plt
	lw	a0,8(sp)
	addi	s0,sp,4
	lla	s1,.LC13
	call	close@plt
	mv	a0,s0
	call	wait@plt
	mv	a1,a0
	lla	a0,.LC11
	call	printf@plt
	lla	a0,.LC12
	call	printf@plt
	ld	a5,0(s3)
	sd	s1,16(sp)
	sd	s2,32(sp)
	sd	a5,24(sp)
	sd	zero,40(sp)
	call	fork@plt
	bne	a0,zero,.L10
	addi	a1,sp,16
	mv	a0,s1
	call	exec@plt
	lla	a0,.LC14
	j	.L13
.L9:
	addw	s0,s0,a0
	j	.L8
.L10:
	mv	a0,s0
	call	wait@plt
	lla	a0,.LC15
	call	printf@plt
	ld	ra,88(sp)
	ld	s0,80(sp)
	ld	s1,72(sp)
	ld	s2,64(sp)
	ld	s3,56(sp)
	addi	sp,sp,96
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
.LC16:
	.string	"0"
	.globl	output_lengths
	.globl	test_outputs
	.globl	cycles
	.globl	syscall_tests
	.align	3
.LC17:
	.string	"brk"
	.align	3
.LC18:
	.string	"mmap"
	.align	3
.LC19:
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
	.dword	.LC16
	.type	syscall_tests, @object
	.size	syscall_tests, 24
syscall_tests:
	.dword	.LC17
	.dword	.LC18
	.dword	.LC19
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
