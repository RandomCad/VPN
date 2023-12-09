#!/bin/bash

# Zweck: Installation und Konfiguration OpenVPN Server:
# Vorraussetzungen: linuxbasiertes, ubuntuähnliches BS mit Internetverbindung
# diese Datei muss mit Superuser-Rechten ausgeführt werden

# Hilfe
# shellcheck disable=SC2034
helpStr="Installations- und Konfigurationsskript für eine Layer 2 Site-to-Site OpenVPN Verbindung\n
Dies ist die Serverkonfiguration und muss auf dem rechten Router ausgeführt werden \n
Aufruf: $0 \n"

# allgemeine Funktionen und Konstanten hinzufügen
. "$( dirname "${BASH_SOURCE[0]}" )/src/common.sh"

startScript

# Überprüfen, ob alle benötigten Skripte und Konfigurationsdateien kopiert wurden
if [[ ! -f "./src/common.sh" ]]; then
    echo "./src/common.sh ist nicht vorhanden! Diese ist für das Skript essentiell!"
    exit 1
fi 
if [[ ! -f "./src/vpn_r-R_bridging.sh" ]]; then
    err "./src/vpn_r-R_bridging.sh ist nicht vorhanden! Diese ist für das Skript essentiell!"
fi 
if [[ ! -f "./src/r-R.conf" ]]; then
    if [[ ! -f "/etc/openvpn/r-R.conf" ]]; then
        err "./src/r-R.conf ist nicht vorhanden! Diese ist für das Skript essentiell!"
    else 
        warn "./src/r-R.conf ist nicht vorhanden! Jedoch existiert bereits eine OpenVPN Konfiguration /etc/openvpn/r-R.conf"
    fi 
fi 

# Sicherstellen, dass mit sudo ausgeführt wird
ensureRoot

# Installation OpenVPN
installPkg openvpn 

# # Beenden aller potentiell bestehenden VPN Verbindungen und schließen derer Netzwerkadapter und Brücken
# ./vpn_r-RL_closeSession.sh
# Definieren der benötigten virtuellen Netzwerkschnittstelle und Bridgen dieser mit dem physischen Netzwerkadapter
./src/vpn_r-R_bridging.sh --unfunny

# Prüfen, ob Konfigurationsdatei bereits vorhanden, wenn nicht dann Kopieren dieser
if [[ ! -f "/etc/openvpn/r-R.conf" ]]; then
    cp ./src/r-R.conf /etc/openvpn/
fi 

# Prüfen, ob Schlüssel und Zertifikate bereits vorhanden. Ansonsten generieren dieser
if [[ ! -f "/etc/openvpn/keys/ca.crt" ]] || [[ ! -f "/etc/openvpn/keys/server.crt" ]] || [[ ! -f "/etc/openvpn/keys/server.key" ]] || [[ ! -f "/etc/openvpn/keys/dh2048.pem" ]] || [[ ! -f "/etc/openvpn/keys/ta.key" ]]; then
    # Erstellen und Betreten der Key Verzeichnisse und kopieren benötigter Ressourcen
    header "Keyfiles und Zertifikate werden erstellt" -t 1 -f blue -c blue
    mkdir -p /etc/openvpn/keys
    cp /usr/share/doc/openvpn/examples/sample-keys/openssl.cnf /etc/openvpn/keys/
    cp /usr/share/doc/openvpn/examples/sample-keys/gen-sample-keys.sh /etc/openvpn/keys/
    cd /etc/openvpn/keys || exit 1

    # Anpassen und ausführen des Beispielscriptes um verschiedene Keys und Zertifikate zu erstellen
    sed -i 's/$(dirname ${0})\/..\/..\/src\/openvpn\/openvpn/openvpn/' gen-sample-keys.sh
    ./gen-sample-keys.sh
fi

endScript

# Starten der OpenVPN Sitzung:
header "Starten der OpenVPN Sitzung" -t 1 -f green -c green
cd /etc/openvpn || exit 1
openvpn r-R.conf &