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

if [ "$1" = "" ]
then
        echo
        echo "How to use: $0 Username"
        echo "Example:  $0 0123456"
        echo
        exit 1
fi

Username=`cat /etc/passwd | grep -Ew ^$1 | cut -d":" -f1`

if [ "$Username" = "" ]
then
        echo "Username $1 not found"
        exit 2
fi

Userid=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f3`
UserPrimaryGroupId=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f4`
UserPrimaryGroup=`cat /etc/group | grep :"$UserPrimaryGroupId": | cut -d":" -f1`
UserInfo=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f5`
UserHomeDir=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f6`
UserShell=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f7`
UserGroups=`groups $Username | awk -F": " '{print $2}'`
PasswordExpiryDate=`chage -l $Username | grep "Password expires" | awk -F": " '{print $2}'`
LastPasswordChangeDate=`chage -l $Username | grep "Last password change" | awk -F": " '{print $2}'`
AccountExpiryDate=`chage -l $Username | grep "Account expires" | awk -F": " '{print $2}'`
HomeDirSize=`du -hs $UserHomeDir | awk '{print $1}'`
clear
echo
  echo " "
  echo " "
  echo " "
  echo "User $Username Account Information:"
  echo "======================================"
printf "%-25s : %5s [User Id - %s]\n" "Username                 " "$Username" "$Userid"
printf "%-25s : %5s\n"                "Password previous change " "$LastPasswordChangeDate"
printf "%-25s : %5s\n"                "Account Date Expired     " "$AccountExpiryDate"
  echo "======================================"
  echo " "

echo