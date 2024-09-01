echo "==Installing Apps=="
winget install --id=Microsoft.Office -e
winget install --id=Foxit.FoxitReader -e
winget install --id=JRSoftware.InnoSetup -e
winget install --id=GitHub.GitHubDesktop -e
winget install --id=Microsoft.VisualStudioCode -e
winget install --id=Microsoft.VisualStudio.2022.Community -e
winget install --id=Git.Git -e
winget install --id=Zoom.Zoom -e
winget install --id=Discord.Discord -e
winget install --id=Element.Element -e
winget install --id=Valve.Steam -e
winget install --id=EpicGames.EpicGamesLauncher -e
winget install WhatsApp -s msstore
winget install --id 9P3JFPWWDZRC -s msstore
winget install --id=JanDeDobbeleer.OhMyPosh -e
winget install --id=mlocati.GetText -e
winget install --id=Fastfetch-cli.Fastfetch -e
winget install --id=DEVCOM.JetBrainsMonoNerdFont -e
winget install --id 9WZDNCRDXF41 -s msstore
winget install --id=DBBrowserForSQLite.DBBrowserForSQLite -e
winget install --id=DimitriVanHeesch.Doxygen -e
winget upgrade --all
echo "==Setting Environment Variables=="
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
[System.Environment]::SetEnvironmentVariable("VCPKG_DEFAULT_TRIPLET","x64-windows", "User")
[System.Environment]::SetEnvironmentVariable("VCPKG_ROOT","C:\Users\$env:UserName\vcpkg", "User")
[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\$env:UserName\OneDrive\Documents\Programming", "User")
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Type DWord
echo "==Configuring PowerShell=="
New-Item -Path $PROFILE -Type File -Force
echo "fastfetch" | Out-File -FilePath $PROFILE
echo 'oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/jandedobbeleer.omp.json" | Invoke-Expression' | Out-File -Append -FilePath $PROFILE
echo "==Minecraft=="
Start-Process https://aka.ms/DownloadNewLauncher?ref=launcher
echo "==Serato=="
Start-Process https://serato.com/dj/pro/downloads
echo "==WSL=="
$install_wsl = Read-Host "Do you want to install WSL? (y/n) "
if ($install_wsl -eq "y") {
    wsl --install --d Ubuntu
}