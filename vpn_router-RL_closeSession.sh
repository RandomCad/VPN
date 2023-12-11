#!/bin/bash

#Strukturiertes Beenden einer OpenVPN Layer 2 Site-to-Site Verbindung
#Dieses Skript muss sowohl auf dem Client als auch dem Server und jeweils mit Root-Berechtigung ausgeführt werden

# Hilfe
# shellcheck disable=SC2034
helpStr="Skript zum strukturierten Beenden einer OpenVPN Layer 2 Site-to-Site Verbindung\n
Dieses Skript muss sowohl auf dem Client als auch dem Server ausgeführt werden\n
Aufruf: $0 \n"

# allgemeine Funktionen und Konstanten hinzufügen
. "$( dirname "${BASH_SOURCE[0]}" )/src/common.sh"

startScript

# Beenden des geforkten OpenVPN Prozesses
info "attempting to kill the child process"
if kill "$(pidof openvpn)"; then
    info "killed the child"
else    
    err "couldn't kill the child"
fi

# Beenden OpenVPN daemon Prozess
info "Verbannen des OpenVPN Daemonen"
systemctl stop openvpn

# Tear Down Ethernet bridge on Linux
info "Einreißen der Netzwerkbrücke"
ifconfig br0 down
brctl delbr br0

# Löschen des virtuellen tap0 Interfaces
info "Schließen der virtuellen Interface-Tür tap0"
if openvpn --rmtun --dev tap0; then
    info "Schotten dicht"
else
    err "Es ziehieht"
fi

endScript
