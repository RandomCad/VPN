#! /usr/bin/bash

#netplan files are worked alpabeticaly and the settings of the latest file is taken. If therfor the settings are writen in the last file thei will take effecte
for i in $(ls /etc/netplan/ | grep '.*yaml'); do
	echo $i
done | sort > zwi

#get the numbering of the higest numberd file
files=$(tail -1 zwi)
FileNum=$(echo $files | grep -o -E '[0-9]+' )

#creat the file name of the new file
if (( $FileNum < 9 )) ; then
  FILE=/etc/netplan/0$(($FileNum+1))-Inter-VM-Comm.yaml
else
  FILE=/etc/netplan/$(($FileNum+1))-Inter-VM-Comm.yaml
fi

echo 'network:
  version: 2
  renderer: NetworkManager
  ethernets:
    enp0s8:
      dhcp4: no
      addresses: [5.4.2.1/24]
      routes:
      - to: default
        via: 5.4.2.2
      - to: 192.168.1.0/24
        via: 5.4.2.2
    enp0s9:
      dhcp4: no
      addresses: [5.4.3.1/24]
      routes:
      - to: default
        via: 5.4.3.2
      - to: 192.168.2.0/24
        via: 5.4.3.2' >> $FILE

sudo chmod 600 $FILE

if grep -q '#net.ipv4.ip_forward=.' /etc/sysctl.conf ; then
        sed -i 's/#net.ipv4.ip_forward=./net.ipv4.ip_forward=1/' /etc/sysctl.conf
elif grep -q 'net.ipv4.ip_forward=.' /etc/sysctl.conf ;then
        sed -i 's/net.ipv4.ip_forward=./net.ipv4.ip_forward=1/' /etc/sysctl.conf
else
	echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
fi

sudo netplan apply
    
#making shure the nat networking is run on reboot
if sudo crontab -l -u root | grep -q '@reboot sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE' ; then
  echo '...'
else
  { sudo crontab -l -u root ; echo '@reboot sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE' ; } | sudo crontab -u root -
fi

#running nat-networking command
sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE  

#cleanup
rm zwi -f



