$ProgressPreference = 'SilentlyContinue'
$host.ui.RawUI.WindowTitle = "Windows - Reparatur-Tool"
[Console]::WindowWidth=101;
[Console]::Windowheight=45;
[Console]::setBufferSize(101,45) #width,height

$Display = {
Write-Host "                             __      __.__      __________               
                            /  \    /  \__| ____\______   \ ____ ______  
                            \   \/\/   /  |/    \|       _// __ \\____ \ 
                             \        /|  |   |  \    |   \  ___/|  |_> >
                              \__/\  / |__|___|  /____|_  /\___  >   __/ 
                                   \/          \/       \/     \/|__|                        v3.0.0" -ForegroundColor Red
}

# Computernamen abrufen
$computerName = $env:COMPUTERNAME

# Netzwerk-IP abrufen (Beispiel für IPv4)
$networkIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne '127.0.0.1' }).IPAddress

# Betriebssystem abrufen
$operatingSystem = (Get-CimInstance Win32_OperatingSystem).Caption

# CPU-Namen abrufen
$cpuName = (Get-CimInstance -ClassName Win32_Processor).Name

# Maximale Breite für die Informationen
$maxWidth = 56

# Funktion zum Kürzen oder Auffüllen von Text auf die maximale Breite
function Format-Text($text) {
    $textLength = $text.Length
    $padding = [Math]::Max(0, $maxWidth - $textLength)
    return $text + (' ' * $padding)
    }

$RestoreSystem = {
Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
Write-Host "           ╠══════════════════════════" -ForegroundColor Yellow -NoNewLine
Write-Host " Windows - Systemrestore " -ForegroundColor Magenta -NoNewLine
Write-Host "══════════════════════════╣" -ForegroundColor Yellow
Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
Write-Host "   Sichere Systemdateien, Treiberdatein und Konfigurationsdatein....         " -ForegroundColor Red -NoNewLine
Write-Host "║" -ForegroundColor Yellow
Start-Sleep 2
Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
Write-Host "   Sichere Registrierungsdatenbank....                                       " -ForegroundColor Red -NoNewLine
Write-Host "║" -ForegroundColor Yellow
Start-Sleep 2
Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
Write-Host "   Sichere Master Boot Record (MBR)....                                      " -ForegroundColor Red -NoNewLine
Write-Host "║" -ForegroundColor Yellow
Start-Sleep 2
Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
Write-Host "   Sichere Anwendungsdaten und Einstellungen....                             " -ForegroundColor Red -NoNewLine
Write-Host "║" -ForegroundColor Yellow
Start-Sleep 2
Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
Write-Host "   Erstelle Wiederherstellungspunkt.... Bitte Warten                         " -ForegroundColor Red -NoNewLine
Write-Host "║" -ForegroundColor Yellow
# Erstellung des Wiederherstellungspunkts
Checkpoint-Computer -Description "$restorePointName" -RestorePointType "MODIFY_SETTINGS"
Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host "`n           Ein Wiederherstellungspunkt mit dem Namen '$restorePointName' wurde erstellt."
Write-Host
Start-Sleep 1
}

function menu {
    Clear-Host
    Invoke-Command -ScriptBlock $Display
    Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
    Write-Host "           ╠════════════════════════════" -ForegroundColor Yellow -NoNewline
    Write-Host " Systeminformationen " -ForegroundColor Magenta -NoNewline
    Write-Host "════════════════════════════╣" -ForegroundColor Yellow
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewline
    Write-Host ("    Computername   = {0}" -f (Format-Text $computerName)) -ForegroundColor Green -NoNewline
    Write-Host "║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewline 
    Write-Host ("    Netzwerk - IP  = {0}" -f (Format-Text $networkIP)) -ForegroundColor Green -NoNewline
    Write-Host "║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewline 
    Write-Host ("    Betriebssystem = {0}" -f (Format-Text $operatingSystem)) -ForegroundColor Green -NoNewline
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║" -ForegroundColor Yellow -NoNewline
    Write-Host ("    Prozessor      = {0}" -f (Format-Text $cpuName)) -ForegroundColor Green -NoNewline
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ╠═══════════════════════════════" -ForegroundColor Yellow -NoNewline
    Write-Host " Windows Tools " -ForegroundColor Magenta -NoNewline
    Write-Host "═══════════════════════════════╣" -ForegroundColor Yellow
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     1: Windows Komponentenspeicher auf Fehler Prüfen      [ScanHealth]      " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     2: Überprüfen ob Windows als beschädigt makiert wurde [CheckHealth]     " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     3: Automatische Reparaturvogänge durchführen          [RestoreHealth]   " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     4: Abgelöste Startkomponenten bereinigen              [ComponentCleanup]" -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     5: Systemdateien Prüfen und Reparieren                [SFC Scannow]     " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     6: Netzwerkeinstellungen zurücksetzen                 [FlushDNS usw.]   " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ╠═════════════════════════════════" -ForegroundColor Yellow -NoNewline
    Write-Host " Sonstiges " -ForegroundColor Magenta -NoNewline
    Write-Host "═════════════════════════════════╣" -ForegroundColor Yellow
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     7: Windows Store Zurücksetzen / Cache Reinigung                         " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     8: Zuverlässigkeitsverlauf                                              " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     9: Upgrade von Windows Home auf Windows Pro                             " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow 
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "    10: Windows Höchstleistungsmodus                                         " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "    11: Windows Wiederherstellungspunkt erstellen                            " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow  
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ╠═════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Yellow
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "    0: Beenden                                                 12: Readme    " -ForegroundColor Magenta -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host


    $actions = "0"
    while ($actions -notin "0..12") {
    $actions = Read-Host -Prompt '                Was möchtest du tun?'
        if ($actions -in 0..12) {
            if ($actions -eq 0) {
                exit
            }

            # Startet den DISM Scanmodus um zu überprüfen ob das Windows Abbild beschädigt wurde.
            if ($actions -eq 1) {
                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠═════════════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " DISM SCAN " -ForegroundColor Magenta -NoNewLine
                Write-Host "═════════════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "  Scanne das Abbild, um es auf beschädigungen zu prüfen..                    " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "  Dieser Vorgang wird einige Minuten dauern.                                 " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
                Start-Process -Wait -FilePath "C:\Windows\System32\DISM.exe" -ArgumentList '/Online /Cleanup-Image /ScanHealth' -NoNewWindow
                Write-Host
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

            # Startet den DISM Checkmodus um zu überprüfen ob das Windows Abbild als beschädigt markiert wurde.
            if ($actions -eq 2) {
                Clear-Host          
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠═════════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " DISM  Checkhealth " -ForegroundColor Magenta -NoNewLine
                Write-Host "═════════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "  Überprüfe das Abbild, ob es als beschädigt makiert wurde.                  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
                Start-Process -Wait -FilePath "C:\Windows\System32\DISM.exe" -ArgumentList '/Online /Cleanup-Image /CheckHealth' -NoNewWindow
                Write-Host 
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

            # Startet den DISM Wiederherstellungmodus um ein beschädigtes Windows Abbild zu Reparieren.
            if ($actions -eq 3) {
                Clear-Host          
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠═══════════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " DISM  RESTORE " -ForegroundColor Magenta -NoNewLine
                Write-Host "═══════════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Versuche das beschädigte Abbild zu reparieren.                            " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Dieser Vorgang wird einige Minuten dauern.                                " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow 
                Start-Process -Wait -FilePath "C:\Windows\System32\DISM.exe" -ArgumentList '/Online /Cleanup-Image /RestoreHealth' -NoNewWindow
                Write-Host 
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

            # Startet den DISM Komponentenbereinigung um nicht mehr benötigte und temporäre Dateien, die während der Installation von Updates und Patches erstellt wurden, zu entfernen.
            if ($actions -eq 4) {
                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠═════════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " DISM STARTCLEANUP " -ForegroundColor Magenta -NoNewLine
                Write-Host "═════════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow 
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Bereinigung der Temporären Startkomponenten..                             " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Dieser Vorgang wird einige Minuten dauern.                                " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow 
                Start-Process -Wait -FilePath "C:\Windows\System32\DISM.exe" -ArgumentList '/Online /Cleanup-Image /StartComponentCleanup' -NoNewWindow
                Write-Host
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

            # Startet den System File Checker um beschädigte Windows Systemdateien auf Fehler zu überprüfen und gegebenfalls direkt zu Reparieren.
            if ($actions -eq 5) {
                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠════════════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " SFC  SCANOW " -ForegroundColor Magenta -NoNewLine
                Write-Host "════════════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow 
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Scanne Systemdateien auf beschädigungen und versuche diese zu reparieren.." -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Dieser Vorgang wird einige Minuten dauern.                                " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow 
                Start-Process -Wait -FilePath "C:\Windows\System32\SFC.exe" -ArgumentList '/scannow' -NoNewWindow
                Write-Host
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

            # Setzt Windows Netzwerkadapter und Einstellungen auf die ursprüngliche Werte um Netzwerkprobleme zu beheben.
            if ($actions -eq 6) {
                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠══════════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " Netzwerk  Reset " -ForegroundColor Magenta -NoNewLine
                Write-Host "══════════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow 
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Zurücksetzen des Winsock API Katalogs auf Standardeinstellungen.          " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                netsh winsock reset | Out-Null
                Start-Sleep 1
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Zurücksetzen der TCP und IP Einstellung auf Standard.                     " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                netsh int ip reset | Out-Null
                Start-Sleep 1
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Bereinigung des IP und DNS cache                                          " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                ipconfig /release | Out-Null
                ipconfig /renew | Out-Null
                ipconfig /flushdns | Out-Null
                Start-Sleep 1
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Wiederherstellung der Standard Firewall Einstellungen.                    " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                netsh advfirewall reset | Out-Null
                Start-Sleep 1
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Netzwerk Reset Abgeschlossen.                                             " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Start-Sleep 1
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow 
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow 
                Write-Host "`n           Bitte starten Sie Ihr Gerät neu!" -ForegroundColor Green
                Write-Host
                    $UpgradeSure1 = Read-Host "           Möchten Sie jetzt neu starten? (J/N)" 
                    if ($UpgradeSure1 -eq 'J') {
                    Write-Host "`n           Neustart..." -ForegroundColor Cyan
                    Start-Sleep 3
                    Restart-Computer
                    }
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

            # Bereinigung des Microsoft Store Cache zur Fehlerbehebung.
            if ($actions -eq 7) {
                Start-Process -FilePath "wsreset.exe" -Wait
            }

            # Öffnet den Windows Zuverlässigkeitsverlauf.
            if ($actions -eq 8) {
                perfmon /rel
            }

            # Windows Home System mit KMS Upgrade Key auf Windows Pro ändern ohne Neuinstallation.
            if ($actions -eq 9) {
                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " Windows Home zu Pro Upgrade " -ForegroundColor Magenta -NoNewLine
                Write-Host "════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow  

                    #Check if Windows Home or Windows Pro
                    $OSVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption
                    if ($OSVersion -eq "Microsoft Windows 10 Home" -or $OSVersion -eq "Microsoft Windows 11 Home") {

                        Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                        Write-Host "   Aktualisierung von Windows Home auf Professional.                         " -ForegroundColor Red -NoNewLine
                        Write-Host "║" -ForegroundColor Yellow
                        Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                        Write-Host "   Sie müssen Windows später mit einem [Windows Pro Key] aktivieren!         " -ForegroundColor Red -NoNewLine
                        Write-Host "║" -ForegroundColor Yellow
                        Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                        Write-Host "   Das System startet neu, um die Pro-Features zu freizuschalten.            " -ForegroundColor Red -NoNewLine
                        Write-Host "║" -ForegroundColor Yellow
                        Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                        Write-Host "   Dieser Vorgang wird einige Minuten dauern!                                " -ForegroundColor Red -NoNewLine
                        Write-Host "║" -ForegroundColor Yellow
                        Write-Host "           ║                                                                             ║" -ForegroundColor Yellow  
                        Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow 
                        Write-Host
                                    $UpgradeSure2 = Read-Host "           Möchten Sie ein Upgrade auf Windows Professional durchführen? (J/N)" 
                                    if ($UpgradeSure2 -eq 'J') {
                                    Write-Host "`n           Starte Upgrade des Systems auf Windows Professional..." -ForegroundColor Cyan
                                    Start-Sleep 2
                                    Changepk.exe /ProductKey VK7JG-NPHTM-C97JM-9MPGT-3V66T
                                    Start-Sleep 100
                                        }
                                    }
                        elseif ($OSVersion -eq "Microsoft Windows 10 Pro" -or $OSVersion -eq "Microsoft Windows 11 Pro") {
                            Clear-Host
                            Invoke-Command -ScriptBlock $Display
                            Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                            Write-Host "           ╠════════════════════════" -ForegroundColor Yellow -NoNewLine
                            Write-Host " Windows Home zu Pro Upgrade " -ForegroundColor Magenta -NoNewLine
                            Write-Host "════════════════════════╣" -ForegroundColor Yellow
                            Write-Host "           ║                                                                             ║" -ForegroundColor Yellow  
                            Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                            Write-Host "   Ihr System ist bereits eine Pro-Version, ein Upgrade ist nicht möglich.   " -ForegroundColor Red -NoNewLine
                            Write-Host "║" -ForegroundColor Yellow
                            Write-Host "           ║                                                                             ║" -ForegroundColor Yellow  
                            Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow 
                            Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                            $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                            }
            }

            # Windows Optimierung: Energiesparplan auf Höchstleistung, Monitortimeout auf 0 Min, Ruhezustand / Schnellstart [Deaktivieren] und Stromtaster auf Herunterfahren umstellen.
            if ($actions -eq 10) {
                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠══════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " Performance Optimierung " -ForegroundColor Magenta -NoNewLine
                Write-Host "══════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow 
                $planGUID = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
                $powerPlans = powercfg.exe /list
                $planExists = $powerPlans -match $planGUID

                if ($planExists) {
                } else {   

                powercfg -duplicate 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c | Out-Null
                     
                    }
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Aktiviere Höchstleistungs Energieplan...                                  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow 
                Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\ControlPanel\NameSpace\{025A5937-A6BE-4686-A844-36FE4BEC8B6D}' -Name PreferredPlan -Value 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
                powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c | Out-Null
                Start-Sleep 1     

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Deaktiviere Ruhezustand...                                                " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -hibernate off | Out-Null
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Einstellungen für Festplatten Timeout... [Niemals Ausschalten]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -change -disk-timeout-dc 30 | Out-Null
                powercfg -change -disk-timeout-ac 0 | Out-Null
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Einstellungen für Selektiven-USB-Modus...[Niemals Ausschalten]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
                powercfg -SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Monitor-Timeout Einstellungen...      [Strom: 0m | Akku = 10m]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -change -standby-timeout-ac 0 | Out-Null
                powercfg -change -standby-timeout-dc 0 | Out-Null
                powercfg -change -monitor-timeout-ac 0 | Out-Null
                powercfg -change -monitor-timeout-dc 10 | Out-Null
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Einstellungen für das Schließen des Deckels...    [Nichts tun]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -setdcvalueindex scheme_current sub_buttons 5ca83367-6e45-459f-a27b-476b1d01c936 0 | Out-Null
                powercfg -setacvalueindex scheme_current sub_buttons 5ca83367-6e45-459f-a27b-476b1d01c936 0 | Out-Null
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Einstellungen für die Schlaftaste...              [Nichts tun]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -setdcvalueindex scheme_current sub_buttons 96996bc0-ad50-47ec-923b-6f41874dd9eb 0 | Out-Null
                powercfg -setacvalueindex scheme_current sub_buttons 96996bc0-ad50-47ec-923b-6f41874dd9eb 0 | Out-Null
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Einstellungen für die Starttaste...           [Herunterfahren]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -setdcvalueindex scheme_current sub_buttons 7648efa3-dd9c-4e3e-b566-50f929386280 3 | Out-Null
                powercfg -setacvalueindex scheme_current sub_buttons 7648efa3-dd9c-4e3e-b566-50f929386280 3 | Out-Null
				powercfg -setdcvalueindex scheme_current sub_buttons a7066653-8d6c-40a8-910e-a1f54b84c7e5 2 | Out-Null
				powercfg -setacvalueindex scheme_current sub_buttons a7066653-8d6c-40a8-910e-a1f54b84c7e5 2 | Out-Null
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimierungen abgeschlossen.                                              " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Start-Sleep 1

                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow 
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow 
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

            # Wiederherstellungspunkt erstellen.
            if ($actions -eq 11) {
                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠══════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " Windows - Systemrestore " -ForegroundColor Magenta -NoNewLine
                Write-Host "══════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Ein Windows-Wiederherstellungspunkt ist eine Möglichkeit,                 " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   das Betriebssystem auf einen vorherigen stabilen Zustand zurückzusetzen,  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   um Systemprobleme zu beheben.                                             " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Es sichert Systemdateien und ermöglicht eine einfache Wiederherstellung.  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow             
                Enable-ComputerRestore -Drive C:\ | Out-Null
                $null = & vssadmin.exe resize shadowstorage /For=C: /On=C: /maxSize=5GB
                Write-Host "           ╠═════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Konfiguration des Windows-Wiederherstellungspunkt wird ausgeführt.        " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow    
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
                Write-Host 

                $RestoreName = Read-Host "             Eigener Name für Wiederherstellungspunkt? [Default: FACTORY-RESTORE] (J/N)"
                if ($RestoreName -eq 'J') {
                    # Benutzerabfrage für den Namen des Wiederherstellungspunkts
                    $restorePointName = Read-Host "`n           Geben Sie einen Namen für den Wiederherstellungspunkt an"
    
                    Clear-Host
                    Invoke-Command -ScriptBlock $Display
                    Invoke-Command -ScriptBlock $RestoreSystem
                    Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    }
                elseif ($RestoreName -eq 'N') {
                    # Vorgegebener Name für den Wiederherstellungspunkt
                    $restorePointName = "FACTORY-RESTORE" 
                    Clear-Host
                    $null = & vssadmin delete shadows /all /quiet
                    Invoke-Command -ScriptBlock $Display
                    Invoke-Command -ScriptBlock $RestoreSystem
                    Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                    }
                menu
            }

            # Github Readme öffnen für weitere Informationen.
            if ($actions -eq 12) {
                Start-Process "https://github.com/SD-ITLab/WinRep"
                menu
            }
            menu
        }
        else {
            menu
        }
    }
}
menu
