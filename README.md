![Winrep](https://github.com/user-attachments/assets/98ef822e-b4ae-4c2e-961b-aa4732a108ba)


[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://badgen.net/github/license/SD-ITLab/WinRep)

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

---
# ENGLISH

# WinRep | Windows Repair & Optimization

**Version: 3.6.1**

## 📌 Description
The PowerShell script "WinRep.ps1" is a comprehensive script that includes various Windows diagnostic and recovery functions. 
It provides a collection of useful tools and commands to identify and resolve issues with the Windows operating system.

## 🚀 Usage
1. Run the script "WinRep.ps1" or the compiled EXE.  
2. The script displays a menu with options for different diagnostic and repair tasks.  
3. Select the desired option by entering the corresponding number.  
4. The script executes the appropriate commands based on the selected option.  
5. Once completed, a confirmation message will be displayed.

## 🛠️ Menu Options  
1️⃣ **Check Windows Component Store for Errors** *(DISM ScanHealth)*  
2️⃣ **Check if Windows is Marked as Corrupted** *(DISM CheckHealth)*  
3️⃣ **Perform Automatic Repair Operations** *(DISM RestoreHealth)*  
4️⃣ **Cleanup Deprecated Startup Components** *(ComponentCleanup)*  
5️⃣ **Scan and Repair System Files** *(sfc /scannow)*  
6️⃣ **Reset Network Settings** *(FlushDNS, WinSock reset, and more)*  
7️⃣ **Reset Windows Store / Clear Cache**  
8️⃣ **Reliability Monitor**  
9️⃣ **Upgrade Windows Home to Windows Pro**  
🔠 **Enable Windows Maximum Performance Mode** *(Set Power Plan to High Performance & additional optimizations)*  
1️⃣1️⃣ **Create a System Restore Point**  

## ℹ️ Notes
✔ The script helps detect and, if necessary, fix Windows issues.  
✔ All command-line operations are integrated into Windows; this script simply provides an easier interface.  
✔ Additionally, system information such as computer name, local IP address, Windows version, and installed CPU will be displayed.  
   - Computername  
   - Lokale IP-Adresse  
   - Windows-Version  
   - CPU-Modell

## 📝 Version History  
🔹 **Version 3.6.1:** Minor bug fixes and code cleanup.  
🔹 **Version 3.6.0:** Revised network reset and performance optimization.  
🔹 **Version 3.5.0:** Fixes and improvements to network reset and performance optimization.  
🔹 **Version 3.0.0:** Added minor features and integrated system information.  
🔹 **Version 2.5.0:** Small revisions and added recovery options.


