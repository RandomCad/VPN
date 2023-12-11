#!/bin/bash
# Dieses Skript dient dem erstellen eines virtuellen Netzwerkadapters tap0 
# und dem anschließenden bridgen dieses mit dem physischen Adapters des interfaceernen Netzes

# allgemeine Funktionen und Konstanten hinzufügen
. "$( dirname "${BASH_SOURCE[0]}" )/common.sh"

# Installation der bridging und networking Werkzeuge
header "Konfigurieren der Netzwerkbrücke" -t 1 -f blue -c blue
installPkg bridge-utils
installPkg net-tools

#Deklaration von Umgebungsvariablen,
#um das zu bridgende Interface sowie die IP Adresse der Netzwerkbrücke einfach austauschbar zu machen
intern_interface="enp0s8"
bridge_ip="192.168.1.254"
bridge_netmask="255.255.255.0"
bridge_broadcast="192.168.1.255"

# Erstellen einer virtuellen Netzwerkschnittstelle tap0
openvpn --mktun --dev tap0
# Erstellen der bridge Netzwerkschnittstelle br0
brctl addbr br0
# Bridgen der Netzwerkschnittstellen tap0 und dem LAN Netzwerkadapter enp0s8
brctl addif br0 $intern_interface
brctl addif br0 tap0
# Konfigurieren der Netzwerkadapter mit entsprechenden IP Adressen und Modi
# promisc - promiscuous mode: schmeißt Pakete die nicht an ihn gerichtet sind nicht weg
# die IPs der beiden gebridgden Netzwerkadapter werden gelöscht, 
# da innerhalb der Netzwerkbrücke Inkonsistenzen zu vermeiden sind 
# und deshalb die IP Konfiguration nur einmal, zentral auf dem Bridge Interface gemacht wird
ifconfig tap0 0.0.0.0 promisc up
ifconfig $intern_interface 0.0.0.0 promisc up
ifconfig br0 $bridge_ip netmask $bridge_netmask broadcast $bridge_broadcast

# Firewallanpassungen der Netzwerkschnittstellen
iptables -A INPUT -i tap0 -j ACCEPT
iptables -A INPUT -i br0 -j ACCEPT
iptables -A FORWARD -i br0 -j ACCEPT
