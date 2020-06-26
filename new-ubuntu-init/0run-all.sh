#below tow mathods all can modify the download server, should prefer first mathod!
#software-properties-gtk-> ubuntu software-> download from-> main server
#update-manager-> Settings & Livepath...-> ubuntu software-> download from-> main server
mkdir ~/work
mkdir ~/bin
mkdir ~/notes
mkdir ~/temp
mkdir ~/nfs
./1tools-install.sh
#./2configs.sh
cat ./bashrc >> ~/.bashrc
cp -f ./vimrc ~/.vimrc
cp -f ./gdbinit ~/.gdbinit
