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

totalaccounts=`cat /var/lib/premium-script/data-user-pptp | wc -l`
echo " " > /tmp/alluser-pptp-data
for((i=1; i<=$totalaccounts; i++ ))
       do  
username=`cat /var/lib/premium-script/data-user-pptp | awk '{print $1}' | head -n $i | tail -n 1`
userpass=`cat /var/lib/premium-script/data-user-pptp | awk '{print $3}' | head -n $i | tail -n 1`
saat_expired=`cat /var/lib/premium-script/data-user-pptp | awk '{print $5}' | head -n $i | tail -n 1`
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')
echo "PPTP VPN User: $username [$userpass] Expired On: $tanggal_expired_display" >> /tmp/alluser-pptp-data
done
clear
  echo " "
  echo " "
  echo " "
  echo "-----------------------------------------------"
  echo "             VPN PPTP Accounts                 "
  echo "-----------------------------------------------"
cat /tmp/alluser-pptp-data
  echo "-----------------------------------------------"
  echo " "
  echo " "