#-------------------------------------------------------------
#input sources config:
#	gnome-control-center->region & language->manage installed languages-> install/remove languages->select [chinese (simplified)]
#	gnome-control-center->region & language->input sources->add[chinese(intelligent pinyin)]
#-------------------------------------------------------------
#the brightness will reset Max when setup every time:
#	sudo vim /etc/rc.local
#	add two line:
#		#!/bin/sh
#		echo 976 > /sys/class/backlight/intel_backlight/brightness
#-------------------------------------------------------------
#gnome-terminal config:
#	font
#	background color
#	"reset and clear" shortcut
#-------------------------------------------------------------
#ubuntu desktop config:
#	backgroud color
#-------------------------------------------------------------
#git config:
#	git config --global alias.st status
#	git config --global alias.br branch
#	git config --global diff.tool meld
#	git config --global core.editor vim
#	git config --global color.diff.whitespace "red reverse"
#	git config --global diff.wsErrorHighlight all
#	git config --global difftool.prompt no
#	git diff --ws-error-highlight=all
#-------------------------------------------------------------
#evince config:
#	backgroud color
#	asve as default config
#-------------------------------------------------------------
#firefox browser config:
#	add-ons:search zoom->set default font size
#	add-ons:search flash->
#	add-ons:Dark Background and Light Text
#-------------------------------------------------------------
#vim-scripts config:
#	cp -rf /usr/share/vim-scripts/ ~/.vim/
#vim vundle plugin config:
#	vim .vim/bundle/Vundle.vim/autoload/vundle/installer.vim
#-    let cmd = 'git clone			 --recursive '.vundle#installer#shellesc(a:bundle.uri).' '.vundle#installer#shellesc(a:bundle.path())
#+    let cmd = 'git clone --depth=1 --recursive '.vundle#installer#shellesc(a:bundle.uri).' '.vundle#installer#shellesc(a:bundle.path())
#	vim
#	:PluginInstall
#	wait vim plugin Install Done
#	vim ~/.vim/bundle/Vundle.vim/ftplugin/markdown.vim  // resize table of contents window
#-            execute 'vertical resize ' . (&columns/2)
#+            execute 'vertical resize ' . (&columns/6)
#-------------------------------------------------------------
#gnome-control-center config:
#	----
#-------------------------------------------------------------
#gnome-tweaks config:
#	----
#-------------------------------------------------------------
#update-manager config:
#	----
#-------------------------------------------------------------
#nfs-kernel-server config:
#	echo "/home/user/nfs *(rw,sync,no_root_squash)" > /etc/exports
#-------------------------------------------------------------
#everytime bootup show "System program problem detected" resolvent
#	sudo vim /etc/default/apport modfy "enable=0"
#-------------------------------------------------------------
#windows(LTC) and ubuntu(UTC+8) double system time error
#	modify windows regedit
#-------------------------------------------------------------
