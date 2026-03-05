	.file	"init.c"
	.option pic
	.option norelax
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\ninit: starting to test [%s]\n"
	.align	3
.LC1:
	.string	"init: fork failed\n"
	.align	3
.LC2:
	.string	"init: exec [%s] failed\n"
	.align	3
.LC3:
	.string	"init: wait returned an error\n"
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-64
	li	a2,0
	li	a1,1
	li	a0,2
	sd	ra,56(sp)
	sd	s0,48(sp)
	sd	s2,32(sp)
	sd	s3,24(sp)
	sd	s4,16(sp)
	sd	s5,8(sp)
	sd	s1,40(sp)
	call	dev@plt
	li	a0,0
	call	dup@plt
	li	a0,0
	lla	s2,.LANCHOR0
	call	dup@plt
	li	s0,0
	mv	s3,s2
	lla	s4,.LANCHOR2
	lla	s5,.LC0
.L2:
	lw	a5,0(s4)
	bgt	a5,s0,.L6
	ld	ra,56(sp)
	ld	s0,48(sp)
	ld	s1,40(sp)
	ld	s2,32(sp)
	ld	s3,24(sp)
	ld	s4,16(sp)
	ld	s5,8(sp)
	li	a0,0
	addi	sp,sp,64
	jr	ra
.L6:
	ld	a1,0(s2)
	mv	a0,s5
	call	printf@plt
	call	fork@plt
	mv	s1,a0
	bge	a0,zero,.L3
	lla	a0,.LC1
.L11:
	call	printf@plt
	j	.L10
.L3:
	bne	a0,zero,.L4
	slli	s0,s0,3
	add	s0,s3,s0
	ld	a0,0(s0)
	lla	a1,.LANCHOR1
	call	exec@plt
	ld	a1,0(s0)
	lla	a0,.LC2
	call	printf@plt
.L10:
	li	a0,1
	call	exit@plt
.L4:
	li	a0,0
	call	wait@plt
	beq	s1,a0,.L5
	bge	a0,zero,.L4
	lla	a0,.LC3
	j	.L11
.L5:
	addiw	s0,s0,1
	addi	s2,s2,8
	j	.L2
	.size	main, .-main
	.globl	cycles
	.globl	tests
	.section	.rodata.str1.8
	.align	3
.LC4:
	.string	"write"
	.align	3
.LC5:
	.string	"getpid"
	.align	3
.LC6:
	.string	"getcwd"
	.align	3
.LC7:
	.string	"times"
	.align	3
.LC8:
	.string	"uname"
	.globl	argv
	.data
	.align	2
	.set	.LANCHOR2,. + 0
	.type	cycles, @object
	.size	cycles, 4
cycles:
	.word	5
	.bss
	.align	3
	.set	.LANCHOR1,. + 0
	.type	argv, @object
	.size	argv, 8
argv:
	.zero	8
	.section	.data.rel.local,"aw"
	.align	3
	.set	.LANCHOR0,. + 0
	.type	tests, @object
	.size	tests, 40
tests:
	.dword	.LC4
	.dword	.LC5
	.dword	.LC6
	.dword	.LC7
	.dword	.LC8
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
