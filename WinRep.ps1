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
                                   \/          \/       \/     \/|__|                        v3.8.1" -ForegroundColor Red
}

# Computernamen abrufen
$computerName = $env:COMPUTERNAME

# Funktion, um die IP-Adresse basierend auf dem aktiven Netzwerkprofil abzurufen
function Get-ActiveNetworkIP {
    # Hole alle Netzwerkprofile mit aktivem Status
    $activeNetworks = Get-NetConnectionProfile

    foreach ($network in $activeNetworks) {
        # Hole die IP-Adresse für das Netzwerk
        $ipAddress = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $network.InterfaceAlias | Where-Object { $_.IPAddress -ne $null }).IPAddress

        if ($ipAddress) {
            return $ipAddress
        }
    }

    return $null
}

# IP-Adresse basierend auf dem aktiven Netzwerkprofil abrufen
$activeIP = Get-ActiveNetworkIP

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
    Write-Host ("    Netzwerk - IP  = {0}" -f (Format-Text $activeIP)) -ForegroundColor Green -NoNewline
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
    Write-Host "     7: Windows Updates Zurücksetzen / Cache Reinigung                       " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     8: Temporäre Dateien bereinigen                                         " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "     9: Upgrade von Windows Home auf Windows Pro                             " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "    10: Windows Höchstleistungsmodus                                         " -ForegroundColor Cyan -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "    11: Zeige Systeminformationen                                            " -ForegroundColor Cyan -NoNewLine
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
                Write-Host "   Zurücksetzen von IPv4 und IPv6 auf DHCP.                                  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                $networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
                foreach ($adapter in $networkAdapters) {
                    netsh interface ip set address name="$($adapter.Name)" source=dhcp | Out-Null
                    netsh interface ip set dns "$($adapter.Name)" dhcp | Out-Null
                    netsh interface ipv6 set dns "$($adapter.Name)" dhcp | Out-Null
                }
                # IPv6 auf DHCP setzen
                netsh interface ipv6 reset | Out-Null
                Start-Sleep 1
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
                Write-Host "   Zurücksetzen der Proxy Einstellungen.                                     " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                netsh winhttp reset proxy | Out-Null
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name AutoConfigURL -Value ""
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 0
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name AutoDetect -Value 1
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
                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠═══════════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " Reset Updates " -ForegroundColor Magenta -NoNewLine
                Write-Host "═══════════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Attribute von catroot2 und seinen Dateien zurücksetzen.                   " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                attrib -h -r -s "$env:windir\system32\catroot2"
                attrib -h -r -s "$env:windir\system32\catroot2\*.*"
                Start-Sleep 1
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Windows Update, Kryptografie und BITS-Dienst stoppen...                   " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Stop-Service -Name wuauserv -Force
                Stop-Service -Name CryptSvc -Force
                Stop-Service -Name BITS -Force
                Stop-Service -Name msiserver -Force
                Start-Sleep 1
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Benenne Update-Cache ordner um...                                         " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Rename-Item -Path "$env:windir\system32\catroot2" -NewName "catroot2.old" -ErrorAction SilentlyContinue
                Rename-Item -Path "$env:windir\SoftwareDistribution" -NewName "sold.old" -ErrorAction SilentlyContinue
                Rename-Item -Path "$env:ALLUSERSPROFILE\Microsoft\Network\downloader" -NewName "downloader.old" -ErrorAction SilentlyContinue
                Start-Sleep 1
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Starte Update-Dienste erneut..                                            " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Start-Service -Name BITS
                Start-Service -Name CryptSvc
                Start-Service -Name wuauserv
                Start-Service -Name msiserver
                Start-Sleep 1
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Windows Update-Dienste wurden zurückgesetzt!                              " -ForegroundColor Red -NoNewLine
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

            # Bereinige Temporäre Dateien.
            if ($actions -eq 8) {
                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠════════════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " TempCleaner " -ForegroundColor Magenta -NoNewLine
                Write-Host "════════════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow 
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Starte bereinigung von Temporäre Dateien...                               " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                $Keys = @(
                    "Active Setup Temp Folders",
                    "Downloaded Program Files",
                    "Internet Cache Files",
                    "Memory Dump Files",
                    "Old ChkDsk Files",
                    "Previous Installations",
                    "Recycle Bin",
                    "Service Pack Cleanup",
                    "Setup Log Files",
                    "System error memory dump files",
                    "System error minidump files",
                    "Temporary Files",
                    "Temporary Setup Files",
                    "Thumbnail Cache",
                    "Update Cleanup",
                    "Upgrade Discarded Files",
                    "Windows Error Reporting Archive Files",
                    "Windows Error Reporting Queue Files",
                    "Windows Error Reporting System Archive Files",
                    "Windows Error Reporting System Queue Files",
                    "Windows Upgrade Log Files"
                )

                $BaseKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"

                foreach ($Key in $Keys) {
                    New-ItemProperty -Path "$BaseKey\$Key" -Name "StateFlags0100" -PropertyType DWORD -Value 0x2 -Force -ErrorAction SilentlyContinue | Out-Null
                }
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Dieser Vorgang wird einige Minuten dauern.                                " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow 
                Start-Process -Wait -FilePath "$env:SystemRoot\System32\cleanmgr.exe" -ArgumentList "/sagerun:200 " -NoNewWindow
                Write-Host
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
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

                if (-not ($powerPlans -match $planGUID)) {
                    powercfg -duplicate "$planGUID" | Out-Null 2>$null
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
                Write-Host "   Optimiere Einstellung für Mindest-CPU-zustand... [Strom: 50% | Akku: 5%]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 50
                powercfg -SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 5
                Start-Sleep 1   

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Einstellungen für Core Parking....     [Strom: 0% | Akku: 50%]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100
                powercfg -SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 50
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Einstellungen für Festplatten Timeout. [Strom: 0m | Akku: 15m]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -change -disk-timeout-dc 15 | Out-Null
                powercfg -change -disk-timeout-ac 0 | Out-Null
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Einstellungen für Selektiven-USB-Modus [Strom: Off | Akku: On]  " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                powercfg -SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
                powercfg -SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
                Start-Sleep 1

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimiere Monitor-Timeout Einstellungen...       [Strom: 0m | Akku: 10m]  " -ForegroundColor Red -NoNewLine
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
                powercfg /setactive SCHEME_CURRENT | Out-Null
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Optimierungen abgeschlossen.                                              " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow
                Start-Sleep 1

                $apps = @(
                    "Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe",
                    "Microsoft.Microsoft3DViewer_8wekyb3d8bbwe",
                    "Microsoft.WindowsAlarms_8wekyb3d8bbwe",
                    "Microsoft.WindowsCalculator_8wekyb3d8bbwe",
                    "Microsoft.WindowsCamera_8wekyb3d8bbwe",
                    "Microsoft.549981C3F5F10_8wekyb3d8bbwe",
                    "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe",
                    "Microsoft.GetHelp_8wekyb3d8bbwe",
                    "Microsoft.ZuneMusic_8wekyb3d8bbwe",
                    "microsoft.windowscommunicationsapps_8wekyb3d8bbwe",
                    "Microsoft.WindowsMaps_8wekyb3d8bbwe",
                    "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe",
                    "Microsoft.WindowsStore_8wekyb3d8bbwe",
                    "Microsoft.ZuneVideo_8wekyb3d8bbwe",
                    "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",
                    "Microsoft.Office.OneNote_8wekyb3d8bbwe",
                    "Microsoft.MSPaint_8wekyb3d8bbwe",
                    "Microsoft.People_8wekyb3d8bbwe",
                    "Microsoft.Windows.Photos_8wekyb3d8bbwe",
                    "windows.immersivecontrolpanel_cw5n1h2txyewy",
                    "Microsoft.SkypeApp_kzf8qxf38zg5c",
                    "Microsoft.ScreenSketch_8wekyb3d8bbwe",
                    "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
                    "Microsoft.Getstarted_8wekyb3d8bbwe",
                    "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe",
                    "Microsoft.BingWeather_8wekyb3d8bbwe",
                    "Microsoft.XboxApp_8wekyb3d8bbwe",
                    "Microsoft.YourPhone_8wekyb3d8bbwe",
                    "Microsoft.MixedReality.Portal_8wekyb3d8bbwe",
                    "Microsoft.Xbox.TCUI_8wekyb3d8bbwe"
                )

                foreach ($app in $apps) {
                    $path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\$app"
                    if (!(Test-Path $path)) {
                        New-Item -Path $path -Force | Out-Null
                    }
                    Set-ItemProperty -Path $path -Name "Disabled" -Value 1 -Type DWord
                    Set-ItemProperty -Path $path -Name "DisabledByUser" -Value 1 -Type DWord
                }

                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow 
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow 
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

            # Analysiere System-Informationen und gib diese als txt Datei aus.
            if ($actions -eq 11) {

                Clear-Host
                Invoke-Command -ScriptBlock $Display
                Write-Host " ══════════╦═════════════════════════════════════════════════════════════════════════════╦══════════" -ForegroundColor Yellow
                Write-Host "           ╠═══════════════════════════" -ForegroundColor Yellow -NoNewLine
                Write-Host " Windows - information " -ForegroundColor Magenta -NoNewLine
                Write-Host "═══════════════════════════╣" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "   Check Windows-Version....                                                 " -ForegroundColor Red -NoNewLine
                Write-Host "║" -ForegroundColor Yellow

                # Desktop-Pfad ermitteln
                $desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop", "Systeminfo.txt")

    $output = @"

    Systeminformationen

    Betriebssystem
        Edition       = $((Get-CimInstance Win32_OperatingSystem).Caption)
        Build-Nummer  = $((Get-CimInstance Win32_OperatingSystem).Version)`n
"@
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "   Check Processor-Information....                                           " -ForegroundColor Red -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Get-CimInstance Win32_Processor| ForEach-Object {
    $output += @"

    Prozessor         
        Name          = $((Get-CimInstance -ClassName Win32_Processor).Name)
        Kerne/Threads = $((Get-CimInstance -ClassName Win32_Processor).NumberOfCores)/$((Get-CimInstance -ClassName Win32_Processor).ThreadCount)
        Sockel        = $((Get-CimInstance -ClassName Win32_Processor).SocketDesignation)`n

"@
}
    Start-Sleep 1
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "   Check Graphic-Information....                                             " -ForegroundColor Red -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Start-Sleep 1
Get-CimInstance -ClassName Win32_VideoController | ForEach-Object {
    $output += @"
    Grafik-Chip
        Chip-Name     = $($_.Name)
        Treiberverion = $($_.DriverVersion)
        Treiberdatum  = $($_.DriverDate)`n

"@

}    
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "   Check Motherboard-Information....                                         " -ForegroundColor Red -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Start-Sleep 1
    $output += @"
    Mainboard
        Hersteller    = $((Get-CimInstance -Class Win32_BaseBoard).Manufacturer)
        Modell        = $((Get-CimInstance -Class Win32_BaseBoard).Product)
        Seriennummer  = $((Get-CimInstance -Class Win32_BaseBoard).SerialNumber)
        Revision      = $((Get-CimInstance -Class Win32_BaseBoard).Version)
        BIOS-Version  = $((Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion)`n

"@
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "   Check RAM-Information....                                                 " -ForegroundColor Red -NoNewLine
    Write-Host "║" -ForegroundColor Yellow
    Start-Sleep 1
# Arbeitsspeicher abrufen und formatieren
Get-CimInstance Win32_PhysicalMemory | ForEach-Object {
    $output += @"
    Arbeitsspeicher
        Hersteller    = $($_.Manufacturer)
        Modell        = $($_.PartNumber)
        Seriennummer  = $($_.SerialNumber)
        Steckplatz    = $($_.DeviceLocator)
        Speicher      = $([math]::Round($_.Capacity / 1GB, 0)) GB
        Taktfrequenz  = $($_.ConfiguredClockSpeed) MHz`n

"@

}    
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow    
    Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
    Write-Host "   Check Disk-Information....                                                " -ForegroundColor Red -NoNewLine
# Festplatten abrufen und Volumeninformationen einbinden
Get-CimInstance -Class Win32_DiskDrive | ForEach-Object {
    # Get Partition Details
    $partitions = Get-CimInstance -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($_.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition"
    
    # Standardwerte setzen
    $volumeLetter = "Kein Laufwerk"
    $volumeName = "Unbekannt"

    foreach ($partition in $partitions) {
        # Holen der logischen Laufwerksinformationen, wenn Partitionen vorhanden sind
        $logicalDrive = Get-CimInstance -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition"
        
        if ($logicalDrive) {
            $volumeLetter = $logicalDrive.DeviceID
            $volumeName = if ($logicalDrive.VolumeName) { $logicalDrive.VolumeName } else { "Kein Name" }
        }
    }

    # Festplatten-Daten hinzufügen
    $output += @"
    Disk-Drive
        Modell        = $($_.Model)
        Speicher      = $([math]::Round($_.Size / 1e9, 0)) GB
        Laufwerk      = $volumeLetter
        Volumenname   = $volumeName`n

"@
}    
    Write-Host "║" -ForegroundColor Yellow   
    Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
    Write-Host "           ╠═════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Yellow
    Start-Sleep 1

# Datei speichern
$output | Set-Content -Path $desktopPath -Encoding UTF8

# Datei öffnen
Start-Process "notepad.exe" -ArgumentList "`"$desktopPath`""

                Write-Host "           ║" -ForegroundColor Yellow -NoNewLine
                Write-Host "  Vorgang Abgeschlossen...                                                   " -ForegroundColor Red -NoNewLine                
                Write-Host "║" -ForegroundColor Yellow
                Write-Host "           ║                                                                             ║" -ForegroundColor Yellow
                Write-Host "           ╚═════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
                Write-Host
                Write-Host "`n           Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Green
                $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }

            # Github Readme öffnen für weitere Informationen.
            if ($actions -eq 12) {
                Start-Process "https://sd-itlab.de/windows-repairtools/"
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
