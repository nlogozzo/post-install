$ProgressPreference = 'SilentlyContinue'
echo "==Installing Apps=="
winget source refresh
$firefox = Read-Host "Install Firefox? (y/n) "
if ($firefox -eq 'y') {
    winget install --id=Mozilla.Firefox -e
}
winget install --id=Microsoft.Office -e
winget install --id=Foxit.FoxitReader -e
winget install --id=JRSoftware.InnoSetup -e
winget install --id=GitHub.GitHubDesktop -e
winget install --id=Microsoft.VisualStudioCode -e
winget install --id=Microsoft.VisualStudio.2022.Community -e
winget install --id=Git.Git -e
winget install --id=Zoom.Zoom -e
winget install --id=Discord.Discord -e
winget install --id=cinnyapp.cinny-desktop -e
winget install WhatsApp -s msstore
winget install --id 9P3JFPWWDZRC -s msstore # WinUI 3 Gallery
winget install --id=JanDeDobbeleer.OhMyPosh -e 
winget install --id=mlocati.GetText -e
winget install --id=Fastfetch-cli.Fastfetch -e
winget install --id=DEVCOM.JetBrainsMonoNerdFont -e
winget install --id 9WZDNCRDXF41 -s msstore # Character Map UWP
winget install --id=DBBrowserForSQLite.DBBrowserForSQLite -e
winget install --id=DimitriVanHeesch.Doxygen -e
winget install --id=VideoLAN.VLC -e
winget install --id=Nickvision.Parabolic -e
winget install --id=Cyanfish.NAPS2 -e
$games = Read-Host "Install Games? (y/n) "
if ($games -eq 'y') {
    winget install --id=Valve.Steam -e
    winget install --id=EpicGames.EpicGamesLauncher -e
    Start-Process https://aka.ms/DownloadNewLauncher?ref=launcher
}
$mega = Read-Host "Install megasync? (y/n) "
if ($mega -eq 'y') {
    winget install --id=Mega.MEGASync -e
}
$hp = Read-Host "Install HP Smart? (y/n) "
if ($hp -eq 'y') {
    winget install --id 9WZDNCRFHWLH -s msstore # HP Smart
}
winget upgrade --all
$qt = Read-Host "Install Qt Creator? (y/n) "
if ($qt -eq 'y') {
    winget install --id=Cppcheck.Cppcheck -e
    Invoke-WebRequest "https://download.qt.io/official_releases/qtcreator/15.0/15.0.1/qt-creator-opensource-windows-x86_64-15.0.1.exe" -OutFile qtcreator.exe
    Start-Process .\qtcreator.exe
    Remove-Item .\qtcreator.exe
    git clone https://github.com/Raincode/QtCreator-Color-Schemes
    cd QtCreator-Color-Schemes
    .\install_windows.bat
    cd ..
    Remove-Item "QtCreator-Color-Schemes" -Recurse -Force
}
$npp = Read-Home "Install Notepad++? (y/n) "
if($npp -eq 'y') {
    winget install --id Notepad++.Notepad++ -e
    git clone "https://github.com/hellon8/VS2019-Dark-Npp"
    cd VS2019-Dark-Npp
    sudo install.bat
    cd ..
    Remove-Item "VS2019-Dark-Npp" -Recurse -Force
}
echo "==Setting Environment Variables=="
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\$env:UserName\OneDrive\Documents\Programming", "User")
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Type DWord
echo "==Configuring PowerShell=="
New-Item -Path $PROFILE -Type File -Force
echo "fastfetch" | Out-File -FilePath $PROFILE
echo 'oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/jandedobbeleer.omp.json" | Invoke-Expression' | Out-File -Append -FilePath $PROFILE
echo "==Serato=="
Start-Process https://serato.com/dj/pro/downloads
echo "==WSL=="
$install_wsl = Read-Host "Install WSL? (y/n) "
if ($install_wsl -eq "y") {
    wsl --update
    wsl --set-default-version 2
    Invoke-WebRequest "https://github.com/WhitewaterFoundry/Fedora-Remix-for-WSL/releases/download/41.0.0/Fedora-Remix-for-WSL-SL_41.0.0.0_x64_arm64.msixbundle" -OutFile fedora.msixbundle
    Add-AppxPackage .\fedora.msixbundle
    Remove-Item .\fedora.msixbundle
}
echo "==vcpkg=="
$vcpkg = Read-Host "Install and Setup vcpkg? (y/n) "
if ($vcpkg -eq 'y') {
    [System.Environment]::SetEnvironmentVariable("VCPKG_DEFAULT_TRIPLET","x64-windows", "User")
    [System.Environment]::SetEnvironmentVariable("VCPKG_ROOT","C:\Users\$env:UserName\vcpkg", "User")
    cd %HOMEPATH%
    git clone "https://github.com/microsoft/vcpkg"
    cd vcpkg
    Start-Process "bootstrap-vcpkg.bat"
    .\vcpkg.exe install boost-date-time boost-json boost-gil curl gettext-libintl glfw3 gtest libnick maddy skia[core,fontconfig,freetype,gl,harfbuzz,icu,vulkan] sqlcipher qtbase qtsvg qttools qlementine qlementine-icons
}
