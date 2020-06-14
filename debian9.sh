#!/bin/bash
# Original script by : Fordsenpai
# Modified by : PR Aiman

wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add -
sleep 2
echo "deb http://build.openvpn.net/debian/openvpn/release/2.4 stretch main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
#Requirement
apt update
apt upgrade -y
apt install openvpn nginx php7.0-fpm stunnel4 dropbear easy-rsa vnstat ufw build-essential fail2ban zip -y

#Install Curl
apt-get -y update && apt-get -y install curl
apt update && apt install curl

# initializing var
MYIP=`ifconfig eth0 | awk 'NR==2 {print $2}'`
MYIP2="s/xxxxxxxxx/$MYIP/g";
cd /root
wget "https://github.com/praiman99/AutoScriptDebian9/raw/master/Files/Plugins/plugin.tgz"
wget "https://github.com/praiman99/AutoScriptDebian9/raw/master/Files/Menu/bashmenu.zip"

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Malaysia /etc/localtime

# install webmin
cd
wget "http://downloads.sourceforge.net/webadmin/webmin_1.930_all.deb"
dpkg --install webmin_1.930_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.930_all.deb
service webmin restart

# install screenfetch
cd
wget -O /usr/bin/screenfetch "https://github.com/praiman99/AutoScriptDebian9/raw/master/Files/Plugins/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# install squid3
apt-get install squid3
cat > /etc/squid/squid.conf <<-END
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 442
acl Safe_ports port 445
acl Safe_ports port 444
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 3128
http_port 8000
http_port 8888
http_port 8080
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname PRAiman
END
sed -i $MYIP2 /etc/squid/squid.conf;

# install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=442/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells

# setting banner
rm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/praiman99/AutoScriptDebian9/master/Files/Others/issue.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service ssh restart
service dropbear restart

#install OpenVPN
cp -r /usr/share/easy-rsa/ /etc/openvpn
mkdir /etc/openvpn/easy-rsa/keys

# replace bits
sed -i 's|export KEY_COUNTRY="US"|export KEY_COUNTRY="PH"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_PROVINCE="CA"|export KEY_PROVINCE="Malaysia"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_CITY="SanFrancisco"|export KEY_CITY="Selangor"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_ORG="Fort-Funston"|export KEY_ORG="PRAiman"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_EMAIL="me@myhost.mydomain"|export KEY_EMAIL="praiman@gmail.com"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU="MyOrganizationalUnit"|export KEY_OU="PRAiman"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_NAME="EasyRSA"|export KEY_NAME="PRAiman"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU=changeme|export KEY_OU=PRAiman|' /etc/openvpn/easy-rsa/vars
#Create Diffie-Helman Pem
openssl dhparam -out /etc/openvpn/dh1024.pem 1024
# Create PKI
cd /etc/openvpn/easy-rsa
cp openssl-1.0.0.cnf openssl.cnf
. ./vars
./clean-all
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca $*
# create key server
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --server server
# setting KEY CN
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" client
cd
#cp /etc/openvpn/easy-rsa/keys/{server.crt,server.key} /etc/openvpn
cp /etc/openvpn/easy-rsa/keys/server.crt /etc/openvpn/server.crt
cp /etc/openvpn/easy-rsa/keys/server.key /etc/openvpn/server.key
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn/ca.crt
chmod +x /etc/openvpn/ca.crt

# Setting Server
tar -xzvf /root/plugin.tgz -C /usr/lib/openvpn/
chmod +x /usr/lib/openvpn/*
cat > /etc/openvpn/server.conf <<-END
port 55
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh1024.pem
verify-client-cert none
username-as-common-name
plugin /usr/lib/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 192.168.10.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log openvpn.log
verb 3
ncp-disable
cipher none
auth none
END
systemctl start openvpn@server
#Create OpenVPN Config
mkdir -p /home/vps/public_html
cat > /home/vps/public_html/client.ovpn <<-END
#Created by PR Aiman
#https://t.me/PR_Aiman
auth-user-pass
client
dev tun
proto tcp
remote $MYIP 55
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 3355
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none
http-proxy $MYIP 3128
http-proxy-option CUSTOM-HEADER CONNECT HTTP/1.1
http-proxy-option CUSTOM-HEADER Host bug.com
http-proxy-option CUSTOM-HEADER X-Forward-Host bug.com
http-proxy-option CUSTOM-HEADER Connection: Keep-Alive
http-proxy-option CUSTOM-HEADER Proxy-Connection: keep-alive
END
echo '<ca>' >> /home/vps/public_html/client.ovpn
cat /etc/openvpn/ca.crt >> /home/vps/public_html/client.ovpn
echo '</ca>' >> /home/vps/public_html/client.ovpn

cat > /home/vps/public_html/OpenVPN-SSL.ovpn <<-END
# Created by PR Aiman
auth-user-pass
client
dev tun
proto tcp
remote 127.0.0.1 445
route $MYIP 255.255.255.255 net_gateway
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none
END
echo '<ca>' >> /home/vps/public_html/OpenVPN-SSL.ovpn
cat /etc/openvpn/ca.crt >> /home/vps/public_html/OpenVPN-SSL.ovpn
echo '</ca>' >> /home/vps/public_html/OpenVPN-SSL.ovpn

cat > /home/vps/public_html/stunnel.conf <<-END
client = yes
debug = 6
[openvpn]
accept = 127.0.0.1:443
connect = $MYIP:445
TIMEOUTclose = 0
verify = 0
sni = dns.wechat.com
END

# Configure Stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -sha256 -subj '/CN=127.0.0.1/O=localhost/C=PH' -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem
cat > /etc/stunnel/stunnel.conf <<-END
sslVersion = all
pid = /stunnel.pid
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
client = no
[openvpn]
accept = 445
connect = 127.0.0.1:442
cert = /etc/stunnel/stunnel.pem
[dropbear]
accept = 443
connect = 127.0.0.1:442
cert = /etc/stunnel/stunnel.pem
END

#Setting UFW
ufw allow ssh
ufw allow 55/tcp
sed -i 's|DEFAULT_INPUT_POLICY="DROP"|DEFAULT_INPUT_POLICY="ACCEPT"|' /etc/default/ufw
sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|' /etc/default/ufw

# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

#Setting IPtables
cat > /etc/iptables.up.rules <<-END
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -j SNAT --to-source xxxxxxxxx
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.10.0/24 -o eth0 -j MASQUERADE
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:fail2ban-ssh - [0:0]
-A INPUT -p tcp -m multiport --dports 22 -j fail2ban-ssh
-A INPUT -p ICMP --icmp-type 8 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 80  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 143  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 442  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 443  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 444  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 587  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 55  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 55  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 3355  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 3355  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8085  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8085  -m state --state NEW -j ACCEPT 
-A INPUT -p tcp --dport 10000  -m state --state NEW -j ACCEPT
-A fail2ban-ssh -j RETURN
COMMIT
*raw
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
END
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules

# Configure Nginx
sed -i 's/\/var\/www\/html;/\/home\/vps\/public_html\/;/g' /etc/nginx/sites-enabled/default
cp /var/www/html/index.nginx-debian.html /home/vps/public_html/index.html

# Create and Configure rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
exit 0
END
chmod +x /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.8.8" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.4.4" >> /etc/resolv.conf' /etc/rc.local
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local

# Configure menu
apt-get install unzip
cd /usr/local/bin/
wget "https://github.com/praiman99/AutoScriptDebian9/raw/master/Files/Menu/bashmenu.zip" 
unzip bashmenu.zip
chmod +x /usr/local/bin/*

# add eth0 to vnstat
vnstat -u -i eth0

# compress configs
cd /home/vps/public_html
zip configs.zip client.ovpn OpenVPN-SSL.ovpn stunnel.conf

# install libxml-parser
apt-get install -y libxml-parser-perl

#Install Badvpn
sudo apt-get install wget screen
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/khairilg/script-jualan-ssh-vpn/master/conf/badvpn-udpgw64"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200' /etc/rc.local
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200' /etc/rc.d/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200
badvpn-udpgw --listen-addr 127.0.0.1:7200 > /dev/null &

# Install DDOS Deflate
cd
apt-get -y install dnsutils dsniff
wget "https://github.com/praiman99/AutoScriptDebian9/raw/master/Files/Others/ddos-deflate-master.zip"
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
cd
rm -rf ddos-deflate-master.zip

# finalizing
vnstat -u -i eth0
apt-get -y autoremove
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx start
/etc/init.d/php7.0-fpm start
/etc/init.d/vnstat restart
/etc/init.d/openvpn restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/squid restart

# remove unscd
apt remove unscd

#clearing history
history -c
rm -rf /root/*
cd /root
# info
clear
echo " "
echo "Installation has been completed!!"
echo " Please Reboot your VPS"
echo "=========================== Configuration Setup Server ========================="
echo "                       Debian Script HostingTermurah Based                      "
echo "                           Remodified & Fixed Script By                         "
echo "                                   -PR Aiman-                                   "
echo "================================================================================"
echo ""  | tee -a log-install.txt
echo "Server Information"  | tee -a log-install.txt
echo "   - Timezone    : Asia/Malaysia (GMT +8)"  | tee -a log-install.txt
echo "   - Fail2Ban    : [ON]"  | tee -a log-install.txt
echo "   - IPtables    : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot : [OFF]"  | tee -a log-install.txt
echo "   - IPv6        : [OFF]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Application & Port Information"  | tee -a log-install.txt
echo "   - OpenVPN		: TCP 55 "  | tee -a log-install.txt
echo "   - OpenVPN-SSL	: 445 "  | tee -a log-install.txt
echo "   - Dropbear		: 442"  | tee -a log-install.txt
echo "   - Stunnel  	 : 443"  | tee -a log-install.txt
echo "   - Squid Proxy	: 3128, 8080 ,8000 , 8888 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Nginx		: 80"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Premium Script Information"  | tee -a log-install.txt
echo "   To display list of commands: menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Important Information"  | tee -a log-install.txt
echo "   - Download Config OpenVPN : http://$MYIP/client.ovpn"  | tee -a log-install.txt
echo "   - Installation Log        : cat /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   - Webmin                  : http://$MYIP:10000/"  | tee -a log-install.txt
echo ""
echo "------------------------------ Script by PR Aiman -----------------------------"
echo "-----Please Reboot your VPS -----"
sleep 5
