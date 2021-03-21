#!/bin/bash
#Licensed to https://www.hostingtermurah.net/
#Script by PR Aiman

if [[ -e /etc/debian_version ]]; then
	OS=debian
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	RCLOCAL='/etc/rc.d/rc.local'
	chmod +x /etc/rc.d/rc.local
else
	echo "It looks like you are not running this installer on Debian, Ubuntu or Centos system"
	exit
fi
color1='\e[031;1m'
color2='\e[34;1m'
color3='\e[0m'
echo "--------------- Welcome To Premium Script Menu ---------------"
	echo "----------------- Script by PR Aiman --------------------"
	echo " "
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

	echo -e "\e[032;1mCPU Model:\e[0m $cname"
	echo -e "\e[032;1mNumber Of Cores:\e[0m $cores"
	echo -e "\e[032;1mCPU Frequency:\e[0m $freq MHz"
	echo -e "\e[032;1mTotal Amount Of RAM:\e[0m $tram MB"
	echo -e "\e[032;1mTotal Amount Of Swap:\e[0m $swap MB"
	echo -e "\e[032;1mSystem Uptime:\e[0m $up"
	echo -e "-----------------------------------------------------"
	echo ""
	echo -e "-----=[ SSH & OpenVPN Section ]=-----"
	echo -e "${color1}1${color3}.Create User Account (${color2}user-add${color3})"
	echo -e "${color1}2${color3}.Generate Random Account (${color2}user-generate${color3})"
	echo -e "${color1}3${color3}.Create Trial Account (${color2}trial${color3})"
	echo -e "${color1}4${color3}.Add Active Period SSH & OpenVPN Account (${color2}user-aktif${color3})"
	echo -e "${color1}5${color3}.Change User Account Password (${color2}user-password${color3})"
	echo -e "${color1}6${color3}.Banned Multi Login User (${color2}user-ban${color3})"
	echo -e "${color1}7${color3}.Unbanned User Account (${color2}user-unban${color3})"
	echo -e "${color1}8${color3}.Lock User Account (${color2}user-lock${color3})"
	echo -e "${color1}9${color3}.Unlock User Account (${color2}user-unlock${color3})"
	echo -e "${color1}10${color3}.Delete User Account (${color2}user-delete${color3})"
	echo -e "${color1}11${color3}.User Account Details (${color2}user-detail${color3})"
	echo -e "${color1}12${color3}.Display User Lists (${color2}user-list${color3})"
	echo -e "${color1}13${color3}.Check Account Login (${color2}user-login${color3})"
	echo -e "${color1}14${color3}.Check Login Log Dropbear & OpenSSH (${color2}user-log${color3})"
	echo -e "${color1}15${color3}.Kill Multi Login (${color2}user-limit${color3})"
	echo -e "${color1}16${color3}.Set Multi Login Limit (${color2}autokill${color3})"
	echo -e "${color1}17${color3}.Display User Account Nearly Expired (${color2}infouser${color3})"
	echo -e "${color1}18${color3}.Check Expired User Account (${color2}expireduser${color3})"
	echo -e "${color1}19${color3}.Remove Expired User Account (${color2}user-delete-expired${color3})"
	echo -e "${color1}20${color3}.Lock Expired User Account(${color2}user-expire${color3})"
	echo -e "${color1}21${color3}.Display Locked User Account  (${color2}log-limit${color3})"
	echo -e "${color1}22${color3}.Check Banned User Account(${color2}log-ban${color3})"
	echo -e " "
	echo -e "-----=[ PPTP VPN Section ]=-----"
	echo -e "${color1}23${color3}.Create PPTP Account (${color2}user-add-pptp${color3})"
	echo -e "${color1}24${color3}.Remove PPTP Account (${color2}user-delete-pptp${color3})"
	echo -e "${color1}25${color3}.View PPTP Account Details (${color2}user-detail-pptp${color3})"
	echo -e "${color1}26${color3}.Check Login PPTP Account (${color2}user-login-pptp${color3})"
	echo -e "${color1}27${color3}.View PPTP Account Lists (${color2}alluser-pptp${color3})"
	echo -e " "
	echo -e "-----=[ VPS Section ]=-----"
	echo -e "${color1}28${color3}.Speedtest Server (${color2}speedtest --share${color3})"
	echo -e "${color1}29${color3}.Benchmark Server (${color2}bench-network${color3})"
	echo -e "${color1}30${color3}.Check Server RAM Usage (${color2}ram${color3})"
	echo -e "${color1}31${color3}.Restart Stunnel (${color2}service stunnel restart${color3})"
	if [[ "$OS" = 'debian' ]]; then 
	echo -e "${color1}32${color3}.Restart OpenSSH (${color2}service ssh restart${color3})"
	echo -e "${color1}33${color3}.Restart Dropbear (${color2}service dropbear restart${color3})"
	echo -e "${color1}34${color3}.Restart OpenVPN (${color2}service openvpn restart${color3})"
	echo -e "${color1}35${color3}.Restart PPTP VPN (${color2}service pptpd restart${color3})"
	echo -e "${color1}36${color3}.Restart Webmin (${color2}service webmin restart${color3})"
	echo -e "${color1}37${color3}.Restart Squid Proxy (${color2}service squid3 restart${color3})"
else
	echo -e "${color1}32${color3}.Restart OpenSSH (${color2}service sshd restart${color3})"
	echo -e "${color1}33${color3}.Restart Dropbear (${color2}service dropbear restart${color3})"
	echo -e "${color1}34${color3}.Restart OpenVPN (${color2}service openvpn restart${color3})"
	echo -e "${color1}35${color3}.Restart PPTP VPN (${color2}service pptpd restart${color3})"
	echo -e "${color1}36${color3}.Restart Webmin (${color2}service webmin restart${color3})"
	echo -e "${color1}37${color3}.Restart Squid Proxy (${color2}service squid restart${color3})"
fi
echo -e "${color1}38${color3}.Edit Server Port (${color2}edit-port${color3})"
echo -e "${color1}39${color3}.Set Auto Reboot (${color2}auto-reboot${color3})"
echo -e "${color1}40${color3}.Reboot VPS(${color2}reboot${color3})"
echo -e "${color1}41${color3}.Change Server Password (${color2}passwd${color3})"
echo -e " "
echo -e "-----=[ Others ]=-----"
echo -e "${color1}42${color3}.View Installation Log (${color2}log-install${color3})"
echo -e "${color1}43${color3}.VPS Diagnostics (${color2}diagnosa${color3})"
echo -e "${color1}44${color3}.Exit Menu (${color2}exit${color3})"
echo -e "${color1}45${color3}.Update Premium Script"
echo "-------------------------------------------"
read -p "Choose an option from (1-45): " x
if test $x -eq 1; then
user-add
elif test $x -eq 2; then
user-generate
elif test $x -eq 3; then
trial
elif test $x -eq 4; then
user-aktif
elif test $x -eq 5; then
user-password
elif test $x -eq 6; then
read -p "Select Maximum Login (1-2): " MULTILOGIN
user-ban $MULTILOGIN
elif test $x -eq 7; then
user-unban
elif test $x -eq 8; then
user-lock
elif test $x -eq 9; then
user-unlock
elif test $x -eq 10; then
user-delete
elif test $x -eq 11; then
user-detail
elif test $x -eq 12; then
user-list
elif test $x -eq 13; then
user-login
elif test $x -eq 14; then
user-log
elif test $x -eq 15; then
read -p "Select Maximum Login (1-2): " MULTILOGIN
user-limit $MULTILOGIN
elif test $x -eq 16; then
autokill
elif test $x -eq 17; then
infouser
elif test $x -eq 18; then
expireduser
elif test $x -eq 19; then
user-delete-expired
elif test $x -eq 20; then
clear
echo "This script runs automatically every 12 hours"
echo "You don't need to run it manually"
echo "If you still want to run this script, type user-expire"
elif test $x -eq 21; then
log-limit
elif test $x -eq 22; then
log-ban
elif test $x -eq 23; then
user-add-pptp
elif test $x -eq 24; then
user-delete-pptp
elif test $x -eq 25; then
user-detail-pptp
elif test $x -eq 26; then
user-login-pptp
elif test $x -eq 27; then
alluser-pptp
elif test $x -eq 28; then
speedtest --share
elif test $x -eq 29; then
bench-network
elif test $x -eq 30; then
ram
elif test $x -eq 31; then
service stunnel4 restart
elif test $x -eq 32; then
	if [[ "$OS" = 'debian' ]]; then 
		service ssh restart 
	else 
		service sshd restart 
	fi
elif test $x -eq 33; then
service dropbear restart
elif test $x -eq 34; then
service openvpn restart
elif test $x -eq 35; then
	if [[ "$OS" = 'debian' ]]; then 
		service pptpd restart 
	else 
		service pptpd restart 
	fi
elif test $x -eq 36; then
service webmin restart
elif test $x -eq 37; then
	if [[ "$OS" = 'debian' ]]; then 
		service squid3 restart 
	else 
		service squid restart 
	fi
elif test $x -eq 38; then
edit-port
elif test $x -eq 39; then
auto-reboot
elif test $x -eq 40; then
reboot
elif test $x -eq 41; then
passwd
elif test $x -eq 42; then
log-install
elif test $x -eq 43; then
diagnosa
elif test $x -eq 44; then
echo " "
echo "Goodbye Menu!"
echo "Modified by PR Aiman"
echo " "
exit
elif test $x -eq 45; then
wget https://raw.githubusercontent.com/daybreakersx/premscript/master/updates/install-premiumscript.sh -O - -o /dev/null|sh
else
echo "Options Not Available In Menu."
echo " "
exit
fi