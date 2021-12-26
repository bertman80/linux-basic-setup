# install most handy tools
sudo su
echo "Installing: basic packages"
apt install -y $(awk '{print $1'} linux-basic-setup-packages.txt)
apt -y install python3-pip
pip3 install BeautifulSoup4
pip3 install pandas
pip3 install requests

echo "Install Microsoft Visual Code"
cd /tmp
wget https://code.visualstudio.com/docs/?dv=linux64_deb
dpkg -i zabbix-release_5.0-2+debian11_all.deb

apt update
apt upgrade -y
updatedb
exit
