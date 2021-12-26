echo "What do you want to install, this are te options"<br>
echo "basic"<br>
echo "zabbix"<br><br>
echo -n "What do you want to install: "<br>
read answer<br>
case $answer in<br>
  basic)
    echo -n "Install basics"<br>
    # install most handy tools
    echo "Installing: basic packages"
    apt install -y $(awk '{print $1'} linux-basic-setup-packages.txt)
    apt -y install python3-pip
    pip3 install BeautifulSoup4
    pip3 install pandas
    pip3 install requests
    ;;

  zabbix)
    echo -n "Install Zabbix"<br>
    wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1+buster_all.deb -O /tmp/zabbix.deb
    dpkg -i zabbix.deb
    apt update
    apt install -y $(awk '{print $1'} linux-zabbix-packages.txt)
    ;;

  *)
    echo -n "unknown"<br>
    ;;
esac


#echo "Install Microsoft Visual Code"
#cd /tmp
#wget https://code.visualstudio.com/docs/?dv=linux64_deb
#dpkg -i zabbix-release_5.0-2+debian11_all.deb

#apt update
#apt upgrade -y
#updatedb


# install Zabbix 5 LTS
#wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1+buster_all.deb
