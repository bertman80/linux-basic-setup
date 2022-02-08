#!/usr/bin/env bash
#curl -L https://raw.githubusercontent.com/bertman80/linux-basic-setup/main/lamp-server.txt | bash
echo "### Apache WebServer Installeren ###"

#sudo apt-get install apache2 php mariadb-server php-mysql -y
#sudo service apache2 restart
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

externalip=$(curl ifconfig.me)
internalip=$(hostname -I | awk '{print $1}')
echo "start de webbrowser"
echo "http://$internalip/info.php"

echo "### FireWall ###" 
sudo apt install ufw
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
