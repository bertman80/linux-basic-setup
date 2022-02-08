#!/bin/bash

echo "What do you want to install, this are te options"
echo "basic"
echo "zabbix"
echo -n "What do you want to install: "
read answer
case $answer in
  basic)
    echo -n "Install basics"
    # install most handy tools
    echo "Installing: basic packages"
    apt install -y $(awk '{print $1'} packages-linux-basic.txt)
    apt -y install python3-pip
    pip3 install BeautifulSoup4
    pip3 install pandas
    pip3 install requests
    ;;

  zabbix)
    echo -n "Install Zabbix"
    neofetch
    echo "go to this site and give us the right install url, based on this Linux version"
    echo "https://www.zabbix.com/download?zabbix=5.0&os_distribution=debian&os_version=11_bullseye&db=mysql&ws=ap>"
    echo "type down here the url the you can find under 2.a. Install Zabbix repository"
    echo "after wget, so it have to start with https://"  
    read answer
    wget $answer -O /tmp/zabbix.deb
    dpkg -i /tmp/zabbix.deb
    apt update
    apt install -y $(awk '{print $1'} packages-zabbix.txt)
    
    echo "zabbix ALL=NOPASSWD: /usr/bin/nmap" >> /etc/sudoers
    echo "adjust password in sql file"
        
    echo "Press any key to continue"
    read -n 1 -s
    nano zabbix.sql

    echo "Enter password for creating database and user"
    mysql -uroot -p < zabbix.sql

    echo "Enter password for importing basic SQL filem this may take a while!"
    zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
    
    echo "adjust password in zabbix file"
    echo "DBPassword=PASSWORD"
    echo "Press any key to continue"
    read -n 1 -s
    nano /etc/zabbix/zabbix_server.conf
    
    echo "adjust timezone in zabbix file"
    echo "php_value date.timezone Europe/Amsterdam"
    echo "Press any key to continue"
    read -n 1 -s
    nano /etc/zabbix/apache.conf

    echo "adjust timezone in php.ini"
    echo "date.timezone = Europe/Amsterdam"
    echo "Press any key to continue"
    read -n 1 -s
    nano /etc/php/7.4/apache2/php.ini
    date.timezone = Europe/Amsterdam

    systemctl restart zabbix-server zabbix-agent apache2
    systemctl enable zabbix-server zabbix-agent apache2
    
    echo "you can now logon to zabbix:"
    echo "http://penguin.linux.test/zabbix"
    echo "Admin / zabbix"
    ;;

    echo "to improve performance, we stop the zabbix-agent en server (these will automaticly start when linux is started)"
    echo "the website is still running and you can do youre config, but tasks will not be executed at this time"
    service zabbix-server stop
    service zabbix-agent stop
  *)
    echo -n "unknown"
    ;;
esac

echo "You can get some access denied. You can ignore them"
updatedb


#echo "Install Microsoft Visual Code"
#cd /tmp
#wget https://code.visualstudio.com/docs/?dv=linux64_deb
#dpkg -i zabbix-release_5.0-2+debian11_all.deb
