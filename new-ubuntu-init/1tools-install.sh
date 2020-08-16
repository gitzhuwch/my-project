set -x
sudo apt update

sudo apt -y install vim
sudo apt -y install vim-gtk	#加了些增强特性,如+和*号系统剪切板
sudo apt -y install ctags
sudo apt -y install net-tools #ifconfig tools
sudo apt -y install ibus-pinyin
sudo apt -y install git
sudo apt -y install gitk
sudo apt -y install meld
sudo apt -y install make
sudo apt -y install openssh-server #sshd
sudo apt -y install minicom
sudo apt -y install tree
sudo apt -y install nfs-kernel-server

###下面用到时再装
##for linux 5.5 building
#sudo apt -y install flex
#sudo apt -y install bison
##for kernel building
#sudo apt -y install build-essential #gcc and so on
#sudo apt -y install device-tree-compiler #dtc compile dts
#sudo apt -y install libncurses5-dev #make menuconfig
#sudo apt -y install libssl-dev
#sudo apt -y install liblz4-tool
#sudo apt -y install u-boot-tools
#sudo apt -y install libc6-dev-i386 #AMD64 run 32bit app
#sudo apt -y install ccache #for fast compiler code
#sudo apt -y install lib32z1
##GAWK是GNUProject的AWK解释器的开放源代码实现。尽管早期的GAWK发行版是旧的AWK的替代程序，但不断地对其进行了更新，以包含NAWK的特性。
#sudo apt -y install gawk

###较少用到的工具
#sudo apt -y install repo #这个在普通源中找不到
#sudo apt -y install v4l-utils
#sudo apt -y install curl
#sudo apt -y install cmake
#sudo apt -y install expect
##sudo apt -y install flashplugin-installer
##sudo apt -y install cifs-utils #有好的共享文件夹的方式来替代,所以赞不安装
##sudo apt -y install vim-scripts #这种方法淘汰掉,在Vundle中安装和管理
#sudo apt -y install gnome-tweaks #hide mounted disk icon on desktop
#sudo apt -y install ffmpeg #preview yuv data
#sudo apt -y install wkhtmltopdf #convert html to pdf or image
#sudo apt -y install patchelf
##for wifi hotspot and wifi the same time
#sudo apt -y install hostapd
#sudo apt -y install haveged
##install samba tools for ubuntu/windows sheared folder可以在nautilus中安装
##sudo aptitude -y install samba-libs
##sudo aptitude -y install samba-libs=2:4.7.6+dfsg~ubuntu-0ubuntu2
##sudo aptitude -y install samba-common-bin
##sudo aptitude -y install samba
##sudo aptitude -y install samba-common
