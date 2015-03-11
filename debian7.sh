#!/bin/bash
# go to root
cd
# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart
# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;
apt-get remove sendmail sendmail-bin postfix
apt-get purge postfix exim4 sendmail sendmail-bin
# install wget and curl
apt-get update;apt-get -y install wget curl;
# install essential package
apt-get -y install nano iptables sysv-rc-conf vnstat apt-file
apt-get -y install build-essential
# disable exim
service exim4 stop
sysv-rc-conf exim4 off
# update apt-file
apt-file update
# setting vnstat
vnstat -u -i venet0
service vnstat restart
# install badvpn
wget -O /usr/bin/badvpn-udpgw "http://repo.sufanet.com/debian6/badvpn-udpgw"
sed -i '$ i\badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/nul &
# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
service ssh restart
# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart
# install fail2ban
apt-get -y install fail2ban;service fail2ban restart
# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.730_all.deb"
dpkg --install webmin*;
apt-get -y -f install;
rm /root/webmin*
service webmin restart
service vnstat restart
 
