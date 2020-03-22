sudo apt update

sudo apt -y install vim
#sudo rm ~/.viminfo #~/.viminfo pession may be cause vim can not record the position
sudo apt -y install net-tools #ifconfig tools
sudo apt -y install meld
sudo apt -y install ctags
sudo apt -y install repo
sudo apt -y install git
sudo apt -y install make
sudo apt -y install build-essential #gcc and so on
sudo apt -y install openssh-server #sshd
sudo apt -y install gitk
sudo apt -y install expect
#for build kernel
sudo apt -y install device-tree-compiler #dtc compile dts
#sudo apt -y install libcurses*
sudo apt -y install libncurses5-dev #make menuconfig
sudo apt -y install libssl-dev
sudo apt -y install liblz4-tool
#for build linux 5.5
sudo apt -y install flex
sudo apt -y install bison
#for uboot tools
sudo apt -y install u-boot-tools

#sudo apt -y install flashplugin-installer
sudo apt -y install minicom
sudo apt -y install curl
sudo apt -y install libc6-dev-i386 #AMD64 run 32bit app
sudo apt -y install lib32z1
sudo apt -y install ccache #for fast compiler code

#install vim plugins
sudo apt -y install vim-scripts

sudo apt -y install cmake
sudo apt -y install gnome-tweaks #hide mounted disk icon on desktop

sudo apt -y install nfs-kernel-server

sudo apt -y install ffmpeg #preview yuv data

sudo apt -y install wkhtmltopdf #convert html to pdf or image

sudo add-apt-repository ppa:rednotebook/stable
#Ubuntu 18.04用户可以跳过sudo apt update命令，因为它已经在添加PPA时完成了
#sudo apt update
sudo apt -y install rednotebook
#sudo apt remove --autoremove rednotebook
#并通过软件和更新实用工具删除PPA - >其他软件选项卡

sudo apt -y install ibus-pinyin
