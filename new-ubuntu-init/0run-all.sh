#update-manager-> ubuntu software-> download from-> main server
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
