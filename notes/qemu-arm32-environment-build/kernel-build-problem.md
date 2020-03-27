# kernel build probloms
	编译时用make -j会报错，不加-j就不会有问题
	Makefile发现依赖关系很混乱
	make并发编译问题

##makefile
对任务节点建立正确依赖有向图
避免对临时资源的共用，以此来保证 make -j 成功。

不过有时候 makefile 复杂了，在 without parallel 会成功，就懒得改的。所以有些库建议 without -j 进行构建，既然能用就忍忍，大家都不容易（Sad：

------------ 吐槽分割线 --------------------

make -j 报错后还要继续狂刷日志，最后还是得 make without -j 来定位错误，实在太不友好了。

顺便说个不靠谱的奇淫技巧，先 make -j 构建，错了再 make。可以省些中间结果的构建时间，但是如果遇到第二种情况，构建的中间结果错了，那就再重来吧。（如果错误没被发现就哭了

首先make -jN不是多线程（Multithreaded）编译，而是并行化执行任务（Parallel Job Execution）。

然后主要的问题就是大部分的gnu Make脚本都是串行写的，并行化最多的会造成依赖（Dependency）的缺失。

比如touch a；touch b；touch c；cp c a这三个命令并行处理，很有可能c还没创建，cp就先执行了。
当然还有其他的错误，不过根本原因还是脚本的思路都是串行的，缺少对并行下的设计。

这个跟makefile有很大关系,也跟机器的硬件有关系:

makefile是定义的依赖顺序,如果没有考虑多线程编译,很大概率会出问题;

另外就是机器的硬件了,若是核心数不够,也会出问题,我在编译caffe的时候,CPU核心数是20,我向快点编译,就用了make -j30,结果出现莫名其妙的错误(后来查看是因为用来的头文件,是用proto生成的,但是还没有进行proto编译,就用了这个头文件,结果出错了),但是用make -j20就没有问题.

#gcc -O0 build kernel not allowed
尝试用-O0的选项重新编译内核。
这个时候，编译内核代码会出现问题

include/linux/compiler.h:437:2: note: in expansion of macro '_compiletime_assert'
_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)