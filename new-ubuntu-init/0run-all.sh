#below three mathods all can modify the sources server, should prefer first mathod!
#1, software-properties-gtk-> ubuntu software-> download from-> main server
#2, update-manager-> Settings & Livepath...-> ubuntu software-> download from-> main server
#3, directly modify /etc/apt/sources.list
sudo software-properties-gtk
if [ ! -d ~/work ]; then
	mkdir ~/work
fi

if [ ! -d ~/bin ]; then
mkdir ~/bin
fi

if [ ! -d ~/notes ]; then
mkdir ~/notes
fi

if [ ! -d ~/temp ]; then
mkdir ~/temp
fi

if [ ! -d ~/nfs ]; then
mkdir ~/nfs
fi

if [ ! -d ~/.vim ]; then
mkdir ~/.vim
fi

./1tools-install.sh
#tips: do not use "sudo ./2configs.sh" this will config in /root/ directory
./2configs.sh

grep "export PS1=" ~/.bashrc -q
if [ $? != 0 ]; then
	cat ./bashrc >> ~/.bashrc
fi
cp -f ./vimrc ~/.vimrc
cp -f ./gdbinit ~/.gdbinit
