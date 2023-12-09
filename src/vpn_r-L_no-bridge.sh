#!/bin/bash
# Dieses Skrip.t dient dem Erstellen und Konfigurieren eines virtuellen Netzwerkadapters tap0 

# allgemeine Funktionen und Konstanten hinzufügen
. "$( dirname "${BASH_SOURCE[0]}" )/common.sh"

# Installation der networking Werkzeuge
header "Konfigurieren des Netzwerkadapters tap0" -t 0 -f blue -c blue
installPkg net-tools

# Erstellen einer virtuellen Netzwerkschnittstelle tap0
openvpn --mktun --dev tap0
# Zuweisung der richtigen IP
ifconfig tap0 192.168.1.1/24