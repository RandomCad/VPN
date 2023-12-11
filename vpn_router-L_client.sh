#! /usr/bin/bash
# Zweck: Installation und Konfiguration OpenVPN Client:
# Vorraussetzungen: linuxbasiertes, ubuntuähnliches BS mit Internetverbindung
#                   sowie das die Zertifikate ca.crt, client.crt und die Schlüssel client.key, ta.key 
#                   in das Verzeichnis /etc/openvpn/keys kopiert wurden!
# diese Datei muss mit Superuserouter-Lechten ausgeführt werden

# Hilfe
# shellcheck disable=SC2034
helpStr="Installations- und Konfigurationsskript für eine Layer 2 Site-to-Site OpenVPN Verbindung\n
Dies ist die Clientkonfiguration und muss auf dem linken Router ausgeführt werden\n
Das Skript kann erst erfolgreich durchlaufen werden, wenn die Zertifikate ca.crt, client.crt und die Schlüssel client.key, ta.key in das Verzeichnis /etc/openvpn/keys kopiert wurden!\n
Aufruf: $0 \n
Optionen:\n
    --no-bridge    erstellt keine Netzwerkbrücke, sondern nur den Netzwerkadapter tap0; nur für Testzwecke"

# allgemeine Funktionen und Konstanten hinzufügen
. "$( dirname "${BASH_SOURCE[0]}" )/src/common.sh"

startScript

# Überprüfen, ob alle benötigten Skripte und Konfigurationsdateien kopiert wurden
if [[ ! -f "./src/common.sh" ]]; then
    echo "FEHLER! ./src/common.sh ist nicht vorhanden! Diese ist für das Skript essentiell!"
    exit 1
fi 
if [[ ! -f "./src/vpn_router-L_bridging.sh" ]]; then
    err "./src/vpn_router-L_bridging.sh ist nicht vorhanden! Diese ist für das Skript essentiell!"
fi 
if [[ ! -f "./src/router-L.conf" ]]; then
    if [[ ! -f "/etc/openvpn/router-L.conf" ]]; then
        err "./src/router-L.conf ist nicht vorhanden! Diese ist für das Skript essentiell!"
    else 
        warn "./src/router-L.conf ist nicht vorhanden! Jedoch existiert bereits eine OpenVPN Konfiguration /etc/openvpn/router-L.conf"
    fi 
fi 

# Sicherstellen, dass mit sudo ausgeführt wird
ensureRoot

# Installation OpenVPN
installPkg openvpn

#Prüfen, ob Schlüsselverzeichnis vorhanden, ansonsten Erstellen und Abbruch
if [[ ! -f "/etc/openvpn/keys" ]]; then
    mkdir "/etc/openvpn/keys"
    err "Das Skript kann erst erfolgreich durchlaufen werden, wenn die Zertifikate ca.crt, client.crt und die Schlüssel client.key, ta.key in das Verzeichnis /etc/openvpn/keys kopiert wurden!"
fi
# Prüfen, ob Schlüssel und Zertifikate vorhanden und korrekt eingebunden sind
if [[ ! -f "/etc/openvpn/keys/ca.crt" ]]; then
    err "ca.crt ist nicht vorhanden! Bitte alle Zertifikate und Keys einbinden!"
fi
if [[ ! -f "/etc/openvpn/keys/client.crt" ]]; then
    err "client.crt ist nicht vorhanden! Bitte alle Zertifikate und Keys einbinden!"
fi
if [[ ! -f "/etc/openvpn/keys/client.key" ]]; then
    err "client.key ist nicht vorhanden! Bitte alle Zertifikate und Keys einbinden!"
fi
if [[ ! -f "/etc/openvpn/keys/ta.key" ]]; then
    err "ta.key ist nicht vorhanden! Bitte alle Zertifikate und Keys einbinden!"
fi

# Durchführung der Netzwerkkonfiguration abhängig vom evt gesetzen Parameter
if [[ $1 = "--no-bridge" ]]; then
    # Definieren des benötigten virtuellen tap0 Netzwerkadapters
    bash ./src/vpn_router-L_no-bridge.sh --unfunny
else
    # Definieren der benötigten virtuellen Netzwerkschnittstelle und Bridgen dieser mit dem physischen Netzwerkadapter
    ./src/vpn_router-L_bridging.sh --unfunny
fi

# Prüfen, ob Konfigurationsdatei bereits vorhanden, wenn nicht dann kopieren dieser
if [[ ! -f "/etc/openvpn/router-L.conf" ]]; then
    cp ./src/router-L.conf /etc/openvpn/
fi 

endScript

# Starten der OpenVPN Sitzung:
header "Starten der OpenVPN Sitzung" -t 1 -f green -c green
cd /etc/openvpn || exit 1
openvpn router-L.conf &
