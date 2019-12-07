#!/bin/bash
#Licensed to https://www.hostingtermurah.net/
#Script by PR Aiman

cyan='\e[0;36m'
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
clear
echo " "
echo " "
echo " "
read -p "Input USERNAME to unban: " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
# proses mengganti passwordnya
passwd -u $username
clear
  echo " "
  echo " "
  echo " "
  echo "-------------------------------------------"
  echo -e "Username ${cyan}$username${NC} successfully ${green}UNBANNED${NC}."
  echo -e "Password for Username ${cyan}$username${NC} has been restored"
  echo "-------------------------------------------"
  echo " "
  echo " "
else
echo " "
echo -e "Username ${red}$username${NC} not found in your VPS."
echo " "
	exit 1
fi