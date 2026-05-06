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
	.string	"test_mem_cow"
	.align	3
.LC5:
	.string	"\ninit: starting Part 5 test [%s]\n"
	.align	3
.LC6:
	.string	"init: fork failed\n"
	.align	3
.LC7:
	.string	"init: exec %s failed\n"
	.align	3
.LC8:
	.string	"init: wait returned an error\n"
	.text
	.align	1
	.globl	run_scheduler_test
	.type	run_scheduler_test, @function
run_scheduler_test:
	addi	sp,sp,-48
	lla	a1,.LC4
	lla	a0,.LC5
	sd	ra,40(sp)
	sd	s0,32(sp)
	sd	s1,24(sp)
	call	printf@plt
	call	fork@plt
	bge	a0,zero,.L4
	lla	a0,.LC6
.L11:
	call	printf@plt
	j	.L10
.L4:
	mv	s0,a0
	addi	s1,sp,12
	bne	a0,zero,.L5
	lla	a1,.LANCHOR0
	lla	a0,.LC4
	call	exec@plt
	lla	a1,.LC4
	lla	a0,.LC7
	call	printf@plt
.L10:
	li	a0,1
	call	exit@plt
.L5:
	mv	a0,s1
	call	wait@plt
	beq	s0,a0,.L3
	bge	a0,zero,.L5
	lla	a0,.LC8
	j	.L11
.L3:
	ld	ra,40(sp)
	ld	s0,32(sp)
	ld	s1,24(sp)
	addi	sp,sp,48
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
.LC9:
	.string	"0"
	.globl	output_lengths
	.globl	test_outputs
	.globl	cycles
	.globl	syscall_tests
	.align	3
.LC10:
	.string	"brk"
	.align	3
.LC11:
	.string	"mmap"
	.align	3
.LC12:
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
	.type	argv, @object
	.size	argv, 8
argv:
	.zero	8
	.type	output_lengths, @object
	.size	output_lengths, 4
output_lengths:
	.zero	4
	.zero	4
	.type	test_outputs, @object
	.size	test_outputs, 1024
test_outputs:
	.zero	1024
	.section	.data.rel.local,"aw"
	.align	3
	.type	order, @object
	.size	order, 8
order:
	.dword	.LC9
	.type	syscall_tests, @object
	.size	syscall_tests, 24
syscall_tests:
	.dword	.LC10
	.dword	.LC11
	.dword	.LC12
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
