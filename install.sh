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
    wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-2+debian11_all.deb -O /tmp/zabbix.deb
    dpkg -i /tmp/zabbix.deb
    apt update
    apt install -y $(awk '{print $1'} packages-zabbix.txt)
    
    echo "zabbix ALL=NOPASSWD: /usr/bin/nmap" >> /etc/sudoers
    echo "adjust password in sql file"
        
    echo "Press any key to continue"
    while [ true ] ; do
      read -t 3 -n 1
    done

    nano zabbix.sql
    zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
    
    echo "adjust password in zabbix file"
    echo "DBPassword=PASSWORD"
    echo "Press any key to continue"
    while [ true ] ; do
      read -t 3 -n 1
    done
    nano /etc/zabbix/zabbix_server.conf
    
    echo "adjust timezone in zabbix file"
    echo "php_value date.timezone Europe/Amsterdam"
    echo "Press any key to continue"
    while [ true ] ; do
      read -t 3 -n 1
    done    
    nano /etc/zabbix/apache.conf

    echo "adjust timezone in php.ini"
    echo "date.timezone = Europe/Amsterdam"
    echo "Press any key to continue"
    while [ true ] ; do
      read -t 3 -n 1
    done
    nano /etc/php/7.3/apache2/php.ini
    date.timezone = Europe/Amsterdam

    systemctl restart zabbix-server zabbix-agent apache2
    systemctl enable zabbix-server zabbix-agent apache2
    
    echo "you can now logon to zabbix:"
    echo "http://penguin.linux.test/zabbix"
    echo "Admin / zabbix"
    ;;

  *)
    echo -n "unknown"
    ;;
esac

updatedb


#echo "Install Microsoft Visual Code"
#cd /tmp
#wget https://code.visualstudio.com/docs/?dv=linux64_deb
#dpkg -i zabbix-release_5.0-2+debian11_all.deb
