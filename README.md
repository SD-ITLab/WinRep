# Windows Reparatur Tool | WinRep

![WinRep](https://github.com/SD-ITLab/WinRep/assets/30149483/542442fc-23ce-4c58-bfbd-b4cb513e5e6e)

Version: 3.0.0

## Beschreibung

Das PowerShell-Skript "WinRep.ps1" ist ein umfangreiches Skript, das verschiedene Windows-Diagnose- und Wiederherstellungsfunktionen enthält. 
Es bietet eine Sammlung nützlicher Tools und Befehle, um Probleme mit dem Windows-Betriebssystem zu erkennen und zu beheben.

## Verwendung
1. Führen Sie das Skript "WinRep.ps1" oder als Kompilierte exe aus.
2. Das Skript zeigt ein Menü mit Optionen für verschiedene Diagnose- und Reparatur Möglichkeiten an.
3. Wählen Sie die gewünschte Option aus, indem Sie die entsprechende Nummer eingeben.
4. Das Skript führt dann, je nach ausgewählter option, die entsprechende befehle aus.
5. Sobald dies abgeschlossen ist, wird eine Bestätigungsmeldung angezeigt.

## Menü Optionen 
1. Windows Komponentenspeicher auf Fehler Prüfen       [DISM ScanHealth]
2. Überprüfen ob Windows als beschädigt makiert wurde  [DISM CheckHealth] 
3. Automatische Reparaturvogänge durchführen           [DISM RestoreHealth]
4. Abgelöste Startkomponenten bereinigen               [ComponentCleanup]
5. Systemdateien Prüfen und Reparieren                 [SFC Scannow]
6. Netzwerkeinstellungen zurücksetzen                  [FlushDNS, WinSock reset und vieles mehr]
7. Windows Store Zurücksetzen / Cache Reinigung
8. Zuverlässigkeitsverlauf
9. Upgrade von Windows Home auf Windows Pro
10. Windows Höchstleistungsmodus                        [Energiesparplan auf Höchstleistung inkl. weitere Optimierungen]
11. Wiederherstellungspunkt erstellen.


## Hinweise
- Das Script kann helfen um Windows Probleme zu finden und gegebenfalls zu beheben.
- Alle Befehlszeilen sind in Windows Integriert, mit diesem Script wird es nur vereinfachter dargestellt.
- Desweiteren werden Systeminformationen wie Computername, Lokale-IP-Addresse, Windows Version und die verbaute CPU

## Versionsgeschichte
- Version 3.0.0: Erweiterung kleiner Funktionen und einbindung von Systeminformationen
- Version 2.5.0: Kleinere Überarbeitung und Hinzufügen von Wiederherstellungsoption
- Version 2.0.0: Code vollständig überarbeitet Inkl. Optische verbesserungen und bereinigungen
- Version 1.0.0: Erste Veröffentlichung

Bei Fragen oder Support wenden Sie sich bite an den Skriptautor.
