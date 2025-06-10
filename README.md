# linux-basic-setup
Install and setup basic linux settings and apps

Make a github basic dir, run this script with sydo su to get the all the rights<br>
<code>sudo su</code><br>
<code>mkdir /dev/github</code><br>
<code>apt install -y git</code><br>
<code>cd /dev/github</code><br>
<code>git clone https://github.com/bertman80/linux-basic-setup.git</code><br>
<code>cd linux-basic-setup</code><br>
<code>./install.sh</code><br>
<code>exit</code><br>
<br>

# update.sh
plaats dit script in /opt/update.sh<br>
maak hem uitvoerbaar: <code>chmod +x /opt/update.sh</code><br>
als je deze automatisch laten uitvoeren b.v. op zondag ochtend om 7:00 <br>
voeg deze dan toe aan crontab -e<br>
<code>0 7 * * 0 /opt/update.sh</code>
