#! /usr/bin/bash

#Installation und Konfiguration OpenVPN Server:
#Vorraussetzungen: linuxbasiertes BS mit Internetverbindung
#diese Datei muss mit Superuser-Rechten ausgeführt werden

#Installation OpenVPN
echo "OpenVPN wird heruntergeladen ..."
apt install openvpn -y
mkdir /etc/openvpn

#Erstellen der Key Verzeichnisse und kopieren benötigter Ressourcen
echo "Keyfiles werden erstellt ..."
mkdir -p /etc/openvpn/keys
cp /usr/share/doc/openvpn/examples/sample-keys/openssl.conf /etc/openvpn/keys/
cp /usr/share/doc/openvpn/examples/sample-keys/gen-sample-keys.sh /etc/openvpn/keys/
cd /etc/openvpn/keys || exit

#Anpassen und ausführen des Beispielscriptes um verschiedene Keys und Zertifikate zu erstellen
sed -i 's/$(dirname ${0})\/..\/..\/src\/openvpn\/openvpn/openvpn/' gen-sample-keys.sh
./gen-sample-keys.sh

#Erstellen der Konfigurationsdatei
echo "Konfigurationen werden festgelegt ..."
mkdir /etc/openvpn/server
cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/server/
cd /etc/openvpn/server || exit

#Anpassen der Positionen der Zertififkate und Schlüssel
sed -i 's/ca.crt/..\/keys\/ca.crt/' server.conf
sed -i 's/server.crt/..\/keys\/server.crt/' server.conf
sed -i 's/server.key/..\/keys\/server.key/' server.conf
sed -i 's/dh2048.pem/..\/keys\/dh2048.pem/' server.conf
sed -i 's/ta.key/..\/keys\/ta.key/' server.conf
