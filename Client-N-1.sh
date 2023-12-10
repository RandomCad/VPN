Red="\033[1;31m"
Green="\033[1;32m"
Yellow="\033[1;33m"
Blue="\033[1;34m"
White="\033[0m"

Total=4
Work=1

echo "$Green Running the central setup script for the net one client.$White"

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
    return 1
  fi

fi

#testing enp0s8 thsi wone is needed!
if ! $(ip a | grep -q "enp0s8"); then
	echo "$Red No enp0s8 network interface detected. This interface is used to communicat with the internal network. Pleas set it up. $White"
  return 1
fi

#testing enp0s9 it shouldn't exist
if $(ip a | grep -q "enp0s9"); then
	echo "$Red enp0s9 network interface detected. This interface isn't needed and moust be removed. $White"
  return 1
fi
echo "$Blue Checking network setup. Done $Work of $Total  $White"
Work=$(($Work + 1))
 
#chek the instalation of netplan
echo "$Blue Checking the instalation of Netplan. Start $Work of $Total $White"
if ! $(apt-cache policy netplan.io | grep -qe "Installed: .*ubuntu.*$") ; then
  echo "$Red Netplan is not instaled. Pleas install and use netplan as standart Networkmaneger $White"
  return 1
fi
echo "$Blue Checking the instalation of Netplan. Done $Work of $Total $White"
Work=$(($Work + 1))

#run the static Ip setup
echo "$Blue Setting up static ip addresses and ip forwarding. Start $Work of $Total $White"
sudo bash ./Client-N-1-Netplan-Conf.sh
echo "$Blue Static ip address setup. Done $Work of $Total $White"
Work=$(($Work + 1))

ping -qI enp0s8 -c 1 8.8.8.8 2>&1 > /dev/null

echo "$Blue Checking internet conection. Start $Work.1 of $Total $White"
#testing that google is reachabel
ping -qI enp0s8 -c 100 -i 0.002 8.8.8.8 | tee zwi
if ! cat zwi | grep -q "received, .% packet" ; then
  echo "$Red Connecting to google failed. Pleas make shure, that the enp0s9 intervace is conected to the middel router.$White"
  return 1
fi
echo "$Blue Checking internet conection. Done $Work of $Total $White"
Work=$(($Work + 1))

#TODO: is ther further setup needed?
