#all my notes below:
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
	6,	A buffer is the in-memory text of a file.
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

##kernel debug methods:
###qemu32-arm:
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

###kgdb:
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
###earlyprintk:
	qemu-system-arm cmdline arguments add [ -append "earlyprintk console=ttyAMA0" ]
###dmesg-principle
	strace -yf dmesg
	read /dev/kmsg		#accumulation log
	read /proc/kmsg		#real time log

##GNU binary utilities:
###gdb:
	1, -E, --preserve-env  preserve user environment when running command
		sudo -E ./t7gdb vmlinux
			gdb:edit start_kernel	(success)
		sudo ./t7gdb vmlinux
			gdb:edit start_kernel	(failed)
####gdbinit:
	1,
	define dump_current
	set var $stacksize = sizeof(union thread_union)
	set var $stackp = (size_t)$sp--------这里必须加上强制类型转换，否则下面计算错的，非常坑
	set var $stack_bottom = ($stackp) & (~($stacksize - 1))
	set var $threadinfo = (struct thread_info *)$stack_bottom
	set var $task_struct =(struct task_struct *)($threadinfo->task)
	printf "current::pid:%d; comm:%s; mm:0x%x ", $task_struct->pid, $task_struct->comm, $task_struct->mm
	if ($task_struct->mm != 0)
	    printf "pgd:0x%x\n", $task_struct->mm->pgd
	else
	    printf "pgd:0\n"
	end
	end
	2, notes/linux-memory/gdb_error_Argument_to_arithmetic_operation_not_a_number_or_boolean
	--------------------------------error------------------------------------
	define dump_current
    set var $stacksize = sizeof(union thread_union)
    set var $stackp = $sp???????????????????????????????????????????????????????????
    set var $stack_bottom = ($stackp & ~($stacksize - 1))
    set var $threadinfo = (struct thread_info *)$stack_bottom
    set var $task_struct =(struct task_struct *)($threadinfo->task)
    printf "pid:%d; comm:%s\n", $task_struct.pid, $task_struct.comm
	end
	--------------------------------right------------------------------------
	define dump_current
    set var $stacksize = sizeof(union thread_union)
    set var $stackp = (size_t)$sp!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    set var $stack_bottom = ($stackp & ~($stacksize - 1))
    set var $threadinfo = (struct thread_info *)$stack_bottom
    set var $task_struct =(struct task_struct *)($threadinfo->task)
    printf "pid:%d; comm:%s\n", $task_struct.pid, $task_struct.comm
	end

###gcc:
####gcc option -O0:
	#pragma GCC push_options
	#pragma GCC optimize ("O0")
	void fun()
	{
		return 0;
	}
	#pragma GCC pop_options
####gcc sysroot environment
	type command:
		arm-poky-linux-gnueabi-gcc  --sysroot=/opt/fsl-imx-x11/4.1.15-2.1.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi   -print-libgcc-file-name
	result:
		/opt/fsl-imx-x11/4.1.15-2.1.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/lib/arm-poky-linux-gnueabi/5.3.0/libgcc.a
	type command:
		arm-poky-linux-gnueabi-gcc  -print-libgcc-file-name
	result:
		libgcc.a
####gcc enable openmp?
###objcopy:
	1,要将一个二进制的文件，如图片作为一个目标文件的段:
	objcopy -I binary -O elf32-i386 -B i386 Dark.jpg image.o
	gcc -o test_elf main.c image.o

##code version control:
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
	9, git ls-remote 查看远程所有references

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

##Linux driver model:
###device_add()
	drivers/base/core.c::device_add----这里会创建设备在sys下的所有节点和链接文件，也会在devtmpfs下创建节点
###driver_register()
	drivers/base/driver.c::driver_register
	drivers/base/bus.c::bus_add_driver---这里真正创建driver->kobj目录
###cdev:
####cdev创建的3大步
	1, __register_chrdev_region():主要申请设备号
	申请设备号，并实例化一个struct char_device_struct对象，并把该对象地址加入到chrdevs[major_to_index(major)]数组中
	2，cdev_add():真正注册设备
	int cdev_add(struct cdev *p, dev_t dev, unsigned count)
	{
	    int error;
	    p->dev = dev;
	    p->count = count;
	    error = kobj_map(cdev_map, dev, count, NULL,
	             exact_match, exact_lock, p);----------映射完,chrdev_open函数就可以根据设备号找到该cdev
	    if (error)
	        return error;
	    kobject_get(p->kobj.parent);
	    return 0;
	}
	3,device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL, "tty");
	会在tty class下链接生成tty子目录，mdev就能够遍历到，然后自动在/dev下mknod创建设备节点
	会调到device_add()函数里：
	if (MAJOR(dev->devt)) {
		error = device_create_file(dev, &dev_attr_dev);----在该设备目录下创建uevent节点
		if (error)
			goto DevAttrError;
		error = device_create_sys_dev_entry(dev);---------创建/sys/dev/char/xx:xx节点
		if (error)
			goto SysEntryError;
		devtmpfs_create_node(dev);
	}
	device_add()->device_add_class_symlinks(dev);----如果dev->class存在，就会将该设备目录链接到/sys/class/xxx/目录下一个子目录(以设备名命名的子目录)
###char dev name where defining:
	1, drivers/base/core.c:
		dev_uevent(){}
			device_get_devnode()
####devtmpfs下产生的设备名称
	#0  device_get_devnode (dev=0xee58f600, mode=0xee4b7a6c, uid=0xee4b7a70, gid=0xee4b7a74, tmp=0xee4b7a4c) at drivers/base/core.c:2743
	#1  devtmpfs_create_node (dev=0xee58f600) at drivers/base/devtmpfs.c:120
	#2  device_add (dev=0xee58f600) at drivers/base/core.c:2450
####uevent产生的设备名称
	#0  device_get_devnode (dev=0xee5c0408, mode=0xee4b7cce, uid=0xee4b7cd4, gid=0xee4b7cd8, tmp=0xee4b7cd0) at drivers/base/core.c:2743
	#1  dev_uevent (kset=<optimized out>, kobj=0xee5c0408, env=0xee4b8000) at drivers/base/core.c:1433
	#2  kobject_uevent_env (kobj=0xee5c0408, action=<optimized out>, envp_ext=0x0) at lib/kobject_uevent.c:556
	#3  kobject_uevent (kobj=<optimized out>, action=<optimized out>) at lib/kobject_uevent.c:641
	#4  device_add (dev=0xee5c0408) at drivers/base/core.c:2460
###tty subsystem:
	static struct tty_driver *tty_lookup_driver(dev_t device, struct file *filp,
	        int *index)
	{
	    struct tty_driver *driver = NULL;
	    switch (device) {
	#ifdef CONFIG_VT
	    case MKDEV(TTY_MAJOR, 0): {
	        extern struct tty_driver *console_driver;---------找设备号为4,0的tty_driver;/dev/tty0
	        driver = tty_driver_kref_get(console_driver);
	        *index = fg_console;
	        break;
	    }
	#endif
	    case MKDEV(TTYAUX_MAJOR, 1): {
	        struct tty_driver *console_driver = console_device(index);---------找设备号为5,1的tty_driver;/dev/console
	        if (console_driver) {
	            driver = tty_driver_kref_get(console_driver);
	            if (driver && filp) {
	                /* Don't let /dev/console block */
	                filp->f_flags |= O_NONBLOCK;
	                break;
	            }
	        }
	        if (driver)
	            tty_driver_kref_put(driver);
	        return ERR_PTR(-ENODEV);
	    }
	    default:
	        driver = get_tty_driver(device, index);---------会到tty_drivers链表里找/dev/ttySn和/dev/tty1-x
	        if (!driver)
	            return ERR_PTR(-ENODEV);
	        break;
	    }
	    return driver;
	}
####tty_drivers
	所有tty_driver都会注册到tty_drivers里面,所以tty_open的时候到这个链表找tty_driver，都可以找得到
####/dev/tty设备
	1,tty 设备号5,0;打开时会用当前进程的tty
	2,cdev_init(&tty_cdev, &tty_fops);
	3,cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1)
####/dev/console设备
	1,console 设备号5,1;打开时会找cmdline中console=xxx指定的tty
	2,cdev_init(&console_cdev, &console_fops);
	3,cdev_add(&console_cdev, MKDEV(TTYAUX_MAJOR, 1), 1)
####/dev/tty0设备
	1,设备号4,0，打开时会找到struct tty_driver *console_driver
	2,cdev_init(&vc0_cdev, console_fops);
	3,cdev_add(&vc0_cdev, MKDEV(TTY_MAJOR, 0), 1)
####/dev/tty1-63设备
	1,设备号4,1-63，打开时会到tty_drivers链表里找

####/dev/ttySn设备
#####ttyS0设备名的产生
	struct uart_port.line=x-------------------------
	ttySx-------------------------
	static struct uart_driver amba_reg = {
	    .owner          = THIS_MODULE,
	    .driver_name    = "ttyAMA",
	    .dev_name       = "ttyS",---------------------------this is the uart port name base; +port.line =ttySx
	    .major          = SERIAL_AMBA_MAJOR,
	    .minor          = SERIAL_AMBA_MINOR,
	    .nr				= UART_NR,
	    .cons           = AMBA_CONSOLE,
	};
	uart_register_driver(&amba_reg)
	{
		struct tty_driver *normal;
		int i, retval = -ENOMEM;
		drv->state = kcalloc(drv->nr, sizeof(struct uart_state), GFP_KERNEL);
		normal = alloc_tty_driver(drv->nr);
		drv->tty_driver = normal;
		normal->driver_name = drv->driver_name;
		normal->name        = drv->dev_name;---------------------------using uart_driver init tty_driver
		normal->major       = drv->major;
		normal->minor_start = drv->minor;
		normal->type        = TTY_DRIVER_TYPE_SERIAL;
		normal->subtype     = SERIAL_TYPE_NORMAL;
		normal->init_termios    = tty_std_termios;
		normal->init_termios.c_cflag = B9600 | CS8 | CREAD | HUPCL | CLOCAL;
		normal->init_termios.c_ispeed = normal->init_termios.c_ospeed = 9600;
		normal->flags       = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
		normal->driver_state    = drv;
		tty_set_operations(normal, &uart_ops);
		for (i = 0; i < drv->nr; i++) {
			struct uart_state *state = drv->state + i;
			struct tty_port *port = &state->port;
			tty_port_init(port);
			port->ops = &uart_port_ops;
		}
		retval = tty_register_driver(normal);
	}
	uart_add_one_port(&amba_reg, &uap->port)
		-->tty_port_register_device_attr_serdev(port, drv->tty_driver, uport->line, uport->dev, port, uport->tty_groups)
			-->tty_register_device_attr(driver, index, device, drvdata, attr_grp)------------kzallock struct device and device_register
				-->static ssize_t tty_line_name(struct tty_driver *driver, int index, char *p)------------driver is tty_driver not is uart_driver
					{
					    if (driver->flags & TTY_DRIVER_UNNUMBERED_NODE)
					        return sprintf(p, "%s", driver->name);
					    else
					        return sprintf(p, "%s%d", driver->name,-----------------is driver->name not is driver->driver_name
					                   index + driver->name_base);
					}

#####/dev/ttySn设备号设定
######由tty_driver->major决定
	#2  tty_register_device_attr (driver=0xee635200, index=3230862924, device=0x0, drvdata=0xee4b9000, attr_grp=0xee612c00) at drivers/tty/tty_io.c:3145
	#3  tty_port_register_device_attr_serdev (port=<optimized out>, driver=0xee614380, index=0, device=0xee540c00, drvdata=0xee4b9000, attr_grp=<optimized out>) at drivers/tty/tty_port.c:166
	#4  uart_add_one_port (drv=0xc0b49c14 <amba_reg>, uport=0xee635040) at drivers/tty/serial/serial_core.c:2861
	#5  pl011_register_port (uap=0xee635040) at drivers/tty/serial/amba-pl011.c:2601
	struct device *tty_register_device_attr(struct tty_driver *driver,
	                   unsigned index, struct device *device,
	                   void *drvdata,
	                   const struct attribute_group **attr_grp)
	{
	...
	dev_t devt = MKDEV(driver->major, driver->minor_start) + index;----由tty_driver->major决定
	...
	}
######tty_driver->major怎么设定
######由uart_driver决定
	int uart_register_driver(struct uart_driver *drv)
	{
	...
	struct tty_driver *normal;
	normal = alloc_tty_driver(drv->nr);
	drv->tty_driver = normal;
	normal->driver_name = drv->driver_name;
	normal->name        = drv->dev_name;
	normal->major       = drv->major;---------tty_driver由uart_driver初始化
	normal->minor_start = drv->minor;
	normal->type        = TTY_DRIVER_TYPE_SERIAL;
	normal->subtype     = SERIAL_TYPE_NORMAL;
	normal->init_termios    = tty_std_termios;
	normal->init_termios.c_cflag = B9600 | CS8 | CREAD | HUPCL | CLOCAL;
	normal->init_termios.c_ispeed = normal->init_termios.c_ospeed = 9600;
	normal->flags       = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
	normal->driver_state    = drv;
	tty_set_operations(normal, &uart_ops);
	...
	}

	static struct uart_driver amba_reg = {
	    .owner          = THIS_MODULE,
	    .driver_name        = "ttyAMA",
	    .dev_name       = "ttyAMA",
	    .major          = SERIAL_AMBA_MAJOR,--------uart_driver定义处
	    .minor          = SERIAL_AMBA_MINOR,
	    .nr         = UART_NR,
	    .cons           = AMBA_CONSOLE,
	};

####/dev/ptmx-/dev/pts/n设备
	1,drivers/tty/pty.c

###uevent subsystem:
####uevent_helper
	1, /sys/kernel/uevent_helper
#####/sys/kernel目录怎么创建的
	kernel/ksysfs.c
		ksysfs_init()
			-->kernel_kobj = kobject_create_and_add("kernel", NULL);
#####/sys/kernel/uevent_helper节点怎么创建的
	kernel/ksysfs.c:
	static struct attribute * kernel_attrs[] = {
	    &fscaps_attr.attr,
	    &uevent_seqnum_attr.attr,
	#ifdef CONFIG_UEVENT_HELPER
	    &uevent_helper_attr.attr,------------这里定义
	#endif
	#ifdef CONFIG_PROFILING
	    &profiling_attr.attr,
	#endif
	#ifdef CONFIG_KEXEC_CORE
	    &kexec_loaded_attr.attr,
	    &kexec_crash_loaded_attr.attr,
	    &kexec_crash_size_attr.attr,
	#endif
	#ifdef CONFIG_CRASH_CORE
	    &vmcoreinfo_attr.attr,
	#endif
	#ifndef CONFIG_TINY_RCU
	    &rcu_expedited_attr.attr,
	    &rcu_normal_attr.attr,
	#endif
	    NULL
	};
	static const struct attribute_group kernel_attr_group = {
	    .attrs = kernel_attrs,
	};
	error = sysfs_create_group(kernel_kobj, &kernel_attr_group);
####mdev开机自动生成设备节点
	1,在qemu中kernel起来后，在rcS里加了mdev -s 所以/dev下会有节点

##linux file system:
###所有文件系统挂载的关键:
####register_filesystem()
	只是将file_system_type实例加到全局链表file_systems中
####vfs_kern_mount()
	会产生一个文件系统mount实例，产生root inode/dentry
###rootfs的挂载
	#0  rootfs_init_fs_context (fc=0xee403280) at init/do_mounts.c:701
	#1  alloc_fs_context (fs_type=0xc0b07a2c <rootfs_fs_type>, reference=0x0, sb_flags=0, sb_flags_mask=0, purpose=FS_CONTEXT_FOR_MOUNT) at fs/fs_context.c:293
	#2  fs_context_for_mount (fs_type=<optimized out>, sb_flags=<optimized out>) at fs/fs_context.c:307
	#3  vfs_kern_mount (type=<optimized out>, flags=<optimized out>, name=0xc08e866c "rootfs", data=0x0) at fs/namespace.c:982
	#4  init_mount_tree () at fs/namespace.c:3716
	#5  mnt_init () at fs/namespace.c:3771
	#6  vfs_caches_init () at fs/dcache.c:3215
	#7  start_kernel () at init/main.c:950
	static int rootfs_init_fs_context(struct fs_context *fc)
	{
	    if (IS_ENABLED(CONFIG_TMPFS) && is_tmpfs)
	        return shmem_init_fs_context(fc);
	    return ramfs_init_fs_context(fc);
	}
	所以rootfs的root是shmemfs或者ramfs类型的
####rootfs root inode generate
	#0  shmem_alloc_inode (sb=0xee428800) at mm/shmem.c:3737
	#1  alloc_inode (sb=0xee428800) at fs/inode.c:231
	#2  new_inode_pseudo (sb=<optimized out>) at fs/inode.c:927
	#3  new_inode (sb=<optimized out>) at fs/inode.c:956
	#4  shmem_get_inode (sb=0xee428800, dir=0x0, mode=17407, dev=0, flags=2097152) at mm/shmem.c:2249
	#5  shmem_fill_super (sb=0xee428800, fc=<optimized out>) at mm/shmem.c:3694
	#6  vfs_get_super (fc=0xee403280, keying=<optimized out>, fill_super=0xc0222ba0 <shmem_fill_super>) at fs/super.c:1191
	#7  get_tree_nodev (fc=<optimized out>, fill_super=<optimized out>) at fs/super.c:1221
	#8  shmem_get_tree (fc=<optimized out>) at mm/shmem.c:3711
	#9  vfs_get_tree (fc=0xee403280) at fs/super.c:1547
	#10 fc_mount (fc=0xee403280) at fs/namespace.c:962
	#11 vfs_kern_mount (type=<optimized out>, flags=<optimized out>, name=<optimized out>, data=0x0) at fs/namespace.c:992
	#12 init_mount_tree () at fs/namespace.c:3716
	#13 mnt_init () at fs/namespace.c:3771
	#14 vfs_caches_init () at fs/dcache.c:3215
	#15 start_kernel () at init/main.c:950
	在shmem_get_inode函数中调用init_special_inode(inode, mode, dev);生成设备节点
####rootfs root dentry generate
	shmem_fill_super
		-->d_make_root
###devtmpfs文件系统
####devtmpfs下设备节点产生
	首先要在menuconfig中选上
	然后do_basic_setup->driver_init->devtmpfs_init->kthread_run(devtmpfsd, &err, "kdevtmpfs");创建devtmpfsd线程
	在device_add()函数中
	if (MAJOR(dev->devt)) {-----必须有设备号才会在devtmpfs下创建节点
	    error = device_create_file(dev, &dev_attr_dev);
	    if (error)
	        goto DevAttrError;
	    error = device_create_sys_dev_entry(dev);
	    if (error)
	        goto SysEntryError;
	    devtmpfs_create_node(dev);----在这里唤醒devtmpfsd线程，创建设备节点
	}
####devtmpfs挂载
	选中CONFIG_DEVTMPFS_MOUNT=y会自动挂载
	prepare_namespace->mount_root之后调用->devtmpfs_mount
	int \__init devtmpfs_mount(void)
	{
	    int err;
	    if (!mount_dev)----这个变量决定是否自动挂载
	        return 0;
	    if (!thread)
	        return 0;
	    err = do_mount("devtmpfs", "dev", "devtmpfs", MS_SILENT, NULL);
	    if (err)
	        printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
	    else
	        printk(KERN_INFO "devtmpfs: mounted\n");
	    return err;
	}
	默认没有挂载；kernel起来后可以手动挂载

##linux memory management:
###arm32内存管理调试在qemu上
	1, 用下面的gdbinit调试
	.gdbinit: notes/linux-memory/gdbinit_of_debug_memory.txt
	kernel boot时关键的几个函数
	b prepare_page_table
	b early_init_dt_add_memory_arch
	b __create_mapping
	b setup_arch
	b check_and_switch_context
	b cpu_v7_switch_mm
	2, 通过gdb执行一下命令，多执行几次
	b __create_mapping
	cbt
	dump_ksptx
	可以得出：
		在汇编阶段只map kernel code;
		map_lowmem()map整个低端内存;
		然后创建一些io map等等.
###virtual address space layout:
	1, low memory:虚拟地址与物理地址偏移量固定
	2, hight memory:随机映射
	3, 高端内存是为了利用1G/2G内核虚拟地址空间访问超过1G/2G的物理内存而设计的
###kmalloc and vmalloc difference:
	1, kmalloc在低端内存中分配，虚拟地址连续，物理地址连续
	2，vmalloc在高端内存中申请，虚拟地址连续，物理地址不一定连续
###PGD/PUD/PMD/PTE:
	1, PGD: page global directory
	2, PUD: page upper directory
	3, PMD: page middle directory
	4, PTE: page table

##linux process managemnet:
###1号进程的in/out终端怎么产生
	do_basic_setup();所有驱动模块初始化完后
	调用console_on_rootfs();
	void console_on_rootfs(void)
	{
	    /* Open the /dev/console as stdin, this should never fail */
	    if (ksys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
	---do_sys_open
		->do_sys_openat2
			->do_filp_open
				->path_openat
					->do_last
						->vfs_open
							->do_dentry_open
								->chrdev_open
									->tty_open
										->tty_open_by_driver
											->tty_lookup_driver到struct console *console_drivers;链表里找第一个，即cmdline中最后一个console=xx指定的
	        pr_err("Warning: unable to open an initial console.\n");
	    /* create stdout/stderr */
	    (void) ksys_dup(0);
	    (void) ksys_dup(0);
	}
####/dev/console节点怎么创建的
#####noinitramfs的时候
	static int \__init default_rootfs(void)
	{
	    int err;
	    err = ksys_mkdir((const char __user __force *) "/dev", 0755);
	    if (err < 0)
	        goto out;
	    err = ksys_mknod((const char __user __force *) "/dev/console",-------这里创建console
	            S_IFCHR | S_IRUSR | S_IWUSR,
	            new_encode_dev(MKDEV(5, 1)));
	    if (err < 0)
	        goto out;
	    err = ksys_mkdir((const char __user __force *) "/root", 0700);
	    if (err < 0)
	        goto out;
	    return 0;
	out:
	    printk(KERN_WARNING "Failed to create a rootfs\n");
	    return err;
	}
	rootfs_initcall(default_rootfs);------以initcall形式调用
#####initramfs的时候
	static int \__init populate_rootfs(void)
	{
	    /* Load the built in initramfs */
	    char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);-----这个段里里创建console
	    if (err)
	        panic("%s", err); /* Failed to decompress INTERNAL initramfs */
	    if (!initrd_start || IS_ENABLED(CONFIG_INITRAMFS_FORCE))
	        goto done;
	    if (IS_ENABLED(CONFIG_BLK_DEV_RAM))
	        printk(KERN_INFO "Trying to unpack rootfs image as initramfs...\n");
	    else
	        printk(KERN_INFO "Unpacking initramfs...\n");
	    err = unpack_to_rootfs((char *)initrd_start, initrd_end - initrd_start);-----这里解压ramdisk
	    if (err) {
	        clean_rootfs();
	        populate_initrd_image(err);
	    }
	done:
	    /*
	     * If the initrd region is overlapped with crashkernel reserved region,
	     * free only memory that is not part of crashkernel region.
	     */
	    if (!do_retain_initrd && initrd_start && !kexec_free_initrd())
	        free_initrd_mem(initrd_start, initrd_end);
	    initrd_start = 0;
	    initrd_end = 0;
	    flush_delayed_fput();
	    return 0;
	}
	rootfs_initcall(populate_rootfs);-------以initcall形式调用
######initrd_start这个段怎么产生
	链接脚本中产生
######initramfs_start这个段怎么产生
	在kernel源码目录下usr/gen_init_cpio.c这个代码中产生

###进程间通信/协作:
####semaphore:
	1, /* Please don't access any members of this structure directly */
	struct semaphore {
	    raw_spinlock_t      lock;
	    unsigned int        count;
	    struct list_head    wait_list;
	};
####completion:
	1, struct completion {
		unsigned int done;
		wait_queue_head_t wait;
	};
####wait_queue_head:
	1, struct wait_queue_head {
		spinlock_t      lock;
		struct list_head    head;
	};

####signal:

###schedual调度相关:
	1, wake_up_process(struct task_struct *p)
	2, 所有drivers框架中grep "wake"/"wake_up",基本上都能分析它的数据流处理流程；
	基本上都是来一个中断，中断唤醒一个workqueue，workqueue调work，work唤醒waitqueue或者semaphore

###所有内核线程的创建过程:
(包括工作队列的工作者进程的创建):
	1,start_kernel->rest_init->kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES)----创建kthreadd进程
	2,kthread_create_on_node->__kthread_create_on_node->list_add_tail(&create->list, &kthread_create_list);---加到链表中
	wake_up_process(kthreadd_task);----唤醒kthreadd进程
	3,kthreadd()->create_kthread(create)->kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
	----最终通过kernel_thread()函数创建内核进程
	4,pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
		{
		    struct kernel_clone_args args = {
		        .flags      = ((flags | CLONE_VM | CLONE_UNTRACED) & ~CSIGNAL),
		        .exit_signal    = (flags & CSIGNAL),
		        .stack      = (unsigned long)fn,
		        .stack_size = (unsigned long)arg,
		    };
		    return _do_fork(&args);
		}

##linux interrupt subsystem:
###interrupt bottom:
####softirq:

#####tasklet:

####workqueue:
#####系统前期一些workqueue创建流程:
	1,实例化workqueue_struct
		start_kernel->workqueue_init_early->alloc_workqueue->list_add_tail_rcu(&wq->list, &workqueues);
	2,为workqueue_struct创建工作者进程
		worker->task = kthread_create_on_node(worker_thread, worker, pool->node,--------所有工作者进程的入口函数都是worker_thread
                      "kworker/%s", id_buf);
	#0  kthread_create_on_node (threadfn=0xc01404a0 <rescuer_thread>, data=0xee403600, node=-1, namefmt=0xc013cb44 <init_rescuer+48> "") at kernel/kthread.c:383
	#1  init_rescuer (wq=0xee405900) at kernel/workqueue.c:4206
	#2  workqueue_init () at kernel/workqueue.c:6006
	#3  kernel_init_freeable () at init/main.c:1402
	#4  kernel_init (unused=<optimized out>) at init/main.c:1323
	#5  ret_from_fork () at arch/arm/kernel/entry-common.S:155
#####workqueue的使用
	1, 以tty为例
	void tty_buffer_init(struct tty_port *port)
	{
	    struct tty_bufhead *buf = &port->buf;
	    mutex_init(&buf->lock);
	    tty_buffer_reset(&buf->sentinel, 0);
	    buf->head = &buf->sentinel;
	    buf->tail = &buf->sentinel;
	    init_llist_head(&buf->free);
	    atomic_set(&buf->mem_used, 0);
	    atomic_set(&buf->priority, 0);
	    INIT_WORK(&buf->work, flush_to_ldisc);------1,先初始化一个work
	    buf->mem_limit = TTYB_DEFAULT_MEM_LIMIT;
	}
	queue_work(system_unbound_wq, &buf->work);-----2，中断来的时候会执行该函数，将work挂到worker thread的等待队列中，然后唤醒worker thread，
											------worker thread执行完work后，会将work从work queue中卸载，所以下次又可以执行queue_work

###workqueue and waitqueue difference:
	1, waitqueue用wake_up唤醒
	2, workqueue用queue_work()->wake_up()唤醒，

##linux misc subsystem:
###clk/clocksource/time区别:
	1, drivers/clk: device clk tree;
	2, drivers/clocksource: kernel time source;
	3, kernel/time: kernel time system.
###power/regulator区别:
	1, power: sleep wakeup system
	2, regulator: power management system
###cpufreq:
	1, cat /sys/devices/system/cpu/cpufreq
	2, drivers/base/bus.c:
		system_kset = kset_create_and_add("system", NULL, &devices_kset->kobj);-----这是在/sys/devices目录下
	3, drivers/base/cpu.c:
		subsys_system_register(&cpu_subsys, cpu_root_attr_groups)
###gpio/pinctrl区别:
	1, gpio:
	2, pinctrl:
###arm smp多核使能:
	1, edit smp_init

##linux sound architecture:
###Advanced Linux Sound Architecture:

##linux media architecture:
###Video4Linux:

##USB(universal serial bus):

##linux参数传递和管理:
###参数类型:
	1, 在__setup_start段里
	struct obs_kernel_param {
	    const char *str;
	    int (*setup_func)(char *);
	    int early;
	}
	#define __setup(str, fn)	__setup_param(str, fn, fn, 0)
	2, 在__start___param段里
	struct kernel_param {
	    const char *name;
	    struct module *mod;
	    const struct kernel_param_ops *ops;
	    const u16 perm;
	    s8 level;
	    u8 flags;
	    union {
	        void *arg;
	        const struct kparam_string *str;
	        const struct kparam_array *arr;
	    };
	}
	#define module_param(name, type, perm)	module_param_named(name, name, type, perm)

###参数节点创建:
	static void __init param_sysfs_builtin(void)
	{
	    const struct kernel_param *kp;
	    unsigned int name_len;
	    char modname[MODULE_NAME_LEN];
	    for (kp = __start___param; kp < __stop___param; kp++) {------只有这个段里的参数创建sys节点
	        char *dot;
	        if (kp->perm == 0)
	            continue;
	        dot = strchr(kp->name, '.');
	        if (!dot) {
	            /* This happens for core_param() */
	            strcpy(modname, "kernel");
	            name_len = 0;
	        } else {
	            name_len = dot - kp->name + 1;
	            strlcpy(modname, kp->name, name_len);
	        }
	        kernel_add_sysfs_param(modname, kp, name_len);
	    }
	}

##Linux accounts management:
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
###Linux用户类型:
	Linux用户类型分为 3 类：超级用户、系统用户和普通用户。
    超级用户：用户名为 root 或 USER ID(UID)为0的账号，具有一切权限，可以操作系统中的所有资源。root可以进行基础的文件操作以及特殊的文件管理，另外还可以进行网络管理，可以修改系统中的任何文件。日常工作中应避免使用此类账号，只有在必要的时候才使用root登录系统。
    系统用户：正常运行系统时使用的账户。每个进程运行在系统里都有一个相应的属主，比如某个进程以何种身份运行，这些身份就是系统里对应的用户账号。注意系统账户是不能用来登录的，比如 bin、daemon、mail等。
    普通用户：普通使用者，能使用Linux的大部分资源，一些特定的权限受到控制。用户只对自己的目录有写权限，读写权限受到一定的限制，从而有效保证了Linux的系统安全，大部分用户属于此类。
###Linux用户创建:
	6, sudo useradd username
	7, usermod:modify a user account
		-d, --home HOME_DIR
        The user's new login directory.
###登录或切换:sudo/su/login
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
	4, sudo report:使用sudo时报一下错误
		test is not in the sudoers file.  This incident will be reported.
		resolve mathods:解决方法
			a) modify /etc/sudoers
			b) modify user group to sudo group

##Bootloader:
###Bootloader种类
	Bootloader	Monitor		描述							x86		ARM			PowerPC
	LILO		否			Linux磁盘引导程序				是		否			否
	GRUB		否			GNU的LILO替代程序				是		否			否
	Loadlin		否			从DOS引导Linux					是		否			否
	ROLO		否			从ROM引导Linux而不需要BIOS		是		否			否
	Etherboot	否			通过以太网卡启动Linux系统的固件	是		否			否
	LinuxBIOS	否			完全替代BUIS的Linux引导程序		是		否			否
	BLOB		否			LART等硬件平台的引导程序		否		是			否
	U-boot		是			通用引导程序					是		是			是
	RedBoot		是			基于eCos的引导程序				是		是			是
###grub给kernel传参修改网络设备名eth0:
	1, 修改/boot/grub/grub.cfg,在linux参数项中加net.ifnames=0 biosdevname=0

##IC related:
###DMA burst:
	1, burst传输就是占用多个总线周期，完成一次块传输，此间cpu不能访问总线; DMA占用的周期个数叫做burst length.
	2, Burst操作还是要通过CPU的参与的，与单独的一次读写操作相比，burst只需要提供一个其实地址就行了，
	以后的地址依次加1，而非burst操作每次都要给出地址，以及需要中间的一些应答、等待状态等等。
	如果是对地址连续的读取，burst效率高得多，但如果地址是跳跃的，则无法采用burst操作
	3, DMA controler支持链表的，美其名曰“scatter”，内核有struct scatter可以参考
	4, transfer size：就是数据宽度，比如8位、32位，一般跟外设的FIFO相同。
	5, burst size：就是一次传几个 transfer size.

##nfs的使用:
	1, server端构建:
		安装nfs-kernel-server并配置:
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
	2, 直接在文件浏览器中挂载或打开,input smb://10.3.153.95/e/ in ubuntu files browser
	3,
		SMB:	Server Message Block
		CIFS:	Common Internet File System
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

##apt使用介绍:
	1, man:apt-get(8), apt-cache(8), sources.list(5), apt.conf(5), apt-config(8)
	2, apt-get install安装目录是包的维护者确定的，不是用户
		可以预配置的时候通过./configure --help看一下–prefix的默认值是什么，
		就知道默认安装位置了，或者直接指定安装目录。
		apt-config dump | grep  -i "dir::cache" show the apt download directory

##xdg-open:
	xdg-open: opens a file or URL in the user's preferred application

##ffplay-using
	ffplay -f rawvideo -pixel_format nv12 -video_size 640x480 cap.yuv

##wps:shutcut of Format brush
	双击格式刷就可以实现这个功能

##url:
	在WWW上，每一信息资源都有统一的且在网上唯一的地址，该地址就叫URL（Uniform Resource Locator,统一资源定位符），它是WWW的统一资源定位标志，就是指网络地址
	URL由三部分组成：资源类型、存放资源的主机域名、资源文件名。
	也可认为由4部分组成：协议、主机、端口、路径
	URL的一般语法格式为：
	(带方括号[]的为可选项)：
	protocol :// hostname[:port] / path / [;parameters][?query]#fragment

##service/systemd/systemctl?

##ssh/ssh-agent/ssh-copy-id?

##disk分区相关:
###MBR:
	1, MBR:Master Boot Record
	2, mbr最多支持四个主分区，gpt没有限制
	3, MBR结束标志：占MBR扇区最后2个字节，一直为“55 AA”
	4, MBR一共占用64个字节，其中每16个字节为一个分区表项
	也就是在MBR扇区中只能记录4个分区信息，可以是4个主分区，或者是3个主分区1个扩展分区。
https://www.cnblogs.com/hwli/p/8633314.html:
	5, 磁盘的第1个扇区叫做MBR扇区，一共有512B，主要有3个部分，引导信息、分区表、结束标志。
	  5.1 0~0x1BD即为引导程序，占扇区前446字节,计算机在上电完成BIOS自检后，会将该主引导扇区加载到内存中并执行前面446字节的引导程序，
		引导程序首先会在分区表中查找活动分区，若存在活动分区，则根据活动分区的偏移量找到该活动分区上的引导扇区的地址，并将该引导扇区加载到内存中，
		同时检查该引导扇区的有效性，然后根据该引导扇区的规则去引导操作系统。在一些非启动磁盘上，MBR引导代码可能都是0，这对磁盘使用没有任何影响。
	  5.2 0x1BE~0x1FD即为分区表，占扇区中间64字节。分区表是磁盘管理最重要的部分，通过分区表信息来定位各个分区，访问用户数据。
		分区表包含4个分区项，每一个分区项通过位置偏移、分区大小来唯一确定一个主分区或者扩展分区。
		每个分区项占16字节，包括引导标识、起始和结束位置的CHS参数、分区类型、开始扇区、分区大小等，具体描述如下表所示
		字节位移 	占用字节数 	描述
		0x01BE		1Byte		引导指示符，指明该分区是否是活动分区
		0x01BF 		1Byte 		开始磁头
		0x01C0 		6Bit 		开始扇区，占用6位
		0x01C1 		10Bit 		开始柱面，占用10位，最大值1023
		0x01C2 		1Byte 		分区类型，NTFS位0x07
		0x01C3 		1Byte 		结束磁头
		0x01C4 		6Bit 		结束扇区，占用6位
		0x01C5 		10Bit 		介乎柱面，占用10位，最大值1023
		0x01C6 		4Byte 		相对扇区数，从此扇区到该分区的开始的扇区偏移量，以扇区为单位
		0x01CA 		4Byte 		该分区的总扇区数
		字节位移0x01BE：引导指示符，只能是0和0x80，0代表是非活动分区，0x80代表是活动分区。活动分区里包含着操作系统的入口扇区。
		字节位移0x01BF~0x01C1:指明了该分区位于磁盘的物理位置。具体搜索C/H/S与LBA地址的对应关系
		字节位移0x01C2：文件系统格式
	  5.3 结束标志
	  最后的"55 AA"即为结束标志，或者称魔数，占扇区最后2字节。每次执行系统引导代码时都会检查MBR主引导扇区最后2字节是否是"55 AA"，
	  若是，则继续执行后续的程序，否则，则认为这是一个无效的MBR引导扇区，停止引导系统。
	6, 拓展分区
	由MBR中拓展分区信息，找到拓展分区表所在扇区，该扇区处又有像MBR类似的分区表信息，规则与MBR规则一样，只是此处分区表的分区类型不同，我们叫做逻辑分区。
	7, 疑问：按照上面每个分区的范围，MBR后面为什么保留了0x40个扇区？扩展分区扇区到逻辑分区扇区也保留了0x40个扇区？

###GPT:
	http://en.wikipedia.org/wiki/GUID_Partition_Table
	GPT:GUID Partition Table
	1, 保护MBR:
		只包含一个类型值为0xEE的分区项,它的作用是阻止不能识别GPT分区的磁盘工具试图对其进行分区或格式化等操作，所以该扇区被称为“保护MBR”;
		保护MBR位于GPT磁盘的第一(LBA0)扇区，也就是0号扇区，有磁盘签名，MBR磁盘分区表和结束标志组成，没有引导代码。
		而且分区表内只有一个分区表项，这个表项GPT根本不用，只是为了让系统认为这个磁盘是合法的。
	2, EFI部分:
	 EFI信息区位于磁盘的1号扇区(LBA1)，也称为GPT头
	 EFI部分又可以分为4个区域：EFI信息区(GPT头)、分区表、GPT分区、备份区域。
	  2.1, GPT头:
		起始于磁盘的LBA1，通常也只占用这个单一扇区。其作用是定义分区表的位置和大小。
		GPT头还包含头和分区表的校验和，这样就可以及时发现错误。
		GPT头位于GPT磁盘的第二个(LBA1)扇区，也就是1号扇区，该扇区是在创建GPT磁盘时生成，
		GPT头会定义分区表的起始位置，分区表的结束位置、每个分区表项的大小、分区表项的个数及分区表的校验和等信息。
	  2.2, 分区表:
		分区表位于GPT磁盘的LBA2～LBA33扇区，一共占用32个扇区，能够容纳128个分区表项。每个分区表项大小为128字节。
		因为每个分区表项管理一共分区，所以Windows系统允许GPT磁盘创建128个分区。
		每个分区表项中记录着分区的起始，结束地址，分区类型的GUID，分区的名字，分区属性和分区GUID。
	  2.3, 分区区域
		GPT分区区域就是用户使用的分区，也是用户进行数据存储的区域。分区区域的起始地址和结束地址由GPT头定义。
	  2.4, GPT头备份
		GPT头有一个备份，放在GPT磁盘的最后一个扇区，但这个GPT头备份并非完全GPT头备份，某些参数有些不一样。复制的时候根据实际情况更改一下即可。
	  2.5, 分区表备份
		分区区域结束后就是分区表备份，其地址在GPT头备份扇区中有描述。分区表备份是对分区表32个扇区的完整备份。
		如果分区表被破坏，系统会自动读取分区表备份，也能够保证正常识别分区。

###LBA:
	Logic Block Address
	我们俗称扇区

###UEFI:
	1, Unified Extensible Firmware Interface

###UUID
	UUID(Universally Unique IDentifiers)
####UUID由来:
	https://blog.csdn.net/smstong/article/details/46417213
	为解决上述问题，UUID被文件系统设计者采用，使其可以持久唯一标识一个硬盘分区。
	其实方式很简单，就是在文件系统的超级块中使用128位存放UUID。
	这个UUID是在使用文件系统格式化分区时计算生成的，
	例如Linux下的文件系统工具mkfs就在格式化分区的同时，
	生成UUID并把它记录到超级块的固定区域中。
####查看硬盘UUID
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

###MBR中主分区/拓展分区/逻辑分区:
	1, 主分区中不能再划分其他类型的分区,因此每个主分区都相当于一个逻辑磁盘
	主分区是直接在硬盘上划分的,逻辑分区则必须建立于扩展分区中
	2, 一个硬盘可以有1到3个主分区和1个扩展分区,也可以只有主分区而没有扩展分区,但主分区必须至少有1个,
	扩展分区则最多只有1个,且主分区+扩展分区总共不能超过4个。逻辑分区可以有若干个。
	3, 分出主分区后,其余的部分可以分成扩展分区,一般是剩下的部分全部分成扩展分区,也可以不全分,剩下的部分就浪费了。
	4, 扩展分区不能直接使用,必须分成若干逻辑分区。所有的逻辑分区都是扩展分区的一部分。
	硬盘的容量=主分区的容量+扩展分区的容量;   扩展分区的容量=各个逻辑分区的容量之和。
	5, 激活的主分区会成为“引导分区”(或称为“启动分区”),引导分区会被操作系统和主板认定为第一个逻辑磁盘
	6, DOS/Windows 中无法看到非激活的主分区和扩展分区
	7,  硬盘分区依照功能性的不同可分为主分区( Primary )、拓展分区(Extended)及逻辑分区( Logical ) 三种。
	硬盘最多可以分割成4个主分区或3个主分区+1个拓展分区

###kernel-scan-partition-table-gpt:
	kernel如何扫描一个块设备中的分区表信息的
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

###partitions-view-tools:
	df -T 只可以查看已经挂载的分区和文件系统类型。
	sudo fdisk -l 可以显示出所有挂载和未挂载的分区，但不显示文件系统类型。
	sudo parted -l 可以查看未挂载的文件系统类型，以及哪些分区尚未格式化。
	sudo lsblk -f 也可以查看未挂载的文件系统类型。
	sudo file -s /dev/sda3
	sudo blkid

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

##IC设计/生产/封装/测试：
###wafer/die/chip:
	1, wafer——晶圆
	2, die——晶粒,Wafer上的一个小块，就是一个晶片晶圆体，学名die，封装后就成为一个颗粒。
	3, chip——芯片
###chip package
	1, PGA:Pin Grid Array
	2, BGA:Ball Grid Array
	3, DIP:Dual Inline Package,双排直立式封装,黑色长得像蜈蚣
	4, QFP:塑料方形扁平封装
###chip test:
	1, WAT: Wafer Acceptance Test,是晶圆出厂前对testkey的测试
	2, CP: Circuit Probe/chip probing，是封装前晶圆级别对芯片测试。这里就涉及到测试芯片的基本功能了。
		通过了这两项后, 晶圆会被切割.
	3, FT:Final test，封装完成后的测试
	4, SLT:system level test
	5, ATE(Auto Test Equipment) 在测试工厂完成. 大致是给芯片的输入管道施加所需的激励信号，
		同时监测芯片的输出管脚，看其输出信号是否是预期的值。有特定的测试平台。

##开发板种类(EVB/REF):
	1, EVB(Evaluation Board) 开发板：软件/驱动开发人员使用EVB开发板验证芯片的正确性，进行软件应用开发
	2, REF(reference Board) 开发板：参考板
