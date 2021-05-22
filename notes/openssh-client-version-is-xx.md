openssh-server : Depends: openssh-client (= 1:6.6p1-2ubuntu2.8)
                  Recommends: ssh-import-id but it is not going to be installed
E: Unable to correct problems, you have held broken packages.

原因如下：

这是因为,openssh-server是依赖于openssh-clien的,那ubuntu不是自带了openssh-client吗?

原由是自带的openssh-clien与所要安装的openssh-server所依赖的版本不同,这里所依赖的版本是：

1:6.6p1-2ubuntu2.8

所以要安装对应版本的openssh-clien,来覆盖掉ubuntu自带的

sudo apt-get install openssh-client=1:6.6p1-2ubuntu1

这样再安装openssh-server就可以成功了。
