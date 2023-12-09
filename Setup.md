# Anleitung zur Instalation und nutzung von OpenVPN
## Voraussetzungen
Für die durchführung des Versuches werden min 5 unterschiedliche Linux VM's benötigt. Diese sollten ein Ubuntu oder Kubuntu OS installiert haben.  
Es wird Virtuelbox zum ausführen der VM's verwendet. Eine Internet anschluss des Ausführenden Rechners wird benötigt.
## Instalation einer VM
Je nach eigenem bedarf kann eine neu VM verwendet werden. Es ist empfholen eine VM aufzusetzen und diese im folgenden 4-mal zu klonen um alle benötigte rechner zu erhalten. Da eine vielzahl von VM's benötigt wird, ist es empfählenswert eine Minimalistesche instalation durchzuführen, sowie eine geringe festpalttengöße zu wählen. Die Installation mit 15 GB ist möglich. 
**Die sprache der zu verwendenden VM ist zwingend auf English zu stellen.**
## Ursprüngliches Setup
Nachedem die zu klonende VM ausgewhält wurde sind folgenden schritte zu beachten:
1. Proxy einstellung vornehmen
2. Maschine Updaten
3. Folgende Packete instalieren: git, tcpdump, iperf3, vim
4. Clone folgendes Direktorys: RandomCad/VPN befehl: `git clone https://github.com/RandomCad/VPN`
5. Zum umschalten in den CLI modus folgenden befehl ausführen: `sudo systemctl set-default multi-user.target`
## Kloning und VBox einstellungen
Die Ursprüngliche VM ist nun in 4 VM's zu vervielfältigen. Die folgende benenung wird von uns verwendet:
* RouterM
* RouterL
* ClientL
* RouterR
* ClientR  
#TODO einfügen Klone anleitung
### Netzwerkkonfiguration
* RouterM
    * Adapter 1: Klasisches Nat network
    * Adapter 2: Internes Netzwerk Benennung Bsp: '**intnetL**'
    * Adapter 3: Internes Netzwerk Benennung Bsp: '**intnetR**'
    * Adpater 4: Unverbunden
* RouterL
    * Adapter 1: Unverbunden
    * Adapter 2: Internes Netzwerk Benennung Bsp: **intnetLi**
    * Adapter 3: Internes Netzwerk verbunden mit '**intnetL**'
    * Adpater 4: Unverbunden
* RouterR
    * Adapter 1: Unverbunden
    * Adapter 2: Internes Netzwerk Benennung Bsp: '**intnetRi**'
    * Adapter 3: Internes Netzwerk verbunden mit **intnetR**
    * Adpater 4: Unverbunden
* ClientL
    * Adapter 1: Unverbunden
    * Adapter 2: Internes Netzwerk verbunden mit **intnetLi**
    * Adapter 3: Unverbunden
    * Adpater 4: Unverbunden
* ClientR
    * Adapter 1: Unverbunden
    * Adapter 2: Internes Netzwerk verbunden mit **intnetRi**
    * Adapter 3: Unverbunden
    * Adpater 4: Unverbunden
### System Leistungs einstellung
Wir empfählen die Leistung der VM's herunter zu setzen.  
1 Core reicht folständig aus. Das herrabsätzen der Execution kapp ist auch möglich. Wir empfehlen folgende einstellungen:
||Core Number|Execution Capp|Speicher|
|:-----:|:-----:|:------------:|:-----:|
|RouterM|1|80%|650 MB|
|RouterL|1|60%|650 MB|
|RouterR|1|60%|650 MB|
|ClientL|1|50%|650 MB|
|ClientR|1|50%|650 MB|
# Ausführung der Scripte
Die skripte sind mit oder ohne sudo auszuführen. Sie werden in jedem falle eine sudo berechtigung durchführen müssen. Es ist zu empfählen die Skripte vom M-Router aus auszuführen. Es ist zu erwarten, dass die skripte isbesondere nich beim ersten durchlauf Ohne fehlermeldung durchgeführt werden können.  


