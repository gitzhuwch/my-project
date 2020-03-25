install some apps not be installed by apt:
#citrix receiver installl
1, download:
	->https://www.citrix.com/downloads/citrix-receiver/linux/receiver-for-linux-latest.html
	->Debian Packages
	->Web Packages
	->Download Files(icaclientWeb_13.10.0.20_amd64.deb)
2, install:
	sudo dpkg -i icaclientWeb_13.10.0.20_amd64.deb
3, configs:
	sudo ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts
	sudo /opt/Citrix/ICAClient/util/ctx_rehash
#wps insatll
1, gnome-software &
2, search wps
3, install
