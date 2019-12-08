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

echo " "
echo " "
echo "===========================================";
echo " ";
if [ -e "/root/log-ban.txt" ]; then
echo "         BANNED USER ACCOUNTS        ";
echo "Time - Username - Number of Multilogin"
echo "-------------------------------------";
cat /root/log-ban.txt
else
echo " No user has committed a violation"
echo " "
echo " or"
echo " "
echo " The user-ban script has not yet started"
fi
echo " ";
echo "===========================================";
echo " ";
echo " ";
