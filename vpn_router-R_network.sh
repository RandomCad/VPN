#!/bin/bash
Red="\033[1;31m"
Green="\033[1;32m"
Yellow="\033[1;33m"
Blue="\033[1;34m"
White="\033[0m"

Total=5
Work=1

echo "$Green Running the central setup script for the net too router.$White"

#Testing the existenc of the network adapters and what ty can reach 
echo "$Blue Checking network setup. Start $Work of $Total  $White"
#TEsting enp0s3
if $(ip a | grep -q "enp0s3"); then
	echo "$Yellow enp0s3 network interface detected. This interface should not be used. It cann be deconected. $White"

  #testing of google is reachabel
  ping -I enp0s3 -c 100 -i 0.002 8.8.8.8 | tee zwi
  if cat zwi | grep -q "received, .% packet" ; then
    echo "$Red Connecting to google throw enp0s3 was posibel. Pleas remove the interface or deconect it from the internet. All conections of this computer shud run throw enp0s8.$White"
    #google is reachebal this isn't ok
    exit 1
  fi

fi

#testing enp0s8 thsi wone is needed!
if ! $(ip a | grep -q "enp0s8"); then
	echo "$Red No enp0s8 network interface detected. This interface is used to communicat with the internal network. Pleas set it up. $White"
  exit 1
fi

#testing enp0s9 it shouldn't exist
if ! $(ip a | grep -q "enp0s9"); then
	echo "$Red No enp0s9 network interface detected. This interface while be used to conect to the rest of the world. Pleas set it up. $White"
  exit 1
fi
echo "$Blue Checking network setup. Done $Work of $Total  $White"
Work=$(($Work + 1))
 
#chek the instalation of netplan
echo "$Blue Checking the instalation of Netplan. Start $Work of $Total $White"
if ! $(apt-cache policy netplan.io | grep -qe "Installed: .*ubuntu.*$") ; then
  echo "$Red Netplan is not instaled. Pleas install and use netplan as standart Networkmaneger $White"
  exit 1
fi
echo "$Blue Checking the instalation of Netplan. Done $Work of $Total $White"
Work=$(($Work + 1))

#run the static Ip setup
echo "$Blue Setting up static ip addresses and ip forwarding. Start $Work of $Total $White"
sudo bash ./src/vpn_router-R_netplanConf.sh
sudo sysctl -p
echo "$Blue Static ip address setup. Done $Work of $Total $White"
Work=$(($Work + 1))


echo "$Blue Setting up NAT-networking. Start $Work of $Total $White"
echo "$Blue Running corntab setting. Start $Work.1 of $Total $White"
#making shure the nat networking is run on reboot
if ! sudo crontab -l -u root | grep -q '@reboot sudo iptables -t nat -A POSTROUTING -o enp0s9 -j MASQUERADE' ; then
  { sudo crontab -l -u root ; echo '@reboot sudo iptables -t nat -A POSTROUTING -o enp0s9 -j MASQUERADE' ; } | sudo crontab -u root -
fi
echo "$Blue Running corntab setting. Done $Work.1 of $Total $White"

#running nat-networking command
echo "$Blue Aktivating NAT-networking for now. Start $Work.2 of $Total $White"
sudo iptables -t nat -A POSTROUTING -o enp0s9 -j MASQUERADE
echo "$Blue Aktivating NAT-networking for now. Done $Work.2 of $Total $White"
echo "$Blue Setting up NAT-networking. Done $Work of $Total $White"
Work=$(($Work + 1))

ping -qI enp0s3 -c 1 8.8.8.8 2>&1 > /dev/null

echo "$Blue Checking network. Start $Work of $Total $White"
Error=0
echo "$Blue Checking internet conection. Start $Work.1 of $Total $White"
#testing that google is reachabel
ping -qI enp0s9 -c 100 -i 0.002 8.8.8.8 | tee zwi
if ! cat zwi | grep -q "received, .% packet" ; then
  echo "$Red Connecting to google failed. Pleas make shure, that the enp0s9 intervace is conected to the middel router.$White"
  Error=1
fi
echo "$Blue Checking internet conection. Done $Work.1 of $Total $White"

#is this needed?
#echo "$Blue Checking Client net one conection. Start $Work.2 of $Total $White"
#ping -qI enp0s8 -c 1000 -f 5.4.2.2 | tee zwi
#if ! cat zwi | grep -q "received, .% packet" ; then
#  echo "$Red Connecting to router net one failed. Pleas make shure, that the router is set up and connected.$White"
#  Error=1
#fi
#echo "$Blue Checking router net one conection. Done $Work.2 of $Total $White"

echo "$Blue Checking router net one conection. Start $Work.3 of $Total $White"
ping -qI enp0s9 -c 1000 -f 5.4.2.2 | tee zwi
if ! cat zwi | grep -q "received, .% packet" ; then
  echo "$Red Connecting to router net too failed. Pleas make shure, that the router is set up and connected.$White"
  Error=1
fi
echo "$Blue Checking router net too conection. Done $Work.3 of $Total $White"

#final checking if network is setup
if [ "$Error" -eq "1" ] ; then
  echo "$Red Network test didn't run corectly. This isn't a porbelm fore this machine but may hinder on other machines. $White"
  echo "$Yellow If the configuration fails enshurd, that netplan is the default network maneger!$White"
  exit 1
fi
echo "$Blue Checking network. Done $Work of $Total $White"
Work=$(($Work + 1))

#TODO: add VPN setup
