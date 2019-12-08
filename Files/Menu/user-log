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

if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi

case $1 in
dropbear)
ps ax|grep dropbear > /tmp/pid.txt
cat $LOG |  grep -i "Password auth succeeded" > /tmp/sukses.txt
perl -pi -e 's/Password auth succeeded for//g' /tmp/sukses.txt
perl -pi -e 's/dropbear/PID/g' /tmp/sukses.txt
;;
openssh)
clear
ps ax|grep sshd > /tmp/pid.txt
cat /var/log/auth.log | grep -i ssh | grep -i "Accepted password for" > /tmp/sukses.txt
perl -pi -e 's/Accepted password for//g' /tmp/sukses.txt
perl -pi -e 's/sshd/PID/g' /tmp/sukses.txt
;;
*)
echo -e "Use the ${red}user-log dropbear${NC} to check Dropbear log"
echo -e "Use the ${red}user-log openssh${NC} to check Openssh log"
echo " "
echo "==========================================="
echo " "
echo " "
exit 1
;;
esac
echo "            User Log Details" > /tmp/hasil.txt
echo "Date - Hour - Hostname - Process ID - Username - IP address" >> /tmp/hasil.txt
echo "===========================================" >> /tmp/hasil.txt
cat /tmp/pid.txt | while read line;do
set -- $line
cat /tmp/sukses.txt | grep $1 >> /tmp/hasil.txt
done
echo "===========================================" >> /tmp/hasil.txt
echo " " >> /tmp/hasil.txt
echo " " >> /tmp/hasil.txt
cat /tmp/hasil.txt
