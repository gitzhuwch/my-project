#below three mathods all can modify the sources server, should prefer first mathod!
#1, software-properties-gtk-> ubuntu software-> download from-> main server
#2, update-manager-> Settings & Livepath...-> ubuntu software-> download from-> main server
#3, directly modify /etc/apt/sources.list
sudo software-properties-gtk
mkdir ~/work
mkdir ~/bin
mkdir ~/notes
mkdir ~/temp
mkdir ~/nfs
./1tools-install.sh
sudo ./2configs.sh
cat ./bashrc >> ~/.bashrc
cp -f ./vimrc ~/.vimrc
cp -f ./gdbinit ~/.gdbinit
