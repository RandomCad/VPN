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
      addresses: [192.168.2.2/24]
      routes:
      - to: default
        via: 192.168.2.1' >> $FILE

sudo chmod 600 $FILE

sudo netplan apply
  
#add nameserver
if grep -q 'nameserver 8.8.8.8' /etc/resolv.conf || grep -q 'nameserver 8.8.4.4' /etc/resolv.conf ; then
  #nameserver already set
  echo 'nameserver is set corectly'
else
  sed -i -e '$anameserver 8.8.8.8' /etc/resolv.conf
fi     

sudo systemctl restart systemd-resolved.service

#cleanup
rm zwi -f



