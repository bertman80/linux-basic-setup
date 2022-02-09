#!/usr/bin/env bash
#curl -L https://raw.githubusercontent.com/bertman80/linux-basic-setup/main/wordpress-server.sh | bash
read -p "LAN ip-range (192.168.178.0/24): " internsubnet
read -p "Website name: " websitename
if [[ websitename = "" ]] then 
  websitename="test.nl"
fi
if [[ internsubnet = "" ]] then 
  internsubnet="192.168.178.0/24"
fi

echo $websitename
echo $internsubnet

read -p "ff wachten" est

#internsubnet=192.168.178.0/24
wordpress_url="https://nl.wordpress.org/latest-nl_NL.zip"

echo "### Apache WebServer Installeren ###"

sudo apt-get install apache2 php mariadb-server php-mysql -y
sudo service apache2 restart
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

externalip=$(curl ifconfig.me)
internalip=$(hostname -I | awk '{print $1}')
#echo "start de webbrowser"
#echo "http://$internalip/info.php"

wpdir=/var/www/wordpress/
if [ ! -d "$wpdir" ]; then
  curl -o /tmp/wp.zip $wordpress_url
  unzip /tmp/wp.zip -d /var/www
fi

wpconfig=/etc/apache2/sites-enabled/wordpress.conf
if [ ! -f "$wpconfig" ]; then
  cp /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/wordpress.conf
  sed -i 's/:80/:8080/' /etc/apache2/sites-enabled/000-default.conf
fi
sudo service apache2 restart


echo "### FireWall ###" 
sudo apt install ufw
# ssh alleen van intern
ufw allow from $internsubnet to any app ssh
# website overal te benaderen
ufw allow from any to any app www
sudo ufw enable
# show rules
sudo ufw status numbered

