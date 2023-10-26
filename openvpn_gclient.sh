#! /usr/bin/bash

#Installation und Konfiguration OpenVPNclient:
#Vorraussetzungen: linuxbasiertes BS mit Internetverbindung
#diese Datei muss mit Superuser-Rechten ausgeführt werden

#Installation OpenVPN
echo "OpenVPN wird heruntergeladen ..."
apt install openvpn -y


#Erstellen der Key Verzeichnisse
mkdir -p /etc/openvpn/keys

#Erstellen der Konfigurationsdatei
echo "Konfigurationen werden festgelegt ..."
mkdir -p /etc/openvpn/client
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/client/
cd /etc/openvpn/client || exit

#Anpassen der Positionen der Zertififkate und Schlüssel
sed -i 's/ca.crt/..\/keys\/ca.crt/' client.conf
sed -i 's/client.crt/..\/keys\/client.crt/' client.conf
sed -i 's/client.key/..\/keys\/client.key/' client.conf
sed -i 's/ta.key/..\/keys\/ta.key/' client.conf
#Anpassen der "öffentlichen" VPN-Serveradresse
sed -i 's/my-server-1/192.168.2.2/g' client.conf

echo "Alles einsatzbereit"
