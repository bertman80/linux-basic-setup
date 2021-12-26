# install most handy tools
echo "Installing: basic packages"
apt install /y $(awk '{print $1'} linux-basic-setup-packages.txt)
sudo apt -y install python3-pip
sudo pip3 install BeautifulSoup4
sudo pip3 install pandas
sudo pip3 install requests
sudo apt update
sudo apt upgrade
updatedb
