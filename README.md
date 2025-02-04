![WinRep](https://github.com/user-attachments/assets/0ae514c2-5f21-4724-ad9c-f58bf5b4fe24)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://badgen.net/github/license/SD-ITLab/OptimizeWindows)

# WinRep | Windows Diagnose- & Reparatur-Skript  
**Version: 3.6.1**  

## 📌 Beschreibung  
**WinRep.ps1** ist ein leistungsstarkes **PowerShell-Skript**, das verschiedene Windows-Diagnose- und Wiederherstellungsfunktionen vereint.  
Es hilft dabei, Probleme im Windows-Betriebssystem zu erkennen und zu beheben, indem es eine Vielzahl nützlicher Tools und Befehle in einer **einfachen Menüoberfläche** bereitstellt.  

## 🚀 Verwendung  
1. Führen Sie das Skript **WinRep.ps1** oder die **kompilierte EXE** als Administrator aus.  
2. Wählen Sie eine Option aus dem **Menü**, indem Sie die entsprechende Nummer eingeben.  
3. Das Skript führt die gewählte Aktion automatisch aus.  
4. Nach Abschluss erhalten Sie eine **Bestätigungsmeldung**.  

## 🛠️ Menüoptionen  
1️⃣ **Windows-Komponentenspeicher auf Fehler prüfen** *(DISM ScanHealth)*  
2️⃣ **Überprüfen, ob Windows als beschädigt markiert wurde** *(DISM CheckHealth)*  
3️⃣ **Automatische Reparaturvorgänge durchführen** *(DISM RestoreHealth)*  
4️⃣ **Abgelöste Startkomponenten bereinigen** *(ComponentCleanup)*  
5️⃣ **Systemdateien prüfen und reparieren** *(sfc /scannow)*  
6️⃣ **Netzwerkeinstellungen zurücksetzen** *(FlushDNS, WinSock-Reset & mehr)*  
7️⃣ **Windows Store zurücksetzen / Cache bereinigen**  
8️⃣ **Zuverlässigkeitsverlauf anzeigen**  
9️⃣ **Upgrade von Windows Home auf Windows Pro durchführen**  
🔠 **Windows-Höchstleistungsmodus aktivieren** *(Energiesparplan inkl. weiterer Optimierungen)*  
1️⃣1️⃣ **Wiederherstellungspunkt erstellen**  

## ℹ️ Hinweise  
✔ **WinRep** erleichtert die Fehlerdiagnose und -behebung durch eine intuitive Oberfläche.  
✔ Alle Befehle sind bereits in Windows integriert – das Skript stellt sie lediglich **übersichtlicher und automatisiert** bereit.  
✔ Das Skript zeigt zusätzlich **Systeminformationen** an, darunter:  
   - Computername  
   - Lokale IP-Adresse  
   - Windows-Version  
   - CPU-Modell  

## 📝 Versionshistorie  
🔹 **Version 3.6.1** – Kleinere Fehlerbehebungen und Code-Bereinigung  
🔹 **Version 3.6.0** – Überarbeitung des Netzwerk-Resets und Performance-Optimierung  
🔹 **Version 3.5.0** – Fixes und Erweiterung der Netzwerk-Reset-Option  
🔹 **Version 3.0.0** – Integration neuer Funktionen & Anzeige von Systeminformationen  
🔹 **Version 2.5.0** – Erweiterung der Wiederherstellungsoptionen und kleinere Überarbeitungen

