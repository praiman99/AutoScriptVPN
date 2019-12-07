#!/bin/bash
#Licensed to https://www.hostingtermurah.net/
#Script by PR Aiman

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
echo "Connecting to Server..."
sleep 0.5
echo "Checking Permision..."
sleep 0.4
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
last | grep ppp | grep still | awk '{print " ",$1," - " $3 }' > /tmp/login-db-pptp.txt;
echo " "
echo " "
echo "===========================================";
echo " "
echo " "
echo "-------------------------------------";
echo "    PPTP VPN User Login";
echo "-------------------------------------";
echo "Username   ---   IP";
echo "-------------------------------------";
cat /tmp/login-db-pptp.txt
echo " "
echo " "
echo " "
echo "===========================================";
echo " ";
echo " ";