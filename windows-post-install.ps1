function Install-Apps {
    winget source refresh
    winget upgrade --all
    winget install --id=Microsoft.PowerShell -e
    winget install --id=Microsoft.Office -e
    winget install --id=Foxit.FoxitReader -e
    winget install --id=JRSoftware.InnoSetup -e
    winget install --id=GitHub.GitHubDesktop -e
    winget install --id=Microsoft.VisualStudio.2022.Community -e
    winget install --id=Microsoft.VisualStudioCode -e
    winget install --id=Git.Git -e
    winget install --id Python.Python.3.12 -e
    winget install --id=OpenJS.NodeJS -e
    winget install --id=Zoom.Zoom -e
    winget install --id=Discord.Discord -e
    winget install --id=cinnyapp.cinny-desktop -e
    winget install --id=JanDeDobbeleer.OhMyPosh -e 
    winget install --id=mlocati.GetText -e
    winget install --id=Fastfetch-cli.Fastfetch -e
    winget install --id=DEVCOM.JetBrainsMonoNerdFont -e
    winget install --id=DBBrowserForSQLite.DBBrowserForSQLite -e
    winget install --id=DimitriVanHeesch.Doxygen -e
    winget install --id=VideoLAN.VLC -e
    winget install --id=Nickvision.Parabolic -e
    winget install --id=Cyanfish.NAPS2 -e
    winget install --id=Valve.Steam -e
    winget install --id=EpicGames.EpicGamesLauncher -e
    winget install --id=Cppcheck.Cppcheck -e
    winget install --id Notepad++.Notepad++ -e
    winget install --id Microsoft.PowerToys -e
    Start-Process https://serato.com/dj/pro/downloads
}

function Install-NotepadThemes {
    git clone "https://github.com/hellon8/VS2019-Dark-Npp"
    cd VS2019-Dark-Npp
    sudo install.bat
    cd ..
    Remove-Item "VS2019-Dark-Npp" -Recurse -Force
}

function Install-PythonDependencies {
    pip install requirements-parser
}

function Add-EnvironmentVariables {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Users\$env:UserName\OneDrive\Documents\Programming", "User")
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Type DWord
}

function Add-PowerShellConfiguration {
    $profilePath = "$([Environment]::GetFolderPath("MyDocuments"))\PowerShell\Microsoft.PowerShell_profile.ps1"
    New-Item -Path $profilePath -Type File -Force
    echo "clear" | Out-File -FilePath $profilePath
    echo "fastfetch" | Out-File -Append -FilePath $profilePath
    echo 'oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/jandedobbeleer.omp.json" | Invoke-Expression' | Out-File -Append -FilePath $profilePath
}

function Install-WSL {
    wsl --set-default-version 2
    wsl --update --pre-release
    wsl --install --no-distribution
    wsl --install openSUSE-Tumbleweed
}

function Install-Vcpkg {
    [System.Environment]::SetEnvironmentVariable("VCPKG_DEFAULT_TRIPLET","x64-windows", "User")
    [System.Environment]::SetEnvironmentVariable("VCPKG_ROOT","C:\Users\$env:UserName\vcpkg", "User")
    cd %HOMEPATH%
    git clone "https://github.com/microsoft/vcpkg"
    cd vcpkg
    Start-Process "bootstrap-vcpkg.bat"
    .\vcpkg.exe install boost-date-time boost-json boost-gil cpr curl gettext-libintl glfw3 gtest libjpeg-turbo libnick maddy skia[core,fontconfig,freetype,gl,harfbuzz,icu,vulkan] sqlcipher
}

function Invoke-Main {
    $ProgressPreference = 'SilentlyContinue'
    Start-Process powershell -ArgumentList "-Command & { sudo config --enable normal }" -Verb RunAs
    Install-Apps
    Install-NotepadThemes
    Install-PythonDependencies
    Add-EnvironmentVariables
    Add-PowerShellConfiguration
    Install-WSL
    Install-Vcpkg
}

Invoke-Main