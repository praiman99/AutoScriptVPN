#!/bin/sh

# Script Created by John Ford Sangalang <exodia090@gmail.com>

# extract ip address
if [ -z "$1" ]; then
clear
echo
echo "Error: Payload not found! Please execute again with payload."
echo
echo "Example: $0<space><payloadhere>"
echo
echo "or execute the command like this."
echo
echo "$0 m.facebook.com"
echo
echo "Note: m.facebook.com payload is example."
echo
else
IPADDRESS=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{print $1}' | head -1`
IPADD="s/ipaddresxxx/$IPADDRESS/g";
# clean repo
apt-get clean
# update repo
apt-get update
# install needs
apt-get -y install stunnel4 apache2 openvpn easy-rsa ufw
# stunnel
cd /etc/stunnel/
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -sha256 -subj '/CN=127.0.0.1/O=localhost/C=US' -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem
sudo touch stunnel.conf
echo "client = no" > /etc/stunnel/stunnel.conf
echo "pid = /var/run/stunnel.pid" >> /etc/stunnel/stunnel.conf
echo "[openvpn]" >> /etc/stunnel/stunnel.conf
echo "accept = 443" >> /etc/stunnel/stunnel.conf
echo "connect = 127.0.0.1:1194" >> /etc/stunnel/stunnel.conf
echo "cert = /etc/stunnel/stunnel.pem" >> /etc/stunnel/stunnel.conf
sudo sed -i -e 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo cp /etc/stunnel/stunnel.pem ~
echo "client = yes\ndebug = 6\n[openvpn]\naccept = 127.0.0.1:1194\nconnect = $IPADDRESS:443\nTIMEOUTclose = 0\nverify = 0\nsni = $1" > /var/www/html/stunnel.conf
# openvpn
cp -r /usr/share/easy-rsa/ /etc/openvpn
mkdir /etc/openvpn/easy-rsa/keys
sed -i 's|export KEY_COUNTRY="US"|export KEY_COUNTRY="PH"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_PROVINCE="CA"|export KEY_PROVINCE="TAR"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_CITY="SanFrancisco"|export KEY_CITY="Tarlac City"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_ORG="Fort-Funston"|export KEY_ORG="JohnFordTV"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_EMAIL="me@myhost.mydomain"|export KEY_EMAIL="exodia090@gmail.com"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU="MyOrganizationalUnit"|export KEY_OU="JohnFordTV"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_NAME="EasyRSA"|export KEY_NAME="JohnFordTV"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU=changeme|export KEY_OU=JohnFordTV|' /etc/openvpn/easy-rsa/vars
# create diffie-helman pem
openssl dhparam -out /etc/openvpn/dh1024.pem 1024
# create pki
cd /etc/openvpn/easy-rsa
. ./vars
./clean-all
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca $*
# create key server
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --server server
# setting key cn
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" client
cd
# copy /etc/openvpn/easy-rsa/keys/{server.crt,server.key,ca.crt} /etc/openvpn
cp /etc/openvpn/easy-rsa/keys/server.crt /etc/openvpn/server.crt
cp /etc/openvpn/easy-rsa/keys/server.key /etc/openvpn/server.key
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn/ca.crt
# setting server
cat > /etc/openvpn/server.conf <<-END
port 1194
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh1024.pem
client-cert-not-required
username-as-common-name
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
server 192.168.100.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "route-method exe"
push "route-delay 2"
duplicate-cn
push "route-method exe"
push "route-delay 2"
keepalive 10 120
persist-key
persist-tun
status openvpn-status.log
log openvpn.log
verb 3
cipher none
END
# create openvpn config
cat > /var/www/html/openvpn.ovpn <<-END
client
dev tun
proto tcp-client
remote $IPADDRESS:1194@$1 1194
persist-key
persist-tun
dev tun
pull
resolv-retry infinite
nobind
ns-cert-type server
verb 3
mute 2
mute-replay-warnings
auth-user-pass
redirect-gateway def1
script-security 2
route 0.0.0.0 0.0.0.0
route-method exe
route-delay 2
cipher none
http-proxy $IPADDRESS 8080
http-proxy-option CUSTOM-HEADER CONNECT HTTP/1.0
http-proxy-option CUSTOM-HEADER Host $1
http-proxy-option CUSTOM-HEADER X-Online-Host $1
http-proxy-option CUSTOM-HEADER X-Forward-Host $1
http-proxy-option CUSTOM-HEADER Connection keep-alive
http-proxy-option CUSTOM-HEADER Proxy-Connection keep-alive
http-proxy-retry

END
echo '<ca>' >> /var/www/html/openvpn.ovpn
cat /etc/openvpn/ca.crt >> /var/www/html/openvpn.ovpn
echo '</ca>' >> /var/www/html/openvpn.ovpn
# create openvpn config with stunnel
cat > /var/www/html/openvpnssl.ovpn <<-END
client
dev tun
proto tcp
remote 127.0.0.1 1194
persist-key
persist-tun
dev tun
pull
resolv-retry infinite
nobind
ns-cert-type server
verb 3
mute 2
mute-replay-warnings
auth-user-pass
redirect-gateway def1
script-security 2
route $IPADDRESS 255.255.255.255 net_gateway
route-method exe
route-delay 2
cipher none

END
echo '<ca>' >> /var/www/html/openvpnssl.ovpn
cat /etc/openvpn/ca.crt >> /var/www/html/openvpnssl.ovpn
echo '</ca>' >> /var/www/html/openvpnssl.ovpn
# compress config
cd /var/www/html/
tar -zcvf /var/www/html/openvpn.tgz openvpn.ovpn openvpnssl.ovpn stunnel.conf
# install squid3
apt-get -y install squid3
cat > /etc/squid/squid.conf <<-END
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst ipaddresxxx-ipaddresxxx/32
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8080
http_port 8000
http_port 3128
coredump_dir /var/spool/squid
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname JohnFordTV
END
sed -i $IPADD /etc/squid/squid.conf;
# setting iptables
cat > /etc/iptables.up.rules <<-END
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -j SNAT --to-source ipaddresxxx
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
-A POSTROUTING -s 10.1.0.0/24 -o eth0 -j MASQUERADE
COMMIT

*filter
:INPUT ACCEPT [19406:27313311]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [9393:434129]
:fail2ban-ssh - [0:0]
-A FORWARD -i eth0 -o ppp0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i ppp0 -o eth0 -j ACCEPT
-A INPUT -p ICMP --icmp-type 8 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 85  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 80  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 80  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 443  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 1194  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 1194  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 3128  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 3128  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8000  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8000  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8080  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8080  -m state --state NEW -j ACCEPT
COMMIT

*raw
:PREROUTING ACCEPT [158575:227800758]
:OUTPUT ACCEPT [46145:2312668]
COMMIT

*mangle
:PREROUTING ACCEPT [158575:227800758]
:INPUT ACCEPT [158575:227800758]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [46145:2312668]
:POSTROUTING ACCEPT [46145:2312668]
COMMIT
END
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i $IPADD /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules
# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
# add dns server ipv4
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver 8.8.8.8" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.4.4" >> /etc/resolv.conf' /etc/rc.local
# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime
# setting ufw
ufw allow ssh
ufw allow 1194/tcp
sed -i 's|DEFAULT_INPUT_POLICY="DROP"|DEFAULT_INPUT_POLICY="ACCEPT"|' /etc/default/ufw
sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|' /etc/default/ufw
cat > /etc/ufw/before.rules <<-END
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
# Allow traffic from OpenVPN client to eth0
-A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE
COMMIT
# END OPENVPN RULES
END
ufw enable
ufw status
ufw disable
# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
# restart apps
service squid stop
service squid3 stop
service squid4 stop
service squid start
service squid3 start
service squid4 start
service stunnel4 restart
service openvpn stop
service openvpn start
# create openvpn account
useradd openvpn
echo "openvpn:fordsenpai" | chpasswd
clear
echo "######### Download your config files here! #########"
echo "~> http://$IPADDRESS/openvpn.ovpn - Normal config"
echo "~> http://$IPADDRESS/openvpnssl.ovpn - Config with stunnel"
echo "~> http://$IPADDRESS/stunnel.conf - Stunnel config file"
echo "~> http://$IPADDRESS/openvpn.tgz - All config"
echo "######### Download your config files here! #########"
echo
echo "################# OpenVPN Account ##################"
echo "~> Username: openvpn"
echo "~> Password: fordsenpai"
echo "################# OpenVPN Account ##################"
echo
echo "######### To Add OpenVPN User Account ##############"
echo "useradd USERNAMEHERE"
echo "echo USERNAMEHERE:PASSWORDHERE | chpasswd"
echo "######### To Add OpenVPN User Account ##############"
echo
echo "######## To Change OpenVPN User Account ############"
echo "echo USERNAMEHERE:PASSWORDHERE | chpasswd"
echo "######## To Change OpenVPN User Account ############"
echo
echo "########### To Delete OpenVPN Account ##############"
echo "userdel USERNAMEHERE"
echo "########### To Delete OpenVPN Account ##############"
fi
