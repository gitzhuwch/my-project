#all my notes below:
##vim:
###principle
    :help window -->/usr/share/vim/vim81/doc/windows.txt
    Summary:
    A buffer is the in-memory text of a file.
    A window is a viewport on a buffer.
    A tab page is a collection of windows.
    :help tabpage -->/usr/share/vim/vim81/doc/tabpage.txt
    A tab page holds one or more windows.
###tabline
    When nonempty, this option determines the content of the tab pages
    line at the top of the Vim window.  When empty Vim will use a default
    tab pages line.  See setting-tabline for more info.

    The tab pages line only appears as specified with the 'showtabline'
    option and only when there is no GUI tab line.  When 'e' is in
    'guioptions' and the GUI supports a tab line 'guitablabel' is used
    instead.  Note that the two tab pages lines are very different.

    The value is evaluated like with 'statusline'.  You can use
    tabpagenr(), tabpagewinnr() and tabpagebuflist() to figure out
    the text to be displayed.  Use "%1T" for the first label, "%2T" for
    the second one, etc.  Use "%X" items for closing labels.
###statusline
    When nonempty, this option determines the content of the status line.
    Also see status-line.

    The option consists of printf style '%' items interspersed with
    normal text.  Each status line item is of the form:
      %-0{minwid}.{maxwid}{item}
    All fields except the {item} are optional.  A single percent sign can
    be given as "%%".  Up to 80 items can be specified.  E541

    When the option starts with "%!" then it is used as an expression,
    evaluated and the result is used as the option value.  Example:
            :set statusline=%!MyStatusLine()
    The g:statusline_winid variable will be set to the window-ID of the
    window that the status line belongs to.

###minibufexplr/airline区别
    前者是基于window原理实现的(新建窗口来显示buffer name)，后者是基于tabpage原理实现的(修改tabline)
    大多插件是新建window来实现的，缺点是窗口显示易出问题.
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
        vim ~/.vim/bundle/vim-markdown/ftplugin/markdown.vim  //resize table of contents window
          execute 'vertical resize ' . (&columns/2)
          execute 'vertical resize ' . (&columns/6)
          ......
          call setline(i, repeat('    ', l:level). d.text)
    4, CTRL-G == :f :file "show current file path
    5, :help CTRL-] == :tag {ident}
    6,  A buffer is the in-memory text of a file.
        A window is a viewport on a buffer.
        A tab page is a collection of windows.
###vim中显示变量值
    echo &var //显示vim自定义变量值
    echo $var //显示系统环境变量值
    :se[t] Show all options that differ from their default value
    :set encoding?
    :set expandtab //当使用tab键时会替换成相应数目的空格
###vim取消快捷键映射
    map q <Nop> //取消烦人的q(recording)功能快捷键,然后就可map qq :qa!<CR>了
###vim-plugin:
    Vundle插件管理器是通过git clone下载插件的；
    有三种下载源:
        git clone https://github.com/vim-scripts/项目名     //github中vim-scripts的项目
        git clone https://github.com/用户名/项目名          //github中私有用户的项目
        git clone URL                                       //私有项目
    所以先在github上搜索插件,再添加到vimrc中.
    1, #如果你的插件是来自github中私有用户的，写在下方，只要用户名/项目名就行了
         Bundle 'tpope/vim-fugitive' #如这里就安装了vim-fugitive这个插件
         Bundle 'bogado/file-line'
    2, #如果插件来自 vim-scripts，你直接写项目名就行了
         Bundle 'L9'
         Bundle 'file-line.vim'
    3, #如使用其它的git库的插件，像下面这样做
         Bundle 'git://git.wincent.com/command-t.git'
    4, 如何移除插件
        (1)编辑.vimrc文件移除的你要移除的插件行
        (2)保存退出当前的vim
        (3)重打开vim，在命令模式下输入命名PluginClean。
###vimrc grammar:
    1, autocmd Filetype markdown inoremap<buffer> <silent> ,xxx
        autocmd Filetype markdown
        会在打开文件时判断当前文件类型，如果是 markdown 就执行后面的命令
        inoremap     也就是映射命令map，当然它也可以添加很多前缀
        ----------------------------------------------------------------------------------------------------------------------------
        |i    |表示在插入模式下生效                                                                                                 |
        ----------------------------------------------------------------------------------------------------------------------------
        |nore |表示非递归，而递归的映射，也就是如果键a被映射成了b，c又被映射成了a，如果映射是递归的，那么c就被映射成了b             |
        ----------------------------------------------------------------------------------------------------------------------------
        |n    |表示在普通模式下生效                                                                                                 |
        ----------------------------------------------------------------------------------------------------------------------------
        |v    |表示在可视模式下生效                                                                                                 |
        ----------------------------------------------------------------------------------------------------------------------------
        |c    |表示在命令行模式下生效                                                                                               |
        ----------------------------------------------------------------------------------------------------------------------------
        所以inoremap也就表示在插入模式下生效的非递归映射
        <buffer> <silent> map的参数，必须放在map后面
        <buffer> 表示仅在当前缓冲区生效，就算你一开始打开的是md文件，映射生效了，但当你在当前页面打开非md文件，该映射也只会在md文件中生效
        <silent> 如果映射的指令中使用了命令行，命令行中也不会显示执行过程
        后面就是按键和映射的指令了，逻辑什么的就是对 vim 的直接操作，就不详细介绍了
    2, below setting will cause vim search speed slowdown!!
        because prefix 'n'
        nnoremap nw <C-W><C-W>
###左中右对齐
    :17,57 left
    :17,57 center
    :17,57 right
###数字自增/自减
    1, ctrl + a：数字自动增加1
    2, number + ctrl + a：数字自动增加number
    3, ctrl + x：数字自动减小1
    4, number + ctrl + x：数字自动减小number
    5, :let i=1
       :g/^/ s//\=i . ' '/ |let i=i+1
    6, :s/^/\=range(5, 100)
       :s/^/\=range(5, 100, 2) //步进为2的数字序列
###十进制转十六进制
    vim command:
        :%s/\d\+/\=printf("%X", submatch(0))/g
    explain:
        %s            在整个文件中替换 (:help :s )
        \d\+            匹配一个或多个数字 (:help /\d  :help /\+ )
        \=           使用表达式的结果进行替换 (:help /\w )
        printf        按指定格式输出 (:help printf() )
        submatch()    返回:s命令中的指定匹配字符串 (:help submatch() )
        g           替换行内所有出现的匹配 (:help :s_flags)
        看来，替换命令的巧妙使用可以完成很多意想不到的功能！
###vim删除空行的4种技巧
    1, :g/^\s*$/d
       使用 global 命令删除Vim空白行
    2, :v/./d
       使用 vglobal 命令删除Vim文件空行,vglobal用于执行与 global 命令完全相反的操作
       . 用于匹配除换行符 \n 外的任何单字符
    3, :%!grep -v '^\s*$'
       执行 shell 命令删除Vim文件空行,cat -s test.txt 可将 test.txt 文件中的连续空白行替换为一个空白行
       而 grep -v '^\s*$' test.txt 命令可用于过滤 test.txt 文件中的所有空白行
       符号 % 代表当前文件的完整路径
    4, :%s/^\s*$\n//g
       使用替换命令substitute删除Vim文件空白行
       :substitute 命令 (缩写形式 :s) 可以将指定的字符替换成其他目标字符
###显示不可见字符
    cat -A file可以把文件中的所有可见的和不可见的字符都显示出来
    可以这样:%!cat -A在Vim中调用cat转换显示,这样的做法不便于编辑
    :set invlist即可以将不可见的字符显示出来，例如，会以^I表示一个tab符，$表示一个回车符等.
    或者，你还可以自己定义不可见字符的显示方式：
    set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
    set list
    最后，:set nolist可以回到正常的模式
###tab vs space
    1， tab键用4个空格替换，这种方式具有最好的兼容性
    2， 在.vimrc中添加以下代码后，重启vim即可实现按TAB产生4个空格：
        set ts=4  (注：ts是tabstop的缩写，设TAB宽4个空格)
        set expandtab
    3， 对于已保存的文件，可以使用下面的方法进行空格和TAB的替换：
        TAB替换为空格：
        :set ts=4
        :set expandtab
        :%retab!
    4， 空格替换为TAB：
        :set ts=4
        :set noexpandtab
        :%retab!
    加!是用于处理非空白字符之后的TAB，即所有的TAB，若不加!，则只处理行首的TAB。
###How do I disable the “Press ENTER or type command to continue” prompt in Vim
    https://stackoverflow.com/questions/890802/how-do-i-disable-the-press-enter-or-type-command-to-continue-prompt-in-vim
    1,  Add an extra <CR> to the shortcut
        map <F5> :wall!<CR>:!sbcl --load foo.cl<CR><CR>
    2,  :silent !<command>
    3,  :help hit-enter
    4,  :Silent top
###quickfix
    1, :set makeprg=xxxx
    2, :make/grep/helpgrep
    3, :cw
    4, :cclose/:copen
    5, :cn/cp
###vertical terminal
    1, :vertical terminal or :vert ter能在vim中启动一个终端
###taglist-plugin
    基于ctags才能发挥作用，因此要确保安装了ctags
    The taglist plugin requires the following:
    * Vim version 6.0 and above
    * Exuberant ctags 5.0 and above
###cscope
    1,  生成一个包含所有需要扫描的文件的列表，保存为cscope.files。Cscope默认会处理.c、.h、.y、.l后缀的文件，
        所以对于一个纯C项目，只需在项目根目录执行 cscope -R 即可建立数据库。但是如果需要解析C++、Java、
        Python文件，或者想不包含某些文件，那么就需要生成cscope.files。
        文件列表中的文件最好是绝对路径，这样就不会受数据库创建位置的限制。可以在根路径执行 find 命令来做到。
        如：
        find /my/project/dir -name '*.java' > /my/project/dir/cscope.files
        生成Cscope数据库:
        cscope -b -q -k
        -b 表示创建数据库， -q 创建一个反向索引文件，这在数据库较大时会使查找快很多， -k 开启内核模式，
        这样对项目中的 #include 文件，不查看/usr/include下的头文件。
        项目中增加了新文件后，将它们加入到cscope.files中，然后重新生成数据库。
    2,  cscope乱跳现象
        是因为源文件已修改,cscope数据库是旧的,所以按照旧的数据库找的行数是错的,自然跳的行数也是不对的.
###vim刷新屏幕
    1,  Ctrl-L      与tmux.conf中自定义刷屏快捷键冲突,在tmux之外可以用
    2,  :redraw!    可在.vimrc中自定义快捷键，<Leader>r :redraw!,可在tmux中使用，不加!只重绘，不刷屏
###text文件中画流程图
    方法一:
        安装vim plugin DrawIt
    方法二:
        浏览器打开:acsiiflow.cn(比较好用)
        网页源码已下载到本地(没有网络时使用)，导出到vim时，vim粘贴不要用ctrl+shift+v，直接在normal模式下p就行

##tmux:
###概念
    1,server/session/window/pane:
    tmux是基于C/S架构的
    一个tmux server上可创建多个session,
    一个session可创建多个window,
    一个window可分割成多个pane.
    每一个pane都对应一个虚拟终端:/dev/ps/xx(说明一个pane对应一个linux process session,因为session和tty一一对应)
###不要会话嵌套
    sessions should be nested with care, unset $TMUX to force
###tpm插件管理
    tpm (Tmux Plugin Manager)
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    <Ctrl>-b + <Shift>-i //安装插件
    <Ctrl>-b + <Shift>-u //更新插件
    <Ctrl>-b + <Alt>-u   //删除插件
####resurrect
    恢复窗口布局插件
    prefix + <Ctrl>-s手动备份，用prefix + <Ctrl>-r手动恢复
####continuum
    每隔15分钟备份一次布局
###tmux清屏
    bind -n C-k clear-history #清除历史记录不清屏
    bind-key b send-keys -R \; clear-history #清除历史记录并清屏
###tmux command
    1,  在tmux命令行中使用命令
        tmux list-commands  列出所有的 tmux 命令及其参数
        tmux list-keys      列出所有可以的快捷键和其运行的 tmux 命令
        tmux info           列出所有的 session, window, pane, 运行的进程号，等
    2， 在tmux里使用命令
        C-b + :(和vim类似)
    3,  简单命令
        #!/bin/bash
        tmux new-session -d -s ssh
        tmux split-window -h
        tmux select-pane -t 1
        tmux send-keys "cd /home/user/work/rtems-9-1-from-cd/build" C-m
        #tmux send-keys "arm-rtems5-gdb arm-rtems5/c/sgr5-expander/testsuites/samples/hello.out" C-m
        #tmux split-window -v
        tmux select-pane -t 0
        tmux send-keys "sudo minicom" C-m
        tmux send-keys "user" C-m
        tmux select-pane -t 0
        tmux attach-session -t ssh
###No protocol specified
    情景:   在电脑A本地启动一个tmux，在电脑B上通过ssh -X登陆到电脑A，然后tmux a唤起，在唤起的tmux中，
            使用gedit，报No protocol specified.
    分析:   以上tmux是在电脑A本地启动的，启动时没有$DISPLAY环境变量，所以X window用不了
    解决:   ssh -X登陆后，再执行tmux，启动新的tmux服务，这时tmux默认带了有环境变量$DISPLAY;
            应该可以手动export DISPLAY=localhost:10.0

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
        //也可以从gitee下载,速度更快:git clone https://gitee.com/mirrors/linux.git
        cd linux
        vim Makefile
            CROSS_COMPILE := arm-linux-gnueabi-
            ARCH ?= arm
        //do not modify gcc -O0 that will compiling error!! gcc -O can work, but need add local #pragma GCC optimize(O2) for gpu driver code.
        make vexpress_defconfig
        make zImage -j2
    5, git clone --depth=1 git://busybox.net/busybox.git
        //也可设置为nfs的挂载目录，直接通过网络文件系统进行挂载，便于开发。
        cd busybox
        vim Makefile
        ARCH ?= arm //maybe not must
        CROSS_COMPILE ?= arm-linux-gnueabi-
        make menuconfig
            Busybox Settings->
                Build Options->[*] Build Busybox as a static binary(no shared libs)
            Installtion Options
                在busybox instantlltionprefix一栏中，输入你想要创建rootfs的目录,比如我的是/opt/FriendlyARM/mini2440/rootfs。
            去掉Coreutils->sync选项；
            去掉Linux System Utilities->nsenter选项；
        make -j4 install  //busybox会自动将rootfs根文件系统安装到之前设置的目录下
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
    6,  #qemu-system-arm -kernel ./arch/arm64/boot/Image -append "console=ttyAMA0" -m 2048M -smp 4 -M virt -cpu cortex-a57 -nographic
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
    read /dev/kmsg      #accumulation log
    read /proc/kmsg     #real time log
###ftrace
    我主要用来跟踪某个内核函数从进入到退出，中间的调用流程，即用于跟踪内核调用栈.当然还有其他用途.
####原理
    在每个函数的入口插入call mcount桩指令
####exec命令带来的方便
    使用如下脚本可只trace指定程序
    ......
    echo $$ > set_ftrace_pid
    exec command

##strace
    用来跟踪应用程序调用了哪些系统调用，以及系统调用的参数
###常用参数
    1, -f 跟踪由fork调用所产生的子进程
    2, -ff 如果提供-o filename,则所有进程的跟踪结果输出到相应的filename.pid中,pid是各进程的进程号
    3, -c 统计每一系统调用的所执行的时间,次数和出错的次数等
    4, -t 在输出中的每一行前加上时间信息
    5, -T 显示每一调用所耗的时间
    6, -x 以十六进制形式输出非标准字符串
    7, -e expr 指定一个表达式,用来控制如何跟踪.格式：[qualifier=][!]value1[,value2]...
        qualifier只能是 trace,abbrev,verbose,raw,signal,read,write其中之一.value是用来限定的符号或数字.默认的 qualifier是 trace.
        感叹号是否定符号.例如:-e open等价于 -e trace=open,表示只跟踪open调用.而-etrace!=open 表示跟踪除了open以外的其他调用.
        有两个特殊的符号 all 和 none. 注意有些shell使用!来执行历史记录里的命令,所以要使用\\.
    8, -s strsize 指定输出的字符串的最大长度.默认为32.文件名一直全部输出.
    9, -u username 以username的UID和GID执行被跟踪的命令
###系统调用参数显示不全解决办法
    strace -e abbrev/--abbrev=syscall_set
        Abbreviate the output from printing each member of large structures.
    strace -s strsize/--string-limit=strsize
        Specify the maximum string size to print (the default is 32).  Note that filenames are not considered strings and are always printed in full
###跟踪vim向pts中写入的数据
    strace -fyo log.txt -e trace=write -s 1024 vim xxx

##ToolChains:
###GNU binary utilities:
####BFDL:
    Binary File Descriptor library;
    多数binutils程序使用BFD(Binary File Descriptor库)实现底层操作,多数也使用opcodes库来汇编及反汇编机器指令.
####objcopy:
    1, 要将一个二进制的文件，如图片作为一个目标文件的段:
        objcopy -I binary -O elf32-i386 -B i386 Dark.jpg image.o
        gcc -o test_elf main.c image.o
    2, objcopy --info List object formats and architectures supported
        objcopy -O ihex/verilog  //能够生成ihex,verilog文件
####ld:
    1,  ld --verbose 显示内置链接脚本
#####linkscript/Command Language
        https://www.math.utah.edu/docs/info/ld_3.html:
        https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_chapter/ld_3.html:
            The command language provides explicit control over the link process,
            allowing complete specification of the mapping between the linker's input files and its output.
        Scripts: Linker Scripts
        Expressions: Expressions
        MEMORY: MEMORY Command
        SECTIONS: SECTIONS Command
        Entry Point: The Entry Point
        Option Commands: Option Commands
###gdb:
    1, -E, --preserve-env  preserve user environment when running command
        sudo -E ./t7gdb vmlinux
            gdb:edit start_kernel   (success)
        sudo ./t7gdb vmlinux
            gdb:edit start_kernel   (failed)
####断点种类
    插入断点是为了让CPU产生exception.
    软件断点:在要调试的指令地址处,插入特殊指令,CPU执行到该地址的指令后时产生异常
    硬件断点:往CPU断点寄存器中写入要调试的指令地址,CPU执行到该地址时产生异常
####DWARF/COFF
    COFF(Common Object File Format)
    DWARF(Debugging With Attributed Record Formats)
    DWARF 调试信息简单的来说就是在机器码和对应的源代码之间建立一座桥梁
    但从我们平时使用的调试器提供给我们更多的信息:
        当前程序执行指令对应于源码的文件及行号
        当前程序栈帧(stack frame|activation record) 下的局部变量
    调试器如何从一些十分基础的信息，例如 IP(指令地址), 呈现给我们如此丰富的调试信息呢?
    那便我们为什么需要 DWARF, 其提供了程序运行时信息(Runtime)到源码信息的映射(Source File)
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
####cmd:monitor
    Send a command to the remote monitor (remote targets only).
    :monitor reset halt
    :monitor exit
####cmd:file&load
    file -- Use FILE as program to be debugged
    load -- Dynamically load FILE into the running program.
####set confirm off
    关闭gdb命令的确认交互
####gdb不退出重新加载?
    1, file xxx
    2, run
####target/remote/monitor区别
    1,  target: Connect to a target machine or process
    2,  remote: Manipulate files on the remote system.
        Transfer files to and from the remote target system.
    3,  monitor: Send a command to the remote monitor (remote targets only).

###GCC:
    GNU Compiler Collection
####gcc specifications file
    gcc -dumpspecs //Display all of the built in spec strings.
    cc 是一个驱动式的程序. 它调用其它程序来依次进行编译, 汇编和链接.
    GCC 分析命令行参数, 然后决定该调用哪一个子程序, 哪些参数应该传递给子程序.
    所有这些行为都是由 SPEC 字符串(spec strings)来控制的.
    通常情况下, 每一个 GCC 可以调用的子程序都对应着一个 SPEC 字符串, 不过有少数的子程序需要多个 SPEC 字符串来控制他们的行为.
    编译到 GCC 中的 SPEC 字符串可以被覆盖, 方法是使用 -specs= 命令行参数来指定一个 SPEC 文件(spec file).
    Spec 文件(Spec files) 就是用来配置 SPEC 字符串的. 它包含了一系列用空行分隔的指令. 指令的类型由一行的第一个非空格字符决定,
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
####-B/-I/-L
    1,  -Bprefix    This option specifies where to find the executables, libraries, include files, and data files of
                    the compiler itself
                    Add <directory> to the compiler's search paths.
    2,  -Idir       Add the directory dir to the list of directories to be searched for header files during preprocessing
    3,  -Ldir       Add directory dir to the list of directories to be searched for -l
####-dumpspecs
    Display all of the built in spec strings
####-print-search-dirs
    Display the directories in the compiler's search path
####-print-libgcc-file-name
    Display the name of the compiler's companion library.
####-specs=<file>
    Override built-in specs with the contents of <file>
####浮点相关参数
    https://blog.csdn.net/houxiaoni01/article/details/107521098
    xxx uses VFP register arguments xxx does not
    1,  -mfpu=vfp(or vfpv1 or vfpv2)
    2,  -mfloat-abi=soft 使用这个参数时，其将调用软浮点库(softfloat lib)来支持对浮点的运算，GCC编译器已经有这个库了，一般在libgcc里面。
        这时根本不会使用任何浮点指令，而是采用常用的指令来模拟浮点运算。如果使用的ARM芯片不支持硬浮点时，可以考虑使用这个参数。
        在使用这个参数时，链接时一般会出现下面的提示：
        undefined reference to '__aeabi_fdiv'
        这时使用将libgcc库加入即可
    3,  -mfloat-abi=softfp
        -mfloat-abi=hard
        这两个参数都用来产生硬浮点指令，至于产生哪里类型的硬浮点指令，需要由
        -mfpu=xxx参数来指令。这两个参数不同的地方是：
        -mfloat-abi=softfp生成的代码采用兼容软浮点调用接口(即使用-mfloat-abi=soft时的调用接口)，这样带来的好处是：兼容性和灵活性。
        库可以采用-mfloat-abi=soft编译，而关键的应用程序可以采用-mfloat-abi=softfp来编译。特别是在库由第三方发布的情况下。
        -mfloat-abi=hard生成的代码采用硬浮点(FPU)调用接口。这样要求所有库和应用程序必须采用这同一个参数来编译，否则连接时会出现接口不兼容错误。

##CODE VERSION CONTROL:
###git:
####git远程协议
    1，ssh/http/git协议都是CS架构;
    2, 使用ssh协议时，git向server的22端口发请求；
    3，ssh协议需要认证，http/git就不太清楚了？
####git简单命令介绍
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
    5,  git help --all
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
    7, git checkout master的底层等效操作
        git checkout xxx-SHA1: HEAD == xxx-SHA1 != refs/heads/master
        git reset    xxx-SHA1: HEAD == refs/heads/master == xxx-SHA1
    8, git clone url的分解动作
        mkdir repo-name + cd repo-name + git init + git remote add + git fetch + git checkout
####git diff/apply
    1, git diff - Show changes between commits, commit and working tree
    2, git apply - Apply a patch to files and/or to the index
####git format-patch/am
    1, git-format-patch - Prepare patches for e-mail submission
    2, git-am - Apply a series of patches from a mailbox
####git ls-remote报错
    git ls-remote
        fatal: No remote configured to list refs from.
    解决方法:
        git ls-remote remote_name 即后面加一个远程库名
####git fetch报错:
    git fetch origin tx:tx
        fatal: Refusing to fetch into current branch refs/heads/tx of non-bare repository
        fatal: The remote end hung up unexpectedly
    原因:因为该库当前处在tx分支上，git不允许在非bare库中以这种方式抓取远程分支，可能远程的tx分支已经前进了。
    解决方法1:
        在本地库中新建一个远程库中没有的分支，并切换到新建分支上去，然后再执行就可以了
    解决方法2:
        git fetch --update-head-ok origin refs/heads/*:refs/heads/* 即fetch加--update-head-ok参数
####git clone报id_rsa权限错误:
    git clone ssh://git@www.rockchip.com.cn/repo/rk/tools/repo
        Cloning into 'repo'...
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        @         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        Permissions 0777 for '/home/git/.ssh/id_rsa' are too open.
        It is required that your private key files are NOT accessible by others.
        This private key will be ignored.
        Load key "/home/git/.ssh/id_rsa": bad permissions
        git@www.rockchip.com.cn's password:
    解决方法:
        chmod 600 id_rsa*
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
####git pull::warning: redirecting to https://xxxx
    This is typical of a Git repo URL starting with git:// or http://,
    but which is redirected at the server level to https:// (which is more secure, and allows for authentication)
    解决方法:
        git remote set-url origin https://github.com/wanchao-zhu/my-project
####github下载慢
    解决方法:
        1, 使用gitee.com网站,目前免费,速度1~3MB/s
        2, 使用gitclone.com,是github的缓存服务器,命令:git clone https://gitclone.com/github.com/gitzhuwch/my-project
####hooks script从哪来?
    man git-init:
        /usr/share/git-core/templates

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
            --repo-url url  \repo repository location
            -u url          \--manifest-url=URL
            -b REVISION     \manifest branch or revision
            -m xx.xml       \initial manifest file
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
                                    Save revisions as current HEAD  把当前HEAD保存为manifest里的revision字段
              --suppress-upstream-revision                          去除manifest里的upstream字段
                                    If in -r mode, do not write the upstream field.  Only
                                    of use if the branch names for a sha1 manifest are
                                    sensitive.
              -o -|NAME.xml, --output-file=-|NAME.xml
                                    File to save the manifest to
####repo二次镜像库搭建:
    1, 一次repo镜像搭建(用于实时同步rockchip官方代码)
        sudo apt install -y repo
        mkdir mirror1
        cd mirror1
        repo init
            --mirror
            --repo-url ssh://git@www.rockchip.com.cn/repo/rk/tools/repo
            -u ssh://git@www.rockchip.com.cn/linux/rk/platform/manifests
            -b linux -m rk3399_linux_release.xml
        .repo/repo/repo sync
    2, 基于第一次下载的repo镜像再在另一台服务器上搭建一个repo镜像库(用于内部开发)
        (1)git clone ssh://git@10.3.153.96/home/git/rk-sdk-repository-mirror/repo
        (2)mkdir mirror2
        (3)cd mirror2
        (3)../repo/repo init
            --mirror
            --repo-url ssh://git@10.3.153.96/home/git/rk-sdk-repository-mirror/repo
            -u ssh://git@10.3.153.96/home/git/rk-sdk-repository-mirror/rk/platform/manifests
            -b linux -m rk3399_linux_release.xml
        (4)cd .repo/manifests
        (5)vim rk3399_linux_release.xml
            将<remote fetch="ssh://git@www.rockchip.com.cn/linux/" name="rk"/>
            改为<remote fetch="ssh://git@10.3.153.96/home/git/rk-sdk-repository-mirror/" name="rk"/> ------重点---改为第一次镜像的url
        (6)cd -
        (7).repo/repo/repo sync
        (8).repo/repo/repo start iflytek ------重要---基于当前的HEAD创建开发分支,不影响主分支,这样4.5步才能切分支
    3, 为第二次repo镜像服务器创建一个独立的manifests/repo仓库
        (1)首先搭建一个自己用的manifests库
            git clone ssh://git@10.3.153.96/home/git/rk-sdk-repository-mirror/rk/platform/manifests
            cd manifests
            git checkout -b iflytek -------新建一个自己用的分支,不影响主分支
            vim rk3399_linux_release.xml
            将<remote fetch="ssh://git@www.rockchip.com.cn/linux/" name="rk"/>
            改为<remote fetch="ssh://rksdk@10.3.153.233/home/rksdk/rk-sdk-mirror-from-96-git/" name="rk"/> ------重点---改为第二次镜像的url
            git add -A
            git commit -m "xxx"
        (2)搭建一个稳定统一的repo工具库
            git clone ssh://git@10.3.153.96/home/git/rk-sdk-repository-mirror/repo
    4, 开发人员使用第二次搭建的repo镜像服务器
        (1)mkdir develop
        (2)cd develop
        (3)repo init
            --repo-url ssh://rksdk@10.3.153.233/home/rksdk/repo ------第三步创建的repo工具库
            -u ssh://rksdk@10.3.153.233/home/rksdk/manifests------第三步创建的manifests库
            -b iflytek -m rk3399_linux_release.xml
        (4)repo sync
        (5)repo forall -c "git checkout -b iflytek refs/remotes/rk/iflytek" -------切换到2.8步创建的分支
###gerrit:
####java jdk或jre安装
    sudo apt install openjdk-8-jre
####apache安装
    sudo apt install apache
####apache模块软链接
    cd /etc/apache2/mods-enabled/
    确保一下软链接存在:
        proxy_balancer.conf -> ../mods-available/proxy_balancer.conf
        proxy_balancer.load -> ../mods-available/proxy_balancer.load
        proxy.conf -> ../mods-available/proxy.conf
        proxy_http.load -> ../mods-available/proxy_http.load
        proxy.load -> ../mods-available/proxy.load
#####apache配置
    在/etc/apache2/apache2.conf末尾添加:
    Listen 8081             //apache监听的端口
    <VirtualHost *:8081>
        ProxyRequests Off
        ProxyVia Off
        ProxyPreserveHost On
        <Proxy *>
              Order deny,allow
              Allow from all
        </Proxy>
        <Location "/login/">                                    //http认证对话框显示内容
            AuthType Basic
            AuthName "Gerrit Code Review"
            Require valid-user
            AuthBasicProvider file
            AuthUserFile /home/gerrit/proxy-passwd.file         //http帐户密码文件
        </Location>
        ProxyPass / http://10.3.153.96:8092/                    //apache收到8081端口发来的请求后转发给这个地址+端口(即gerrit web监听端口)
    </VirtualHost>
#####apache重启
    sudo /etc/init.d/apache2 restart
    sudo /etc/init.d/apache2 stop/start
#####查看apache启动状态
    sudo netstat -ltpn | grep -i apache
    或者使用ss命令
####gerrit下载
    也有其他下载方式，但没有下面这个快
        wget https://gerrit-releases.storage.googleapis.com/gerrit-2.14.6.war
    下面这个也能访问
        https://www.gerritcodereview.com/           //gerrit发布官网
        里面的下载链接也是访问上面的网址下载的
#####gerrit安装
    java -jar ~/gerrit-full-2.5.2.war init -d ~/gerrit_site
#####gerrit安装流程分析
    1, gerrit用户身份认证方式
        1.1 OpenID模式
            默认的鉴权方式为 openid，即使用任何支持OpenID 的认证源（如 Google、Yahoo！）进行身份认证。
            此模式支持用户自建帐号，用户通过OpenID 认证源的认证后，Gerrit 会自动从认证源获取相关属性如用户全名和邮件地址等信息创建帐号。
            如果是开放服务的Gerrit服务，使用OpenId认证是最好的方法
        1.2 LDAP模式
            如果有可用的 LDAP 服务器，可以直接使用LDAP 中的已有帐号进行认证，不过此认证方式下 Gerrit 的自建帐号功能是关闭的。
            登录时提供的用户名和口令通过LDAP服务器验证之后，Gerrit会自动从LDAP服务器中获取相应的字段属性，为用户创建帐号。
        1.3 HTTP模式
            此认证方式需要配置 Apache 的反向代理，并在Apache 中配置 Web 站点的口令认证，
            通过口令认证后Gerrit 在创建帐号的过程中会询问用户的邮件地址并发送确认邮件。
            当用户访问Gerrit网站首先需要通过Apache配置的HTTP Basic Auth认证，
            当Gerrit发现用户已经登录后，会要求用户确认邮件地址。
            当用户邮件地址确认后，再填写其他必须的字段完成帐号注册。
            HTTP认证方式的缺点除了在口令文件管理上需要管理员手工维护比较麻烦之外，还有一个缺点就是用户一旦登录成功后,
            想退出登录或者更换其他用户帐号登录变得非常麻烦，除非关闭浏览器。
        1.4 development_become_any_account
            任何访问者都可以使用管理账号
    2, gerrit数据库选择
        选择默认的H2，无须任何配置即可使用
    3, 反向代理使能
    4, 下载报错
        Downloading http://www.bouncycastle.org/download/bcprov-jdk16-144.jar ... !! FAIL !!
        Please download:
        http://www.bouncycastle.org/download/bcprov-jdk16-144.jar
        and save as:
        /home/user/gerrit/site/lib/bcprov-jdk16-144.jar
        Press enter to continue
        安装过程中会下载失败，按照以上提示，到该网站下载该包，放到指定目录，按回车继续
    5, 安装过程发现
        > 可以看到Gerrit服务打开了两个端口，其中29418是默认的Gerrit SSH端口，而8080是默认的Gerrit Web端口
        > netstat -ltpn | grep -i gerrit  用该命令可以看到gerrit所用端口号
        > service iptables stop  用该命令可以关闭防火墙
        > 80端口是apache代理的统一入口
    6, 登录
        登录的第一个用户将自动成为管理员（Account ID为1000000的就是管理员），所有后续登录的用户都是无权限用户（需要管理员指定权限）。
        如果你选择了development_become_any_account，在页面顶端会有一个Become链接，通过它可以进入注册/登录页面。
#####gerrit配置
    /home/gerrit/review3.2.2/etc/gerrit.config
        [gerrit]
            basePath = ./gerrit/
            canonicalWebUrl = http://10.3.153.96:8081                   //可以填写gerrit服务器域名
            serverId = 65d2a7b9-2c32-4443-b1d7-27d16f538725
        [container]
            javaOptions = "-Dflogger.backend_factory=com.google.common.flogger.backend.log4j.Log4jBackendFactory#getInstance"
            javaOptions = "-Dflogger.logging_context=com.google.gerrit.server.logging.LoggingContext#getInstance"
            user = root
            javaHome = /usr/lib/jvm/java-8-openjdk-amd64/jre
        [index]
            type = lucene
        [auth]
            type = HTTP                                         //使用http作为认证方式
        [receive]
            enableSignedPush = true
        [sendemail]
            smtpServer = localhost
        [sshd]
            listenAddress = *:29418
        [httpd]
            listenUrl = proxy-http://*:8092/                        //gerrit daemon监听端口
        [cache]
            directory = cache
#####gerrit重启
    sudo ./review3.2.2/bin/gerrit.sh restart
    sudo ./review3.2.2/bin/gerrit.sh stop/start
#####查看gerrit启动状态
    sudo netstat -ltpn | grep -i gerrit
    或者使用ss命令
####htpasswd命令
    htpasswd -c -b ~/proxy-passwd.file admin 123123     //-c 表示创建新文件; -b 表示密码由命令行提供
    http认证后，将用户名传给gerrit，gerrit以此创建gerrit帐户
    第一个gerrit用户有超级权限
####gerrit ssh命令行使用
    ssh -p 29418 admin@10.3.153.96 gerrit + 子命令
    ssh -p 29418 admin@10.3.153.96 gerrit + 子命令 + --help     //查看gerrit所有子命令
    ssh -p 29418 admin@10.3.153.96 gerrit + 子命令 + --help     //查看子命令帮助信息
####~/.ssh/config配置
    host gerrit-server
    user admin
    hostname 10.3.153.96
    port 29418
    identityfile ~/.ssh/id_rsa.pub
    这样就可以使用“ssh gerrit-server gerrit + 子命令”与gerrit daemon交互了
####gerrit用户注册与http认证
    1，gerrit用户与http认证中的帐户是独立的
####gerrit用户属性配置
    1, ssh命令行配置用户时，只有管理员才有权限；
    2，UI配置时，能登录就能配
#####邮箱配置
######邮箱由命令行配置
    ssh -p 29418 admin@10.3.153.96 gerrit set-account --add-email wczhu2@iflytek.com
    命令行配置邮箱不需要发确认邮件
######在UI界面配置
    gerrit3.2.2 UI上配置邮箱必须要发确认邮件，才能生效
#####ssh-key配置
######ssh-key由命令行配置
    cat ~/.ssh/id_rsa.pub | ssh -p 29418 admin@10.3.153.96 gerrit set-account --add-ssh-key -
######在UI上配置
    只有配置完邮箱才能在UI上配置ssh-key
####gerrit帐户配置的实现原理
    1，gerrit2.14之后的版本使用git仓库存储帐户信息
    以gerrit3.0.0为例:
        cd /home/gerrit/review3.0.0/git/All-Users.git
        tree refs/
            refs/
            ├── groups
            │   ├── 17
            │   └── 87
            │       └── 87f662f11d59506d3b08553e2baf52507d53e208
            ├── heads
            ├── meta
            │   └── config
            ├── sequences
            │   ├── accounts
            │   └── groups
            ├── tags
            └── users
                ├── 00
                │   └── 1000000             //这是创建的管理员帐户
                └── 01
                    └── 1000001             //这是创建的普通用户
        git log refs/users/00/1000000
            commit e62868bbea3e53547bf8a6e1be86aaf6462ef6b1 (refs/users/00/1000000)
            Author: zhuwanchao <admini@10.3.153.96>
            Date:   Tue Jul 28 17:01:16 2020 +0800

                Updated SSH keys

            commit b16f3be614e5f0b96bb0c2393900c54d66517908
            Author: Gerrit Code Review <gerrit@user-ThinkPad-E490>
            Date:   Tue Jul 28 17:00:18 2020 +0800

                Set Full Name via API

            commit 8b1f332a7de652eb45bbafaca566056414cdea36
            Author: Gerrit Code Review <gerrit@user-ThinkPad-E490>
            Date:   Tue Jul 28 16:59:54 2020 +0800

                Create Account on First Login
            管理员帐户有三次提交记录: 创建时提交; 修改full name时提交; 修改ssh keys时提交.
        git log refs/users/01/1000001
            commit 9d9ab42582495013ee816b23b378ae4c0f77fbe6 (refs/users/01/1000001)
            Author: user11 <user11@10.3.153.96>
            Date:   Tue Jul 28 17:12:48 2020 +0800

                Updated SSH keys

            commit 6986a24e8ddeecb13e1f3f6955c0af76ed07e4ac
            Author: Gerrit Code Review <gerrit@user-ThinkPad-E490>
            Date:   Tue Jul 28 17:12:15 2020 +0800

                Create Account on First Login
            该用户暂时有两次修改记录
    使用git cat-file -p + sha1IDke可以查看帐户的所有信息; 也可以将该git库clone出去，git checkout 相应的refs，来查看帐户信息
####学会看gerrit后台日志:
    review3.2.2/logs/error_log      //http服务或者sshd服务在和前台交互时的错误log
    review3.2.2/logs/sshd_log       //sshd与ssh -p 29418 ip gerrit sub-cmd交互过程的log
####gerrit工作原理
    1, 俩个特殊引用
        1.1 refs/for/<branch-name>
            Gerrit 的 Git 服务器，禁止用户向   refs/heads命名空间下的引用执行推送（除非特别的授权）;
            Gerrit 的 Git 服务器只允许用户向特殊的引用   refs/for/<branch-name>   下执行推送，其中   <branch-name>   即为开发者的工作分支;
            向   refs/for/<branch-name>   命名空间下推送并不会在其中创建引用而是为新的提交分配一个 ID，称为 task-id ，
            并为该 task-id 的访问建立如下格式的引用   refs/changes/nn/<task-id>/m;
        1.2 refs/changes/nn/<task-id>/m
            task-id 为 Gerrit 为评审任务顺序分配的全局唯一的号码。
            nn 为 task-id 的后两位数，位数不足用零补齐。即 nn 为 task-id 除以 100 的余数。
            m 为修订号，该 task-id 的首次提交修订号为 1，如果该修订被打回，重新提交修订号会自增。
    2, Git 库的钩子脚本 hooks/commit-msg
        为了保证已经提交审核的修订通过审核入库后，被别的分支 cherry-pick 后再推送至服务器时不会产生新的重复的评审任务，
        Gerrit 设计了一套方法，即要求每个提交包含唯一的 Change-Id，这个 Change-Id 因为出现在日志中，当执行 cherry-pick 时也会保持，
        Gerrit 一旦发现新的提交包含了已经处理过的   Change-Id   ，就不再为该修订创建新的评审任务和 task-id，而直接将提交入库。
        为了实现 Git 提交中包含唯一的 Change-Id，Gerrit 提供了一个钩子脚本，放在开发者本地 Git 库中（hooks/commit-msg）。
        这个钩子脚本在用户提交时自动在提交说明中创建以 "Change-Id: " 及包含   git hash-object   命令产生的哈希值的唯一标识。
        当 Gerrit 获取到用户向refs/for/<branch-name>   推送的提交中包含 "Change-Id: I..." 的变更 ID，如果该 Change-Id 之前没有见过，
        会创建一个新的评审任务并分配新的 task-id，并在 Gerrit 的数据库中保存 Change-Id 和 Task-Id 的关联。 如果当用户的提交因为某种原因被要求打回重做，
        开发者修改之后重新推送到 Gerrit 时就要注意在提交说明中使用相同的 “Change-Id” （使用 --amend 提交即可保持提交说明），
        以免创建新的评审任务，还要在推送时将当前分支推送到   refs/changes/nn/task-id/m中。其中   nn   和   task-id   和之前提交的评审任务的修订相同，
        m 则要人工选择一个新的修订号。

###gitolite:
    1, sudo useradd -r -m -s /bin/bash gitolite
    2, sudo passwd gitolite
    3, su - gitolite
    4, mkdir -p $HOME/bin
    5, git clone https://github.com/sitaramc/gitolite.git
    6, gitolite/install -to $HOME/bin
    7, $HOME/bin/gitolite setup -pk YourName.pub

####git describe failed; cannot deduce version numbe
      a)--depth=1 will not cover the release version so install failed
        git clone --depth=1  https://github.com/sitaramc/gitolite.git
        gitolite/install -to $HOME/bin
        **git describe failed; cannot deduce version numbe**
      b)success
        git clone https://github.com/sitaramc/gitolite.git
        gitolite/install -to $HOME/bin

####PTY allocation request failed on channel 0 hello id_rsa, this is git@user-ThinkPad-E490 running gitolite3 v3.6.11-9-gd89c7dd on git 2.17.1
    ssh -X git@10.3.153.96 report title error
    cat .ssh/authorized_keys
        # gitolite start
        command="/home/git/bin/gitolite-shell id_rsa",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty
        ssh-rsa
        AAAAB3NzaC1yc2EAAA......T4UNW7kAwKgonTeNg3
        user@user-ThinkPad-E490
        # gitolite end

####fatal: No path specified. See 'man git-pull' for valid url syntax
    git clone ssh://git@10.3.153.96:gitolite-admin report title error
    fix: below two all right
        git clone ssh://git@10.3.153.96:/gitolite-admin
        git clone ssh://git@10.3.153.96/gitolite-admin

###gitolite/gerrit:
    gitolite is through .ssh/authorized_keys-->command to export git repository
    gerrit is through ip:29418 port to process client requestion

##linux driver model:
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
##tty subsystem:
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
###tty3是怎么输出到屏幕上的?
####ftrace跟踪:------跟踪指定进程和指定的函数;下面有更友好的设置,输出log更好看
    1,  sudo su
    2,  set -x
        cd /sys/kernel/debug/tracing
        echo 0 > tracing_on
        echo "" > trace
        echo 50000 > buffer_size_kb
        echo '' > set_ftrace_pid
        echo 3328 > set_ftrace_pid #改成tty3的shell进程的PID
        #echo $$ > set_ftrace_pid
        echo "function_graph" > current_tracer
        echo "" > set_graph_function
        #-----------------------------------------------------------
        #千万不要设到set_ftrace_filter里面去了,那样所有其它函数都会被disabled
        echo "con_write" > set_graph_function
        #echo "con_write_room" > set_graph_function
        #echo "con_put_char" > set_graph_function
        #echo "con_flush_chars" > set_graph_function
        #echo "con_write" > set_graph_function
        #-----------------------------------------------------------
        #echo "noblock" > trace_options
        #echo "context-info" > trace_options
        echo "overwrite" > trace_options
        #echo "irq-info" > trace_options
        echo "display-graph" > trace_options
        echo "stacktrace" > trace_options
        echo "" > trace
        echo 1 > tracing_on
        #-----------------------------------------------------------
        #修改log存放目录,将log放到linux源码目录中方便跳转
        rm -f /home/user/temp/linux/trace.log
        cat trace_pipe > /home/user/temp/linux/trace.log
    3,  ctrl+alt+f3  #切换到tty3
    4,  输入:ls
    5,  ctrl+alt+f2  #切换回来
    6,  结束跟踪
        log如./tty3-ftrace.log
####总结
    由log不难看出，linux真实终端(不是ptm/pts/ttySn)tty3，输入输出直接是kernel里的keyboard和framebuffer，不经过用户层转换
    usb keyboard subsystem没有跟踪，也可以加个关键函数看看
###tty种类
    tty: teletypes 电传打字机
####vty内核里直接接屏幕和键盘
        virtual tty, Virtual Consoles, Screen Blanking, Screen Dumping, Color, Graphics, Chars, and VT100 enhancements by Peter MacDonald.
        设备节点为tty0, 给kernel传参console=/dev/tty0时, 可在lcd上显示log
####tty1-63虚拟终端(VT)
    1,  如果你的电脑只有一个终端，那将是多么乏味。一个需要长时间执行的任务就能导致你什么也做不了，
        Linux 的多任务机制的好处荡然无存。所以，你需要更多的终端。Linux 内核使用复用机制，
        将一个控制台复用为多个终端 (63 个，/dev/tty1 到 dev/tty63)。 按键 Alt+F1-F12 (
        如果当前在 X 中，需要再按下 Ctrl 键 ) 能在 12 个终端中进行切换。事实上你拥有 63 个
        终端，键盘只能切换其中的 12 个，其他的终端你可以通过 chvt 命令进行切换。
    2,  与vty同一代码文件, 这类tty主要是主机自带显示器和键盘
####console
        这类tty主要给printk使用,kernel启动早期还有early console,kernel启动参数cansole可控制,主要给kernel吐log的, init进程也可用
####ttySn
        这类tty是serial tty，对应串口设备
####pty伪终端
        这类是伪终端,psuedo tty,有/dev/ptmx和/dev/pts/n一对，ptmx是master，pts/n是slave,
        ptmx设备节点只有一个,可以被打开多次,每打开一次,会自动产生一个/dev/pts/n,并且open返回的fd都不同,
        通过fd可以找到与之对应的/dev/pts/n设备节点,主要给终端仿真器使用:gnome-ternimal,putty,sshd,tmux...
###tty_drivers
    所有tty_driver都会注册到tty_drivers里面,所以tty_open的时候到这个链表找tty_driver，都可以找得到
###/dev/tty设备
    1,tty 设备号5,0;打开时会用当前进程的tty
    2,cdev_init(&tty_cdev, &tty_fops);
    3,cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1)
###/dev/console设备
    1,console 设备号5,1;打开时会找cmdline中console=xxx指定的tty
    2,cdev_init(&console_cdev, &console_fops);
    3,cdev_add(&console_cdev, MKDEV(TTYAUX_MAJOR, 1), 1)
###/dev/tty0设备
    1,设备号4,0，打开时会找到struct tty_driver *console_driver
    2,cdev_init(&vc0_cdev, console_fops);
    3,cdev_add(&vc0_cdev, MKDEV(TTY_MAJOR, 0), 1)
###/dev/tty1-63设备
    1,设备号4,1-63，打开时会到tty_drivers链表里找
###/dev/ttySn设备
####ttyS0设备名的产生
    struct uart_port.line=x-------------------------
    ttySx-------------------------
    static struct uart_driver amba_reg = {
        .owner          = THIS_MODULE,
        .driver_name    = "ttyAMA",
        .dev_name       = "ttyS",---------------------------this is the uart port name base; +port.line =ttySx
        .major          = SERIAL_AMBA_MAJOR,
        .minor          = SERIAL_AMBA_MINOR,
        .nr             = UART_NR,
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
####/dev/ttySn设备号设定
#####由tty_driver->major决定
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
#####tty_driver->major怎么设定
#####由uart_driver决定
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
###/dev/ptmx和/dev/pts/n设备
    https://segmentfault.com/a/1190000009082089
####/dev/pts/x怎么输出到screen?
####/dev/ttyn与/dev/pts/n区别?
####ansower
#####SSH远程访问
    1.Terminal收到键盘的输入，Terminal通过ssh协议将数据发往sshd
    2.sshd收到客户端的数据后，根据它自己管理的session，找到该客户端对应的关联到ptmx上的fd
    3.往找到的fd上写入客户端发过来的数据
    4.ptmx收到数据后，根据fd找到对应的pts（该对应关系由ptmx自动维护），将数据包转发给对应的pts
    5.pts收到数据包后，检查绑定到自己上面的当前前端进程组，将数据包发给该进程组的leader
    6.由于pts上只有shell，所以shell的read函数就收到了该数据包
    7.shell对收到的数据包进行处理，然后输出处理结果（也可能没有输出）
    8.shell通过write函数将结果写入pts
    9.pts将结果转发给ptmx
    10.ptmx根据pts找到对应的fd，往该fd写入结果
    11.sshd收到该fd的结果后，找到对应的session，然后将结果发给对应的客户端
#####SSH + Screen/Tmux
    这种情况要稍微复杂一点，不过原理都是一样的，前半部分和普通ssh的方式是一样的，只是pts/0关联的前端进程不是shell了，
    而是变成了tmux客户端，所以ssh客户端发过来的数据包都会被tmux客户端收到，然后由tmux客户端转发给tmux服务器，而tmux服务器
    干的活和ssh的类似，也是维护一堆的session，为每个session创建一个pts，然后将tmux客户端发过来的数据转发给相应的pts。
    由于tmux服务器只和tmux客户端打交道，和sshd没有关系，当终端和sshd的连接断开时，虽然pts/0会被关闭，和它相关的shell和
    tmux客户端也将被kill掉，但不会影响tmux服务器，当下次再用tmux客户端连上tmux服务器时，看到的还是上次的内容。
###终端仿真器
    终端仿真器是能够接收源端发过来的数据、解析部分源端发过来的控制序列、显示源端数据的程序。
####内核空间终端仿真器
    drivers/tty/vt/vt.c
        do_bind_con_driver()
####用户空间终端仿真器
    基于ptm/pts实现的,如:gnome-terminal,putty,ssh...
###终端转义和控制序列
    man console_codes //Linux console escape and control sequences
    本质上是发送端和接收端的"控制协议"，发送端发送控制序列，接收端(包括tty driver和终端仿真器)来决定和执行什么样的行为。
    即:由源端发送控制序列，tty driver和仿真器来解析。
####内核解析部分控制字符代码
#####输入字符解析
    drivers/tty/n_tty.c:
        n_tty_receive_char_special()
            解析部分控制字符:start,stop,int,quit etc
#####输出字符解析
        do_output_char()
            转换\r,\n,\t,\b等字符
####内核终端仿真器解析部分代码
#####输入字符解析
    grep "033" drivers/tty/vt/* -rn
####改变终端仿真器的标题:
#####改变用户空间的gnome-terminal的标题
    使用转义序列来实现的，向ptsn端发送转义序列，监听在ptmx端的gnome-terminal收到后，
    执行解析代码，并做相应动作。
    1,方法:
        1)使用PROMPT_COMMAND和PS1俩个变量来实现
            export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD}\007"'  //PWD前面的HOME部分不能用~号缩写
            export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$\n\[\033[00m\]->"
        2)使用PS1一个变量来实现(优先使用此方法)
            export PS1="\[\e]0;\u@\h:\w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$\n\[\033[00m\]->"
        3)执行echo命令实现
            echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD}\007" //只刷新一次,如果想在标题中显示实时目录,这种方法不可取
    2,原理:
        1)  https://www.cnblogs.com/fanweisheng/p/11076987.html
            ESC ] 0 ; txt BEL       将图标名和窗口标题设为文本.
            ESC ] 1 ; txt BEL       将图标名设为文本.
            ESC ] 2 ; txt BEL       将窗口名设为文本.
            ESC ] 4 6 ; name BEL    改变日志文件名(一般由编译时选项禁止)
            ESC ] 5 0 ; fn BEL      字体设置为 fn.
#####改变kernel virtual console的标题
    内核终端仿真器能够解析该控制序列，但不做任何操作
    kernel源码:drivers/tty/vt/vt.c:do_con_trol()
####vim退出后恢复终端内容
    vim端:
        vim有俩个变量:t_ti,t_te，这俩变量来存放控制序列，在vim进入和退出时，会将该序列发给ptsn端，经过tty driver处理一部分
        控制序列，传到监听在ptmx端的终端仿真器gnome-terminal里，gnome-terminal会执行相应行为。
        t_ti = "\<Esc>[?1049h"
        t_te = "\<Esc>[?1049l"
    gnome-terminal端:
        接收到控制序列后，发现该序列让进入alternate screen和退出alternate screen，那么gnome-terminal就在vim打开时进入altscreen,
        进入后，相当于开启一个新的虚拟终端，默认占一屏，没有滚动条。退出时，接收到的控制序列是将之前的screen替换回来。
####linux像vim/man/less/top一样在终端的新屏幕中输出,退出后清屏返回原屏幕
    https://blog.csdn.net/youyudexiaowangzi/article/details/97763505
    1,script中实现
        #!/bin/bash
        tput smcup
        echo -e '\E7'
        echo -e '\033[?47h'
        tput cup 0 0
        echo "aaaaaaaaaaaaa"
        echo "aaaaaaaaaaaaa"
        echo "aaaaaaaaaaaaa"
        sleep 2
        tput cup 5 10
        echo "dddddddddddddd"
        echo "bbbbbbbbbbbbbb"
        echo "cccccccccccccc"
        sleep 2
        #echo -e '\E[2J'
        #echo -e '\033[?47l'
        #echo -e '\E8'
        tput rmcup
    tput smcup、tput rmcup是进入altscreen和退出altscreen，进入altscreen后相当于开启一个新的虚拟终端，此终端默认占一屏，没有滚动条，
    altscreen默认从下往上推动输出，即输出顺序不变，相对位置不变，但是不是从顶部开始输出，而是从底部网上推，所以需要调用
    tput cup命令设置cursor position（y，x）， 先竖直距离坐标，再横向距离坐标
    smcup、rmcup与echo -e对比：
        smcup
        \E7 saves the cursor's position
        \E[?47h switches to the alternate screen
        rmcup
        \E[2J clears the screen (assumed to be the alternate screen)
        \E[?47l switches back to the normal screen
        \E8 restores the cursor's position.
    2,程序中可以采用ncurses库
        #include <ncurses.h>
        #include <unistd.h>
        #define DELAY 30000
        int main(int argc, char *argv[])
        {
            int x = 0;
            int y = 0;
            int max_x = 0,max_y = 0;
            int next_x = 0;
            int direction = 1;
            initscr(); /* 初始化屏幕 */
            noecho(); /* 屏幕上不返回任何按键 */
            curs_set(FALSE); /* 不显示光标 */
            /* getmaxyx(stdscr, max_y, max_x);/* 获取屏幕尺寸 */
            mvprintw(5, 5, "Hello, world!");
            refresh(); /* 更新显示器 */
            sleep(1);
            while(1) {
                getmaxyx(stdscr, max_y, max_x);/* 获取屏幕尺寸 */
                clear(); /* 清屏 */
                mvprintw(y, x, "x");
                refresh();
                usleep(DELAY);
                next_x = x + direction;
                if(next_x >= max_x || next_x < 0) {
                    direction = (-1) * direction;
                }
                else {
                    x = x + direction;
                }
            }
            endwin();  /* 恢复终端 */
        }
    编译运行后，可以看到hello, world然后消失，一个x在第一行左右移动，ctrl+c可以退出，然后恢复终端
####printf实现进度条
    使用\r转义序列
    #define dprintf_info(fmt,args...) printf("\033[0;32m" fmt "\033[0m", ##args)
    dprintf_info("\rtest index:[%d]%5d [%c]", test_count, j, lable[j%4]);
####粗体斜体下划线闪烁
https://askubuntu.com/questions/528928/how-to-do-underline-bold-italic-strikethrough-color-background-and-size-i
    man console_codes
    echo -e "\e[1mbold\e[0m"
    echo -e "\e[3mitalic\e[0m"
    echo -e "\e[3m\e[1mbold italic\e[0m"
    echo -e "\e[4munderline\e[0m"
    echo -e "\e[9mstrikethrough\e[0m"
    echo -e "\e[31mHello World\e[0m"
    echo -e "\x1B[31mHello World\e[0m"
####gnome-terminal palette与vim配色
    gnome-terminal中可以设置text,cursor,bold颜色，调色板中可以定义16中特定颜色值对应的实际颜色等；
    vim将颜色值发给gnome-terminal后，gnome-terminal决定颜色值到颜色的映射.
####vt自动换行autowrap on/off
    echo -en "\e[?7h"   on
    echo -en "\e[?7l"   off
#####ftrace跟踪
    cd /sys/kernel/debug/tracing
    echo 0 > tracing_on
    echo "" > trace
    echo 50000 > buffer_size_kb
    echo '' > set_ftrace_pid
    #echo 70933 > set_ftrace_pid
    echo $$ > set_ftrace_pid                        ##与exec配合使用
    echo "function_graph" > current_tracer
    echo "" > set_graph_function
    #-----------------------------------------------------------
    echo "tty_write" > set_graph_function
    #-----------------------------------------------------------
    echo "noblock" > trace_options
    echo "nofuncgraph-irqs" > trace_options
    echo "nocontext-info" > trace_options
    echo "overwrite" > trace_options
    echo "noirq-info" > trace_options
    echo "display-graph" > trace_options
    echo "stacktrace" > trace_options
    #-----------------------------------------------------------
    echo "" > trace
    echo 1 > tracing_on
    #-----------------------------------------------------------
    #rm -f /home/user/temp/linux/trace.log
    cat trace_pipe > /home/user/temp/linux/trace1.log &
    #cat trace_pipe
    exec echo -ne "\e[?7ha"                         ##与$$配合使用
    #echo "a"
#####ftrace结果
    tty_write() {
        ...
      n_tty_write() {
          ...
        con_write() {
          do_con_write.part.0() {
         ...
            do_con_trol() {
                set_mode(){  -------drivers/tty/vt/vt.c
                    case 7:			/* Autowrap on/off */
                   vc->vc_decawm = on_off;
                }
            }
#####使用
    if (vc->vc_need_wrap) {
        cr(vc);
        lf(vc);
    }
####vim wrap实现
#####strace跟踪
    vim wrap功能是用\e[yy;xxH来控制光标换行实现输出字符换行的，kernel中的vt实现的wrap功能，禁止后，超出colums的字符就没法显示了，所以vim自己实现了wrap。
    在~/.vimrc中set wrap
    执行
        strace -fyo log2 -e trace=write -s 1024 vim test.txt
    在~/.vimrc中set nowrap
    执行
        strace -fyo log2 -e trace=write -s 1024 vim test.txt
        在vim中移动光标至行尾
#####用echo -en实验
    1, vim: set wrap; tty: \e[?7l
        echo -en "\e[?7l\e[3;1H\e[maaaaaaaaaaaaaaaaabbbbbbbbbbccddfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdddddd\e[4;1H\e[93m    \e[mddddddddddddhhhhhhhhhhhhjjjjjjj\r\n\e[94m" > /dev/pts/0
    这种情况依然能够换行，是因为将光标下移了一行后，才输出超出colums的字符
    2，vim: set nowrap; tty: \e[?7h
        echo -en "\e[?7h\e[3;1H\e[maaaaaaaaaaaaaaaaabbbbbbbbbbccddfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffddddddddddddddddddhhhhhhhhhhhhjjjjjjj\r\n\e[94m" > /dev/pts/0
    这种wrap是由终端模拟器完成的
###stty/tty工具
    1,  tty:显示当前终端设备文件
####stty常见的TTY配置
#####怎么禁止换行
    1,  好像不行.用转义控制序列可实现
    2,  systemctl -l --no-pager status xx.service
        如果打印的一行log长度,超出但前tty的colums的log,换一行打印
    3,  systemctl --no-pager status xx.service
        如果打印的一行log长度,超出但前tty的colums的log,被省略
    4,  以上2和3条,看似是tty的设置导致，实际上是systemctl自己作的判断，来控制打印长度和内容
        strace跟踪如下:
            不带-l: write(1</dev/pts/3>, "Nov 10 20:52:51 ubuntu exportfs["..., 112) = 112
            带-l:    write(1</dev/pts/3>, "Nov 10 20:52:51 ubuntu exportfs["..., 156) = 156
#####rows and columns set
    rows 51; columns 204;
    这个配置一般由终端控制，当终端的窗口大小发生变化时，需要通过一定的手段修改该配置，比如ssh协议里面就有修改窗口大小的参数，
    sshd收到客户端的请求后，会通过API修改tty的这个参数，然后由tty通过信号SIGWINCH通知前端程序（比如shell或者vim），前端程序
    收到信号后，再去读tty的这个参数，然后就知道如何调整自己的输出排版了。
#####intr = ^C
    tty除了在终端和前端进程之间转发数据之外，还支持很多控制命令，比如终端输入了CTRL+C，那么tty不会将该输入串转发给前端进程，
    而是将它转换成信号SIGINT发送给前端进程。这个就是用来配置控制命令对应的输入组合的，比如我们可以配置“intr = ^E”表示用
    CTRL+E代替CTRL+C。
#####start = ^Q; stop = ^S;
    这是两个特殊的控制命令，估计经常有人会碰到，在键盘上不小心输入CTRL+S后，终端没反应了，即没输出，也不响应任何输入。
    这是因为这个命令会告诉TTY暂停，阻塞所有读写操作，即不转发任何数据，只有按了CTRL+Q后，才会继续。这个功能应该是历史遗留，
    以前终端和服务器之间没有流量控制功能，所以有可能服务器发送数据过快，导致终端处理不过来，于是需要这样一个命令告诉服务器
    不要再发了，等终端处理完了后在通知服务器继续。
    该命令现在比较常用的一个场景就是用tail -f命令监控日志文件的内容时，可以随时按CTRL+S让屏幕停止刷新，看完后再按CTRL+Q让
    它继续刷，如果不这样的话，需要先CTRL+C退出，看完后在重新运行tail -f命令。
#####echo
    在终端输入字符的时候，之所以我们能及时看到我们输入的字符，那是因为TTY在收到终端发过去的字符后，会先将字符原路返回一份，
    然后才交给前端进程处理，这样终端就能及时的显示输入的字符。echo就是用来控制该功能的配置项，如果是-echo的话表示disable echo功能。
#####-tostop
    如果你在shell中运行程序的时候，后面添加了&，比如./myapp &，这样myapp这个进程就会在后台运行，但如果这个进程继续往tty上写
    数据呢？这个参数就用来控制是否将输出转发给终端，也即结果会不会在终端显示，这里“-tostop”表示会输出到终端，如果配置为“tostop”的话，
    将不输出到终端，并且tty会发送信号SIGTTOU给myapp，该信号的默认行为是将暂停myapp的执行。
####toe
    可以通过命令toe -a列出系统支持的所有终端类型
####infocmp
    可以通过命令infocmp来比较两个终端的区别，比如infocmp vt100 vt220将会输出vt100和vt220的区别。
###setterm关闭自动换行原理
    strace -fyo log.txt -e trace=open,read,write,ioctl -s 1024 setterm -linewrap off
        83531 write(1</dev/pts/10>, "\33[?7h", 5) = 5
###tput rmam同setterm
    tput smam恢复
###vim wrap与vt wrap总结
    1，vim使用的pts中的wrap默认是打开的，vim中的wrap变量的设置不影响tty中的wrap。当vim中设wrap时，如果从文件中读出的一行数据
        的长度超过tty的colums，那么vim会用\e[yy;xxH来设置cursor坐标，达到换行的目的
    2, 当vt中的wrap关闭时，超出colums的字符被截断，永远不显示
    3, if the terminal supports VT escape codes, echo -ne "\x1b[7l" will disable screen wrap
        (echo -ne "\x1b[7h" will enable it)."]")"]"
###终端下不换行和刷新当前行
    终端下耗时较长的程序运行过程中输出中间状态时，有时信息太多，希望一些次要的信息能被覆盖掉，整体显得干净一些。
    以往我用"\r"字符，控制输出的光标回到行首，再次输出覆盖上一行的信息，只要输出不换行，且下次输出的行长度不短于上一次，看起啦就是最后一行不断地在刷新。
    但是如果下一次的输出长度不确定，甚至因接口限制而必须换行时，这种方式就不行了。
    玩过BBS的都知道，ANSI定义了一套终端控制转义字符，可以更精细地控制屏幕输出，比如颜色，光标位置等。查阅ANSI转义代码表，
    CSI n K 　　EL – Erase in Line，当n==2时，清除当前行。
    CSI n F　　 CPL – Cursor Previous Line，光标上移一行。
    CSI为ESC字符，也就是八进制的\033或者\x1E字符，再跟一个左大括号。
    所以，如果能够不换行，只需要输出\r\033[2K字符，就能实现清除当前行并光标回到行首。
    如果字符串输出时，输出接口会自动加上一个换行的话，那就用CSI F回到上一行即可。
    最终，我用这种方式实现了，在Blade中，编译源代码的状态信息自动刷新，削减了3/4的滚屏。
###终端模拟器水平方向的滚动
    一般终端模拟器不实现水平方向的滚动，当一行数据太长时，要么打开自动wrap，要么超出colums的数据丢失。
    水平方向的滚动都由应用程序管理
###vt为什么不实现横向滚动
    滚动功能是将已经flush到屏幕的字符滚动显示，那么要实现这个功能，就要缓存已经flush的字符数据，tty中只能缓存敲回车之前的字符数据，即echo buffer，
    没有其他的缓存区来记录已经显示在屏幕上的字符数据了，所以要实现这样的缓存功能，要么在显示驱动中做，要么在上层应用中做，要么在终端仿真器中做。
    在显示驱动中做显然不合理，那么只有在具体应用中做，或者在终端仿真器中做。
    在具体应用中做，如: vim，less...
    在终端仿真器中做，如: kernel中的vt，userspace中的gnome-terminal,xterminal,xshell,screen
###已经flush到screen的字符
    这些字符数据是实现滚动，查找操作的材料，
    缓存这些数据的地方:
        1, 不在tty framwork中；
        2, 可以在vim,less等应用中；
        3, 可以在vt,gnome-terminal等终端仿真器中
###tty echo buffer
    echo buffer是tty用来存放回显字符的缓存区
    1, 在echo buffer中可以用方向键移动光标，在已经flush到屏幕的字符不能用方向键移动光标
    2, 当echo buffer中的字符数量大于屏幕colums时，autowrap打开:可以自动换行和用方向键移动光标；autowrap关闭时:超出colum的字符中不显示光标移动
####在echo buffer中按左右方向键
    strace结果
        504693 pselect6(1, [0</dev/tty3>], NULL, NULL, NULL, {[], 8}) = 1 (in [0])
        504693 read(0</dev/tty3>, "\33", 1)     = 1
        504693 pselect6(1, [0</dev/tty3>], NULL, NULL, NULL, {[], 8}) = 1 (in [0])
        504693 read(0</dev/tty3>, "[", 1)       = 1
        504693 pselect6(1, [0</dev/tty3>], NULL, NULL, NULL, {[], 8}) = 1 (in [0])
        504693 read(0</dev/tty3>, "D", 1)       = 1
        504693 write(2</dev/tty3>, "\10", 1)    = 1
        504693 pselect6(1, [0</dev/tty3>], NULL, NULL, NULL, {[], 8} <detached ...>
    结论:
        vt接收到向左的方向键，转化成\e[D，传给bash，bash在向tty中写入\010(BACKSPACE)，实现移动光标
####在echo buffer中按DEL键
    strace结果
        504693 pselect6(1, [0</dev/tty3>], NULL, NULL, NULL, {[], 8}) = 1 (in [0])
        504693 read(0</dev/tty3>, "\177", 1)    = 1
        504693 write(2</dev/tty3>, "\33[C\33[C\33[K\10\10\10", 12) = 12
        504693 pselect6(1, [0</dev/tty3>], NULL, NULL, NULL, {[], 8} <detached ...>
    结论:
        将DEL键转化成转义控制序列输出到vt中
###TTY相关信号
    除了上面介绍配置时提到的SIGINT，SIGTTOU，SIGWINCHU外，还有这么几个跟TTY相关的信号
    跟tty相关的信号都是可以捕获的，可以修改它的默认行为
####SIGTTIN
    当后台进程读tty时，tty将发送该信号给相应的进程组，默认行为是暂停进程组中进程的执行。暂停的进程如何继续执行呢？
    请参考下一篇文章中的SIGCONT。
####SIGHUP
    当tty的另一端挂掉的时候，比如ssh的session断开了，于是sshd关闭了和ptmx关联的fd，内核将会给和该tty相关的所有进程
    发送SIGHUP信号，进程收到该信号后的默认行为是退出进程。
####SIGTSTP
    终端输入CTRL+Z时，tty收到后就会发送SIGTSTP给前端进程组，其默认行为是将前端进程组放到后端，并且暂停进程组里所有进程的执行。
###DISPLAY/TERM环境变量
####Linux X Window System的基本原理
    https://m.linuxidc.com/Linux/2013-06/86743.htm
    X是一个开放的协议规范，当前版本为11，俗称X11。X Window System由客户端和服务端组成，服务端X Server负责图形显示，
    而客户端库X Client根据系统设置的DISPLAY环境变量，将图形显示请求发送给相应的X Server
    因此，我们只需要在远端开启一个X Server，并在目标机器上相应的设置DISPLAY变量，即可完成图形的远程显示
    X Server是Gnome等桌面环境的基础，一个桌面环境通常包含了XDM（X Display Manager，通常的图形化用户登录界面就属于XDM）、
    窗口管理器（X Server显示的图形是没有&ldquo;窗口&rdquo;边框的，通过替换窗口管理器可以实现不同的视觉效果，比如实现3D效果的Compiz）等组件
    /usr/bin/Xorg :0 -nr -verbose -audit 4 -auth /var/run/gdm/auth-for-gdm-Ikd3i7/database -nolisten tcp vt1
    这表示在display 0上运行着一个X Server，这里的X Server是Xorg
####DISPLAY
    DISPLAY环境变量是X window(X11)的client端设置的,ssh -X时就会在本地初始化Xserver端(Xorg进程)，
    远程初始化一个Xclient端,client设置环境变量DISPLAY为:localhost:10.0这样的值,ssh不带-X时就不会设置
####TERM
    TERM环境变量是选择终端类型的，比如linux,screen-256color,xterm...
    不同的选择会影响颜色,快捷键等
###man pty
    pty - pseudoterminal interfaces
        Pseudoterminals are used by applications such as network login services (ssh(1),
        rlogin(1), telnet(1)), terminal emulators such as xterm(1), script(1), screen(1), tmux(1),
        unbuffer(1), and expect(1).
###\n与\r区别
    1,  \n是换行，在minicom中，只改变纵坐标不改变横坐标，ascii:0x0a LF
    2,  \r时回车，在minicom中，只改变横坐标不改变纵坐标，ascii:0x0d CR
###EOL of unix,macos,dos
    1, unix EOL is <NL> 换行符
    2, mac EOL is <CR> 回车符
    3, dos EOL is <CR><NL> 回车加换行
###tty3上也能使用tmux
    说明tmux是纯字符画面
###tmux分屏符是怎么显示出来的
####strace跟踪
    strace -fyxo trace-tmux.log tmux
####strace跟踪结果：
    vim trace-tmux.log
        writev(5</dev/pts/0>, [{iov_base="\x1b\x5b\x31\x3b\x39\x36\x48\xe2\x94\x82\x1b\x5b\x32\x3b\x39\x36\x48\xe2\x94\x82\x1b\x5b\x33\x3b\x39\x36\x48\xe2\x94\x82\x1b\x5b"..., iov_len=976}, {iov_base="\x1b\x5b\x4b\x0a\x1b\x5b\x4b\x0a\x1b\x5b\x4b\x0a\x1b\x5b\x4b\x0a\x1b\x5b\x4b\x0a\x1b\x5b\x4b\x0a\x1b\x5b\x4b\x0a\x1b\x5b\x4b\x0a"..., iov_len=318}], 2 <unfinished ...>
        注意:strace只显示了部分参数，实际长度为iov_len=976，并且一次发了多个iov_base
####实验：
        echo -en "\xe2\x94\x82\n\xe2\x94\x82\n"
####结论
    1, tmux的所有画图都是用writev(5</dev/pts/0),函数完成的
    2, tmux的分屏符不是ASCII，是UNICODE码:\xe2\x94\x82
###tmux client的标准IO作用
    由上一章节的strace结果可知，tmux server会将输出的字符、画图字符、控制编码都写入client的标准IO中，并且可以有多个client连接同一个server，这样可以实现
    所谓的屏幕镜像
        +----------------------------------------------------------------------------------------------------------+
        |    user space                                                                                            |
        |                                                                                                          |
        |                                                                                                          |
        |                          +---------------+            +-----------+                                      |
        |                          |gnome-terminal |        +-->|tmux server|<----------------+                    |
        |                          +--^----------^-+        |   +------^----+                 |                    |
        |                             |          |         1|2         |                      |                    |
        |                            1|2         |          |         1|       program1      2|       program2     |
        |                             |         1|2         |          |           |          |          |         |
        |                             |          |          |          |           |          |          |         |
        |     +-----------------------v----+   +-v----+   +-v----+   +-v----+   +--v---+   +--v---+   +--v---+     |
        +-----| video/keyboard input event |---|ptmx0 |---|pts/0 |---|ptmx1 |---|pts/1 |---|ptmx2 |---|pts/2 |-----+
        |     +----------------------------+   +-^----+   +---^--+   +--^---+   +---^--+   +---^--+   +--^---+     |
        |                                        |            |         |           |          |         |         |
        |                                        |           1|2       1|          1|         2|        2|         |
        |                                        |            +---+     |           |   +------+         |         |
        |                                       1|2               |     |           |   |                |         |
        |                                        |            +---v-----v-----------v---v-+              |         |
        |                                        +----------->|       tty    driver       |<-------------+         |
        |                                                     +---------------------------+                        |
        |                                                                                                          |
        |        kernel space                                                                                      |
        |                                                                                                          |
        |                                                                                                          |
        +----------------------------------------------------------------------------------------------------------+
###字符编码
    是将文字符号转化成计算机的二进制码
    整个tty系统都是基于字符的系统，包括可显示的字符，和控制编码（或者叫不可显示的字符，也是字节序），所以了解一些字符编码很有必要
####ASCII码
####ASCII扩展码
####unicode码
####utf8码
####gb2312/gbk码
###字符的显示
    在终端中(包括虚拟终端，伪终端)，是将字符编码根据font文件转化成字形，然后将字形数据copy到显存里
####字体font
    分为点阵字体和矢量字体
#####kernel中自带的font文件
    点阵字体
    lib/fonts/fonts.c
    lib/fonts/font_8x16.c
    lib/fonts/font_8x8.c
#####用户层更改终端字体
    ctrl+alt+f3 //切换到tty3
    cd /usr/share/consolefonts/
    strace -fyxo xx.txt setfont ./Lat15-Terminus14.psf.gz
        ioctl(3</dev/tty3>, KDFONTOP, 0x7ffc926534a0) = 0
        --- SIGWINCH {si_signo=SIGWINCH, si_code=SI_KERNEL} ---
        ioctl(3</dev/tty3>, PIO_UNIMAPCLR, 0x7ffc926534c2) = 0
        ioctl(3</dev/tty3>, PIO_UNIMAP, 0x7ffc92653520) = 0
    KDFONTOP:这个case应该会将用户层的字体数据copy到vt中
    也可以修改/etc/default/console-setup
####字体转RGB
#####虚拟终端中字符显示
    sudo su
    cd /sys/kernel/debug/tracing
    执行tty3-ftrace.sh:-------------跟踪指定进程和指定的函数
        set -x
        cd /sys/kernel/debug/tracing
        echo 0 > tracing_on
        echo "" > trace
        echo 50000 > buffer_size_kb
        echo '' > set_ftrace_pid
        echo 4115 > set_ftrace_pid
        #echo $$ > set_ftrace_pid
        echo "function_graph" > current_tracer
        echo "" > set_graph_function
        #-----------------------------------------------------------
        echo "tty_write" > set_graph_function
        #-----------------------------------------------------------
        echo "noblock" > trace_options
        echo "nofuncgraph-irqs" > trace_options
        echo "nocontext-info" > trace_options
        echo "overwrite" > trace_options
        echo "noirq-info" > trace_options
        echo "display-graph" > trace_options
        echo "stacktrace" > trace_options
        #-----------------------------------------------------------
        echo "" > trace
        echo 1 > tracing_on
        #-----------------------------------------------------------
        rm -f /home/user/temp/linux/trace.log
        cat trace_pipe > /home/user/work/linux/trace.log
        #cat trace_pipe
    以tty3虚拟终端为例，向tty3写入一个字符的ASCII码的ftrace log的部分内容:
    fbcon_putcs() {
      get_color() {
        fb_get_color_depth();
      }
      get_color() {
        fb_get_color_depth();
      }
      bit_putcs() {
        fb_get_color_depth();
        fb_get_buffer_offset();
        drm_fb_helper_cfb_imageblit [drm_kms_helper]() {
          cfb_imageblit();
          drm_fb_helper_dirty.isra.13 [drm_kms_helper]() {
            _raw_spin_lock_irqsave();
            _raw_spin_unlock_irqrestore();
            queue_work_on();
          }
        }
      }
    }
    会根据ASCII码，从字体文件中找到字形偏移量，然后copy出来显示
###开机进入命令行模式(tty1)
    sudo vim /etc/default/grub
    把GRUB_CMDLINE_LINUX_DEFAULT=”quiet splash”改成GRUB_CMDLINE_LINUX_DEFAULT=”quiet splash text”
    然后更新grub
    sudo update-grub
###tty3分辨率调节(解决进入命令界面时字体过大)
    sudo vim /etc/default/grub
    加入GRUB_GFXPAYLOAD_LINUX=1280x1024(最新的不一定是这个参数，可以在这个文件里找一找)
    设置成显卡所支持的分辨率，可以参考显示功能所列出的分辨率
    然后更新grub
    sudo update-grub
###配色和字体
    方法一：
        sudo vim /etc/default/console-setup
        改成如下配置：
        #一般推荐：
        CODESET="Hebrew"
        FONTFACE="VGA"
        FONTSIZE="16"
    方法二（没测试过）：
        sudo dpkg-reconfigure console-setup
###vim and terminal的配色文件
    vim:/usr/share/vim/vim81/colors/*
    terminal:/lib/terminfo/*
             /usr/share/terminfo/*
###用infocap linux能解析terminfo数据库
###Linux terminals, tty, pty and shell
    https://dev.to/napicella/linux-terminals-tty-pty-and-shell-192e
####How does pseudo terminal work?
    Terminal emulator (or any other program) can ask the kernel for a pair of characters files (called PTY master and PTY slave).
    On the master side you have the terminal emulator, while on the slave side you have a Shell.
    Between master and slave sits the TTY driver (line discipline, session management, etc.) which copies stuff from/to PTY master and slave.
    Let's see what happens when...
    you type something in a terminal emulator in the user land like XTerm or any any other application you use to get a terminal.
    Usually we say we open 'the terminal' or we open 'a bash', but what it actually happens is:
        1, a GUI which emulates the terminal starts (like the Terminal or Xterm UI application).
        2, it draws the UI to the video and requests a pty from the OS.
        3, launches bash as subprocess
        3, The std input, output and error of the bash will be set to be the pty slave.
        4, XTerm listens for keyboard events and sends the characters to the pty master
        5, The line discipline gets the character and buffers them. It copies them to the slave only when you press enter. It also writes back its input to the master (echoing back). Remember the terminal is dumb, it will only show stuff on the screen if it comes from the pty master. Thus, the line discipline echoes back the character so that the terminal can draw it on the video, allowing you to see what you just typed.
        6, When you press enter, the TTY driver (it's 'just' a kernel module) takes care of copying the buffered data to the pty slave
        7, bash (which was waiting for input on standard input) finally reads the characters (for example 'ls -la'). Again, remember that bash standard input is set to be the PTY slave.
        8, At this points bash interprets the character and figures it needs to run 'ls'
        9, It forks the process and runs 'ls' in it. The forked process will have the same stdin, stdout and stderr used by bash, which is the PTY slave.
        10, ls runs and prints to standard output (once again, this is the pty slave)
        11, the tty driver copies the characters to the master(no, the line discipline does not intervene on the way back)
        12, XTerm reads in a loop the bytes from the pty master and redraws the UI
    I think we made it! That's roughly what happens when we run a command in a terminal emulator. The drawing should help consolidate the workflow:
    +-------------------------------------------------------------------------+
    |            +---------------------------+                                |
    |            |     terminal emulator     |                                |
    |            |     (ui like xterm,       |         +------+      +------+ |
    |            |     listen for keys       |         |bash  |      |cat   | |
    |            |     and draws the gui)    |         +------+      +------+ |
    |            +---------------------------+          |    |        |    |  |
    |              |   |       |    |                   |    |        |    |  |
    |      ________|   |      I|   O|                   |____|________|____|  |
    |     |            |       |    |                         I|   O|         |
    | +--------+  +--------+  +------+      userspace         +------+        |
    +-| screen |--|keyboard|--|ptmx  |------------------------|pts/x |--------+
    | +--------+  +--------+  +------+      kernelspace       +------+        |
    |                          |    |     +----------------+   |    |         |
    |                         I|   O|     |   TTY DRIVER   |  I|   O|         |
    |                          |    +-----|(line discipline|---+    |         |
    |                          +----------|is applied here)|--------+         |
    |                                     +----------------+                  |
    +-------------------------------------------------------------------------+
    注意:   上图中，如果是使用ptm/pts的terminal emulator，则在应用层使用GUI画字符界面，
            如果是使用ttyn(比如按ctrl+alt+fn)的真实终端，则在kernel层使用vt driver直接画字符界面.
####How can a program control the terminal?
    The way for programs to control the terminal is standardized by the ANSI escape codes.
    Want to change the color of the text from your program?
    Just print to standard out the ANSI escape code for coloring the text.
    Standard out is the PTY slave, TTY driver copies the character to the PTY master, terminal gets the code and understands it needs to set the color to print the text on the screen. Voilà'!'
####How can I "mirror" everything that's happening on one terminal to another?
    m1,
        pacman -Syyu | tee /dev/tty1
    m2, redirect standard out and error of bash also to a file.
        s1, Terminal 1
            bash -i 2>&1 | tee -a out
        s2, tail -f out
    m3, use tmux
####line discipline
    You could put the terminal in "raw mode" which is also known as "no line discipline"
    and the function table would be filled with 127 copies of "send-char-to-program"
    function, immediately producing a task wakeup

##input subsystem
###相关目录
    1, /dev/input/
    2, /proc/bus/input/
    3, /sys/class/input
###设备层-核心层-事件层
    1，device层文件
        drivers/input/keyboard/atkbd.c
    2, core层文件
        drivers/input/input.c
    3, event层文件
        drivers/tty/vt/keyboard.c
                                                                            +-----------------+
                      +-----------------+  +--------------+ +--------------+ |/dev/input/mice  | +------------+
                      |/dev/input/event0|  |/dev/input/ts0| |/dev/input/js0| |/dev/input/mouse0| |/dev/console|
                      |/dev/input/event1|  |/dev/input/ts1| |/dev/input/js1| |/dev/input/mouse1| |/dev/ttyn   |
                      |......           |  |......        | |......        | |......           | |......      |
                      +--------^--------+  +------^-------+ +------^-------+ +--------^--------+ +------^-----+
                               |                  |                |                  |                 |
    +--------------------------|------------------|----------------|------------------|-----------------|---------+
    |kernel space              |                  |                |                  |                 |         |
    |  +-------------+     +-------+          +-------+       +--------+        +----------+       +----------+   |
    |  |event handler|---->|evdev.c|          |tsdev.c|       |joydev.c|        |mousedev.c|       |keyboard.c|   |
    |  +-------------+     +-------+          +-------+       +--------+        +----------+       +----------+   |
    |-------------------------------------------------------------------------------------------------------------|
    |  +----------+                               +---------------------+                                         |
    |  |input core|------------------------------>|drivers/input/input.c|                                         |
    |  +----------+                               +---------------------+                                         |
    |-------------------------------------------------------------------------------------------------------------|
    |  +------------+      +-----------+         +----------+          +--------+        +------+                 |
    |  |input driver|----->|s3c2410ts.c|         |usbmouse.c|          |usbkbd.c|        |......|                 |
    |  +------------+      +-----------+         +----------+          +--------+        +------+                 |
    +-------------------------------------------------------------------------------------------------------------+
###input_dev与input_handler匹配
    device匹配handler:
        input设备在增加到input_dev_list链表上之后，会查找
        input_handler_list事件处理链表上的handler进行匹配，这里的匹配
        方式与设备模型的device和driver匹配过程很相似，所有的input device
        都挂在input_dev_list上，所有类型的事件都挂在input_handler_list
        上，进行“匹配相亲”
        list_for_each_entry(handler, &input_handler_list, node)
            input_attach_handler(dev, handler); /*遍历input_handler_list，试图与每一个handler进行匹配*/
    handler匹配device:
        对于Event handler，就是根据事件注册一个handler，将handler挂到链表input_handler_list下，然后遍历input_dev_list链表,查找并匹配输入设备对应的事件处理层，
        如果匹配上了，就调用connect函数进行连接，并创建input_handle结构
###input_register_device函数
    1, 添加设备；
    2, 把输入设备挂到输入设备链表input_dev_list中；
    3, 遍历input_handler_list链表，查找并匹配输入设备对应的事件处理层，如果匹配上了，就调用handler的connnect函数进行连接。
        设备就是在此时注册的，下面分析handler就清晰了。（input_attach_handler放到分析handler时再做讲解，更容易理解。）
###/dev/input/event节点的创建
    input_dev和input_handler match之后会调用input_handler的connect函数:
        static int mousedev_connect(struct input_handler *handler,
                struct input_dev *dev,
                const struct input_device_id *id)
        {
            struct mousedev *mousedev;
            int error;
            mousedev = mousedev_create(dev, handler, false); --------这里创建/dev/input/eventx
            if (IS_ERR(mousedev))
                return PTR_ERR(mousedev);
            error = mixdev_add_device(mousedev);
            if (error) {
                mousedev_destroy(mousedev);
                return error;
            }
            return 0;
        }
###input_event处理流程
                        +-----------+
                        |program app|
                        +-----^-----+
                              |
                              |
                              |read
                              |
                              |
      +------------+      +------------+                 user space
+-----|device node0|------|device nodex|------------------------------+
|     +------------+      +-^----------+                 kernel space |
|                           |  |read opration will add wait queue     |
|                           |  |           +----------+               |
|    dev and handler match  |  +---------->|wait queue|               |
|    then create input dev  |              +----^-----+               |
|    node                   |                   |wake up              |
|                           |       +-----------+                     |
|                           |       |                                 |
|                         +------------+                              |
|              +--------->| input core |<------+                      |
|              |          +------------+       |                      |
|              |input_handler_register         |input_device_register |
|              |                               |                      |
|              |                               |                      |
|          +-----------+                  +----+-------+              |
|          |input event|                  |input device|              |
|          +---^-------+                  +------------+              |
|              |                               |                      |
|              |                               |                      |
|              +-------------------------------+                      |
|               dev interrupt call handler.event                      |
|               then event()->wake_up user app                        |
+---------------------------------------------------------------------+
###input subsystem与tty关系
    输入子系统是相对独立的，除了可以服务于tty/console之外，也可以通过设备文件服务于X Window等窗口管理器和用户程序

##VT(virtual terminal)
###VT中的键盘输入流程
    基于kernel的input subsystem实现了input_handler驱动:drivers/tty/vt/keyboard.c
    usb键盘中断 调用 input_handler->evnet，然后
        static void kbd_event(struct input_handle *handle, unsigned int event_type,
                      unsigned int event_code, int value)
        {
            /* We are called with interrupts disabled, just take the lock */
            spin_lock(&kbd_event_lock);
            if (event_type == EV_MSC && event_code == MSC_RAW && HW_RAW(handle->dev))
                kbd_rawcode(value);
            if (event_type == EV_KEY && event_code <= KEY_MAX)
                kbd_keycode(event_code, value, HW_RAW(handle->dev));
            spin_unlock(&kbd_event_lock);
            tasklet_schedule(&keyboard_tasklet);
            do_poke_blanked_console = 1;
            schedule_console_callback(); ------->这里会调void schedule_console_callback(void)
                                                         {
                                                             schedule_work(&console_work);--->唤醒tty wait进程
                                                         }
        }
####scancode转换成keycode
####对方向键的处理
    static void k_cur(struct vc_data *vc, unsigned char value, char up_flag)
    {
        static const char cur_chars[] = "BDCA";
        if (up_flag)
            return;
        applkey(vc, cur_chars[value], vc_kbd_mode(kbd, VC_CKMODE));
    }
    最终将方向键转化成终端控制序列，发给用户程序，用户程序再发给终端仿真器，终端仿真器解析后实现显示效果
###VT中的屏幕输出流程
    基于framebuffer实现的:drivers/tty/vt/vt.c
                          drivers/video/fbdev/core/fbcon.c
                            static const struct consw fb_con = {
                                .owner          = THIS_MODULE,
                                .con_startup        = fbcon_startup,
                                .con_init       = fbcon_init,
                                .con_deinit         = fbcon_deinit,
                                .con_clear      = fbcon_clear,
                                .con_putc       = fbcon_putc,
                                .con_putcs      = fbcon_putcs, ------>显示函数
                                .con_cursor         = fbcon_cursor,
                                .con_scroll         = fbcon_scroll,
                                .con_switch         = fbcon_switch,
                                .con_blank      = fbcon_blank,
                                .con_font_set       = fbcon_set_font,
                                .con_font_get       = fbcon_get_font,
                                .con_font_default   = fbcon_set_def_font,
                                .con_font_copy      = fbcon_copy_font,
                                .con_set_palette    = fbcon_set_palette,
                                .con_scrolldelta    = fbcon_scrolldelta,
                                .con_set_origin     = fbcon_set_origin,
                                .con_invert_region  = fbcon_invert_region,
                                .con_screen_pos     = fbcon_screen_pos,
                                .con_getxy      = fbcon_getxy,
                                .con_resize             = fbcon_resize,
                                .con_debug_enter    = fbcon_debug_enter,
                                .con_debug_leave    = fbcon_debug_leave,
                            };
####ftrace log
    fbcon_putcs() {
     get_color() {
       fb_get_color_depth();
     }
     get_color() {
       fb_get_color_depth();
     }
     bit_putcs() {
       fb_get_color_depth();
       fb_get_buffer_offset();
       drm_fb_helper_cfb_imageblit [drm_kms_helper]() {
         cfb_imageblit();
         drm_fb_helper_dirty.isra.13 [drm_kms_helper]() {
           _raw_spin_lock_irqsave();
           _raw_spin_unlock_irqrestore();
           queue_work_on();
         }
       }
     }
   }

##uevent subsystem:
###uevent_helper
    1, /sys/kernel/uevent_helper
####/sys/kernel目录怎么创建的
    kernel/ksysfs.c
        ksysfs_init()
            -->kernel_kobj = kobject_create_and_add("kernel", NULL);
####/sys/kernel/uevent_helper节点怎么创建的
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
###mdev开机自动生成设备节点
    1,在qemu中kernel起来后，在rcS里加了mdev -s 所以/dev下会有节点

##linux filesystem:
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
    int __init devtmpfs_mount(void)
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
    https://www.cnblogs.com/arnoldlu/p/8051674.html
###arm32内存管理在qemu上调试
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
###mmap
    根据mmap是否映射到文件、是共享还是私有映射，将映射类型分成四类，使用场景如下：
    |-------------------|-----------------------------------------------|-------------------------------------------------------|
    |   场景            |       私有影射                                |   共享映射                                            |
    |-------------------|-----------------------------------------------|-------------------------------------------------------|
    |   匿名映射        |       通常用于内存分配                        |   通常用于进程间内存共享，常用于父子进程之间通信。    |
    |                   |       fd=-1，flags=MAP_ANONYMOUS|MAP_PRIVATE  |   fd=-1，flags=MAP_ANONYMOUS|MAP_SHARED               |
    |-------------------|-----------------------------------------------|-------------------------------------------------------|
    |   文件映射        |       通常用于加载动态库                      |   通常用于内存映射IO、进程间通信、读写文件。          |
    |                   |       flags=MAP_PRIVATE                       |   flags=MAP_SHARED                                    |
    |-------------------|-----------------------------------------------|-------------------------------------------------------|
###kernel地址空间PGD同步:
    http://www.wowotech.net/forum/viewtopic.php?id=27
    Step 1：A进程调用vmalloc分配了一段虚拟内存，首地址是x。这时候，所有进程的页表并没有建立关于x的项目，唯一完整建立x地址段的页表是init_mm的PGD。
    Step 2：当进程A、B都访问了某个虚拟地址x，此时A、B的页表都与init_mm同步后，A和B也都建立好了关于x这个虚拟地址段的页表。
            但是，这里需要强调的是：对于x虚拟地址段，A进程和B进程有不同的PGD，但是它们PGD中关于x地址段的entry们都是指向相同的PMD。
            当然PMD entry指向的PTE也是相同的。换句话说，对于x地址段，所有进程还有init mm而言，它们的PMD和PTE都是共享的。
    Step 3：进程A调用vfree函数释放了地址x，当然操作的依然是init mm的PGD以及其下级的页表们。需要说明的是：所有根是init mm PGD的那些PMD和PTE的内存不会回收，
            因此x地址段的PMD和PTE页表本身的内存并不会释放，vfree只是将x地址段对应的页表项全部清除。
    Step 4：进程B访问x地址段的时候，PGD entry指向了大家共享的PMD，PMD的entry指向了大家共享的PTE，但是，PTE中的具体的entry已经被清除，
            因此产生page fault
    各个用户进程拥有自己的PGD，内核线程没有自己的PGD，只是借用某个用户进程的PGD（借用哪一个是看缘分，上面说了，是和进程切换相关）
    Master kernel PGD不属于任何的用户进程或者内核线程，它就是一个共用的模板而已。当申请了内核空间的虚拟地址段的时候，
    内核只是修改了Master kernel PGD以及其child translation table的内容，也就是说仅仅是在模板上设立好了Translation table，
    而各个进程的Translation table还都是空的，这些是在真正访问的时候，发生异常，在异常处理流程中，根据模板中的数据建立自己的页表数据。
###进程切换之地址空间的切换:
    所有和进程地址空间相关的内容都被封装到一个叫做mm_struct的数据结构中，被称作memory descriptor。
    每个用户空间进程都有其对应的memory descriptor，具体位于进程task_struct的mm成员中。内核线程是否有memory descriptor呢？没有，
    因此其进程描述符的mm成员指向了NULL。不过，对于linux而言，内核的最小调度单位是线程，因此存在内核线程和用户线程之间的切换问题，
    每当切换的时候，需要切换进程地址空间（切换页表，进程的页表信息位于其mm_struct的pgd成员中），用户线程到用户线程的切换当然没有问题，
    但是用户线程和内核线程之间的切换就会有问题，因为内核线程没有memory descriptor，怎么办？只能是借用了，
    因此，在进程描述符（task_struct）中有一个active_mm的成员，表示该进程（内核线程）当前正在使用的memory descriptor（注意：“使用”并不表示“拥有”）。
    对于普通用户进程，它拥有自己的memory descriptor，因此进程描述符的active_mm和mm成员指向同一个memory descriptor
    （自己有memory descriptor，当然使用自己的了）。对于内核线程，它不可能”拥有“memory descriptor（mm等于NULL），
    因此active_mm需要借用其他进程的memory descriptor，可以参考下面的代码（代码来自4.1.10）：
    －－－－－－－－－－－－－－－－－－－－
    static inline struct rq *
    context_switch(struct rq *rq, struct task_struct *prev,
               struct task_struct *next)
    {
        struct mm_struct *mm, *oldmm;
        prepare_task_switch(rq, prev, next);
        mm = next->mm;
        oldmm = prev->active_mm;
        /*
         * For paravirt, this is coupled with an exit in switch_to to
         * combine the page table reload and the switch backend into
         * one hypercall.
         */
        arch_start_context_switch(prev);
        if (!mm) {－－－－－－－－－－－－－－－－切换到一个内核线程（next的mm成员为NULL）
            next->active_mm = oldmm;－－－－－－－借用上一个的使用的memory descriptor
            atomic_inc(&oldmm->mm_count);
            enter_lazy_tlb(oldmm, next);
        } else－－－－－－－－－－－－－－－－－－－切换到普通进程
        switch_mm(oldmm, mm, next);-----------------切换地址空间
        if (!prev->mm) {
            prev->active_mm = NULL;－－－－－－－－－如果是从一个内核线程切换到某个其他进程，那么借用期结束
            rq->prev_mm = oldmm;
        }
        /*
         * Since the runqueue lock will be released by the next
         * task (which is an invalid locking op but in the case
         * of the scheduler it's an obvious special-case), so we
         * do an early lockdep release here:
         */
        spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
        context_tracking_task_switch(prev, next);
        /* Here we just switch the register state and the stack. */
        switch_to(prev, next, prev);
        barrier();
        return finish_task_switch(prev);
    }
    －－－－－－－－－－－－－－－－－－－－－－－－－－
    讲了这么多，似乎还是没有到init_mm，呵呵，那么init_mm到底是属于哪一个进程呢？其实init_mm不属于任何的进程或者内核线程。
    当然，在启动阶段，swapper进程（idle进程，pid等于0的那个进程）曾经借用国init_mm，但是初始化完成，
    调度器正常运作之后（至少发生了一次进程切换涉及到了idle进程），init_mm不和任何的进程相关了。

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
    static int __init default_rootfs(void)
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
    static int __init populate_rootfs(void)
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
###sysfs cpu节点:
    /sys/devices/system/cpu/
####节点创建:
    1, drivers/base/bus.c:
        system_kset = kset_create_and_add("system", NULL, &devices_kset->kobj);-----这是在/sys/devices目录下创建节点
    2, drivers/base/cpu.c:
        subsys_system_register(&cpu_subsys, cpu_root_attr_groups)
####cpu调频节点:
    /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
####cpu开关核节点:
    /sys/devices/system/cpu/cpu1/online
###Linux CPU使用率
https://segmentfault.com/a/1190000008322093
###Linux OOM killer
https://segmentfault.com/a/1190000008268803
###gpio/pinctrl区别:
    1, gpio:
    2, pinctrl:
###arm smp多核使能:
    1, edit smp_init
###linux I/O model:
    阻塞IO      (blocking IO)
    非阻塞IO    (nonblocking IO)
    IO复用      (select 和poll) (IO multiplexing)
    信号驱动IO  (signal driven IO (SIGIO))
    异步IO      (asynchronous IO (the POSIX aio_functions))
####缓存 IO
    缓存 IO 又被称作标准 IO，大多数文件系统的默认 IO 操作都是缓存 IO
####阻塞/非阻塞:
    block/ nonblock
    针对的对象只有一个;
####同步/异步:
    synchronous communication/ asynchronous communication
    针对的对象俩个;
    与IC接口异步通信/同步通信不一样;
####poll与block read/write区别:
    以按键驱动为例进行说明，用阻塞的方式打开按键驱动文件/dev/buttons，应用程序使用read()函数来读取按键的键值。
    这样做的效果是：如果有按键按下了，调用该read()函数的进程，就成功读取到数据，应用程序得到继续执行；
    倘若没有按键按下，则要一直处于休眠状态，等待这有按键按下这样的事件发生。
    这种功能在一些场合是适用的，但是并不能满足我们所有的需要，有时我们需要一个时间节点。
    倘若没有按键按下，那么超过多少时间之后，也要返回超时错误信息，进程能够继续得到执行，而不是没有按键按下，就永远休眠。
    这种例子其实还有很多，比方说两人相亲，男方等待女方给个确定相处的信，男方不可能因为女方不给信，就永远等待下去，双方需要一个时间节点。
    这个时间节点，就是说超过这个时间之后，不能再等了，程序还要继续运行，需要采取其他的行动来解决问题。

##linux sound architecture?
###Advanced Linux Sound Architecture:

##linux media architecture?
###Video4Linux:

##linux USB framework?
    universal serial bus

##linux参数传递和管理:
###参数类型:
    1, 在__setup_start段里
    struct obs_kernel_param {
        const char *str;
        int (*setup_func)(char *);
        int early;
    }
    #define __setup(str, fn)    __setup_param(str, fn, fn, 0)
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
    #define module_param(name, type, perm)  module_param_named(name, name, type, perm)

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
###/sys/module目录创建:
    static int __init param_sysfs_init(void)
    {
        module_kset = kset_create_and_add("module", &module_uevent_ops, NULL);
        if (!module_kset) {
            printk(KERN_WARNING "%s (%d): error creating kset\n",
                __FILE__, __LINE__);
            return -ENOMEM;
        }
        module_sysfs_initialized = 1;
        version_sysfs_builtin();
        param_sysfs_builtin();
        return 0;
    }
    subsys_initcall(param_sysfs_init);
##linux权限管理
###Linux文件权限?
###Linux进程权限?
###Linux accounts management:
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
####useradd与adduser
    1, useradd is a low level utility for adding users. On Debian, administrators should usually use adduser(8) instead
    2, file /usr/sbin/adduser
        /usr/sbin/adduser: Perl script text executable
    3, file /usr/sbin/useradd
        /usr/sbin/useradd: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked
####Linux用户类型:
    Linux用户类型分为 3 类：超级用户、系统用户和普通用户。
    超级用户：用户名为 root 或 USER ID(UID)为0的账号，具有一切权限，可以操作系统中的所有资源。root可以进行基础的文件操作以及特殊的文件管理，
              另外还可以进行网络管理，可以修改系统中的任何文件。日常工作中应避免使用此类账号，只有在必要的时候才使用root登录系统。
    系统用户：正常运行系统时使用的账户。每个进程运行在系统里都有一个相应的属主，比如某个进程以何种身份运行，
              这些身份就是系统里对应的用户账号。注意系统账户是不能用来登录的，比如 bin、daemon、mail等。
    普通用户：普通使用者，能使用Linux的大部分资源，一些特定的权限受到控制。用户只对自己的目录有写权限，读写权限受到一定的限制，
              从而有效保证了Linux的系统安全，大部分用户属于此类, 普通用户可用来登录。
####linux用户帐户创建:
    1, sudo useradd -r 创建系统级用户，不能登录
                 -m 生成家目录
                 -s /bin/bash 指定用户交互程序
                 gitolite 用户名
    2, sudo adduser gitolite 这个命令是useradd的封装，自动做了一些事
####usermod修改用户帐户
    usermod:modify a user account
        -d, --home HOME_DIR  --->修改用户家目录
        The user's new login directory.
    修改gerrit用户添加到sudo组中，这样gerrit用户能使用sudo，俩中方法如下:
    > sudo usermod gerrit gerrit,sudo
    > sudo usermod -a -G sudo gerrit //-a表示追加用户组, sudo代表要追加的组，gerrit代表用户名
####帐户登录或切换:sudo/su/login
    1, -E, --preserve-env  preserve user environment when running command
        sudo -E ./t7gdb vmlinux
            gdb:edit start_kernel   (success)
        sudo ./t7gdb vmlinux
            gdb:edit start_kernel   (failed)
    2,  su -l username
        su - username //login as username
    3,  sudo:   execute a command as another user
        su:     The su command is used to become another user during a login session.
        login:  The login program is used to establish a new session with the system.
    4, 使用sudo时报错误
        test is not in the sudoers file.  This incident will be reported.
        resolve mathods:解决方法
            a) modify /etc/sudoers
            b) modify user group to sudo group

##linux Container容器
https://segmentfault.com/a/1190000006908063
    1,  跟我们常说的虚拟机这种虚拟化技术没有关系
    2,  容器就是一个或多个进程以及他们所能访问的资源的集合
    3,  容器和虚拟机的差别
            从技术角度来看，他们是不同的两种技术，没有任何关系，但由于他们的应用场景有重叠的地方，所以人们经常比较他们两个
            容器目前只能在Linux上运行，容器里面只能跑Linux
            虚拟机可以在所有主流平台上运行，比如Windows，Linux，Mac等，并且能模拟不同的系统平台，如在Windows下安装Linux的 虚拟机
            容器是Linux下一组进程以及他们所能访问资源的集合，所有容器共享一个内核，要比虚拟机轻量级，占用系统资源少，
            并且容器比虚拟机要快，包括启动速度，生成快照速度等
            虚拟机是一整套的虚拟环境，包括BIOS, 虚拟网卡, 磁盘, CPU，以及操作系统等， 启动慢，占用硬件资源多.
            由于虚拟机的和主机只是共享硬件资源，隔离程度要比容器高，所以相对来说虚拟机更安全
    4,  docker和容器的关系
        docker是容器管理技术的一种实现，用来管理容器，就像VMware是虚拟机的一种实现一样，除了docker，
        还有LXC/LXD，Rocket，systemd-nspawn，只是docker做的最好，所以我们一说容器，就想到了docker。
    5,  为什么容器只出现在Linux里面
        因为Linux中有资源隔离和管理的机制(Namespace,CGroups)，有COW（copy on write）文件系统等容器所需要的基础技术。
        当然其他平台也有类似的东西，但功能都没有Linux下的完善，不过随着容器技术越来越流行，其他的系统平台也在慢慢的
        实现和完善类似的这些技术。
    6,  为什么容器里面只能运行Linux
        因为Linux下的所有容器共享一个Linux内核，所以容器里面只能跑Linux系统
    7,  容器启动为什么那么快？
        容器的本质是一个或多个进程以及他们所能访问的资源的集合。启动一个容器的步骤大概就是：
            配置好相关资源，如内存、磁盘、网络等
            配置资源就是往系统中添加一些配置，非常快
            初始化容器所用到的文件目录结构
            由于Linux下有COW（copy on write）的文件系统，如Btrfs、aufs，所以可以很快的根据镜像生成容器的文件系统目录结构。
            启动进程
            和启动一个普通的进程没有区别，对Linux内核来说，所有的应用层进程都是一样的
        从上面可以看出启动容器的过程中没有耗时的操作，这也是为什么容器能在毫秒级别启动起来的原因
    8,  启动容器会占用很多资源导致系统变慢吗
        由于Namespace和CGroups已经是Linux内核的一部分了，所以应用层运行的进程一定会属于某个Namespace和CGroups（如果没有指定，
        就属于默认的Namespace和CGroups），也就是说，就算我们不用Docker，所有的进程都已经运行在默认容器中了。对内核来说，默认
        容器中运行的进程和Docker创建的容器中运行的进程没有什么区别，就是他们所属的容器号不一样。
        所以说创建新容器会不会影响主机性能完全取决于容器里面运行什么东西。如果运行的是耗资源的进程，那么肯定会对主机性能造
        成影响，但这种影响可以在一定程度上由CGroups控制住，不至于对主机带来灾难性的影响。如果容器里面运行的是不耗资源的进程，
        那么对系统就没有影响，只是容器里面的文件系统可能会占用一些磁盘空间。

##linux namespace and cgroup
    是对进程能看到的，能获取到的系统资源的能力的一种限制，就是让不同的进程拥有不同的系统资源.
    没有namespace，那么子进程可能继承父进程的所有全局资源，有了namespace，可以邦子进程创建新的
    namespace，
###linux namespace
    docker的原理
    namespace是为了隔离进程组之间的资源
    Namespace是对全局系统资源的一种封装隔离，使得处于不同namespace的进程拥有独立的全局系统资源，
    改变一个namespace中的系统资源只会影响当前namespace里的进程，对其他namespace中的进程没有影响。
    1,  unshare - run program with some namespaces unshared from parent
    2,  一个namespace创建了一个子namespace，子namespace的挂载信息和父namespace的挂载信息，看到的不一样
        比如在子namespace中创建一个目录，在父namespace中可能就看不到
###linux cgroup
    cgroup和namespace类似，也是将进程进行分组，但它的目的和namespace不一样，
    namespace是为了隔离进程组之间的资源，而cgroup是为了对一组进程进行统一的资源监控和限制

##linux session and process group
https://segmentfault.com/a/1190000009152815
###session
    1,  session就是一组进程的集合，session id就是这个session中leader的进程ID。
    2,  session的特点
        1)  session的主要特点是当session的leader退出后，session中的所有其它进程将会收到SIGHUP信号，其默认行为是终止进程，
            即session的leader退出后，session中的其它进程也会退出。
        2)  如果session和tty关联的话，它们之间只能一一对应，一个tty只能属于一个session，一个session只能打开一个tty。
            当然session也可以不和任何tty关联。
###process group
    1,  进程组（process group）也是一组进程的集合，进程组id就是这个进程组中leader的进程ID。
    2,  进程组的特点
        进程组的主要特点是可以以进程组为单位通过函数killpg发送信号
###session和process group的关系
    dev@debian:~$ sleep 1000 &
    [1] 1646
    dev@debian:~$ cat | wc -l &
    [2] 1648
    dev@debian:~$ jobs
    [1]-  Running                 sleep 1000 &
    [2]+  Stopped                 cat | wc -l
    下面这张图标明了这种情况下它们之间的关系：
    +--------------------------------------------------------------+
    |                                                              |
    |      pg1             pg2             pg3            pg4      |
    |    +------+       +-------+        +-----+        +------+   |
    |    | bash |       | sleep |        | cat |        | jobs |   |
    |    +------+       +-------+        +-----+        +------+   |
    | session leader                     | wc  |                   |
    |                                    +-----+                   |
    |                                                              |
    +--------------------------------------------------------------+
                                session
    pg = process group(进程组)
    bash是session的leader，sleep、cat、wc和jobs这四个进程都由bash fork而来，所以他们也属于这个session
    bash也是自己所在进程组的leader
    bash会为自己启动的每个进程都创建一个新的进程组，所以这里sleep和jobs进程属于自己单独的进程组
    对于用管道符号“|”连接起来的命令，bash会将它们放到一个进程组中
###daemon
    通过nohup，就可以实现让进程在后台一直执行的功能，为什么我们还要写daemon进程呢？
    从上面的nohup的介绍中可以看出来，虽然进程是在后台执行，但进程跟当前session还是有着千丝万缕的关系，至少其父进程还是被session管着的，
    所以我们还是需要一个跟任何session都没有关系的进程来实现daemon的功能。实现daemon进程的大概步骤如下：
        调用fork生成一个新进程，然后原来的进程退出，这样新进程就变成了孤儿进程，于是被init进程接收，这样新进程就和调用进程没有父子关系了。
        调用setsid，创建新的session，新进程将成为新session的leader，同时该新session不和任何tty关联。
        切换当前工作目录到其它地方，一般是切换到根目录，这样就取消了对原工作目录的引用，如果原工作目录是某个挂载点下面的目录，这样就不会影响该挂载点的卸载。
        关闭一些从父进程继承过来而自己不需要的fd，避免不小心读写这些fd。
        重定向stdin、stdout和stderr，避免读写它们出现错误。
####daemon进程中的printf
#####daemon守护进程中将stdin，stdout，stderr重定向到/dev/null的问题
    有人认为对于后台守护进程做此类重定向操作浪费资源，建议直接关闭0、1、2号句
    柄拉倒，这是非常不正确的。假设它们确实被关闭了，则一些普通数据文件句柄将等
    于0、1、2。以2号句柄为例，某些库函数失败后会向2号句柄输出错误信息，这将破
    坏原有数据。
#####Linux开发--探讨将标准输入输出及错误重定向到/dev/null
    Henry Spencer在setuid(7)手册页中做了如下建议，一切标准I/O句柄都可能因关闭过而不再是真实的标准I/O句柄，在使用printf()一类的函数前，务必确认
    这些句柄是期待中的标准I/O句柄。1991年，在comp news上有人重贴了这份文档。
    内核补丁应该确保对于SUID、SGID进程而言，0、1、2号句柄不会被打开后指向一个普通文件。这有很多实现方式，比如使它们全部指向/dev/null。这种限制
    不应该在库函数一级实现，可能有些SUID、SGID程序直接使用系统调用
    自1998年以来，OpenBSD内核中execve()里有一个检查，如果句柄0、1、2是关闭的，就打开/dev/null，使之对应0、1、2号句柄。这样就可以安全地执行setuid程序了。FreeBSD/NetBSD直至最近才再次暴露出类似问题，而Linux在glibc中做了一些检查。
#####How to see the daemon process's output in Linux?
    It doesn't output anything because it got no terminal attached.
####gui程序中的printf
    比如用鼠标双击一个文本文件启动gedit，其0->/dev/null 1,2->socket,这个socket会输出到/var/log/syslog中

##linux network
https://segmentfault.com/blog/wuyangchun?page=1

##linux交换空间(swap space)
https://segmentfault.com/a/1190000008125116
    1,  由于系统会自动将不常用的内存数据移到swap上，对桌面程序来说，有可能会导致最小化一个程序后，再打开时小卡一下，
        因为需要将swap上的数据重新加载到内存中来。
    2,  为什么需要swap?
        要回答这个问题，就需要回答swap给我们带来了哪些好处。
        对于一些大型的应用程序(如LibreOffice、video editor等)，在启动的过程中会使用大量的内存，但这些内存很多时候只是在启动
        的时候用一下，后面的运行过程中很少再用到这些内存。有了swap后，系统就可以将这部分不这么使用的内存数据保存到swap上去，
        从而释放出更多的物理内存供系统使用。
        很多发行版(如ubuntu)的休眠功能依赖于swap分区，当系统休眠的时候，会将内存中的数据保存到swap分区上，等下次系统启动的
        时候，再将数据加载到内存中，这样可以加快系统的启动速度，所以如果要使用休眠的功能，必须要配置swap分区，并且大小一定
        要大于等于物理内存
        在某些情况下，物理内存有限，但又想运行耗内存的程序怎么办？这时可以通过配置足够的swap空间来达到目标，虽然慢一点，
        但至少可以运行。
        虽然大部分情况下，物理内存都是够用的，但是总有一些意想不到的状况，比如某个进程需要的内存超过了预期，
        或者有进程存在内存泄漏等，当内存不够的时候，就会触发内核的OOM killer，根据OOM killer的配置，某些进程会被kill掉
        或者系统直接重启（默认情况是优先kill耗内存最多的那个进程），不过有了swap后，可以拿swap当内存用，虽然速度慢了点，
        但至少给了我们一个去debug、kill进程或者保存当前工作进度的机会。
        如果看过Linux内存管理，就会知道系统会尽可能多的将空闲内存用于cache，以加快系统的I/O速度，所以如果能将不怎么常用
        的内存数据移动到swap上，就会有更多的物理内存用于cache，从而提高系统整体性能。

##Bootloader:
###Bootloader种类
    --------------------------------------------------------------------------------------
    |Bootloader |   Monitor |   描述                            |   x86 |   ARM | PowerPC|
    --------------------------------------------------------------------------------------
    |LILO       |   否      |   Linux磁盘引导程序               |   是  |   否  | 否     |
    --------------------------------------------------------------------------------------
    |GRUB       |   否      |   GNU的LILO替代程序               |   是  |   否  | 否     |
    --------------------------------------------------------------------------------------
    |Loadlin    |   否      |   从DOS引导Linux                  |   是  |   否  | 否     |
    --------------------------------------------------------------------------------------
    |ROLO       |   否      |   从ROM引导Linux而不需要BIOS      |   是  |   否  | 否     |
    --------------------------------------------------------------------------------------
    |Etherboot  |   否      |   通过以太网卡启动Linux系统的固件 |   是  |   否  | 否     |
    --------------------------------------------------------------------------------------
    |LinuxBIOS  |   否      |   完全替代BUIS的Linux引导程序     |   是  |   否  | 否     |
    --------------------------------------------------------------------------------------
    |BLOB       |   否      |   LART等硬件平台的引导程序        |   否  |   是  | 否     |
    --------------------------------------------------------------------------------------
    |U-boot     |   是      |   通用引导程序                    |   是  |   是  | 是     |
    --------------------------------------------------------------------------------------
    |RedBoot    |   是      |   基于eCos的引导程序              |   是  |   是  | 是     |
    --------------------------------------------------------------------------------------
###grub给kernel传参修改网络设备名eth0:
    1, 修改/boot/grub/grub.cfg,在linux参数项中加net.ifnames=0 biosdevname=0

##ABI/API/POSIX
    1,  POSIX 标准啊，C99 标准啊，都是对 API 的规定
        Linux 上面的 ABI 标准似乎只有 Linux Foundation 提供的一些标准
    2,  API: POSIX (编译前的源代码) ABI: APPLICATION BINARY INTERFACE (编译后的二进制文件，linux & windows不兼容)
        POSIX表示可移植操作系统接口（Portable Operating System Interface of UNIX，缩写为 POSIX ），POSIX标准定义了操作系统应该为应用程序提供的接口标准

##计算机顶层设计中的一些概念
###计算机体系结构与组成原理与微机原理
    1，计算机体系结构:  指软、硬件的系统结构，研究计算机由哪些功能组成
    2, 计算机组成原理:  各个功能的实现:运算器的工作原理,定点浮点，总线结构，存储器结构与原理，
        指令编码，指令执行过程(指令集的实现，指令的实现和执行过程)
    3，微机原理:    汇编程序设计，微机接口技术(指令集的使用,用指令编写程序)
###计算机结构与cpu指令集
    1, 计算机的结构包括:冯诺依曼结构和哈佛结构(定义计算机是由运算器，控制器，存储器，输入输出构成)
    2, 冯诺依曼结构是计算机器的一种顶层设计，对应的可计算性的顶层设计是图灵机（和等价的邱奇lambda演算，对应LISP机）。
        然后才落地到各种具体的指令集流水线执行机构等等物理内容。
    3, 哈佛只是冯诺依曼的一种改进，最主要改进是把数据和代码分开。哈佛本身就是一个加强的冯 诺依曼，因为这些计算机器的顶层设计没有变化。
    4, 指令集是在某种计算机结构上的具体物理实现
    5, computer结构定义了计算机由哪些结构组成，RISC/CISC描述了计算机的部分结构的属性。
###arm architecture
    ARM architecture，是指ARM公司开发的、基于精简指令集架构（RISC, Reduced Instruction Set Computing architecture）
    的指令集架构（Instruction set architecture）
###arm内核(core)
    ARM core是基于ARM architecture开发出来的IP core
###arm cpu
    基于ARM公司发布的Core，开发自己的ARM处理器，这称作ARM CPU（也可称为MCU)
###arm:arm9:armv9:cortex-a9:
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
###IC design related:
####DMA burst:
    1, burst传输就是占用多个总线周期，完成一次块传输，此间cpu不能访问总线; DMA占用的周期个数叫做burst length.
    2, Burst操作还是要通过CPU的参与的，与单独的一次读写操作相比，burst只需要提供一个起始地址就行了，
    以后的地址依次加1，而非burst操作每次都要给出地址，以及需要中间的一些应答、等待状态等等。
    如果是对地址连续的读取，burst效率高得多，但如果地址是跳跃的，则无法采用burst操作
    3, DMA controler支持链表的，美其名曰“scatter”，内核有struct scatter可以参考
    4, transfer size：就是数据宽度，比如8位、32位，一般跟外设的FIFO相同。
    5, burst size：就是一次传几个 transfer size.
####JTAG:
    https://blog.csdn.net/beingaz/article/details/7440507
#####同事讲解
               -----------------------------
               |           SOC             |
               |                           |
               |  AHB    APB    CPU        |
               |  / \    / \    / \        |
               |   |      |      |         |
               |   |      |   |--------|   |
               |   |      |   |buffer  |   |
               |   |      |   |register|   |
               |   |      |   |--------|   |
               |   |      |     / \        |
               |   |      |      |         |
               |------------     |         |
               |   TAP     |------         |
               |-----------|      |--------|  data
       JTAG    |  DA | DP  |----->|trace32 |-------> trace32
JLink--------->|     |     |      |ETM/ETB |
               -----------------------------
        1,  DA模块里有instruction(OPcode) and data register,这俩个是移位寄存器，负责和JLink通信通过JTAG协议；DA可以接受执行JTAG指令(不是cpu指令).
        2   DP模块有AHB,APB master interface,可以直接发送总线请求，DP也可以直接给cpu一个信号，使其进入debug mode，
            进入debug mode之后，两者通过buffer register通信.
#####JTAG访问ARM通用寄存器
    下面演示的读取寄存器R0的例子，模拟的ARM指令为STR R0, [R0]，即把R0的值存储到R0为地址的内存，
    使用这条指令的目的是让R0的值出现在数据总线上。这条指令的执行需要两个执行周期，一是执行地址计算，二是把R0的值放在数据总线上。
     1）将INTEST指令写指令寄存器
     2） 插入指令STR R0, [R0] & BREAKPT = 0，在Update-DR阶段作用到管脚上，相当于ARM的取指令流水阶段
     3） 插入指令MOV R0, R0 & BREAKPT = 0，ARM的指令译码流水阶段
     4） 插入指令MOV R0, R0 & BREAKPT = 0，ARM的地址计算
     5） 通过扫描链1读出出现在数据总线上的数据，即R0的值，ARM的数据输出阶段
     起始访问通用寄存器的基本方法就是使用INTEST指令，插入特定的指令，然后在指令的指定执行阶段读取数据总线(或把数据放置到数据总线),
     即可事先对通用寄存器的读写。
#####JTAG访问外部内存
    访问外部内存，需要MCLK（因为内存是在MCLK的驱动下工作的），通过设置扫描链1的BREAKPT位为1可实现。
     1） 把要访问的内存地址写入到R0 （通过2.1的方法）
     2） 插入指令LDR R1, [R0]
     3） 执行完毕后，读入R1的内容
     写内存的方法为先将地址写入R0，值写入R1，然后插入指令STR R1, [R0]
#####JLink/Trace32配置文件
    JLink:xx.svd
    Trace32:xx.comm

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
###开发板种类(EVB/REF):
    1, EVB(Evaluation Board) 开发板：软件/驱动开发人员使用EVB开发板验证芯片的正确性，进行软件应用开发
    2, REF(reference Board) 开发板：参考板

##字节序:
###大小端:
    1, 大小端就是字节序，大小端的问题主要是由内存中多字节形数据类型的存在而引起的，他的研究单位是字节，
    对于char型数据类型，就是一个字节，是不存在大小端问题的.
    2, 字节序经常被分为两类：
        Big-Endian（大端）：高位字节排放在内存的低地址端，低位字节排放在内存的高地址端。
        Little-Endian（小端）：低位字节排放在内存的低地址端，高位字节排放在内存的高地址端。
###网络字节序:
    1, UDP/TCP/IP协议规定:把接收到的第一个字节当作高位字节看待,网络字节序是大端字节序
###最高最低有效位:
    1,  MSB（Most Significant Bit）：最高有效位，二进制中代表最高值的比特位，这一位对数值的影响最大。
        LSB（Least Significant Bit）：最低有效位，二进制中代表最低值的比特位

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
        ---------------------------------------------------------------------------------------------
        |字节位移   |   占用字节数  |   描述                                                        |
        ---------------------------------------------------------------------------------------------
        |0x01BE     |   1Byte       |   引导指示符，指明该分区是否是活动分区                        |
        ---------------------------------------------------------------------------------------------
        |0x01BF     |   1Byte       |   开始磁头                                                    |
        ---------------------------------------------------------------------------------------------
        |0x01C0     |   6Bit        |   开始扇区，占用6位                                           |
        ---------------------------------------------------------------------------------------------
        |0x01C1     |   10Bit       |   开始柱面，占用10位，最大值1023                              |
        ---------------------------------------------------------------------------------------------
        |0x01C2     |   1Byte       |   分区类型，NTFS位0x07                                        |
        ---------------------------------------------------------------------------------------------
        |0x01C3     |   1Byte       |   结束磁头                                                    |
        ---------------------------------------------------------------------------------------------
        |0x01C4     |   6Bit        |   结束扇区，占用6位                                           |
        ---------------------------------------------------------------------------------------------
        |0x01C5     |   10Bit       |   介乎柱面，占用10位，最大值1023                              |
        ---------------------------------------------------------------------------------------------
        |0x01C6     |   4Byte       |   相对扇区数，从此扇区到该分区的开始的扇区偏移量，以扇区为单位|
        ---------------------------------------------------------------------------------------------
        |0x01CA     |   4Byte       |   该分区的总扇区数                                            |
        ---------------------------------------------------------------------------------------------
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
        因为每个分区表项管理一个分区，所以Windows系统允许GPT磁盘创建128个分区。
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
    tune2fs -U 578c1ba1-d796-4a54-be90-8a011c7c2dd3 /dev/sda1-----修改uuid
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
    sudo fdisk -l 可以显示出所有挂载和未挂载的分区，但不显示文件系统类型，显示分区名字
    sudo parted -l 可以查看未挂载的文件系统类型，以及哪些分区尚未格式化。
    sudo lsblk -f 也可以查看未挂载的文件系统类型。
    sudo file -s /dev/sda3
    sudo blkid
###通过/sys节点查看分区起始块:
    1, cat /sys/block/sda/sda1/start
###查看Linux系统中分区的UUID和分区名
    1, fdisk可以修改partiton name
    :fdisk /dev/nvme0n1
    :x
    :m
    :p -----该命令能够显示UUID和分区名(只有gpt分区才有)
    :n -----该命令能修改分区名
###GPT分区表项与FS超级块内容对比:
####GPT分区项内容:(fdisk)
    Device             Start        End   Sectors Type-UUID                            UUID                                 Name                         Attrs
    /dev/nvme0n1p1      2048     616447    614400 C12A7328-F81F-11D2-BA4B-00A0C93EC93B 7D4AC1A9-0294-4469-9420-B5AA3A1847D7 EFI system partition
    /dev/nvme0n1p2    616448     878591    262144 E3C9E316-0B5C-4DB8-817D-F92DF00215AE FF3126AF-6274-432A-828A-2510C67DB040 Microsoft reserved partition
    /dev/nvme0n1p3    878592  315453439 314574848 EBD0A0A2-B9E5-4433-87C0-68B6B72699C7 5DE5E1F4-C2A4-49AE-B0C2-CADBC0269934 Basic data partition
    /dev/nvme0n1p4 315453440  475453439 160000000 0FC63DAF-8483-4772-8E79-3D69D8477DE4 BC497B94-44E9-42C2-9E68-7D2007839084
    /dev/nvme0n1p5 475453440  539453439  64000000 0657FD6D-A4AB-43C4-84E5-0933C84B4F4F AAA2F1AA-5B40-4CB0-A6B8-A5FFEFE1DF6D
    /dev/nvme0n1p6 539453440 1000214527 460761088 0FC63DAF-8483-4772-8E79-3D69D8477DE4 CF97032F-DF97-4D53-BCD3-24BCDE3A01BD
####FS超级块内容:(dumpe2fs)
    Filesystem volume name:   <none>
    Last mounted on:          /media/data
    Filesystem UUID:          d973277c-d69f-47a5-894e-203aed24c644
    Filesystem magic number:  0xEF53
    Filesystem revision #:    1 (dynamic)
    Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
    Filesystem flags:         signed_directory_hash
    Default mount options:    user_xattr acl
    ...
    Filesystem OS type:       Linux
    Inode count:              20520000
    Block count:              81920000
    Reserved block count:     4095999
    Free blocks:              50121137
    Free inodes:              20514883
    ...
####卷标与分区名:
    卷标是在文件系统超级块中,可用tune2fs修改；
    分区名是在GPT分区表中，可用fdisk修改；
    1, e2label /dev/sda1----查看卷标
    2, 通过xxd将一个文件系统镜像转换成十六进制和ASSIC码，证明卷标信息被写入文件系统的开头的一段内.
    3, :sudo dumpe2fs /dev/sda3
        dumpe2fs 1.44.1 (24-Mar-2018)
        Filesystem volume name:   <none> --------文件系统卷标
        Last mounted on:          /media/data
        Filesystem UUID:          d973277c-d69f-47a5-894e-203aed24c644 --------文件系统UUID
        Filesystem magic number:  0xEF53
####GPT UUID与FS UUID:
    1, 前者是在GPT中，可用fdisk修改；后者是在文件系统超级块中，可用tune2fs修改。
###/etc/fstab:
    LABEL=t-home2   /home      ext4    defaults,auto_da_alloc      0  2
    The first field:
    1，LABEL=<label> or UUID=<uuid> may be given instead of a device name.
    This is the recommended method, as device names are often a coincidence of hardware detection order,
    and can change when  other  disks  are  added or removed.  For example, `LABEL=Boot' or `UUID=3e6be9de-8139-11d1-9106-a43f08d823a6'.
    2，It's also possible to use PARTUUID= and PARTLABEL=. These partitions identifiers are supported for example for GUID Partition Table (GPT).
    MBR分区项中没有UUID，所以使用PARTUUID=xxx来mount文件系统不通用
###vmware拓展磁盘空间:
    1,  vmware中配置虚拟机->磁盘空间拓展
    2,  启动虚拟机
    3， 修改分区大小(实质是修改MBR/GPT分区表中的分区大小参数)
        使用parted/resizepart命令修改，若被改分区是逻辑分区，应先修改拓展分区大小
    4， 修改该分区文件系统大小
        使用resize2fs命令

##ssh原理及相关工具使用
###ssh
####ssh报错
    1,  现象:ssh Unable to negotiate with ip port 22: no matching cipher found. Their offer: aes128-cbc
        解决方法:
            vim /etc/ssh/ssh_config
            将Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc这一行解注掉
    2,  ssh -X user@ip
        sudo vim /etc/samba/smb.conf
        report:
            X11 connection rejected because of wrong authentication
        resolved:
                cp /home/user/.Xauthority /root/
            or
                sudo -E vim /etc/samba/smb.conf
###ssh-keygen
###ssh-agent
###ssh-copy-id
###scp

##Folder Sharing:
###linux/linux share folder:
    使用NFS:
        1, server端构建:
            安装nfs-kernel-server并配置:
            echo "$HOME/nfs *(rw,sync,no_root_squash)" > /etc/exports
            systemctl -l --no-pager status nfs-kernel-server.service
            sudo systemctl restart nfs-kernel-server.service
        2, client端使用:
            mount -t nfs -o nolock 10.3.153.96:/home/user/nfs /mnt/
    使用SAMBA:
        1, server端构建:
            ubuntu中文件夹右击->属性->共享
            这一步操作生成配置文件:/var/lib/samba/usershares/samba
                #VERSION 2
                path=/home/user/samba
                comment=
                usershare_acl=S-1-1-0:F
                guest_ok=y
                sharename=samba
        2, client端使用:
                在文件浏览器中"挂载"或打开
            or
                sudo mount -t cifs
###linux/windows share folder:
    windows作为server，ubuntu作为client:
        1, server端构建:
            在windows中选择要共享的文件夹，在文件夹属性中共享即可.
        2, client端使用:
            方法一:(这种方法渐渐淘汰)
                sudo apt install cifs-utils
                sudo mount.cifs //[address]/[folder] [mount point] -o user=[username],passwd=[pw]
                sudo mount -t cifs //[address]/[folder] [mount point] -o user=[username],passwd=[pw]
                sudo mount.cifs //[address]/[folder] [mount point] -o user=[username],passwd=[pw],uid=[UID]
                sudo mount.cifs //[address]/[folder] [mount point] -o domain=[domain_name],user=[username],passwd=[pw],uid=[UID]
            方法二:(ubuntu文件浏览器默认支持)
                在文件浏览器中"挂载":
                    -->other locations-->connect to server-->输入smb://10.3.153.95/e/
                在文件浏览器中打开:
                    -->Ctrl + L -->输入smb://10.3.153.95/e/
    ubuntu作为server，windows作为client:
        1, server端构建:
            sudo smbpasswd -a user
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
            注:ubuntu中可以直接右击文件夹-属性中共享，自动安装SAMBA server并配置.
        2, client端使用:
            在windows文件浏览器中添加网络驱动器即可.
###windows/windows share folder:
        1, server端构建:
            windows文件夹共享打开即可
        2, client端使用:
            在windows文件浏览器中添加网络驱动器即可.
###SMB/CIFS/SAMBA/NFS:
    1,  smb是协议级别的概念,其它的不是
    2,  Server Message Block - SMB，即服务(器)消息块，是 IBM 公司在 80 年代中期发明的一种文件共享协议。它只是系统之间通信的一种方式（协议），并不是一款特殊的软件。
    3,  Common Internet File System - CIFS，即通用因特网文件系统。CIFS 是 SMB 协议的衍生品，即 CIFS 是 SMB 协议的一种特殊实现，由美国微软公司开发。
        由于 CIFS 是 SMB 的另一中实现，那么 CIFS 和 SMB 的客户端之间可以互访就不足为奇。
        二者都是协议级别的概念，名字不同自然存在实现方式和性能优化方面的差别，如文件锁、LAN/WAN 网络性能和文件批量修改等。
    4,  Samba 也是 SMB 协议的实现，他是软件,与 CIFS 类似，它允许 Windows 客户访问 Linux 系统上的目录、打印机和文件
    5,  Network File System - NFS，即网络文件系统。由 Sun 公司面向 SMB 相同的功能（通过本地网络访问文件系统）而开发，但它与 CIFS/SMB 完全不兼容。
        也就是说 NFS 客户端是无法直接与 SMB 服务器交互的。NFS 用于 Linux 系统和客户端之间的连接。而 Windows 和 Linux 客户端混合使用时，就应该使用 Samba。
    Windows共享文件夹使用的协议是SMB/CIFS
        SMB:    Server Message Block
        CIFS:   Common Internet File System
###samba的使用
    1,添加共享文件夹的方式
        1)nautilus界面右键共享
        2)编辑/etc/samba/smb.conf
        3)在/var/lib/samba/usershares/下添加配置文件(方法1也是在这里添加配置文件)
    2,为共享文件夹添加用户名和密码
        sudo smbpasswd -a user
        sudo service smbd restart
####samba免用户名和密码
    用nautilus创建共享是可选不要认证，如果设置了用户名和密码认证了，可以通过以下方式取消
    sudo smbpasswd -x user
    sudo service smbd restart

##apt(Advanced Packaging Tool)原理介绍
    1, 如果有需要，编辑/etc/apt/sources.list，选择源服务器；
    2, 执行apt update，由所有源服务器提供的软件包资源，生成本地软件包索引；
    3, 执行apt install或upgrade，真正下载并安装软件包。
tips:
    1, man:apt-get(8), apt-cache(8), sources.list(5), apt.conf(5), apt-config(8)
    2, apt-get install安装目录是包的维护者确定的，不是用户
        可以预配置的时候通过./configure --help看一下–prefix的默认值是什么，
        就知道默认安装位置了，或者直接指定安装目录。
        apt-config dump | grep  -i "dir::cache" show the apt download directory
    3, redhat主要是rpm和更高级的yum，debian主要是dpkg和更高级的apt。
###apt与dpkg
    1, dpkg：是一个底层的工具。上层的工具，如APT，被用于从远程获取软件包以及处理复杂的软件包关系。
    2, dpkg绕过apt包管理数据库对软件包进行操作，所以你用dpkg安装过的软件包用apt可以再安装一遍，
    系统不知道之前安装过了，将会覆盖之前dpkg的安装。
    3, dpkg是用来安装.deb文件,但不会解决模块的依赖关系,且不会关心ubuntu的软件仓库内的软件,可以用于安装本地的deb文件。
    4, apt会解决和安装模块的依赖问题,并会咨询软件仓库, 但不会安装本地的deb文件, apt是建立在dpkg之上的软件管理工具。
###apt图形化工具
    1, software-properties-gtk--->择源，更新，升级等功能
    2, gnome-software--->搜索安装软件
###apt相关的文件或目录
    1, /var/lib/dpkg/available
    文件的内容是软件包的描述信息, 该软件包括当前系统所使用的 Debian 安装源中的所有软件包,其中包括当前系统中已安装的和未安装的软件包.
    2, /var/cache/apt/archives
    目录是在用 apt-get install 安装软件时，软件包的临时存放路径
    3, /etc/apt/sources.list
    存放的是软件源站点, 当你执行 sudo apt-get install xxx 时，Ubuntu 就去这些站点下载软件包到本地并执行安装
    4, /var/lib/apt/lists
    使用apt-get update命令会从/etc/apt/sources.list中下载软件列表，并保存到该目录
###update与upgrade与dist-upgrade区别
    1, update
        1.1 访问服务器，更新可获取软件及其版本信息，但仅仅给出一个可更新的list，具体更新需要通过apt-get upgrade。
        1.2 会访问/etc/apt/sources.list源列表里的每个网址，并读取软件列表，然后保存在本地电脑。
        我们在软件包管理器里看到的软件列表，都是通过update命令更新的。
        1.3 update是下载源里面的metadata的. 包括这个源有什么包, 每个包什么版本之类的.
    2, upgrade
        2.1 apt-get upgrade可将软件进行更新，但是有文章指出不建议一次性全部更新，因为最新的不一定是最好的，有可能出现版本不兼容的情况。
        2.2 upgrade是根据update命令下载的metadata决定要更新什么包(同时获取每个包的位置).
    3, dist-upgrade
        dist-upgrade in addition to performing the function of upgrade
    总而言之，update是更新软件列表，upgrade是更新软件。
    安装软件之前, 可以不upgrade, 但是要update. 因为旧的信息指向了旧版本的包, 但是源的服务器更新了之后旧的包可能被新的替代了, 于是你会遇到404...
###刷新软件源-建立资源索引
    无论用户使用哪些手段配置APT软件源，只是修改了配置文件——/etc/apt/sources.list，目的只是告知软件源镜像站点的地址。
    但那些所指向的镜像站点所具有的软件资源并不清楚，需要将这些资源列个清单，以便本地主机知晓可以申请哪些资源。
    用户可以使用“apt-get update”命令刷新软件源，建立更新软件包列表。在Ubuntu Linux中，“apt-get update”命令会扫描每一个软件源服务器，
    并为该服务器所具有软件包资源建立索引文件，存放在本地的/var/lib/apt/lists/目录中。
    使用apt-get执行安装、更新操作时，都将依据这些索引文件，向软件源服务器申请资源。
    因此，在计算机设备空闲时，经常使用“apt-get update”命令刷新软件源，是一个好的习惯。
###安装软件包
    1, 扫描本地存放的软件包更新列表（由“apt-get update”命令刷新更新列表），找到最新版本的软件包；
    2, 进行软件包依赖关系检查，找到支持该软件正常运行的所有软件包；
    3, 从软件源所指 的镜像站点中，下载相关软件包, 将下载的包文件存放在本地缓存目录(/var/cache/apt/archives)中；
    4, 解压软件包，并自动完成应用程序的安装和配置。
###重新安装
    apt-get --reinstall install 命令进行软件包的重新安装，将重新获得最新版本。
    这里有个小的技巧，使用“apt-get install”也可以卸载软件包，只需在要卸载的软件包后标识“-”即可。
    卸载软件包的过程同后面讲到的“apt-get remove”执行结果是完全相同的。
    如:sudo apt-get install xchat-
###更新软件包
    将系统中的所有软件包一次性升级到最新版本，这个命令就是“apt-get upgrade”，它可以很方便的完成在相同版本号的发行版中更新软件包。
###添加与删除PPA
    PPA: Personal Package Archives
    1, 添加PPA源
        sudo add-apt-repository ppa:user/ppa-name
        sudo apt update
    3, 删除PPA源
        sudo add-apt-repository -r ppa:user/ppa-name
        sudo apt update
    4, 也可以通过软件与更新的其他软件选项可视化操作删除与添加PPA源的过程
        sudo software-properties-gtk &
###apt search
    apt search -f/--full -n/--names-only nautilus //只搜索包名中含有nautilus的条目，并显示详细信息

##miscellaneous
###xdg-open:
    xdg-open: opens a file or URL in the user's preferred application
###ffplay-using
    ffplay -f rawvideo -pixel_format nv12 -video_size 640x480 cap.yuv
###wps:shutcut of Format brush
    双击格式刷就可以实现这个功能
###URI/URL/URN:
    1, uri, url, urn - uniform resource identifier (URI), including a URL or URN
    2, 在WWW上，每一信息资源都有统一的且在网上唯一的地址，该地址就叫URL（Uniform Resource Locator,统一资源定位符），它是WWW的统一资源定位标志，就是指网络地址
    URL由三部分组成：资源类型、存放资源的主机域名、资源文件名。
    也可认为由4部分组成：协议、主机、端口、路径
    URL的一般语法格式为：
    (带方括号[]的为可选项)：
    protocol :// hostname[:port] / path / [;parameters][?query]#fragment
###service/systemd/systemctl?
###ubuntu hotspot:
    git clone https://github.com/oblique/create_ap
    cd create_ap
    sudo create_ap -w 2 wlp5s0 enp4s0 css css123456 &
###vmware网络配置几种方式:
    1, bridged(桥接模式)
        虚拟机A1的IP地址可以设置成192.168.1.5（与主机网卡地址同网段的即可），其他的诸如网关地址，DNS，子网掩码均与主机的相同。
    2, host-only(主机模式)
        虚拟机A1的IP地址可以设置成192.168.80.5（与VMnet8使用相同的网段），网关是NAT路由器地址，即192.168.80.254
    3, NAT(网络地址转换模式)
        虚拟机A1的IP地址可以设置成192.168.10.5（与VMnet1使用相同的网段）
###nautilus
    a file manager for GNOME
####local-network-share
    sudo apt -y insatll nautilus-share
####add-bookmark
    sudo apt -y install python-nautilus
####gvfs-backends
    sudo apt install gvfs-backends
    This package contains the afc, afp, archive, cdda, dav, dnssd, ftp,
    gphoto2, http, mtp, network, sftp, smb and smb-browse backends.
    smb-browse的后端
####右键新建文件
    新的gnome中没有右键新建文件功能，需要手动在~/Templates/下创建一个模板,
    eg: new_document.txt, 之后就有新建文件功能了.

###vmware/ubuntu共享剪切板
    1）sudo apt-get install open-vm-tools
    2）sudo apt-get install open-vm-tools-desktop
    3）#restart the guest operating system
###终端查看ASCII命令
    1, man ascii.7
    2, sudo apt install ascii; ascii
###printf
####printf打印编译时间
    1, printf(__DATE__);
    2, printf(__TIME__);
    minicom也可以看log时间
####printf打印颜色设置
    printf("[QSPI]: \e[31merror\e[0m send cmd timeout\n");
    #define dprintf_err(fmt,args...) printf("\033[0;31m" fmt "\033[0m", ##args)
###minicom显示彩色打印
    sudo minicom -c on
    注:在普通用户下export MINICOM='-c on',然后sudo minicom不起作用.
    可以用sudo -E minicom,这个会继承当前用户的环境变量.
###C语言中续行符“\”
    1, 根据定义，一条预处理指示只能由一个逻辑代码行组成,
       所以，把一个预处理指示写成多行要用“\”续行.
    2, 而把C代码写成多行则不必使用续行符，因为换行在C代码中只不过是一种空白字符,
       在做语法解析时所有空白字符都被丢弃了
    3, 在Linux的shell命令中亦可使用该换行符，在击回车键之前输入“\”，即可实现多行命令输入。
    4, 注意：这种续行的写法要求“\”后面紧跟换行符，中间不能有任何其他的字符。
    5, 宏定义规定，宏定义必须在一行里完成。所以用#define定义宏定义时，有时为了阅读方便，
       就加续行符"\"来换行。在普通代码行后面加不加都一样
###find忽略某个目录:
    eg:
        sudo find / -name "commit-msg.sample" -not -path "/home/*"
        sudo find / -name "commit-msg.sample" ! -path "/home/*"
        sudo find / -name "commit-msg.sample" -o -path "/home/*" -prune
###grep忽略某个目录:
    eg:
        grep "grep" ./ --exclude-dir=notes -rn
###volatile
    1,  volatile 关键字是一种类型修饰符，用它声明的类型变量表示可以被某些编译器未知的因素更改，
        比如：操作系统、硬件或者其它线程.遇到这个关键字声明的变量，编译器对访问该变量的代码就不再进行优化，
        从而可以提供对特殊地址的稳定访问。当要求使用 volatile 声明的变量的值的时候,
        系统总是重新从它所在的内存读取数据，即使它前面的指令刚刚从该处读取过数据。而且读取的数据立刻被保存。例如：
        {
            volatile int i=10;
            int a = i;
            ... // 在此期间其他代码或硬件，并未明确告诉编译器，对 i 进行过操作
            int b = i;
        }
        volatile 指出 i 是随时可能发生变化的，每次使用它的时候必须从 i的地址中读取，
        因而编译器生成的汇编代码会重新从i的地址读取数据放在 b 中。而优化做法是，
        由于编译器发现两次从 i读数据的代码之间的代码没有对 i 进行过操作，
        它会自动把上次读的数据放在 b 中。而不是重新从 i 里面读。
        一般调试模式没有进行代码优化，所以这个关键字的作用看不出来。
    2,  volatile 指针
        和 const 修饰词类似，const 有常量指针和指针常量的说法，volatile 也有相应的概念:
        修饰由指针指向的对象、数据是 const 或 volatile 的：
            const char* cpch;
            volatile char* vpch;
        指针自身的值——一个代表地址的整数变量，是 const 或 volatile 的：
            char* const pchc;
            char* volatile pchv;
    3,  volatile 结构体
        volatile struct xxx{};
###bash
####bash_history隐私
    第一种靠谱的解决方案：
        第1步：设置 HISTCONTROL 环境变量：export HISTCONTROL=ignorespace。
        第2步：输入重要命令时，记得在输入命令前加上空格。
        第3步：执行 history，可以看到刚输入的重要命令没有出现在 history 中。
    通过设置 HISTCONTROL=ignorespace，可以让 history 不记录你的特殊输入（命令前加空格），这样可以在一定程度上有效地保护我们的系统。
    第二种靠谱的解决方案：
        第1步：设置 HISTIGNORE 环境变量 export HISTIGNORE=*。
        第2步：输入重要命令，比如 mysql-uroot-p123。
        第3步：查看你的 history，可以看到刚输入的 mysql 命令没有记录在 history 中。
        第4步：恢复命令的记录 export HISTIGNORE=。
        第4步后，系统又恢复正常，输入的命令又能被正常记录了。
    这个方法虽然略显烦琐，需要你每次在输入重要命令时都要先设置 HISTIGNORE=*，执行完命令后再设置 HISTIGNORE=，但是，
    这种方法能规避由于你的粗心大意（忘记命令前加空格）带来的巨大安全隐患，确保机密信息不会被泄露出去。
####彻彻底底地删除所有的历史命令
    history -c
    history -w
####other
    export HISTTIMEFORMAT='%F %T '  # 设置历史记录的时间
    export HISTFILESIZE=1000        # 控制历史命令记录的总个数
    export HISTFILE=~/history.log   # 更换历史命令的存储位置
    export HISTCONTROL=erasedups    # 清除整个命令历史中的重复条目
    export HISTCONTROL=ignoredups   # 忽略记录命令历史中连续重复的命令
    export HISTCONTROL=ignorespace  # 忽略记录空格开始的命令
    export HISTCONTROL=ignoreboth   # 等价于ignoredups和ignorespace
####C-J
    C-J will terminate an incremental search
####exec命令
    bash执行一个脚本test.sh，首先fork一个子进程，然后execve("./test.sh"...
    如果test.sh中用exec echo "a"执行一个子命令，则不会fork一个新进程，而是直接execve("/usr/bin/echo", ["echo", "a"]；
    这就相当于，当前进程PID没变，但程序换成了echo，并且echo执行完了，直接退出，不会继续解析剩下的脚本内容
###firefox
####about:xxx
    input something as blow in the address bar:
    1,  about:about
    2,  about:config->search "mime"
    3,  about:preferences
####How to open Markdown files with md extension in Firefox
    1,  https://en.terminalroot.com.br/how-to-open-markdown-files-with-md-extension-in-firefox/
        1,  vim ~/.mime.types
        2,  And inside it we will insert the following content:
                text/plain     md txt
        3,  Now comes the role of Firefox’s extension/addon/plugin.
        For this we will use the Markdown Viewer Webext, there are others,
        but we will use this one, after installing, tcharaaamm!!!
