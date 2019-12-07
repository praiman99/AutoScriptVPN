#!/bin/bash
#Licensed to https://www.hostingtermurah.net/
#Script by PR Aiman

if [[ $USER != 'root' ]]; then
	echo "Oops! root privileges needed"
	exit
fi
while :
do
	clear
	echo " "
	echo " "
	echo "-----------------------------------------"
	echo "            Edit Port Options            "
	echo "-----------------------------------------"
	echo -e "\e[031;1m 1\e[0m) Edit Port OpenSSH (\e[34;1medit-port-openssh\e[0m)"
	echo -e "\e[031;1m 2\e[0m) Edit Port Dropbear (\e[34;1medit-port-dropbear\e[0m)"
	echo -e "\e[031;1m 3\e[0m) Edit Port Squid Proxy (\e[34;1medit-port-squid\e[0m)"
	echo -e "\e[031;1m 4\e[0m) Edit Port OpenVPN (\e[34;1medit-port-openvpn\e[0m)"
	echo ""
	echo -e "\e[031;1m x\e[0m) Exit"
	echo ""
	read -p "Select options from (1-4 or x): " option2
	case $option2 in
		1)
		clear
		edit-port-openssh
		exit
		;;
		2)
		clear
		edit-port-dropbear
		exit
		;;
		3)
		clear
		edit-port-squid
		exit
		;;
		4)
		clear
		edit-port-openvpn
		exit
		;;
		x)
		clear
		exit
		;;
	esac
done
cd
