# Anleitung zur Instalation und Nutzung von OpenVPN
## Voraussetzungen
Für die Durchführung des Versuches werden min. 5 unterschiedliche Linux VM's benötigt. Diese sollten ein Ubuntu oder Kubuntu OS installiert haben.  
Es wird Virtualbox zum Ausführen der VM's verwendet. Eine Internet-Anbindung des ausführenden Rechners wird benötigt.
## Installation einer VM
Je nach eigenem Bedarf kann eine neu VM verwendet werden. Es wird empfohlen eine VM aufzusetzen und diese im Folgenden 4-mal zu klonen um alle benötigten Rechner zu erhalten. Da eine Vielzahl von VM's benötigt wird, ist es empfehlenswert eine minimalistische Installation durchzuführen, sowie eine geringe Festplattengröße zu wählen. Die Installation mit 15 GB ist möglich. 
**Die Sprache der zu verwendenden VMs ist zwingend auf Englisch zu stellen.**
## Ursprüngliches Setup
Nachdem die zu klonende VM ausgewählt wurde, sind folgenden Schritte zu beachten:
1. Proxy einstellung vornehmen
2. Maschine Updaten
3. Folgende Packete instalieren: git, tcpdump, iperf3, vim
4. Clone folgendes Direktorys: RandomCad/VPN befehl: `git clone https://github.com/RandomCad/VPN`
5. Zum Umschalten in den CLI modus folgenden befehl ausführen: `sudo systemctl set-default multi-user.target`
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
       * Hierbei muss unter '**Erweitert**' der Promiscous-Mode auf '**erlauben für alle VMs**' gesetzt werden
    * Adpater 4: Unverbunden
* RouterR
    * Adapter 1: Unverbunden
    * Adapter 2: Internes Netzwerk Benennung Bsp: '**intnetRi**'
    * Adapter 3: Internes Netzwerk verbunden mit **intnetR**
       * Hierbei muss unter '**Erweitert**' der Promiscous-Mode auf '**erlauben für alle VMs**' gesetzt werden
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


