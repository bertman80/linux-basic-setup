#!/usr/bin/env bash
#curl -L https://raw.githubusercontent.com/bertman80/linux-basic-setup/main/wordpress-server.sh | bash
#read -p "LAN ip-range (192.168.178.0/24): " internsubnet # werkt alleen als script offline staat
#read -p "Website name: " websitename # werkt alleen als script offline staat
websitename="trebnie.nl"
internsubnet="192.168.178.0/24"
#if [ !websitename  ]; then 
#  websitename="test.nl"
#fi
#if [ !internsubnet ]; then 
#  internsubnet="192.168.178.0/24"
#fi
wordpress_url="https://nl.wordpress.org/latest-nl_NL.zip"
echo ""
echo "####################################"
echo "### Apache WebServer Installeren ###"
echo "####################################"
echo ""
sudo apt-get install apache2 php mariadb-server php-mysql -y
sudo service apache2 restart
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

echo ""
echo "####################################"
echo "###            Config            ###" 
echo "####################################"
echo ""
externalip=$(curl ifconfig.me)
internalip=$(hostname -I | awk '{print $1}')

wpdir=/var/www/wordpress/
if [ ! -d "$wpdir" ]; then
  curl -o /tmp/wp.zip $wordpress_url
  unzip /tmp/wp.zip -d /var/www
fi

wpconfig=/etc/apache2/sites-enabled/wordpress.conf
if [ ! -f "$wpconfig" ]; then
  cp /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/wordpress.conf
  sed -i 's#:80>#:8080>#' /etc/apache2/sites-enabled/000-default.conf
  sed -i 's#/var/www/html#/var/www/wordpress#' /etc/apache2/sites-enabled/wordpress.conf
  sed -i "s#ServerAdmin webmaster@localhost#ServerName http://$websitename \n\t ServerAlias http://www.$websitename \n\t ServerAdmin webmaster@localhost#" /etc/apache2/sites-enabled/wordpress.conf
  sed -i "s#<VirtualHost#  <directory /var/www/wordpress> \n\t require all granted \n </directory> \n <VirtualHost#" /etc/apache2/sites-enabled/wordpress.conf
#  sed -i 's#:80>#:8080>#' /etc/apache2/sites-enabled/000-default.conf
#  sed -i 's#/var/www/html#/var/www/wordpress#' /etc/apache2/sites-enabled/wordpress.conf
#  sed -i 's#ServerAdmin webmaster@localhost#ServerName http://$websitename \n\t ServerAlias http://www.$websitename \n\t ServerAdmin webmaster@localhost#' /etc/apache2/sites-enabled/wordpress.conf
#  sed -i 's#<VirtualHost#  <directory /var/www/wordpress> \n\t require all granted \n </directory> \n <VirtualHost#' /etc/apache2/sites-enabled/wordpress.conf
fi
sudo service apache2 restart
echo ""
echo "####################################"
echo "###           FireWall           ###" 
echo "####################################"
echo ""
sudo apt install ufw
# ssh alleen van intern
ufw allow from $internsubnet to any app ssh
# website overal te benaderen
ufw allow from any to any app www
sudo ufw enable
# show rules
sudo ufw status numbered

