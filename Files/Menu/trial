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


Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
hari="1"
Pass=`</dev/urandom tr -dc a-f0-9 | head -c9`

useradd -e `date -d "$hari days" +"%Y-%m-%d"` -s /bin/false -M $Login
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e""
echo -e""
echo -e""
echo -e "============================="
echo -e "   PREMIUM SERVER MALAYSIA   "
echo -e "============================="
echo -e "============================="
echo -e "    Trial Account Details    "
echo -e "============================="
echo -e "   Validity : 1 Day          " 
echo -e "   Username : $Login         "
echo -e "   Password : $Pass\n        "
echo -e "============================="
echo -e "============================="
echo -e "   PREMIUM SERVER MALAYSIA   "
echo -e "============================="
echo -e""
echo -e""
