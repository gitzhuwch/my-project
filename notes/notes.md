#all my notes below:
##How to make shutcut to Format brush
	双击格式刷就可以实现这个功能

##autocmd Filetype markdown inoremap<buffer> <silent> ,xxx
    autocmd Filetype markdown
    会在打开文件时判断当前文件类型，如果是 markdown 就执行后面的命令
    inoremap 也就是映射命令map，当然它也可以添加很多前缀
    nore
    表示非递归，而递归的映射，也就是如果键a被映射成了b，c又被映射成了a，如果映射是递归的，那么c就被映射成了b
    n
    表示在普通模式下生效
    v
    表示在可视模式下生效
    i
    表示在插入模式下生效
    c
    表示在命令行模式下生效
    所以inoremap也就表示在插入模式下生效的非递归映射
    <buffer> <silent> map的参数，必须放在map后面
    <buffer> 表示仅在当前缓冲区生效，就算你一开始打开的是md文件，映射生效了，但当你在当前页面打开非md文件，该映射也只会在md文件中生效
    <silent> 如果映射的指令中使用了命令行，命令行中也不会显示执行过程
	后面就是按键和映射的指令了，逻辑什么的就是对 vim 的直接操作，就不详细介绍了

##How to build arm qemu32 debug kernel environment
1, sudo apt install qemu-system-arm
2, sudo apt install gcc-arm-linux-gnueabi
3, git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
	cd linux
	vim Makefile
		CROSS_COMPILE := arm-linux-gnueabi-
		ARCH ?= arm
	####do not modify gcc -O0 that will compiling error!! gcc -O can work, but need add local #pragma GCC optimize(O2) for gpu driver code.
	make vexpress_defconfig
	make Image -j2
4, git clone --depth=1 git://busybox.net/busybox.git
	####也可设置为nfs的挂载目录，直接通过网络文件系统进行挂载，便于开发。
	cd busybox
	vim Makefile
	ARCH ?= arm ###maybe not must
	CROSS_COMPILE ?= arm-linux-gnueabi-
	make menuconfig
		Busybox Settings—>
			Build Options—>[*] Build Busybox as a static binary(no shared libs)
		Installtion Options
			在busybox instantlltionprefix一栏中，输入你想要创建rootfs的目录,比如我的是/opt/FriendlyARM/mini2440/rootfs。
		去掉Coreutils—>sync选项；
		去掉Linux System Utilities—>nsenter选项；
	make -j4 install  ##busybox会自动将rootfs根文件系统安装到之前设置的目录下
	上述的make install命令完成后，在rootfs目录下仅仅只是创建一个根文件系统的框架，很多系统运行所必须的文件尚未建立成功，必须手动复制进去。
    1、复制busybox-1.26.2/examples/bootfloppy/etc整个目录下的全部文件，到rootfs/etc目录下。
    2、手动在文件系统中建立如下设备文件：
		cd /opt/FriendlyARM/mini2440/rootfs
		mkdir dev
		cd dev
		sudo mknod -m 660 console c 5 1
		sudo mknod -m 660 null c 1 3
		sudo chown leon *
		sudo chgrp leon *
	最后:
	find . | cpio -o -H newc > rootfs.cpio
	gzip -c rootfs.cpio > rootfs.cpio.gz

5,  #qemu-system-arm -kernel ./arch/arm64/boot/Image -append "console=ttyAMA0" -m 2048M -smp 4 -M virt -cpu cortex-a57 -nographic
	#qemu-system-arm -M vexpress-a9 -m 128M -kernel ./arch/arm/boot/zImage -dtb ./arch/arm/boot/dts/vexpress-v2p-ca9.dtb -nographic -append "console=ttyAMA0"
	qemu-system-arm -M vexpress-a9 -smp 4 -m 1024M -kernel /home/user/work/qemu/linux/arch/arm/boot/zImage -initrd rootfs.cpio.gz -append "rdinit=/linuxrc console=ttyAMA0 loglevel=8" -dtb arch/arm/boot/dts/vexpress-v2p-ca9.dtb -nographic -s -S
	#must be zImage, Image and vmlinux can't bootup

##How to enable earlyprintk when qemu debuging kernel
	qemu-system-arm cmdline arguments add [ -append "earlyprintk console=ttyAMA0" ]

##How to set gcc option -O0 in source code file
	#pragma GCC push_options
	#pragma GCC optimize ("O0")
	void fun()
	{
		return 0;
	}
	#pragma GCC pop_options

##gcc sysroot environment
	type command:
		arm-poky-linux-gnueabi-gcc  --sysroot=/opt/fsl-imx-x11/4.1.15-2.1.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi   -print-libgcc-file-name
	result:
		/opt/fsl-imx-x11/4.1.15-2.1.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/lib/arm-poky-linux-gnueabi/5.3.0/libgcc.a
	type command:
		arm-poky-linux-gnueabi-gcc  -print-libgcc-file-name
	result:
		libgcc.a

##dmesg-principle
	strace -yf dmesg
	read /dev/kmsg		#accumulation log
	read /proc/kmsg		#real time log

##ffmpeg-using
	ffplay -f rawvideo -pixel_format nv12 -video_size 640x480 cap.yuv

##kernel-scan-partition-table-gpt-mmc-driver
	block/partitions/efi.c
	/**
	 * efi_partition(struct parsed_partitions *state)
	 * @state: disk parsed partitions
	 *
	 * Description: called from check.c, if the disk contains GPT
	 * partitions, sets up partition entries in the kernel.
	 *
	 * If the first block on the disk is a legacy MBR,
	 * it will get handled by msdos_partition().
	 * If it's a Protective MBR, we'll handle it here.
	 *
	 * We do not create a Linux partition for GPT, but
	 * only for the actual data partitions.
	 * Returns:
	 * -1 if unable to read the partition table
	 *  0 if this isn't our partition table
	 *  1 if successful
	 *
	 */
	int efi_partition(struct parsed_partitions *state)
	{
    gpt_header *gpt = NULL;
    gpt_entry *ptes = NULL;
    u32 i;
    unsigned ssz = bdev_logical_block_size(state->bdev) / 512;
    if (!find_valid_gpt(state, &gpt, &ptes) || !gpt || !ptes) {
        kfree(gpt);
        kfree(ptes);
        return 0;
    }
    pr_debug("GUID Partition Table is valid!  Yea!\n");

