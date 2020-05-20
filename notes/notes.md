#all my notes below:
##wps:shutcut of Format brush
	双击格式刷就可以实现这个功能

##vim:
###vim:
	sudo apt -y install vim
	1, 查看系统已有键盘映射命令： :map
	   第一列标明了映射在哪种模式下工作，第二列为 {lhs}，第三列为 {rhs} 。
	2, sudo apt -y install vim-scripts
		cp -rf /usr/share/vim-scripts/ ~/.vim/
	3, git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
		vim .vim/bundle/Vundle.vim/autoload/vundle/installer.vim
		let cmd = 'git clone           --recursive '.vundle#installer#shellesc(a:bundle.uri).' '.vundle#installer#shellesc(a:bundle.path())
		let cmd = 'git clone --depth=1 --recursive '.vundle#installer#shellesc(a:bundle.uri).' '.vundle#installer#shellesc(a:bundle.path())
		vim input command:PluginInstall
		wait complete......
		vim ~/.vim/bundle/Vundle.vim/ftplugin/markdown.vim  // resize table of contents window
          execute 'vertical resize ' . (&columns/2)
          execute 'vertical resize ' . (&columns/6)
	4, CTRL-G == :f :file "show current file path
	5, :help CTRL-] == :tag {ident}
	6, A buffer is the in-memory text of a file.
		A window is a viewport on a buffer.
		A tab page is a collection of windows.

###vim-plugin:
	1, #如果你的插件来自github，写在下方，只要作者名/项目名就行了
		 Bundle 'tpope/vim-fugitive' #如这里就安装了vim-fugitive这个插件
		 Bundle 'bogado/file-line'
	2, #如果插件来自 vim-scripts，你直接写插件名就行了
		 Bundle 'L9'
		 Bundle 'file-line.vim'
	3, #如使用自己的git库的插件，像下面这样做
		 Bundle 'git://git.wincent.com/command-t.git'
	4, 如何移除插件
		(1)编辑.vimrc文件移除的你要移除的插件行
		(2)保存退出当前的vim
		(3)重打开vim，在命令模式下输入命名PluginClean。

###vimrc grammar:
	1, autocmd Filetype markdown inoremap<buffer> <silent> ,xxx
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
	2, below setting will cause vim search speed slowdown!!
		because prefix 'n'
		nnoremap nw <C-W><C-W>

##qemu32-arm:
	1, sudo apt -y install qemu-system-arm
	2, sudo apt -y install gcc-arm-linux-gnueabi //has no arm-gdb
	3,
		3.1 get arm-linux-gnueabi-gdb for arm
		https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabi/
		3.2 sudo apt -y install gdb-multiarch
		{
			if appear error "gdb-multiarch : Depends: gdb (= 8.1-0ubuntu3) but 8.1-0ubuntu3.2 is to be installed"
			firstly: sudo apt -y install gdb=8.1-0ubuntu3
			then:    sudo apt -y install gdb-multiarch
		}
	4, git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
		cd linux
		vim Makefile
			CROSS_COMPILE := arm-linux-gnueabi-
			ARCH ?= arm
		####do not modify gcc -O0 that will compiling error!! gcc -O can work, but need add local #pragma GCC optimize(O2) for gpu driver code.
		make vexpress_defconfig
		make zImage -j2
	5, git clone --depth=1 git://busybox.net/busybox.git
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
	6, #qemu-system-arm -kernel ./arch/arm64/boot/Image -append "console=ttyAMA0" -m 2048M -smp 4 -M virt -cpu cortex-a57 -nographic
		#qemu-system-arm -M vexpress-a9 -m 128M -kernel ./arch/arm/boot/zImage -dtb ./arch/arm/boot/dts/vexpress-v2p-ca9.dtb -nographic -append "console=ttyAMA0"
		qemu-system-arm -M vexpress-a9 -smp 4 -m 1024M -kernel ./arch/arm/boot/zImage -initrd rootfs.cpio.gz -append "rdinit=/linuxrc console=ttyAMA0 loglevel=8" -dtb arch/arm/boot/dts/vexpress-v2p-ca9.dtb -nographic -s -S
		#must be zImage, Image and vmlinux can't bootup
	7, ctrl+a+x --> exit qemu-system-arm
		ctrl+x+a --> open/close gdb layout
		gdb: layout --> open gdb layout
	8,
		gdb-multiarch vmlinux
		target remote localhost:1234

##earlyprintk:
	qemu-system-arm cmdline arguments add [ -append "earlyprintk console=ttyAMA0" ]

##kgdb:
	1, kernel cmdline:kgdboc=ttyxx
	2, make menuconfig --> kernel hacking --> ... --> kgdb xxx
	3, uart driver:uart_ops{
		#ifdef CONFIG_CONSOLE_POLL
		.poll_init     = pl011_hwinit,
		.poll_get_char = pl011_get_poll_char,
		.poll_put_char = pl011_put_poll_char,
		#endif
	}
	4, int uart_poll_init()
	{
		port = uart_port_check(state);
		**so uart driver don't realize poll_xxx_char functions;here will failed;**
		if (!port || !(port->ops->poll_get_char && port->ops->poll_put_char))
		{
			ret = -1;
			goto out;
		}
	}
	5,
		set serial baud 115200
		target remote /dev/ttyUSB0


##gdb:
	1, -E, --preserve-env  preserve user environment when running command
		sudo -E ./t7gdb vmlinux
			gdb:edit start_kernel	(success)
		sudo ./t7gdb vmlinux
			gdb:edit start_kernel	(failed)

##gcc:
###gcc option -O0:
	#pragma GCC push_options
	#pragma GCC optimize ("O0")
	void fun()
	{
		return 0;
	}
	#pragma GCC pop_options

###gcc sysroot environment
	type command:
		arm-poky-linux-gnueabi-gcc  --sysroot=/opt/fsl-imx-x11/4.1.15-2.1.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi   -print-libgcc-file-name
	result:
		/opt/fsl-imx-x11/4.1.15-2.1.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/lib/arm-poky-linux-gnueabi/5.3.0/libgcc.a
	type command:
		arm-poky-linux-gnueabi-gcc  -print-libgcc-file-name
	result:
		libgcc.a

###gcc enable openmp?

##dmesg-principle
	strace -yf dmesg
	read /dev/kmsg		#accumulation log
	read /proc/kmsg		#real time log

##ffplay-using
	ffplay -f rawvideo -pixel_format nv12 -video_size 640x480 cap.yuv

##nfs:
	1, server build:
		nfs-kernel-server config:
		echo "/home/user/nfs \*(rw,sync,no_root_squash)" > /etc/exports
	2, client mount:
		mount -t nfs -o nolock 10.3.153.96:/home/user/nfs /mnt/

##smb:samba:ubuntu/windows share folder:
 For ubuntu mount windows:
	1, Windows共享文件夹使用的协议是SMB/CIFS
		sudo apt install cifs-utils
		sudo mount.cifs //[address]/[folder] [mount point] -o user=[username],passwd=[pw]
		sudo mount -t cifs //[address]/[folder] [mount point] -o user=[username],passwd=[pw]
		sudo mount.cifs //[address]/[folder] [mount point] -o user=[username],passwd=[pw],uid=[UID]
		sudo mount.cifs //[address]/[folder] [mount point] -o domain=[domain_name],user=[username],passwd=[pw],uid=[UID]
	2, Server Message Block - SMB
		Common Internet File System - CIFS
	3, input smb://10.3.153.95/e/ in ubuntu files browser
 For windows mount ubuntu:
	4, sudo smbpasswd -a user
		sudo vim /etc/samba/smb.conf
		[user]
		comment = share folder
		browseable=yes
		path = /home/user
		create mask = 0700
		directory mask = 0700
		valid users = user
		force user = user
		force group = user
		public = yes
		available = yes
		writable = yes

##git:repo:gerrit:
###git:
	1, delete local branch
		git branch -d branchname
	2, delete remote branch
		# 冒号前面的空格不能少，相当于把一个空分支push到server上，等于删除该分支
		git push origin :branchname
	3, git clone all branchs of remote repository
		git branch -a，列出所有分支名称如下：
			remotes
			   /origin/devremotes
			   /origin/release
		git checkout -b dev origin/dev，作用是checkout远程的dev分支，在本地起名为dev分支，并切换到本地的dev分支
	4, git config --global credential.helper=store
		在使用Git进行开发的时候，我们可以使用ssh url或者http url来进行源码的clone/push/pull，
		二者的区别是，使用ssh url需要在本地配置ssh key，这也就意味着你必须是开发者或者有一定的权限，
		每次的代码同步（主要是push和clone）不需要进行用户名和密码的输入操作；
		那么http url就相对宽松些，但是需要在每次同步操作输入用户名和密码，有时候，为了省去每次都输入密码的重复操作，
		我们可以在本地新建一个文件，来存储你的用户名和密码，只需要在第一次clone输入用户名和密码，
		这些信息就被存储起来，以后就可以自动读取，不需要你在手动输入了。在Git官网介绍了这一实现，是通过叫做credential
		helper的小玩意儿实现的。可以把它叫做证书或者凭证小助手，它帮我们存储了credential(凭证，里面包含了用户名和密码)
		原文链接：https://blog.csdn.net/u012163684/java/article/details/52433645
	5,	git help --all
		git ls-files -s
		git ls-remote
		git show-ref
		git fetch origin refs/for/refs/heads/cc:refs/for/refs/heads/cc
		git fetch origin refs/for/refs/heads/cc:refs/heads/cc
	6, git tag
		git tag -a v1.4 -m 'my version 1.4'
		git tag v1.4-lw
		git tag -a v1.2 9fceb02
		git push origin v1.5 : git push origin [tagname]
		git push origin --tags
		git checkout -b version2 v2.0.0
		git reset --hard v2.0.0
	7,git checkout master
		git checkout xxx-SHA1: HEAD == xxx-SHA1 != refs/heads/master
		git reset    xxx-SHA1: HEAD == refs/heads/master == xxx-SHA1
	8, git clone url = mkdir repo-name + cd repo-name + git init + git remote add + git fetch + git checkout

####error: RPC failed; curl 18 transfer closed with outstanding read data remaining
	RPC: Remote Procedure Call
	原因1：缓存区溢出
	解决方法：
	1,  clone https方式换成SSH的方式，把 https:// 改为 git://
	例：git clone https://github.com/libgit2/libgit2
	改为：git clone git://github.com/libgit2/libgit2
	2, 加大缓存区 治标不治本
	git config --global http.postBuffer 500000000
	3, 少clone一些，每个文件只取最近一次提交，不是整个历史版本
	git clone https://github.com/flutter/flutter.git --depth 1
	然后更新远程库到本地
	git clone --depth=1 http://gitlab.xxx.cn/yyy/zzz.git
	git fetch --unshallow

####no matching key exchange method found. Their offer: diffie-hellman-group1-sha1
	这个问题主要是客户端与服务端安装的git版本不兼容
	vi ~/.ssh/config加入以下内容
	Host somehost.example.org(你的gerrit服务器，域名或IP) or Host *
	KexAlgorithms +diffie-hellman-group1-sha1

####git describe failed; cannot deduce version numbe?

###repo:
	1, sudo apt -y install repo
	2, vim /usr/bin/repo
		modify: REPO_URL=https://github.com/esrlabs/git-repo
		:wq
	3, repo init -u xxx -b xxx -m xxx
	4, repo tool dependens:
		manifest.git repository
		repo.git repository
	5, repo help init
	6, repo init \
			--repo-url url	\repo repository location
			-u url			\--manifest-url=URL
			-b REVISION		\manifest branch or revision
			-m xx.xml		\initial manifest file
	7,.repo/manifests/.git/xxx symlink to .repo/manifests.git/xxx
	strace -fy repo init --repo-url ssh://git@www.rockchip.com.cn/repo/rk/tools/repo -u ssh://git@www.rockchip.com.cn/linux/rk/platform/manifests -b linux -m rk3399_linux_release.xml
		mkdir("/home/git/temp/.repo/manifests", 0777) = 0
		mkdir("/home/git/temp/.repo/manifests/.git.tmp", 0777) = 0
		...
		mkdir("/home/git/temp/.repo/manifests.git/rr-cache", 0777) = 0
		symlink("../../manifests.git/rr-cache", "/home/git/temp/.repo/manifests/.git.tmp/rr-cache") = 0
		...
		lstat("/home", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
		lstat("/home/git", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
		lstat("/home/git/temp", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
		lstat("/home/git/temp/.repo", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
		lstat("/home/git/temp/.repo/manifests.git", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
		lstat("/home/git/temp/.repo/manifests.git/objects", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
		lstat("/home/git/temp/.repo/manifests/.git.tmp/objects", 0x7ffda7de1ab0) = -1 ENOENT (No such file or directory)
		lstat("/home/git/temp/.repo/manifests.git/objects", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
		symlink("../../manifests.git/objects", "/home/git/temp/.repo/manifests/.git.tmp/objects") = 0
		...
		rename("/home/git/temp/.repo/manifests/.git.tmp", "/home/git/temp/.repo/manifests/.git") = 0
		...
		chdir("/home/git/temp/.repo/manifests") = 0
		...
		execve("/usr/bin/git", ["git", "read-tree", "--reset", "-u", "-v", "HEAD"], 0x7fb3bbec0ce0 /* 28 vars */ <unfinished ...>
	8, 想冻结某个时间点调试好的代码，将其manifest保存起来，以备将来使用
		repo manifest -r -o name.xml
		cp name.xml .repo/manifests/
		repo init -m name.xml
		repo sync
		------
		repo manifest -h
			Usage: repo manifest [-o {-|NAME.xml} [-r]]
			Options:
			  -h, --help            show this help message and exit
			  -r, --revision-as-HEAD
			                        Save revisions as current HEAD	把当前HEAD保存为manifest里的revision字段
			  --suppress-upstream-revision							去除manifest里的upstream字段
			                        If in -r mode, do not write the upstream field.  Only
			                        of use if the branch names for a sha1 manifest are
			                        sensitive.
			  -o -|NAME.xml, --output-file=-|NAME.xml
			                        File to save the manifest to

###gerrit:
	1, web browser: 10.3.153.233:8080
	2, refs/for/master与refs/for/refs/heads/master区别:
		a)这个不是git的规则，而是gerrit的规则
		b)branches, remote-tracking branches, and tags等等都是对commite的引用（reference）
		c)refs/for/mybranch需要经过code review之后才可以提交；refs/heads/mybranch不需要code review

###gitolite:
	1, sudo useradd -r -m -s /bin/bash gitolite
	2, sudo passwd gitolite
	3, su - gitolite
	4, mkdir -p \$HOME/bin
	5, git clone https://github.com/sitaramc/gitolite.git
	6, gitolite/install -to \$HOME/bin
	7, \$HOME/bin/gitolite setup -pk YourName.pub

####git describe failed; cannot deduce version numbe
	  a)--depth=1 will not cover the release version so install failed
		git clone --depth=1  https://github.com/sitaramc/gitolite.git
		gitolite/install -to \$HOME/bin
		**git describe failed; cannot deduce version numbe**
	  b)success
		git clone https://github.com/sitaramc/gitolite.git
		gitolite/install -to \$HOME/bin

####PTY allocation request failed on channel 0 hello id_rsa, this is git@user-ThinkPad-E490 running gitolite3 v3.6.11-9-gd89c7dd on git 2.17.1
	ssh -X git@10.3.153.96 report title error
	cat .ssh/authorized_keys
		\# gitolite start
		command="/home/git/bin/gitolite-shell id_rsa",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty
		ssh-rsa
		AAAAB3NzaC1yc2EAAA......T4UNW7kAwKgonTeNg3
		user@user-ThinkPad-E490
		\# gitolite end

####fatal: No path specified. See 'man git-pull' for valid url syntax
	git clone ssh://git@10.3.153.96:gitolite-admin report title error
	fix: below two all right
		git clone ssh://git@10.3.153.96:/gitolite-admin
		git clone ssh://git@10.3.153.96/gitolite-admin

###gitolite/gerrit:
	gitolite is through .ssh/authorized_keys-->command to export git repository
	gerrit is through ip:29418 port to process client requestion

##apt:
	1, man:apt-get(8), apt-cache(8), sources.list(5), apt.conf(5), apt-config(8)
	2, apt-get install安装目录是包的维护者确定的，不是用户
		可以预配置的时候通过./configure --help看一下–prefix的默认值是什么，
		就知道默认安装位置了，或者直接指定安装目录。
		apt-config dump | grep  -i "dir::cache" show the apt download directory

##accounts management:
	1, su - username (Provide an environment similar to what the user would expect had the user logged in directly)
	2, users: print the user names of users currently logged in to the current host
	3, w: Show who is logged on and what they are doing
	4, 查看当前登录
		w
		who
		users
	   查看系统中所有用户：
		grep bash /etc/passwd
		或者：
		cat /etc/passwd | cut -f 1 -d:
	5, users/w/who command principe: read登录记录文件(/var/run/utmp)
	6, sudo useradd username
	7, usermod:modify a user account
		-d, --home HOME_DIR
        The user's new login directory.
	8,Linux用户类型
	Linux用户类型分为 3 类：超级用户、系统用户和普通用户。
    超级用户：用户名为 root 或 USER ID(UID)为0的账号，具有一切权限，可以操作系统中的所有资源。root可以进行基础的文件操作以及特殊的文件管理，另外还可以进行网络管理，可以修改系统中的任何文件。日常工作中应避免使用此类账号，只有在必要的时候才使用root登录系统。
    系统用户：正常运行系统时使用的账户。每个进程运行在系统里都有一个相应的属主，比如某个进程以何种身份运行，这些身份就是系统里对应的用户账号。注意系统账户是不能用来登录的，比如 bin、daemon、mail等。
    普通用户：普通使用者，能使用Linux的大部分资源，一些特定的权限受到控制。用户只对自己的目录有写权限，读写权限受到一定的限制，从而有效保证了Linux的系统安全，大部分用户属于此类。

##xdg-open:
	xdg-open: opens a file or URL in the user's preferred application

##kernel-scan-partition-table-gpt:
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

##partitions-view-tools:
	df -T 只可以查看已经挂载的分区和文件系统类型。
	sudo fdisk -l 可以显示出所有挂载和未挂载的分区，但不显示文件系统类型。
	sudo parted -l 可以查看未挂载的文件系统类型，以及哪些分区尚未格式化。
	sudo lsblk -f 也可以查看未挂载的文件系统类型。
	sudo file -s /dev/sda3
	sudo blkid

##UUID
	1, https://blog.csdn.net/smstong/article/details/46417213
		为解决上述问题，UUID被文件系统设计者采用，使其可以持久唯一标识一个硬盘分区。
		其实方式很简单，就是在文件系统的超级块中使用128位存放UUID。
		这个UUID是在使用文件系统格式化分区时计算生成的，
		例如Linux下的文件系统工具mkfs就在格式化分区的同时，
		生成UUID并把它记录到超级块的固定区域中。
	2, 查看硬盘UUID：
		两种方法:
		ls -l /dev/disk/by-uuid
		blkid /dev/sda1
		修改分区UUID：
		1、修改分区的UUID
		Ubuntu 使用 uuid命令 生成新的uuid
		centos 使用uuidgen命令 生成新的uuid
		Ubuntu
		sudo uuid | xargs tune2fs /dev/sda1 -U
		centos
		sudo uuidgen | xargs tune2fs /dev/sda1 -U
		2、查看/etc/fstab 将原有UUID写入分区
		tune2fs -U 578c1ba1-d796-4a54-be90-8a011c7c2dd3 /dev/sda1
	3, GPT/UUID :http://en.wikipedia.org/wiki/GUID_Partition_Table
		GPT:GUID Partition Table
		MBR:Master Boot Record
		LBA:Logic Block Address

##arm:arm9:armv9:cortex-a9:
	1,且在GCC编译中，常常要用到 -march,-mcpu等
	2,ARM（Advanced RISCMachines)
	3,ＡＲＭ公司定义了６种主要的指令集体系结构版本。Ｖ１－Ｖ６。（所以上面提到的ＡＲＭｖ６是指指令集版本号）。即：ARM architecture
	4, ARM公司开发了很多ARM处理器核，最新版位ARM11。ARM11：指令集ARMv6，8级流水线，1.25DMIPS/MHz
	5, Cortex-A8：指令集ARMv7-A，13级整数流水线，超标量双发射，2.0DMIPS/MHz，标配Neon，不支持多核
	  Scorpion：指令集ARMv7-A，高通获得指令集授权后在A8的基础上设计的。13级整数流水线，超标量双发射，部分乱序执行，2.1DMIPS/MHz，标配Neon，支持多核
	  Cortex-A9：指令集ARMv7-A，8级整数流水线，超标量双发射，乱序执行，2.5DMIPS/MHz，可选配Neon/VFPv3，支持多核
	  Cortex-A5：指令集ARMv7-A，8级整数流水线，1.57DMIPS/MHz，可选配Neon/VFPv3，支持多核
	  Cortex-A15：指令集ARMv7-A，超标量，乱序执行，可选配Neon/VFPv4，支持多核

##ATE:EVB:SLT
	1, ATE(Auto Test Equipment) 在测试工厂完成. 大致是给芯片的输入管道施加所需的激励信号，
		同时监测芯片的输出管脚，看其输出信号是否是预期的值。有特定的测试平台。
	2, SLT(System Level Test) 也是在测试工厂完成，与ATE一起称之为Final Test.
		SLT位于ATE后面，执行系统软件程序，测试芯片各个模块的功能是否正常。
	3, EVB(Evaluation Board) 开发板：软件/驱动开发人员使用EVB开发板验证芯片的正确性，进行软件应用开发

##clk/clocksource/time:
	1, drivers/clk: device clk tree;
	2, drivers/clocksource: kernel time source;
	3, kernel/time: kernel time system.

##power/regulator:
	1, power: sleep wakeup system
	2, regulator: power management system

##gpio/pinctrl:
	1, gpio:
	2, pinctrl:

##cpufreq:
	1, cat /sys/system/cpu/cpufreq
	2, drivers/base/bus.c:
		system_kset = kset_create_and_add("system", NULL, &devices_kset->kobj);
	3, drivers/base/cpu.c:
		subsys_system_register(&cpu_subsys, cpu_root_attr_groups)

##arm smp open/close:
	1, edit smp_init

##sudo/su/login:
	1, -E, --preserve-env  preserve user environment when running command
		sudo -E ./t7gdb vmlinux
			gdb:edit start_kernel	(success)
		sudo ./t7gdb vmlinux
			gdb:edit start_kernel	(failed)
	2,	su -l username
		su - username //login as username
	3,	sudo:	execute a command as another user
		su:		The su command is used to become another user during a login session.
		login:	The login program is used to establish a new session with the system.
	4, sudo report:
		test is not in the sudoers file.  This incident will be reported.
		resolve mathods:
			a) modify /etc/sudoers
			b) modify user group to sudo group

##url:
	在WWW上，每一信息资源都有统一的且在网上唯一的地址，该地址就叫URL（Uniform Resource Locator,统一资源定位符），它是WWW的统一资源定位标志，就是指网络地址
	URL由三部分组成：资源类型、存放资源的主机域名、资源文件名。
	也可认为由4部分组成：协议、主机、端口、路径
	URL的一般语法格式为：
	(带方括号[]的为可选项)：
	protocol :// hostname[:port] / path / [;parameters][?query]#fragment

##service/systemd/systemctl?

##ssh/ssh-agent/ssh-copy-id?

