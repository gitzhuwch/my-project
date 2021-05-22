# vim
## how much vim filetypes
    1. echo $VIMRUNTIME
        print "/usr/share/vim/vim81/"
    2. ls $VIMRUNTIME/ftplugin/*
## specify the filetype in file
    add this line /* vim: set filetype=markdown : */
## align plugin Tabular.vim
    align with ':'
        :Tabularize /:
## Ctrl-v选至行尾
    Ctrl-v ... Shift-$
## search highlight 临时取消
    :noh/:nohlsearch
        临时取消，下次搜索时会自动打开
    :set hlsearch
        永久取消
## change file line ending
    :set fileformat=unix
    :dos2unix(need install this tool)
## regular expression
### 替换转大小写方法
    比如有下面这段文字：
    every day
    将两个单词都转变为全大写
    :s/\(.*\) \(.*\)/\U\1 \2/
    转变结果为：
    EVERY DAY

    将上面的文字转变为EVERY day
    :s/\(.*\) \(.*\)/\U\1\e \2/
    上面的四个转义序列将在其被显式停止前，对跟在其后的内容持续作用；如果要停止，需要使用'\e'来中断。

    注:
    \u （将分组第一个字母转换成大写）
    \U （将整个分组转换成大写）
    \l （将分组第一个转换成小写）
    \L （将整个分组转换成小写）
## 结构体成员补全
    1. bash:tag
    2. vim: Ctrl-X Ctrl-O
    vim自带的omni-complete plugin可以利用tags文件找到结构体成员并补全
## 为自定义拓展名文件增加类型识别
    au! BufNewFile,BufRead *.cu,*.cuh setf cpp
    au! BufNewFile,BufRead *.lds setf ld
    au BufNewFile,BufRead *.cu,*.cuh setf cpp
    au BufNewFile,BufRead *.lds setf ld
    :autocmd! 可以删除所有自动命令,此操作也将删除插件所定义的自动命令
    如果我们针对同样的文件和同样的事件定义了多条自动命令，那么当满足触发条件时将分别执行多条自动命令。
    因此，建议在自动命令组的开头增加:autocmd!命令，以确保没有重复的自动命令存在。
## 粘贴模式下粘贴代码注释换行不缩进
    取消
    :set paste
    恢复
    :set paste!
## vim verilog plugin
# toolchain
## hex file formats
    ihex
        objcopy -O ihex xxx.bin xxx.ihex
    srec(s-recored)
        objcopy -O srec xxx.bin xxx.srec
## hexdump与sed配合生成hex文件
    输出要求:
        1. 一行16个字节，按俩个word分割，每个word按小尾端出：
            hexdump -n 100 -v -e '2/4 "%08x" "\n"' s1961.bin
        2. file size为16字节对齐时，一行16个字节，按俩个word分割，整个16个字节按小尾端输出：
            1.1. hexdump -n 100 -v -e '2/4 "%08x" "\n"' s1961.bin | sed  's/\(\S\{8\}\)\(\S\{8\}\)/\2\1/'
            1.2. hexdump -n 100 -v -e '2/4 "%08x" "\n"' s1961.bin | sed  's/\([[:alnum:]]\{8\}\)\([[:alnum:]]\{8\}\)/\2\1/'
            上述俩种方法等效
        3. file size非16字节对齐时，一行16个字节，按俩个word分割，整个16个字节按小尾端输出：
            1.1. hexdump -n 100 -v -e '2/4 "%08x" "\n"' s1961.bin | sed  -e 's/\(.\{8\}\)\(.\{8\}\)/\2\1/' -e 's/\s/0/g'
            1.2. hexdump -n 100 -v -e '2/4 "%08x" "\n"' s1961.bin | sed  -e 's/\([[:alnum:]]\{8\}\)\([[:alnum:]]\{8\}\)/\2\1/' -e 's/\s/0/g'
            上述俩种方法等效;
            -e 's/\s/0/g'--->补0对齐
        4. hexdump -n 12 -v -e '2/4 "%08" "\n"': 当输入缺少1个word时，用空格补齐
        5. hexdump -n 10 -v -e '2/4 "%08" "\n"': 当输入缺少1-3个byte时，用0补齐
## link script
    info ld: 比"man"的信息全
### sections
        SECTION [ADDRESS] [(TYPE)] :
          [AT(LMA)]
          [ALIGN(SECTION_ALIGN) | ALIGN_WITH_INPUT]
          [SUBALIGN(SUBSECTION_ALIGN)]
          [CONSTRAINT]
          {
            OUTPUT-SECTION-COMMAND
            OUTPUT-SECTION-COMMAND
            ...
          } [>REGION] [AT>LMA_REGION] [:PHDR :PHDR ...] [=FILLEXP] [,]
    1. bss
        bss: block started by symbol
        存放程序中未初始化的全局变量的一块内存区域
        在初始化时bss 段部分将会清零。bss段属于静态内存分配，即程序一开始就将其清零了
        bss段不在可执行文件中，由系统初始化
    2. text
        存放程序执行代码的一块内存区域
        大小在程序运行前就已经确定
        通常属于只读
    3. data
        存放程序中已初始化的全局变量的一块内存区域
        数据段属于静态内存分配
    4. 一个程序本质上都是由 bss段、data段、text段三个组成的
        text和data段都在可执行文件中（在嵌入式系统里一般是固化在镜像文件中），由系统从可执行文件中加载
    5. '.' location counter
        . = 0x2f000000
        __start = .
### LMA,VMA
        SECTION [ADDRESS] [(TYPE)] :
          [AT(LMA)]
          [ALIGN(SECTION_ALIGN) | ALIGN_WITH_INPUT]
          [SUBALIGN(SUBSECTION_ALIGN)]
          [CONSTRAINT]
          {
            OUTPUT-SECTION-COMMAND
            OUTPUT-SECTION-COMMAND
            ...
          } [>REGION] [AT>LMA_REGION] [:PHDR :PHDR ...] [=FILLEXP] [,]
    VMA是指令执行时所使用的地址,
    LMA是烧录地址,在链接脚本中使用AT来指定
    LMA,VMA大多数情况下是相等的,当它俩不相等时,就要重定位了,
    比如lds中将一个数据段的LMA=0x200,VMA=0x800,此时有一条指令I访问该数据段中的变量时，使用的是VMA(0x800),
    但是，当把该程序烧录到ram中时，该数据段的地址为0x200,所以执行指令I时就会出错，所以就要自己写代码将该数据端
    搬到VMA(0x800)处.
    实例：
    flash的地址空间:0x200-0x10000
    ram的地址空间:0x100000-0x200000
    当希望将数据和代码都烧录到flash中，在运行时，代码放在flash中执行，数据搬到ram中使用，此时就可将数据段的LMA,VMA设成不一样的,来达到这个目的
        .text 0x200 : AT(0x200) {
        *(.text)
        }
        .data 0x100000: AT(0x100000) {
        *(.data)
        }
    上面的lds会导致，生成elf中.text与.data中有一大段0填充，导致elf文件太大，超出flash的size
    可以改称下面
        .text 0x200 : AT(0x200) {
        *(.text)
        }
        .data 0x100000: AT(ADDR(.text) + SIZEOF(.text)) {
        *(.data)
        }
    这样之后，.data就会紧跟.text段，中间不会填0，size就会变小，就可以烧录到flash中
## gcc
    arm-none-eabi-gcc -v --help
    display all sub options
    1. -Wp,option
    2. -Wa,option
    3. -Wl,option
    4. -nostdlib
    5. --specs=nosys.specs(/usr/lib/arm-none-eabi/lib/nosys.specs)
    6. -e entry
       --entry=entry
## ld
    1. -Ttext=0x02000100
    2. -Ttext-segment=
    3. -e__start
## 重定位
## specs file
    Spec 文件(Spec files) 就是用来配置 SPEC 字符串的
    gcc is gnu compiler collection
    specs is control the compiler component:cpp,cc1,asm,linker...
    when you use gcc's component single, the specs don't take effect. eg: "gcc -o" just invoke cpp,cc1,asm. don't invoke linker
## spec string(specs)
## info ld
## info gcc

# 多核存储一致性
    数据存放的地方有:register, store buffer, cache, memory.
    所以数据一致性问题就是以上四个存储地方之间的同步问题.
## cpu register file
## cpu store buffer
## cpu cache
## cpu 乱序执行
    假设，global a = 0; b = 0;
    1. cpu0执行如下程序
    {
        a = 1;
        b = 1;
    }
    在cpu的指令流水线中，a = 1先执行，如果a在cache中没命中，则a写入store buffer中，
    继续执行b = 1；如果b在cache中命中，则将1写入cache中。
    所以虽然a = 1先执行，但b的值有可能先被写入cache或mem中。
    2. cpu1执行如下程序
    {
        while (1) {
            if (b == 1) //如1所示，如果b = 1先写入cache中，则这里就执行结果就是c = a = 0；与意图不符
                c = a;
        }
    }
## memory barrier
    解决cpu乱序执行带来的问题.
    如上一节中的代码所示:
    ...
    a = 1;
    b = 1;
    ...
    虽然a = 1;在b = 1;前面, 但是b = 1;可能比a = 1;先执行完成.
    这时就需要在a = 1;之后，b = 1;之前加一个内存栅栏指令，
    保证a = 1;执行完成之后，再执行b = 1;
#arm architecture
## arm instruction sets
### bfi
    Bitfield Insert copies a bitfield of <width> bits from the least significant bits of the source register
    to bit position <lsb> of the destinationregister, leaving the other destination bits unchanged
    BFI <Wd>, <Wn>, #<lsb>, #<width>
    当操作结构体位域时，会自动生成bfi类似指令，该指令效率很高，建议以后驱动中使用结构体位域格式化寄存器.
    注意:为避免出错，如果是32位架构，结构体中所有成员使用unsigned int型
        typedef union {
        struct {
        uint32_t startBitMidpoint:      16;
        uint32_t baudCompensateValue:   4;
        uint32_t reserved31To20:        12;
        } reg;
        uint32_t all;
        } SGR5UartComps_t;
### DSB/ISB/DMB
    1. DSB:数据同步屏障是一种特殊类型的内存屏障。 只有当此指令执行完毕后，才会执行程序中位于此指令后的指令.
    2. ISB:指令同步屏障可刷新处理器中的管道，因此可确保在 ISB 指令完成后，才从高速缓存或内存中提取位于该指令后的其他所有指令.
    3. DMB:数据同步屏障是一种特殊类型的内存屏障。 只有当此指令执行完毕后，才会执行程序中位于此指令后的指令.
    指令名      功能描述
    DMB         数据存储器隔离。DMB 指令保证： 仅当所有在它前面的存储器访问操作都执行完毕后，才提交(commit)在它后面的存储器访问操作。
    DSB         数据同步隔离。比 DMB 严格： 仅当所有在它前面的存储器访问操作都执行完毕后，才执行在它后面的指令（亦即任何指令都要等待存储器访 问操作——译者注）
    ISB         指令同步隔离。最严格：它会清洗流水线，以保证所有它前面的指令都执行完毕之后，才执行它后面的指令。ISB 指令看起来似乎最强悍
### 原子指令
    1. ldrex/strex //exclusive access instructions; lock address bus
    2. ARMv8.1平台下新添加原子操作指令
        加原子操作
        置位原子操作
        清除位原子操作
        异或原子操作
        比较存储原子操作
        交换原子操作
        比较交换原子操作
#### ldrex/strex独占读写
    1. ldrex会set monitor exclusive bit，strex会clear, 这个信号不会给到ddr
    2. 每一个处理器内部都有一个本地监视器（Local Monitor）
    3. 整个系统范围内还有一个全局监视器（Global Monitor）
    4. 对于本地监视器来说，它只标记了本处理器对某段内存的独占访问，在调用LDREX指令时设置独占访问标志，在调用STREX指令时清除独占访问标志。
    5. 更新内存的操作不一定非要是STREX指令，任何其它存储指令都可以。但如果不是STREX的话，则没法保证独占访问性
### interrupt return instruction
    For example, an interrupt handler that wishes to store its return link on the stack might use instructions of
    the following form at its entry point:
        SUB R14, R14, #4
        STMFD SP!, {<other_registers>, R14}
    and return using the instruction:
        LDMFD SP!, {<other_registers>, PC}^ //中断返回,必须加^符号,^表示将spsr的值复制到cpsr
## arm regsters
    * r0 to r12 are orthogonal general purpose register.
    * R13(stack pointer) and stores the top of the stack in the current processor mode.
    * R14(LR) Link Register where the core puts the return address on executing a subroutine.
    * R15(PC) Program counter stores the address of next instruction to be executed.
    * CPSR: Current Processor Status Register
      bit[4:0] Mode bits(0x12 = IRQ mode)
      bit[5] thumb state bit
      bit[6] F- Fast interrupt request Disable	 If set fast interrupt request channel is disabled
      bit[7] I- Interrupt request Disable	If set interrupt request channel is disabled
      bit[8] A- Disables imprecise data aborts when it is set
      bit[9] E-
      bit[23:10] reserved
      bit[24] jazelle state bit
      bit[26:25] reserved
      bit[27] sticky overflow
      bit[28] overflow
      bit[29] carry/borrow/extend
      bit[30] zero
      bit[31] negative/less than
    * SPSR: Save Program Status Register
      Suppose Processor is in USER mode of operation and if IRQ request arrives then processor has
      to switch itself to IRQ mode of operation but at the same after serving IRQ mode processor
      should return to USER mode and should resume its working.
      So current processor status is copied into SPSR from CPSR in order to resume back.
# linux/freertos最小系统
## 最小系统应具备条件
### clock
### timer
### interrupt
## vcs调试最小系统
    最近再搞一个，vcs下跑一个最小os，废了些周折，总结一下.
    rtl环境说明:
        tube.v:
            用来检测0x2e2ffffc地址，若cpu往这个地址写可显示字符，就将这个字符用$display()/$write()打印出来;
            若写入0xf0，就调用$stop()停止仿真.
    cpu代码环境:
        head.S:
            1. 程序的最开头是异常向量表，cpu进入exception时，就根据不同的exception type，跳到该处+相应的offset；
               其中offset=0x18是外设中断入口。异常向量表，每一项占4Byte，存放的是一条跳转指令，跳转到具体的处理函数；
               当来外设中断后，cpu会disable cpsr的i位，就是关闭cpu的中断总开关，然后取offset=0x18处的指令执行，这是一条
               跳转指令，跳转后，第一件事情是保存现场，然后调用下一级处理函数(在这里要清相应外设的中断位，否则会一直触发),
               回来后恢复现场(这里的栈是中断特有的栈)
            2. disable cpsr的a/i/f位
            3. 初始化cpu各种mode下的stack基址，比如进入IRQ mode, 如果没有配置stack，cpu就hang住了(这里踩过坑，
               具体什么原因不清楚)，事先把IRQ mode的stack配置好，就可以正常跑了.
            4. 初始化pll/clock
            5. branch到main函数
        main.c:
## linux与freertos在arm上的任务切换区别
    1. linux在所有平台上都使用switch_to宏来实现；
    2. freertos使用svc/pendsv mode来切换；
    3. svc mode: supervisor call/system call；这主要是为linux实现系统调用提供的；
    4. swi: software interrupt,该指令产生软中断，进入svc mode；
    5. pendsv: 可推迟执行的svc异常；
    6. linux由用户空间和kernel空间，freertos没有；
# c language
## 全局变量可不可以定义在可被多个.C文件包含的头文件中
    1. 可以在不同的C文件中声明同名的全局变量，前提是其中只能有一个C文件中对此变量赋初值
    2. 可以用引用头文件的方式，也可以用extern关键字，如果用引用头文件方式来引用某个在头文件中声明的全局变理，
    假定你将那个变写错了，那么在编译期间会报错，如果你用extern方式引用时，假定你犯了同样的错误，那么在编译期间不会报错，而在连接期间报错。
# info and man
    info 来自自由软件基金会的 GNU 项目，是 GNU 的超文本帮助系统，能够更完整的显示出 GNU 信息。所以得到的信息当然更多
    man 和 info 就像两个集合，它们有一个交集部分，但与 man 相比，info 工具可显示更完整的　GNU　工具信息。若 man 页包
    含的某个工具的概要信息在 info 中也有介绍，那么 man 页中会有“请参考 info 页更详细内容”的字样。

# VMA与LMA不一致
    发现stream中link.ld指定了data section的LMA，编译后，用arm-none-eabi-objdump -h stream读出来的data section的VMA与LMA不一致，
    运行时，去找data段中的数据，是按照VMA找的，Ozone加载data section时是按照LMA加载的,所以找data段里的数据会找错位置.
    如果VMA与LMA不一致，除非，自己将data section的数据搬到VMA指定的ram位置，而非LMA指定的ram位置，否则就必须让它俩一致

# OpenMP
    1. OpenMP的指令
    2. 只能用于for循环
    3. 循环中的数据没有依赖
    4. 有专门的库支持

# centos default shell
    1. exec bash //在csh中执行bash，将其替换
    2. usermod改变用户的默认shell，创建用户时，也可指定默认shell //需要root权限

# object-oriented programming
    1. 编写qspi test case中：对controller的属性的抽象要细化，分类抽象，比如DAC INDAC STIG 要分开抽象，
       对属性抽象的好坏决定方法实现的是否方便，决定方法能否有很高复用性
    2. 思考对象有哪些行为（方法）
    3. 每一种方法的多样化因素
    4. 思考对象有那些属性，包括上一条中的因素

# printk根据函数地址打印函数名
    %p：打印裸指针(raw pointer)
    %pF可打印函数指针的函数名和偏移地址
    %pf只打印函数指针的函数名，不打印偏移地址。
    %pM打印冒号分隔的MAC地址
    %pm打印MAC地址的16进制无分隔
    %I4打印无前导0的IPv4地址，%i4打印冒号分隔的IPv4地址
    %I6打印无前导0的IPv6地址，%i6打印冒号分隔的IPv6地址
总结:
![](./notes.dia/printk-addr-to-name.png)

# Fourier transformation
## application
    将原信号变换一下，变换后的信号在不同频率段做不同处理，例如某个频率段完全过滤掉，再变换回原信号）。
    对应声音来说，可能就是某个低频段的噪音被去掉了，原声音会更清楚。对于图像来说，看各个答主举得例子更直白。
    1. 声音降噪
    利用傅里叶，将信号拆分成多个频段的波形组，然后滤掉噪声频率段的波形
    2. 图像磨皮
    去除图像中的噪点
    3. 信号传输多载
    将多路不同频率的信号，利用傅里叶原理叠加在一起，传输出去，接收端再拆分出来
        一种是10-90上升时间，指信号从终值的10%跳变到90%所经历的时间。
        第二种定义方式是20-80上升时间，这是指从终值的20%跳变到80%所经历的时间
        下降时间通常要比上升时间短一些，这是由典型CMOS输出驱动器的设计造成的。
## 频域
    频域最重要的性质是：它不是真实的，而是一个数学构造。时域是惟一客观存在的域，而频域是一个遵循特定规则的数学范畴。

# linux统一账户认证方案
## linux su命令认证方式的修改(使用PAM)
    1.  PAM(Pluggable Authentication Modules for Linux)
    2.  config infomation format
        [service] module-type control-flag module-path [arguments]
        PAM 配置文件中的字段包括：
            service： 指定服务/应用程序的名称，如 telnet、login、ftp 等（默认值为 OTHER）。
            module-type： 为 service 字段中的服务/应用程序指定模块类型，模块类型有四种类型（auth/account/session/password）。
            control-flag： 指定了"配置段"里的模块应该怎么相互作用，可以理解为对 PAM 认证的流程控制，它可以获取诸如 requisite、required、sufficient 和 optional 之类的值。
            module-path： 指定实现模块的库对象的路径名称。最好使用绝对路径，缺省路径一般是/lib/security 或/lib64/security。
            arguments：指定可以传递给服务模块的选项或参数（可选字段）。
    3.  Linux-PAM（即linux可插入认证模块）是一套共享库,使本地系统管理员可以随意选择程序的认证方式。
        换句话说，不用重新编译一个包含PAM功能的应用程序，就可以改变它使用的认证机制，这种方式下，就算升级本地认证机制,也不用修改程序。
## /proc/key-users
## sssd(System Security Services Dameon)
    sssd是一款用以取代ldap和AD的软件，配置比较简单。
    id zhuwch@sic.com #从AD中获取域用户信息
    本文介绍如何在ldap客户端部署sssd，来启用ldap认证。
## ssl
    SSL(Secure Sockets Layer 安全套接字协议),及其继任者传输层安全（Transport Layer Security，TLS）是为网络通信提供安全及数据完整性的一种安全协议。
    TLS与SSL在传输层与应用层之间对网络连接进行加密。
## nss
## ldap(Light weight Directory Access Protocol)
    轻量级目录访问协议
    其前身是更为古老的DAP协议
    client<--->ldap<--->db
    LDAP Client指各种需要身份认证的软件，例如Apache、Proftpd和Samba等。LDAP Sever指的是实现LDAP协议的软件，
    例如OpenLDAP等。Datastorage指的是OpenLDAP的数据存储，如关系型数据库（MySQL）或查询效率更高的嵌入式数据库（BerkeleyDB），
    甚至是平面文本数据库（—个txt的文本文件）。可见，OpenLDAP软件只是LDAP协议的一种实现形式，并不包括后台数据库存储。
    但在很多时候管理员经常将LDAP Server和DataStorage放在同一台服务器，这样就产生了人们通常所说的“LDAP数据库”。
    虽然后台数据库（backend）可以是多种多样，但LDAP协议还规定了数据的存储方式。LDAP数据库是树状结构的，与DNS类似，
### openldap
    是LDAP协议的实现，是一款开源应用
## 单点登录(Single Sign On)
    简称为 SSO，是比较流行的企业业务整合的解决方案之一。SSO的定义是在多个应用系统中，用户只需要登录一次就可以访问所有相互信任的应用系统。
## AD(active directory)
    目录是一类为了浏览和搜索数据而设计的特殊的数据库。例如，为人所熟知的微软公司的活动目录（active directory)就是目录数据库的一种。
    目录服务是按照树状形式存储信息的，目录包含基于属性的描述性信息，并且支持高级的过滤功能。

# cpu/mem/disk info display
    | cat /proc/cpuinfo   | top                  |
    | cat /proc/meminfo   | free -lh             |
    | cat /proc/diskstats | cat /proc/partitions | df -lh |

# hexdump/xxd/od
## hexdump
    1. A format unit contains up to three items: an iteration count, a byte count, and a format.
    2. The iteration count is an optional positive integer, which defaults to one.  Each format is applied iteration count times.
    3. The byte count is an optional positive integer.  If specified it defines the number of bytes to be interpreted by each iteration of the format.
    将elf转换成bin文件再转换成hex文件，就需要用到hexdump
    1. 迭代次数为1，迭代后输出"\n"，指针步进单位为4(按word打印)，printf格式为"%08x"(8位十六进制对齐，不够补0)
        hexdump -n 100 -v -e '1/4 "%08x" "\n"' stars_freertos_v1.bin
    2. 迭代次数为4，迭代后输出"\n"，指针步进单位为1(按byte打印)，printf格式为"%02x"(2位十六进制对齐，不够补0)
        hexdump -n 100 -v -e '4/1 "%02x" "\n"' stars_freertos_v1.bin
    3. 迭代次数为2，迭代后输出"\n"，指针步进单位为2(按short打印)，printf格式为"%04x"(4位十六进制对齐，不够补0)
        hexdump -n 100 -v -e '2/2 "%04x" "\n"' stars_freertos_v1.bin
## xxd
    1. xxd -ps和-e选项冲突，即纯十六进制平坦模式输出和小端模式输出不能同时使用
    2. xxd -ps选项不能用printf格式化输出，只能一个字节一个字节输出，所以不能正确打印小端数据
    3. xxd -r选项能将修改的十六进制数转成二进制存储，这为直接编辑二进制文件提供条件
## od
    很少用
# shell
## 'and"(单引号/双引号)
    单引号直接输出后面的字符串，而双引号可以引入变量
# sed(stream editor)
# TCL(tool command language)
    1. 类似bash build-in command; 也类似uboot中的cmdline原理
    2. Tcl是一个库包，可以被嵌入应用程序，Tcl的库包含了一个分析器、用于执行内建命令的例程和可以使你扩充(定义新的过程)的库函数。
    3. 可定制build-in command
    4. 应用程序可以产生Tcl命令并执行，命令可以由用户产生，也可以从用户接口的一个输入中读取（按钮或菜单等）。
       但Tcl库收到命令后将它分解并执行内建的命令，经常会产生递归的调用。
    5. Tcl数据类型简单。对Tcl来说，它要处理的数据只有一种——字符串。
    6. 内嵌的Tk（toolkit）图形工具可以提供简单而又丰富的图形功能，让用户可以轻松的创建简单的图形界面。
    7. Tcl的执行是交互式的，Tcl提供了交互式命令界面，界面有两种：tclsh和wish。tclsh只支持Tcl命令，wish支持Tcl和Tk命令。
       通过交互界面，我们就可以象执行UNIX shell命令一样，逐条命令执行，并即时得到执行结果。
    8. 以;或换行分隔命令
    9. 大多数EDA(vcs,verdi,velrun)工具都集成TCL功能,可以添加内建命令，可以将多条命令写到脚本中，执行脚本进行批处理
# 参数长选项和短选项
    1. -sh == -s -h(short option)
    2. --sh == --sh(long option)
# hardware design
    DFT: design for test
    DUT: design under test
    TB: test bench
    simulation: software, 传统的仿真
    emulation: hardware，可视为Simulator的补充（不是替代），软件仿真的硬件化，极大提高了仿真效率
    verification
    Cadence: Palladium
    Synopsys: ZeBu
    Mentor: veloce
    EDA: Electronic Design Automation
    CDA
    CAD: Computer Aided Design
    HDL: hardware discriptor luanguage
    RTL: Register Transfer Level
    ICE: In-Circuit Emulator(电路内仿真)
    DPI: direct program interface
    PLI/VPI: program language interface/ verilog program interface
## veloce emulation flow
       tools                           process files
    1. vellib                      --> create libraties
    2. velmap                      --> map libraries
    3. create a veloce.config file
    4. velanalyze                  --> analyze RTL files
    5. velcomp                     --> compile DUT files
    6. velhvl or vlog              --> compile testbench files
    7. velrun or vsim              --> Run Emulation
    8. velview                     --> debug
### veloce run
    1. Run emulation with the following command in the same directory as your veloce.config file.
    • Use velrun for C, C++, and SystemC testbenches as described in the table below.
    • Use vsim for SystemVerilog testbenches. (See Questa documentation.)
## linux HDL toolchains
    1. iverilog
        compile
         iverilog xx.v -->a.out
        run
         ./a.out-->a.vcd (实际是vvp解析a.out,生成vcd文件)
        display wave
         gtkwave a.vcd
    2. ghdl
        compile
         ghdl -a xx.vhd
         ghdl -e xx
        run
         ghdl -r xx --vcd=xx.vcd
        display wave
         gtkwave xx.vcd
    3. gtkwave
## 仿真器基本架构原理(前仿)
    Verilog语言确实不是一种可执行语言 。 图2展示了利用Verilog源文件进行仿真的过程 。 绝大
    多数仿真器都遵循这一思路 , 比如VCS 、 iVerilog 、 ModelSim 、 Vivado和Quartus等 。 首先 ,
    准备Verilog源文件以及一些Verilog库文件(标准单元等) 。 仿真器接收这些Verilog文件并将
    其转化为可执行的仿真源文件(C/C++等) 。 在这一过程中 , 仿真器解析Verilog文件的语法
    结构 , 并且根据Verilog语法的规范 , 将语法结构转化为仿真器中的事件响应函数或代码段 。
    这些函数和代码段与仿真器框架源文件一起成为可执行仿真程序的源文件 。 接下类这些源文
    件经过编译得到可执行的仿真程序 。 VCS和iVerilog可以看到生成的可执行文件 。 ModelSim 、
    Vivado和Quartus使用GUI管理设计流程 , 从而将这个可执行文件屏蔽了 , 使其对于用戶可
    透明 。 用戶可以在工程中找到生成的可执行文件 。 最后 , 运行可执行的仿真程序 , 进行软件 仿真 。

    仿真程序通常采用基于事件的仿真架构,这些事件响应函数模拟硬件电路的行为 ，并且产生了新的事件
    通过“读出第一个事件-响应事件-插入新事件”的循环 ， 事件队列可以一直运行下去 ， 直到事件队列为空或者达到了仿真结束的时间
    在仿真开始的时候 ， 必须向事件队列中插入起始事件 ， 从而开始仿真循环
## RTL生成原理图(后仿)
    Vivado可以查看综合或者布局布线后的原理图
    也可以在完成 RTL 编码后查看 RTL 分析 （RTL ANALYSIS） 的原理图
    在综合后的原理图中电路已经被映射到器件的 LUT 和 FF 中，并且经过了综合器的优化。相比原先的代码,可以说"面目全非”了。
    而 RTL 分析的原理图用逻辑门，选择器以及触发器来表示电路，并尽量使用代码中的变量名表示，可以更清晰地和代码对应
    这样一来，就知道自己的代码会变成怎样的电路器件，与门，非门，选择器，加法器等等。尽管我保证他们哪个在 FPGA 上都不存在。
    不过，我们可以将他们映射到 LUT 上实现—— 一种 FPGA 上有的是的东西。
    举个例子
    一个计数器的电路就跃然纸上了，其实计数器和 CPU 都是一样的（真的）。
    右键某个元件，在菜单中选择 Go to Source, 可以跳转到你代码中的相应部分。
        Tool>>Netlist Viewers>>RTL Viewers
        Quartus生成原理图在我们的工程创建完毕后，即vhd代码编写并保存完毕后，
        通过File→Create/Update→Create Symbol Files for Current File即可生成原理图。生成成功的话会提示：生成成功后，在工程的目录下，我们可以找到 实体名.bsf 文件
    1. RTL视图
       编译通过后
       Tools --> Netlist Viewers ----> RTL Viewer
    2. 框图的生成为:
       File -- >Create/Update ---> Create Symbol Files for Current file
## PLI和DPI
### PLI
    1. PLI1.0
        1.1 TF(task/function) interface
        1.2 ACC(access) interface
    2. PLI2.0
        VPI(Verilog Procedural Interface)
    PLI1.0 已经在IEEE 1364-2005(IEEE 1364就是verilog std)中被删除。
### DPI
    1. PLI很强大，几乎无所不能，那么为什么在2003年的时候，会出现一个叫DPI的家伙呢？
        1.1 写PLI例程，是件痛苦的事情，不仅需要好几个步骤，更让人头痛的是PLI三个库中提供的一大堆难记的标准例程名字。
        写完了，还必须再用checktf例程，calltf例程包一层，才能在verilog中调用。
        1.2 另外一个问题， 就是谁来负责写这些PLI例程，通常情况下，不管是设计者还是验证人员通常都不需要了解
        仿真器生成的verilog数据结构。我们只是使用者，不是生产者.
        1.3 编写PLI应用程序很难
            * 必须学习奇怪的PLI术语
            * 必须了解PLI库中的内容
            * 必须创建checktf例程，calltf例程等
        1.4 将PLI应用程序链接到仿真器很难
            * 涉及多个步骤
            * 每个仿真器都不同
            * 谁链接…
                * 设计工程师？
                * EDA工具管理员？
            * 管理多个PLI应用程序很困难
            * PLI代码很少与二进制兼容
            * 必须为每个仿真器重新编译
        综上所述，PLI有以上痛点，它严重阻碍着设计者和验证者使用更高级的语言来加强verilog语言的功力，
        尤其是日益复杂的设计和验证工作迫切需要一种新的编程语言接口，为我们提供强大的生产力的时候。
    2. DPI横空出世
            在2003年IEEE 1800 SV LRM 3.1a中提出了一种直接的编程语言接口DPI。
        SystemVerilog DPI（直接编程接口）是将SystemVerilog与外部语言连接的一个接口。
        理论上外部语言可以是C，C ++，SystemC以及其他语言。
        但是，现在，SystemVerilog仅为C语言定义了一个外部语言层。
            DPI标准源自两个专有接口，一个来自Synopsys公司的VCS DirectC接口，
        另一个是来自Co-Design公司（已被Synopsys公司收购）的SystemSim Cblend接口。
        这两个专有接口起初是为他们各自的仿真器专门开发的， 而不是一个能够工作在任何仿真器上的标准。
        后来Synopsys公司将这两个技术捐献给了Accellera组织，Accellera的SystemVerilog标准委员会把这两个捐献技术合并在一起，
        并定义了DPI接口的语义，使得DPI能够与任何Verilog仿真器一起工作。
            DPI标准源自两个专有接口，一个来自Synopsys公司的VCS DirectC接口，
        另一个是来自Co-Design公司（已被Synopsys公司收购）的SystemSim Cblend接口。
### PLI和DPI两者之间的关系
    DPI绝不是PLI（或VPI）的替代品。相反，他们的角色是互补的。 PLI和VPI将来会继续存在并蓬勃发展，这主要有两个原因。
    1. PLI和VPI是经过时间考验的方法确保了对仿真器数据库的保护。
    PLI和VPI将继续提供访问设计数据的安全机制，同时保持仿真器数据库的完整性。
    2. 对于许多人来说，PLI在未来几年仍将是首选接口语言。有许多应用程序使用PLI和VPI编写。将维护这些遗留应用程序，
    创建新的附加组件，并且将出现全新的应用程序 - 全部使用PLI和VPI。在Accellera决定对整个SystemVerilog语言提供完整的VPI支持时，
    PLI也就证明了其顽强的生命力。你熟悉和喜爱的VPI方法现在将适用于SystemVerilog的整个对象集。
    3. 所以我们同时需要Verilog PLI和SystemVerilog DPI
    * 使用PLI
    * 访问仿真数据结构中任何位置的任何对象
    * 同步到仿真事件队列
    * 阻塞赋值，非阻塞赋值等
    * 与仿真事件同步
    * 仿真的开始，停止，完成，保存，重启，复位等
## verilog and system verilog
### difference between Verilog and SystemVerilog
    1. Verilog is a Hardware Description Language, while SystemVerilog is a Hardware
        Description and Hardware Verification Language based on Verilog.
    2. Hardware Description Language (HDL) is a computer language that is used to describe
        the structure and behaviour of electronic circuits. Hardware Verification Language is
        a programming language that is used to verify the electronic circuits written in a Hardware
        Description Language. Verilog is an HDL while SystemVerilog is an HDL as well as HVL.
        Overall, SystemVerilog is a superset of Verilog.
### module
### port
    端口是一组信号， 用作特定模块的输入和输出， 并且是与之通信的主要方式
### parameter
    1.参数传递方法1
        module trans
        #(parameter para1=50,para2=80)
        (
        input   clk,
        input	rst_n
        );
        endmodule
        //例化传参
        trans trans
        #(.para1(20),.para2(30))
        (
        . clk(clk),
        . rst_n(rst_n)
        );
    2.参数传递方法2
        module trans(
        input   clk,
        input	rst_n
        );
        parameter para1=50,para2=80;
        endmodule
        defparam  trans.para1=20;
        defparam  trans.para2=30;
    3.参数传递方法3
        宏定义传参，必须包含头文件
        #define   para1  30
### task
### function
### for
### 仿真原理
    1. 通过strace vvp和gdb vvp，发现仿真跑起来后，只有一个主线程；并且git clone iverilog的源码，发现vvp中的
       线程的概念不是linux线程的概念；vvp中创建线程是这样的:
       vthread_t vthread_new(vvp_code_t pc, __vpiScope*scope)
       {
             vthread_t thr = new struct vthread_s;
             thr->pc     = pc;
           //thr->bits4  = vvp_vector4_t(32);
             thr->parent = 0;
             thr->parent_scope = scope;
             thr->wait_next = 0;
             thr->wt_context = 0;
             thr->rd_context = 0;

             thr->i_am_joining  = 0;
             thr->i_am_detached = 0;
             thr->i_am_waiting  = 0;
             thr->i_am_in_function = 0;
             thr->is_scheduled  = 0;
             thr->i_have_ended  = 0;
             thr->i_was_disabled = 0;
             thr->delay_delete  = 0;
             thr->waiting_for_event = 0;
             thr->event  = 0;
             thr->ecount = 0;

             thr->flags[0] = BIT4_0;
             thr->flags[1] = BIT4_1;
             thr->flags[2] = BIT4_X;
             thr->flags[3] = BIT4_Z;
             for (int idx = 4 ; idx < 8 ; idx += 1)
               thr->flags[idx] = BIT4_X;

             scope->threads .insert(thr);
             return thr;
       }
    2. initial,always语句会创建线程
    3. iverilog -pfileline=1 counter.v能将源码嵌入到输出文件中，便于理解verilog编译前后的区别
### {}迭代连接运算符
    连接功能：将若干个寄存器类型/线网类型的变量首尾连接，形成一个更大位宽的变量；
    如：
        a = 2'b10;
        b = 3'b010;
       有{a,b} = 5'b10010;
    迭代功能：把一个变量复制多次，首尾连接组成一个更大位宽的变量；（实际仍为连接功能的一个特例：连接元素相同）
    如：
       a = 2'b10;
       有{4{a}}，即{a,a,a,a}
    注意：
    要保证迭代的完整性：{ {4{a}}，b}   （{4{a}}为迭代功能，括号不能少；即不能写为{ 4{a}，b} ）
    迭代连接运算符还可用于常量操作：{ {4{1'b1}}，2'b10}
### 逻辑操作符
    逻辑与 &&
    逻辑或 ||
    逻辑非 ！
### 位操作符
    一元非 ~
    二元与 &
    二元或 |
    二元异或 ^
### 归约操作符/缩位运算符（单目运算符）
    与归约 &
    或归约 |
    异或归约 ^
### 逻辑移位运算符与数字移位运算符
    列举：
        << 逻辑左移运算符；<<< 数字左移运算符；
        >> 逻辑右移运算符；>>> 数字右移运算符；
    区别：
        逻辑移位运算符不关心符号位；逻辑左移右端补零，逻辑右移左端补零；
        数字左移位运算符不关心符号位，与逻辑左移一样；数字右移运算符关心符号位，左端补符号位；
### sv中CpuRead/CpuWrite实现
    svExecuteMan("cpu", "cpu_cmd", pktload, pktloads, NULL);
    task execute_man (....);自己实现一个task，在这个task中完成;
    最终，通过调用例化的axi或mem实例来完成
### display与io_printf区别
    display用在module中
    io_printf用在task/func/program中?只能在sv中用?
    you can use the io_printf function to get some diagnostics from your C code on to the simulator console
### CPU吐log,仿真器接收并打印
    DV/DE都是通过实现一个module，来不停地检测某个地址，来实现打印的
#### DV实现的方式
    R5跑的程序怎么和sv-vip通信
    R5访问的sram是通过sv例化的，在这个例化的sram中，找一块空间,当共享内存来与sv通信。
    sv中可以直接调用sram实例
#### DE实现的方式
    实现一个tube module，由一个always块调用一个task tubewrite，task tubewrite中调用$display()系统函数来打印；
    tube module例化:
        Tube u_tube
        (
        //outputs
        .HRDATA  ( ),
        .HREADY  ( ),
        .HRESP   ( ),
        //inputs
        .HCLK    ( `NOC_SUBSYS_HIE.i_ahb_clk),
        .HCLKEN  ( 1'b1),
        .HSEL    ( `NOC_SUBSYS_HIE.ecm_HSel &&
                   `NOC_SUBSYS_HIE.expf_HWrite &&
                  (`NOC_SUBSYS_HIE.expf_HAddr == 32'h2e2f_fffc)), // CPU只有往这个地址write data,tube才会print
        .HWRITE  ( `NOC_SUBSYS_HIE.expf_HWrite),
        .HTRANS  ( `NOC_SUBSYS_HIE.expf_HTrans[1:0]),
        .HWDATA  ( `NOC_SUBSYS_HIE.expf_HWData[31:0])
        );
### HDL and HVL
    HDL --> Hardware description language --> Used to design digital logic Eg: VHDL, Verilog
    HVL --> Hardware Verification language --> Used to Functionally verify the digital
        logic designed using a HDL Eg: e, vera, system-C, system-Verilog
    HDL is used for RTL design.
    HVL is used for RTL Verification(Random Verification).
### 打印文件名和行号
    `__FILE__, `__LINE__
    $display("Internal error: null handle at %s, line %d.", `__FILE__, `__LINE__);
### testbench
### VIP
    Verification IP (VIP) blocks are inserted into the testbench for a design to check
    the operation of protocols and interfaces, both discretely and in combination
### sv/svh files
    .sv 文件与.svh文件没有本质区别。通常，需要被include 到package的文件定义为.svh类型， 其他的文件定义为.sv类型。
    .svh后缀的文件即systemverilog include文件。
    Class templates that are declared within the scope of a package should be separated out into individual
    files with a .svh extension. These files should be included in the package in the order in which they
    need to be compiled. The package file is the only place where includes should be used, there should be
    no further `include statements inside the included files. Justification: Having the classes declared in
    separate files makes them easier to maintain, and it also makes it clearer what the package content is.
## verilog仿真器
### 解释型仿真器
    解释型仿真器将verilog语言转化成脚本，然后解释执行，生成波形数据
#### iverilog
### 编译型仿真器
    编译型仿真器将verilog语言转化成c/c++语言，然后用gcc/g++编译，生成elf文件，最后运行生成波形数据
#### vcs
##### 编译
    1. vcs是一个shell脚本文件，由/bin/sh解释执行, 会调/tools/sysnopsys/vcs-mx/2018.09-sp2/linux/bin/vcs1,
       vcs1是一个ELF可执行文件
    2. vcs -h //查看帮助信息
###### vcs -V
    enables the verbose mode
    这个选项打开，可以看到vcs编译的细节
###### c/c++/sv/v混合编译
###### 增量编译
###### VCS动态加载PLI shared lib，
　　1)在VCS编译时，加入-P pli.tab等指定。
　　2)在runtime时，每个lib加load选项，simv -load ./pli1.so -load ./pli2.so
###### 动态链接
###### -top
    -top xxxx 不在top下各层的例化的文件,就算编译有错也不会停下编译
    在最后一步 vcs elaboration中需要指定top file
###### 预编译宏定义
    +define+macro=value+
###### other options
    1. vcs -f  xx.f -R -debug_all -ucli
        1.1 -R表示编译完成后，立即运行
        1.2 -ucli实际上是传给simv的，是运行时的参数,不是编译参数
    2.
        2.1 -debug*：旧版选项，粗控制
            -debug_access+*：新版选项，细控制
        2.2 -debug/-debug_all/-debug_pp will enable UCLI/GUI debugging
    3. 编译完成后，默认生成simv ELF文件
    4. 宏定义，可以加载vcs命令行中，也可以加载filelist中
      4.1 commandline 中加宏定义
      eg:
        vcs [args] +define+FEIMA_XPHY_X16_GUC_NEWSEMI_STUB \
        +define+FEIMA_XPHY_X16_GUC_WRAP_USE_STUB \
        +define+FEIMA_XPHY_X4_WRAP_USE_STUB \
      4.2 filelist 中添加宏定义
      eg:
        echo "`define FEIMA_XPHY_X16_GUC_NEWSEMI_STUB" >> feima_sim.f
        echo "`define FEIMA_XPHY_X16_GUC_WRAP_USE_STUB" >> feima_sim.f
        echo "`define FEIMA_XPHY_X4_WRAP_USE_STUB" >> feima_sim.f
        vcs -f feima_sim.f [args]
    5. -y <dir> add search path
    6. +libext.+v search file's extern name
##### 仿真
    1. 一般design flow是:编辑-编译-run(simulation)-dbg(wave view). 其中run过程一般不需要交互，也不需要单步调试的，
    但是，vcs提供了UCLI/GUI交互式debug功能，在需要单步debug时非常有用.
    2. VCS仿真可以分成两步法或三步法， 对Mix language(混合语言)， 必须用三步法。
    仿真前要配置好synopsys_sim.setup文件，里边有lib mapping等信息。设置环境变量'setenv SYNOPSYS_SIM_SETUP /xxx/xxx/synopsys_sim.setup'.
###### 运行仿真
    ./simv [args]
###### debug仿真
    1. UCLI(cmdline interface)
        UCLI: user command line interface
        UCLI是基于command line的交互方式
        前提:
            编译时，enable debug功能，即加上-debug/-debug_all/-debug_pp等编译选项
        命令行:
            ./simv -ucli [args]
            启动后会停在0s位置，等待交互
        交互命令:
            * help //显示帮助信息
            * command -h //显示command的help info
            * stack //显示调用栈,跟踪调用流程很有用
            * get var // display var value
            * finish //结束仿真
            * show 显示当前顶层模块的信号以及子模块
            * show 信号 –value -radix hex/bin/dec 显示信号的值 以特定的进制显示
            * show -h // display show help infomation
            * show -nid(hierarchical path name)
            * show -id(id=instances/scopes/signals...) //能查看当前scope中的instances，这样就可以用scope <instance>进行层级切换了
            * scope 显示当前的顶层模块
            * scope u1 就表示进入到当前顶层模块的u1模块，同时将u1模块设置为顶层模块
            * scope –up 回到目前顶层模块的上一层
            * stop 显示断点
            * stop -line num -file /path/filename //在filename:num处加断点
            * stop –posedge 信号 在信号的上升沿设置断点
            * stop -negedge 信号 在信号的下降沿设置断点
            * stop -condition {信号表达式} 信号表达式为真的地方设置断点
            * stop -delete 断点值 删除断点值的断点
            * run 一直运行，直到遇到$stop或者设置的断点
            * run time 运行多少时间停止（不推荐）
            * run -posedge 信号 运行到信号的上升沿停止
            * run -negedge 信号 运行到信号的下降沿停止
            * run -change 信号 信号有变化时停止
            * restart 重新开启ucli调试模式
    2. DVE/VERDI(GUI interface)
        DVE(Discovery Visual Environment) and VERDI是基于gui的交互工具，可查看波形
        前提:
            编译时加:-deubg/-debug_all/-debug_pp/-debug_access+all/-kdb
        先运行simv,再启动gui:
            * ./simv [args] [-sml=verdi] -ucli2Proc -ucli
            进入ucli交互后，输入:start_verdi即可启动verdi simulation debug界面
            verdi调试界面有一个console窗口，可以输入调试命令，用法和ucli一样
            * ./simv -verdi [args]
            会报错:libXss.so.1: cannot open shared object file
            * ./simv -gui=verdi [args]
            会报错:libXss.so.1: cannot open shared object file
            * ./simv -gui=dve [args]
            会报错:licence error
        先启动gui,再运行simv,或者attach运行中的simv:
            * verdi &
            * 点击Simulation按钮
            * Invoke Simulator
            * verdi会执行simv [args] -sml=verdi -ucli2Proc -ucli
###### 结束仿真
    方法1:
        1. 运行仿真:./simv [args]
        2. DUT中的CPU执行完程序后，向约定地址写入约定值，然后主动进入死循环
        3. testbench中,事先写一个进程，轮询该地址是否被写入约定值，当被写入约定值后，调用verilog系统任务$finish，结束并退出仿真
    方法2:
        1. 运行仿真:./simv [args] -ucli
        2. 进入ucli交互命令行，输入:run，开始仿真
        3. DUT中的CPU执行完程序后，向约定地址写入约定值，然后主动进入死循环
        4. testbench中,事先写一个进程，轮询该地址是否被写入约定值，当被写入约定值后，调用verilog系统任务$stop，暂停仿真
        5. 输入命令: finish/quit结束并退出仿真
##### 看波形dve/verdi
    VCS对应的waveform工具有DVE和Verdi， DVE因为是原生的，所以VCS对DVE非常友好。但DVE已经过时了,
    其对uvm等新feature支持的不好。Verdi是Debussy公司的产品，现在已被Synopsys收购并着力发展，
    所以Verdi是未来的潮流。但由于其原来是Synopsys第三方产品，所以VCS对其支持并不是很友好。
    如果要支持Verdi，需要设置好NOVAS_LIB_PATH的环境变量，并且在命令行中添加-kdb的option，knowledge database（kdb）
    是VCS支持Verdi时的重要概念。另外，VCS支持vpd和fsdb两个格式的dump wave。 fsdb的文件相对比较小。
    1. verdi -ssf xxx.fsdb &
    2. verdi的instance对话框中有俩列：
        左边一列(Hierarchy): 是实例的层级结构图，在添加波形时，只能在实例中找到变量，然后ctrl-w，才可以添加
        右边一列(Module):   是左边实例对应的类型名，在类型中是不能添加波形的，因为它没有实例化
    3. Drive/Load按钮
        可以看一个信号由哪些信号驱动的，和有哪些负载
##### VCS/VCS_MX
    VCS_MX为mixed hdl仿真器，支持vhdl+verilog+sv的混合仿真。vcs则是纯verilog的。
    当然，目前vcs也是有sv支持的。它们在feature上唯一的区别在于对vhdl的支持。
## 各种波形文件
    https://blog.csdn.net/limanjihe/article/details/49910779
### VCD(Value Change Dump)
    是一个通用的格式。 VCD文件是IEEE1364标准(Verilog HDL语言标准)中定义的一种ASCII文件。
    它主要包含了头信息，变量的预定义和变量值的变化信息。
    因为VCD是 Verilog HDL语言标准的一部分，因此所有的verilog的仿真器都能够查看该文件，允许用户在verilog代码中通过系统函数来dump VCD文件。
    通过Verilog HDL的系统函数dumpfile来生成波形，通过dumpvars的参数来规定我们抽取仿真中某些特定模块和信号的数据。
    示例如下：
        // 在testbench中加入以下内容
        initial
        begin
        $dumpfile("*.vcd");
        $dumpvars(0,**);
        end
    正是因为VCD记录了信号的完整变化信息，我们还可以通过VCD文件来估计设计的功耗，
    而这一点也是其他波形文件所不具备的。 Encounter 和 PrimeTime PX （Prime Power）都可以通过输入网表文件，
    带功耗信息的库文件以及仿真后产生的VCD文件来实现功耗分析。
### FSDB(Fast Signal DataBase)
    Spring Soft （Novas）公司 Debussy / Verdi 支持的波形文件，一般较小，使用较为广泛，
    其余仿真工具如ncsim，modlesim 等可以通过加载Verdi 的PLI （一般位于安装目录下的share/pli 目录下）
    而直接dump fsdb文件。 fsdb文件是verdi使用一种专用的数据格式，类似于VCD，但是它是只提出了仿真过程中信号的有用信息，
    除去了VCD中信息冗余，就 像对VCD数据进行了一次huffman编码。因此fsdb数据量小，而且会提高仿真速度。
    我们知道VCD文件使用verilog内置的系统函数来实现 的，fsdb是通过verilog的PLI接口来实现的，例如fsdbDumpfile,
    fsdbDumpvars等。示例如下：
        // Testbench中加入以下内容
        initial
        begin
        $fsdbDumpfile("*.fsdb");  //*代表生成的fsdb的文件名
        $fsdbDumpvars(0,**);    //**代表测试文件名
        end
### WLF(Wave Log File)
    Mentor Graphics 公司Modelsim支持的波形文件。
    在modelsim波形窗口观察波形时，仿真结束时都会生成一个*.wlf的文件(默认是vsim.wlf)，可以用modelsim直接打开，命令如下：
    vsim -view vsim.wlf -do run.do
    其中，run.do中的内容为要查看的波形信号。
    这个wlf文件只能由modelsim来生成，也只能通过modelsim来显示。不是一个通用的文件格式。
### SHM
    Cadence公司 NC verilog 和Simvision支持的波形文件，实际上 .shm是一个目录，其中包含了.dsn和.trn两个文件。
    使用NC Verilog 对同一testcase和相同dump波形条件的比较，产生shm文件的时间最短（废话，本来就是一个公司的），
    产生vcd文件的时间数倍于产生shm和 fsdb的时间。在笔者测试的例子中，产生的fsdb文件为十几MB，shm文件为几十MB，而vcd文件则要几个GB的大小。
### VPD(vcd plus dump)
    Synopsys公司 VCS DVE支持的波形文件，可以用$vcdpluson产生。
### 其余波形文件
    就是各家不同的仿真或调试工具支持的文件类型，互不通用，但基本都可以由VCD文件转换而来
    （其实就是VCD文件的压缩版，因为只取仿真调试需要的数据，所以文件大小要远小于原始VCD文件），
    有的还提供与VCD文件的互转换功能。
## AMBA
### APB
    Signal	    Description
    PCLK	    时钟。APB协议里所有的数据传输都在PCLK上升沿进行
    PRESETn	    复位。低电平有效
    PADDR	    APB地址总线。最大宽度为32位
    PSELx	    选通。APB master会将此信号生成给每个slave。它指示已选择的slave，并且需要进行数据传输。 每个slave都有一个PSELx信号。
    PENABLE	    使能。当它为高时，表示数据有效
    PWRITE	    读写控制。为高时表示写操作，为低时表示读操作
    PWDATA	    写数据。master通过PWDATA将数据写到slave，该总线最大宽度为32位
    PRDATA	    读数据。master通过PRDATA将数据从slave读取回来，该总线最大宽度为32位
    1. read
        总结一下：一开始我们就说到，APB数据传输至少需要两个周期，也就是T1-T3。其实很简单，第一个周期做准备工作（把PADDR,PWRITE,PSEL发送到总线），
        第二个周期进行传输读或写的data（PENABLE拉高，表面当前时刻，数据有效，是master想要的数据！）
    2. write
        通过读写操作的时序图，我们可以看到，无论是读还是写，都是两个周期。在第一个周期，PSEL为高，PENABLE为低，这个时候为data的传输做准备工作；
        第二个周期里，PSEL和PENABLE同时为高，进行data的传输。
## 计算机减法的实现
    1. CPU只有加法器，没有减法器，所有减法运算都转化成加法运算；
    2. 在做减法运算时，比如8-6，CPU执行一条sub指令，该指令首先将减数符号位加1，然后取补码，
       然后再用补码与被减数相加；
    3. sub (-8)-(6)，再编译时，-8已经转化成补码，不需CPU转化，CPU对减数取补码；
### timer回绕问题
    void main()
    {
        unsigned char a = 20;
        unsigned char b = 129;
        char c = (char)b-(char)a;
        printf("    unsigned char   char\n");
        printf("a   0x%x              %d\n", (unsigned char)a, (char)a);
        printf("b   0x%x              %d\n", (unsigned char)b, (char)b);
        printf("c   0x%x              %d\n", (unsigned char)c, (char)c);

        a = 20;
        b = 159;
        c = (char)b-(char)a;
        printf("    unsigned char   char\n");
        printf("a   0x%x              %d\n", (unsigned char)a, (char)a);
        printf("b   0x%x              %d\n", (unsigned char)b, (char)b);
        printf("c   0x%x              %d\n", (unsigned char)c, (char)c);
    }
    结果:
        unsigned char   char
    a   0x14            20
    b   0x81            -127
    c   0x6d            109
        unsigned char   char
    a   0x14            20
    b   0x9f            -97
    c   0x8b            -117
    结论:
        当无符号char型a和b之间的距离超过无符号char型所能表示最大数的一半时(即:128),
        b-a就不大于零，就不能解决回绕
## Difference Between AHB and AXI
    1. AHB is Advanced High-performance Bus and AXI is Advanced eXtensible Interface.
    2. When the Advanced High-performance Bus is a single channel Bus, the Advanced eXtensible Interface is a multi- channel Bus.
    3. In AHB, each of the bus masters will connect to a single-channel shared bus. On the other hand, the bus master in AXI will connect to a Read data channel, Read address channel, Write data channel, Write address channel and Write response channel.
    4. The AHB is also a shared Bus whereas the AXI is a read/write optimized bus.
    5. Bus latencies in AHB starts lower than the AXI.
    6. The Advanced eXtensible Interface uses around 50 per cent more power, which means that AHB has an edge over it.
    7. AHB Bus utilization is higher than AXI utilization
## uart model.sv
    module LightUartTransactor
    (
    input           clk,
    input           cts,
    output reg      rts,
    input           rxd,
    output reg      txd,
    input [31:0]    DBR
    );
    localparam CHARACTER_WIDTH = 8;
    localparam POLLING_INTERVAL = 117;
    localparam RTS_VALUE = 0;
    ...
    bit [15:0]  clocksPerBit = 217; // 25MHz/115200
    ...
    // model's tx
    always begin
        @(txFlag);
        @(posedge clk);
        repeat(pollingInterval - 1) @(posedge clk);
        txd = txBuffer[0];
        repeat(clocksPerBit) @(posedge clk);
        repeat(CHARACTER_WIDTH + 3) begin
            txBuffer = txBuffer >> 1;
            txd = txBuffer[0];
            repeat(clocksPerBit) @(posedge clk);
        end
        txLock = 0;
    end
    // model's rx
    initial begin
        @(posedge clk);
        rxData = 0;
        forever begin
            @(posedge clk);
            while (rxd != 0) @(posedge clk);
            // ref clk和采样点之间的关系及调节原理,联想qspi的timing调节原理
            // 一般在ref/2时刻采样,也可根据需要调节,调节单位为ref clk
            repeat(clocksPerBit + clocksPerbit / 2) @(posedge clk);
            rxData[0] = rxd;
            for (i = 1; i < CHARACTER_WIDTH; i++) begin
                repeat(clocksPerBit) @(posedge clk);
                rxData[i] = rxd;
            end
            sendRxToXterm(rxData);
            repeat(clocksPerBit) @(posedge clk);
        end
    end
    ...
    endmodule
