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

