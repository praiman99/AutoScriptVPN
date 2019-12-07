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
if [ ! -f /usr/local/bin/deleteduser ]; then
    echo "echo "Script Created By VPS-Murah.net"" > /usr/local/bin/deleteduser
	chmod +x /usr/local/bin/deleteduser
fi
hariini=`date +%d-%m-%Y`
echo " "
echo " "
echo "-------------------------------------------"
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
       do
       tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
       username=`echo $tuserval | cut -f1 -d:`
       userexp=`echo $tuserval | cut -f2 -d:`
       userexpireinseconds=$(( $userexp * 86400 ))
       tglexp=`date -d @$userexpireinseconds`             
       tgl=`echo $tglexp |awk -F" " '{print $3}'`
       while [ ${#tgl} -lt 2 ]
       do
           tgl="0"$tgl
       done
       while [ ${#username} -lt 15 ]
       do
           username=$username" " 
       done
       bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
       echo "echo "VPS-Murah.net- User : $username Date Expired On : $tgl $bulantahun"" >> /usr/local/bin/alluser
       todaystime=`date +%s`
       if [ $userexpireinseconds -ge $todaystime ] ;
           then
			:
       else
       echo "echo "Username : $username already expired On Date: $tgl $bulantahun has been deleted on:: $hariini "" >> /usr/local/bin/deleteduser
	   echo "Username $username expired on $tgl $bulantahun successfully removed from the system on $hariini"
       userdel $username
       fi
done
echo "==============================================="
echo " SCRIPT INI TLEAH SELESAI MEMADAM USER EXPIRED "
echo "==============================================="
echo " "