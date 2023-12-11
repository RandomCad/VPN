#!/bin/bash

# Zweck: Testen, ob der Aufbau der VPN-Verbindung funktioniert hat und eine Verbindung besteht
# Hilfe
# shellcheck disable=SC2034
helpStr="Testskript für eine Layer 2 Site-to-Site OpenVPN Verbindung\n
Dieser Test muss auf dem linken Router ausgeführt werden!\n
Aufruf: $0 \n"

# allgemeine Funktionen und Konstanten hinzufügen
. "$( dirname "${BASH_SOURCE[0]}" )/src/common.sh"

startScript

# Testen, ob über den VPN Kanal eine Verbindung zum rechten Router möglich ist
info "testen, ob VPN Kanal zum rechten Router besteht:"
ping -c 10 -i 0.002 192.168.1.254 | tee zwi
if cat zwi | grep -q "received, .% packet"; then
    info "VPN Kanal besteht"
    # Testen, ob Client erreichbar
    info "testen, ob rechter Client (hinter der Netzwerkbrücke) erreichbar ist:"
    ping -c 10 -i 0.002 192.168.1.200 | tee zwi
    if cat zwi | grep -q "received, .% packet"; then
        info "VPN funktioniert einwandfrei"
    else
        err "Netzwerkbrücke des rechten Routers funktioniert nicht ordnungsgemäß"
    fi

else
    err "VPN Kanal besteht nicht, oder bridging funktioniert nicht richtig"
fi
