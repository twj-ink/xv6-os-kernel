# platform	:= k210
platform	:= qemu
# mode := debug
mode := release
K=kernel
U=xv6-user
T=target
##### 功能性测试 #####
TEST=xv6-user/testcases
##### 功能性测试 #####

OBJS = $K/entry_qemu.o

OBJS += \
  $K/printf.o \
  $K/kalloc.o \
  $K/intr.o \
  $K/spinlock.o \
  $K/string.o \
  $K/main.o \
  $K/vm.o \
  $K/proc.o \
  $K/swtch.o \
  $K/trampoline.o \
  $K/trap.o \
  $K/syscall.o \
  $K/sysproc.o \
  $K/bio.o \
  $K/sleeplock.o \
  $K/file.o \
  $K/pipe.o \
  $K/exec.o \
  $K/sysfile.o \
  $K/kernelvec.o \
  $K/timer.o \
  $K/disk.o \
  $K/fat32.o \
  $K/plic.o \
  $K/console.o \
  $K/swap.o \
  $K/vma_util.o

OBJS += \
  $K/virtio_disk.o \
  #$K/uart.o \

QEMU = qemu-system-riscv64

RUSTSBI = ./bootloader/SBI/sbi-qemu

# TOOLPREFIX	:= riscv64-unknown-elf-
TOOLPREFIX	:= riscv64-linux-gnu-
CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb -g
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

##### 功能性测试 #####
# 支持外部传入的编译标志
CFLAGS += $(EXTRA_CFLAGS)

ifeq ($(mode), debug) 
CFLAGS += -DDEBUG 
endif 

CFLAGS += -D QEMU

##### Part 4: 调度算法测试配置 #####
# 默认调度器类型（简化版RR），仅在未设 TYPE 时生效
SCHEDULER_TYPE ?= RR
ifeq ($(TYPE),)
ifeq ($(ALGO),)

# 根据调度器类型设置对应的测试程序
ifeq ($(SCHEDULER_TYPE), RR)
		TEST_PROGRAM = test_proc_rr
		CFLAGS += -DSCHEDULER_RR
else ifeq ($(SCHEDULER_TYPE), PRIORITY)
		TEST_PROGRAM = test_proc_priority
		CFLAGS += -DSCHEDULER_PRIORITY
else ifeq ($(SCHEDULER_TYPE), MLFQ)
		TEST_PROGRAM = test_proc_mlfq
		CFLAGS += -DSCHEDULER_MLFQ
else
		$(error Unknown scheduler type: $(SCHEDULER_TYPE))
endif

# 将测试程序名编译进内核
CFLAGS += -DTEST_PROGRAM=\"$(TEST_PROGRAM)\"

# 用户程序编译标志
USER_CFLAGS =

# 如果启用了judger自动化测试框架
ifeq ($(ENABLE_JUDGER), 1)
		USER_CFLAGS += -DENABLE_JUDGER=1
		# 传递调度器类型到用户程序
		ifeq ($(SCHEDULER_TYPE), RR)
			USER_CFLAGS += -DSCHEDULER_RR
		else ifeq ($(SCHEDULER_TYPE), PRIORITY)
			USER_CFLAGS += -DSCHEDULER_PRIORITY
		else ifeq ($(SCHEDULER_TYPE), MLFQ)
			USER_CFLAGS += -DSCHEDULER_MLFQ
		endif
		USER_CFLAGS += -DTEST_PROGRAM=\"$(TEST_PROGRAM)\"
else
		# 普通模式：传递调度器类型给用户程序
		ifeq ($(SCHEDULER_TYPE), RR)
			USER_CFLAGS += -DSCHEDULER_RR
		else ifeq ($(SCHEDULER_TYPE), PRIORITY)
			USER_CFLAGS += -DSCHEDULER_PRIORITY
		else ifeq ($(SCHEDULER_TYPE), MLFQ)
			USER_CFLAGS += -DSCHEDULER_MLFQ
		endif
		USER_CFLAGS += -DTEST_PROGRAM=\"$(TEST_PROGRAM)\"
endif

# 支持外部传入的用户编译标志
USER_CFLAGS += $(EXTRA_CFLAGS)
endif
endif
##### Part 4: 调度算法测试配置 #####

##### Part 5: 内存/进程测试配置 #####
TYPE ?=

ifneq ($(TYPE),)
	# ======== Part 5 ========
	ifeq ($(TYPE), COW)
		override TEST_PROGRAM = test_mem_cow
		CFLAGS += -DTEST_COW=1
		USER_CFLAGS += -DTEST_COW=1
	else ifeq ($(TYPE), LAZY)
		override TEST_PROGRAM = test_mem_lazy_allocation
		CFLAGS += -DTEST_LAZY=1
		USER_CFLAGS += -DTEST_LAZY=1
	else
		$(error Unknown test type: $(TYPE))
	endif
	CFLAGS += -DTEST_PROGRAM=\"$(TEST_PROGRAM)\"
	USER_CFLAGS += -DTEST_PROGRAM=\"$(TEST_PROGRAM)\"
	ifeq ($(ENABLE_JUDGER), 1)
		USER_CFLAGS += -DENABLE_JUDGER=1
	endif
endif
##### Part 5: 内存/进程测试配置 #####

##### Part 6: 页面置换算法测试配置 #####
ALGO ?=

ifneq ($(ALGO),)
	ifeq ($(ALGO), FIFO)
		override TEST_PROGRAM = test_vm_fifo
		CFLAGS += -DALGO_FIFO
		USER_CFLAGS += -DALGO_FIFO
	else ifeq ($(ALGO), LRU)
		override TEST_PROGRAM = test_vm_lru
		CFLAGS += -DALGO_LRU
		USER_CFLAGS += -DALGO_LRU
	else
		$(error Unknown algo: $(ALGO))
	endif
	CFLAGS += -DTEST_PROGRAM=\"$(TEST_PROGRAM)\"
	USER_CFLAGS += -DTEST_PROGRAM=\"$(TEST_PROGRAM)\"
	ifeq ($(ENABLE_JUDGER), 1)
		USER_CFLAGS += -DENABLE_JUDGER=1
	endif
endif
##### Part 6: 页面置换算法测试配置 #####

LDFLAGS = -z max-page-size=4096

linker = ./linker/qemu.ld

# Compile Kernel
$T/kernel: $(OBJS) $(linker) $U/initcode
	@if [ ! -d "./target" ]; then mkdir target; fi
	@$(LD) $(LDFLAGS) -T $(linker) -o $T/kernel $(OBJS)
	@$(OBJDUMP) -S $T/kernel > $T/kernel.asm
	@$(OBJDUMP) -t $T/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $T/kernel.sym
  
build: $T/kernel userprogs

# Compile RustSBI
RUSTSBI:
	@cd ./bootloader/SBI/rustsbi-qemu && cargo build && cp ./target/riscv64gc-unknown-none-elf/debug/rustsbi-qemu ../sbi-qemu
	@$(OBJDUMP) -S ./bootloader/SBI/sbi-qemu > $T/rustsbi-qemu.asm

rustsbi-clean:
	@cd ./bootloader/SBI/rustsbi-k210 && cargo clean
	@cd ./bootloader/SBI/rustsbi-qemu && cargo clean

image = $T/kernel.bin

ifndef CPUS
CPUS := 1
endif

QEMUOPTS = -machine virt -kernel $T/kernel -m 32M -nographic

# use multi-core 
QEMUOPTS += -smp $(CPUS)

QEMUOPTS += -bios $(RUSTSBI)

# import virtual disk image
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0 
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

# 普通运行命令（类似之前的local，但不清理）
run: build
	@$(QEMU) $(QEMUOPTS)



$U/initcode: $U/initcode.S
	$(CC) $(CFLAGS) -march=rv64g -nostdinc -I. -Ikernel -c $U/initcode.S -o $U/initcode.o
	$(LD) $(LDFLAGS) -N -e start -Ttext 0 -o $U/initcode.out $U/initcode.o
	$(OBJCOPY) -S -O binary $U/initcode.out $U/initcode
	$(OBJDUMP) -S $U/initcode.o > $U/initcode.asm

tags: $(OBJS) _init
	@etags *.S *.c

ULIB = $U/ulib.o $U/usys.o $U/printf.o $U/umalloc.o

_%: %.o $(ULIB)
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^
	$(OBJDUMP) -S $@ > $*.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $*.sym

$U/usys.S : $U/usys.pl
	@perl $U/usys.pl > $U/usys.S

$U/usys.o : $U/usys.S
	$(CC) $(CFLAGS) -c -o $U/usys.o $U/usys.S

$U/_forktest: $U/forktest.o $(ULIB)
	# forktest has less library code linked in - needs to be small
	# in order to be able to max out the proc table.
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $U/_forktest $U/forktest.o $U/ulib.o $U/usys.o
	$(OBJDUMP) -S $U/_forktest > $U/forktest.asm

# Prevent deletion of intermediate files, e.g. cat.o, after first build, so
# that disk image changes after first build are persistent until clean.  More
# details:
# http://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.PRECIOUS: %.o

UPROGS=\
	$U/_init\
	$U/_sh\
	$U/_cat\
	$U/_echo\
	$U/_grep\
	$U/_ls\
	$U/_kill\
	$U/_mkdir\
	$U/_xargs\
	$U/_sleep\
	$U/_find\
	$U/_rm\
	$U/_wc\
	$U/_test\
	$U/_usertests\
	$U/_strace\
	$U/_mv\

##### Part 4 & Part 5: 测试用例编译 #####
TESTCASES=\
	$(TEST)/_judger\
	$(TEST)/_$(TEST_PROGRAM)

# 编译测试用例的规则（cc 生成 .o，ld 链接）
$(TEST)/%: $(TEST)/%.c $(ULIB)
	$(CC) $(USER_CFLAGS) -c -o $(TEST)/$*.o $(TEST)/$*.c
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $(TEST)/$*.o $(ULIB)
	@$(OBJDUMP) -S $@ > $(TEST)/$*.asm
##### Part 4 & Part 5: 测试用例编译 #####

userprogs: $(UPROGS)

dst=/mnt

# Make fs image
fs: $(UPROGS) $(TESTCASES)
	@if [ ! -f "fs.img" ]; then \
		echo "making fs image..."; \
		dd if=/dev/zero of=fs.img bs=512k count=512; \
		mkfs.vfat -F 32 fs.img; fi
	@mount fs.img $(dst)
	@if [ ! -d "$(dst)/bin" ]; then mkdir $(dst)/bin; fi
	@cp README $(dst)/README
	@for file in $$( ls $U/_* ); do \
		cp $$file $(dst)/$${file#$U/_};\
		cp $$file $(dst)/bin/$${file#$U/_}; done
	@for file in $$( ls $(TEST)/_* ); do \
		cp $$file $(dst)/$${file#$(TEST)/_}; done
	@cp -r ./riscv64/* $(dst)
	@umount $(dst)

# Write mounted sdcard
sdcard: userprogs
	@if [ ! -d "$(dst)/bin" ]; then mkdir $(dst)/bin; fi
	@for file in $$( ls $U/_* ); do \
		cp $$file $(dst)/bin/$${file#$U/_}; done
	@cp $U/_init $(dst)/init
	@cp $U/_sh $(dst)/sh
	@cp README $(dst)/README

dump: userprogs
	$(CC) $(USER_CFLAGS) -Os -ffreestanding -fno-common -nostdlib -mno-relax -I. -Ikernel -S $U/init.c -o $U/init.S
	$(CC) $(USER_CFLAGS) -Os -s -fno-unroll-loops -fmerge-all-constants -ffreestanding -fno-common -nostdlib -mno-relax -I. -Ikernel -c $U/init.c -o $U/init.o
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $U/_init $U/init.o $U/usys.o $U/printf.o
	$(OBJCOPY) -S -O binary $U/_init oo
	$(OBJDUMP) -S $U/_init > $U/init.asm
	od -v -t x1 -An oo | sed -E 's/ (.{2})/0x\1,/g' > kernel/include/initcode.h
	rm oo

clean: 
	rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*/*.o */*.d */*.asm */*.sym \
	$T/* \
	$U/initcode $U/initcode.out \
	$K/kernel \
	.gdbinit \
	$U/usys.S \
	$(UPROGS) \
	$(TEST)/*.d $(TEST)/*.o $(TEST)/*.asm $(TEST)/*.sym $(TEST)/_* \
	$(TESTCASES)
	
# 希冀平台所使用的编译命令
all:
	@$(MAKE) clean
	@$(MAKE) dump
	@$(MAKE) build
	@cp $(T)/kernel ./kernel-qemu
	@cp ./bootloader/SBI/sbi-qemu ./sbi-qemu

QEMUOPTS_GDB = $(QEMUOPTS) -S -gdb tcp::1234,server,nowait

gdb: build
	@echo "====== Running QEMU with GDB support... ======"
	@echo "In another terminal, run: 'gdb-multiarch target/kernel', then type 'c' to continue"
	@echo "=============================================="
	$(QEMU) $(QEMUOPTS_GDB)

# local命令：完全类似之前的行为
local:
	@$(MAKE) clean
	@$(MAKE) dump
	@$(MAKE) build
	@$(MAKE) fs
	@$(MAKE) run

##### Part 4 & Part 5: 自动化测试命令 #####
# 使用方法：
#   Part 4: make run_test SCHEDULER_TYPE=RR|PRIORITY|MLFQ
#   Part 5: make run_test TYPE=COW|LAZY
run_test:
	@$(MAKE) clean
	@$(MAKE) dump ENABLE_JUDGER=1
	@$(MAKE) build ENABLE_JUDGER=1
	@$(MAKE) fs ENABLE_JUDGER=1
	@$(MAKE) run ENABLE_JUDGER=1

# Part 4 快捷命令
test-rr:
	@$(MAKE) run_test SCHEDULER_TYPE=RR

test-mlfq:
	@$(MAKE) run_test SCHEDULER_TYPE=MLFQ

test-priority:
	@$(MAKE) run_test SCHEDULER_TYPE=PRIORITY

# Part 5 快捷命令
test-cow:
	@$(MAKE) run_test TYPE=COW

test-lazy:
	@$(MAKE) run_test TYPE=LAZY

# Part 6 快捷命令
test-fifo:
	@$(MAKE) run_test ALGO=FIFO

test-lru:
	@$(MAKE) run_test ALGO=LRU
##### Part 4 & Part 5 & Part 6: 自动化测试命令 #####