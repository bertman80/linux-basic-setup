mysql -uroot -p
create database zabbix character set utf8 collate utf8_bin;
create user zabbix@localhost identified by 'PASSWORD';
grant all privileges on zabbix.* to zabbix@localhost;
quit;
