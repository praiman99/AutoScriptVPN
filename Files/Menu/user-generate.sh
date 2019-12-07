#!/bin/bash
#Licensed to https://www.hostingtermurah.net/
#Script by PR Aiman
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo "Connecting to Server..."
sleep 0.4
echo "Checking Permision..."
sleep 0.3
CEK=PR Aiman
if [ "$CEK" != "PR Aiman" ]; then
		echo -e "${red}Permission Denied!${NC}";
        echo $CEK;
        exit 0;
else
echo -e "${green}Permission Accepted...${NC}"
sleep 1
clear
fi

IP=$(wget -qO- ipv4.icanhazip.com)
read -p "How many accounts will be created?: " banyakuser
read -p "How many days?                    : " aktif
today="$(date +"%Y-%m-%d")"
expire=$(date -d "$aktif days" +"%Y-%m-%d")
clear
echo " "
echo " "
echo " "
echo "==================================="
echo "   PREMIUM THE BEST IN MALAYSIA    "
echo "==================================="
echo "==================================="
echo "        Account Information        "
echo "==================================="
echo "   Host/IP        : $IP"
echo "   OpenSSH        : 22, 143"
echo "   OpenVPN        : 1194"
echo "   OpenVPN SSL    : 443"
echo "   Stunnel        : 444"
echo "   Dropbear       : 442"
echo "   Squid Proxy    : 3128, 8080"
echo "   OpenVPN Config : http://$IP/configs.zip"
echo "   Until On       : $(date -d "$aktif days" +"%d-%m-%Y")"
echo "==================================="
echo "==================================="
echo "   PREMIUM THE BEST IN MALAYSIA    "
echo "==================================="
for (( i=1; i <= $banyakuser; i++ ))
do
	USER=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`
	useradd -M -N -s /bin/false -e $expire $USER
	PASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`;
	echo $USER:$USER | chpasswd
	echo "$i. Username/Password: $USER"
done

  echo "======================================"
  echo " "