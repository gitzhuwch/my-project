# vim
## how much vim filetypes
* `ls $VIMRUNTIME/ftplugin/*`
* `vim: echo $VIMRUNTIME` print "/usr/share/vim/vim81/"
## specify the filetype in file
add this line `/* vim: set filetype=markdown : */`
## align plugin Tabular.vim
* align with ':'
:Tabularize /:
## Ctrl-v选至行尾
Ctrl-v ... Shift-\$
## search highlight 临时取消
* :noh/:nohlsearch
临时取消，下次搜索时会自动打开
* :set hlsearch
永久取消
## change file line ending
* :set fileformat=unix
* :dos2unix(need install this tool)
## regular expression
### 替换转大小写方法
比如有下面这段文字：
every day
* 将两个单词都转变为全大写
```vimrc
:s/\(.*\) \(.*\)/\U\1 \2/
```
转变结果为：
EVERY DAY
* 将上面的文字转变为EVERY day
```vimrc
:s/\(.*\) \(.*\)/\U\1\e \2/
```
上面的四个转义序列将在其被显式停止前，对跟在其后的内容持续作用；如果要停止，需要使用'\e'来中断。
注:
\u （将分组第一个字母转换成大写）
\U （将整个分组转换成大写）
\l （将分组第一个转换成小写）
\L （将整个分组转换成小写）
## 结构体成员补全
1. bash:tag
2. vim:Ctrl-X Ctrl-O
vim自带的omni-complete plugin可以利用tags文件找到结构体成员并补全
## 为自定义拓展名文件增加类型识别
```vimrc
au! BufNewFile,BufRead *.cu,*.cuh setf cpp
au! BufNewFile,BufRead *.lds setf ld
au BufNewFile,BufRead *.cu,*.cuh setf cpp
au BufNewFile,BufRead *.lds setf ld
```
* :autocmd! 可以删除所有自动命令,此操作也将删除插件所定义的自动命令
* 如果我们针对同样的文件和同样的事件定义了多条自动命令，那么当满足触发条件时将分别执行多条自动命令。
因此，建议在自动命令组的开头增加:autocmd!命令，以确保没有重复的自动命令存在。
# typora画流程图、时序图(顺序图)、甘特图
[source page](https://jingyan.baidu.com/article/48b558e3035d9a7f38c09aeb.html)
* 横向流程图源码格式：
```mermaid
graph LR
A[方形] -->B(圆角)
B --> C{条件a}
C -->|a=1| D[结果1]
C -->|a=2| E[结果2]
F[横向流程图]
```
* 竖向流程图源码格式：
```mermaid
graph TD
A[方形] -->B(圆角)
B --> C{条件a}
C -->|a=1| D[结果1]
C -->|a=2| E[结果2]
F[竖向流程图]
```
* 标准流程图源码格式：
```flow
st=>start:            开始框
op=>operation:        处理框
cond=>condition:      判断框(是或否?)
sub1=>subroutine:     子流程
io=>inputoutput:      输入输出框
e=>end:               结束框
st->op->cond
cond(yes)->io->e
cond(no)->sub1(right)->op
```
* 标准流程图源码格式（横向）：
```flow
st=>start:            开始框
op=>operation:        处理框
cond=>condition:      判断框(是或否?)
sub1=>subroutine:     子流程
io=>inputoutput:      输入输出框
e=>end:               结束框
st(right)->op(right)->cond
cond(yes)->io(bottom)->e
cond(no)->sub1(right)->op
```
* UML时序图源码样例：
```sequence
对象A->对象B:         对象B你好吗?（请求）
Note right of 对象B:  对象B的描述
Note left of 对象A:   对象A的描述(提示)
对象B-->对象A:        我很好(响应)
对象A->对象B:         你真的好吗？
```
* UML时序图源码复杂样例：
```sequence
Title:                标题：复杂使用
对象A->对象B:         对象B你好吗?（请求）
Note right of 对象B:  对象B的描述
Note left of 对象A:   对象A的描述(提示)
对象B-->对象A:        我很好(响应)
对象B->小三:          你好吗
小三-->>对象A:        对象B找我了
对象A->对象B:         你真的好吗？
Note over 小三,对象B: 我们是朋友
participant C
Note right of C:      没人陪我玩
```
* UML标准时序图样例：
```mermaid
sequenceDiagram
participant 张三
participant 李四
张三->王五:           王五你好吗？
loop 健康检查
王五->王五:           与疾病战斗
end
Note right of 王五:   合理 食物 <br/>看医生...
李四-->>张三:         很好!
王五->李四:           你怎么样?
李四-->王五:          很好!
```
* 甘特图样例：
```mermaid
gantt
dateFormat  YYYY-MM-DD
title 软件开发甘特图
section 设计
需求:                 done,    des1, 2014-01-06,2014-01-08
原型:                 active,  des2, 2014-01-09, 3d
UI设计:               des3, after des2, 5d
未来任务:             des4, after des3, 5d
section 开发
学习准备理解需求:     crit, done, 2014-01-06,24h
设计框架:             crit, done, after des2, 2d
开发:                 crit, active, 3d
未来任务:             crit, 5d
耍:                   2d
section 测试
功能测试:             active, a1, after des3, 3d
压力测试:             after a1  , 20h
测试报告:             48h
```
# toolchain
## hex file formats
* ihex
objcopy -O ihex xxx.bin xxx.ihex
* srec(s-recored)
objcopy -O srec xxx.bin xxx.srec
## link script
* info ld: 比"man"的信息全
### sections
>SECTION [ADDRESS] [(TYPE)] :
>  [AT(LMA)]
>  [ALIGN(SECTION_ALIGN) | ALIGN_WITH_INPUT]
>  [SUBALIGN(SUBSECTION_ALIGN)]
>  [CONSTRAINT]
>  {
>    OUTPUT-SECTION-COMMAND
>    OUTPUT-SECTION-COMMAND
>    ...
>  } [>REGION] [AT>LMA_REGION] [:PHDR :PHDR ...] [=FILLEXP] [,]
1. bss
* bss: block started by symbol
* 存放程序中未初始化的全局变量的一块内存区域
* 在初始化时bss 段部分将会清零。bss段属于静态内存分配，即程序一开始就将其清零了
* bss段不在可执行文件中，由系统初始化
2. text
* 存放程序执行代码的一块内存区域
* 大小在程序运行前就已经确定
* 通常属于只读
3. data
* 存放程序中已初始化的全局变量的一块内存区域
* 数据段属于静态内存分配
4. 一个程序本质上都是由 bss段、data段、text段三个组成的
* text和data段都在可执行文件中（在嵌入式系统里一般是固化在镜像文件中），由系统从可执行文件中加载
5. '.' location counter
* . = 0x2f000000
* __start = .
### LMA,VMA
>SECTION [ADDRESS] [(TYPE)] :
>  [AT(LMA)]
>  [ALIGN(SECTION_ALIGN) | ALIGN_WITH_INPUT]
>  [SUBALIGN(SUBSECTION_ALIGN)]
>  [CONSTRAINT]
>  {
>    OUTPUT-SECTION-COMMAND
>    OUTPUT-SECTION-COMMAND
>    ...
>  } [>REGION] [AT>LMA_REGION] [:PHDR :PHDR ...] [=FILLEXP] [,]
* VMA是指令执行时所使用的地址,
* LMA是烧录地址,在链接脚本中使用AT来指定
* LMA,VMA大多数情况下是相等的,当它俩不相等时,就要重定位了,
比如lds中将一个数据段的LMA=0x200,VMA=0x800,此时有一条指令I访问该数据段中的变量时，使用的是VMA(0x800),
但是，当把该程序烧录到ram中时，该数据段的地址为0x200,所以执行指令I时就会出错，所以就要自己写代码将该数据端
搬到VMA(0x800)处.
* 实例：
flash的地址空间:0x200-0x10000
ram的地址空间:0x100000-0x200000
当希望将数据和代码都烧录到flash中，在运行时，代码放在flash中执行，数据搬到ram中使用，此时就可将数据段的LMA,VMA设成不一样的,来达到这个目的
```
.text 0x200 : AT(0x200) {
*(.text)
}
.data 0x100000: AT(0x100000) {
*(.data)
}
```
上面的lds会导致，生成elf中.text与.data中有一大段0填充，导致elf文件太大，超出flash的size
可以改称下面
```
.text 0x200 : AT(0x200) {
*(.text)
}
.data 0x100000: AT(ADDR(.text) + SIZEOF(.text)) {
*(.data)
}
```
这样之后，.data就会紧跟.text段，中间不会填0，size就会变小，就可以烧录到flash中
**总结:**
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
* Spec 文件(Spec files) 就是用来配置 SPEC 字符串的
* gcc is gnu compiler collection
* specs is control the compiler component:cpp,cc1,asm,linker...
* when you use gcc's component single, the specs don't take effect. eg: "gcc -o" just invoke cpp,cc1,asm. don't invoke linker
## spec string(specs)
## info ld
## info gcc
# arm instruction set
* bfi
>Bitfield Insert copies a bitfield of <width> bits from the least significant bits of the source register
>to bit position <lsb> of the destinationregister, leaving the other destination bits unchanged
>BFI <Wd>, <Wn>, #<lsb>, #<width>
当操作结构体位域时，会自动生成bfi类似指令，该指令效率很高，建议以后驱动中使用结构体位域格式化寄存器.
注意:为避免出错，如果是32位架构，结构体中所有成员使用unsigned int型
```c
typedef union {
struct {
uint32_t startBitMidpoint:      16;
uint32_t baudCompensateValue:   4;
uint32_t reserved31To20:        12;
} reg;
uint32_t all;
} SGR5UartComps_t;
```
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
* %p：打印裸指针(raw pointer)
* %pF可打印函数指针的函数名和偏移地址
* %pf只打印函数指针的函数名，不打印偏移地址。
* %pM打印冒号分隔的MAC地址
* %pm打印MAC地址的16进制无分隔
* %I4打印无前导0的IPv4地址，%i4打印冒号分隔的IPv4地址
* %I6打印无前导0的IPv6地址，%i6打印冒号分隔的IPv6地址
**总结:**
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
* 一种是10-90上升时间，指信号从终值的10%跳变到90%所经历的时间。
* 第二种定义方式是20-80上升时间，这是指从终值的20%跳变到80%所经历的时间
* 下降时间通常要比上升时间短一些，这是由典型CMOS输出驱动器的设计造成的。
## 频域
* 频域最重要的性质是：它不是真实的，而是一个数学构造。时域是惟一客观存在的域，而频域是一个遵循特定规则的数学范畴。
