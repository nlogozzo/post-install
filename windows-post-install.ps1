function Install-Apps {
    winget source refresh
    sudo winget upgrade --all
    sudo winget install --id=Microsoft.PowerShell -e
    sudo winget install --id=Microsoft.Office -e
    sudo winget install --id SumatraPDF.SumatraPDF -e
    sudo winget install --id Notepad++.Notepad++ -e
    sudo winget install --id=Zoom.Zoom -e
    sudo winget install --id=Discord.Discord -e
    sudo winget install --id=cinnyapp.cinny-desktop -e
    sudo winget install --id=JanDeDobbeleer.OhMyPosh -e 
    sudo winget install --id=Fastfetch-cli.Fastfetch -e
    sudo winget install --id=DEVCOM.JetBrainsMonoNerdFont -e
    sudo winget install --id=VideoLAN.VLC -e
    sudo winget install --id=Nickvision.Parabolic -e
    sudo winget install --id=Cyanfish.NAPS2 -e
    sudo winget install --id Microsoft.PowerToys -e
    sudo winget install --id=Git.Git -e
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    $dev = Read-Host -Prompt "Install development tools? (y/n) "
    if($dev -eq "y" -or $dev -eq "Y") { 
		sudo winget install --id=JRSoftware.InnoSetup -e
		sudo winget install --id=GitHub.GitHubDesktop -e
		sudo winget install --id=Microsoft.VisualStudio.2022.Community -e
		sudo winget install --id=Microsoft.VisualStudioCode -e
		sudo winget install --id Python.Python.3.12 -e
		sudo winget install --id=mlocati.GetText -e
		sudo winget install --id=DBBrowserForSQLite.DBBrowserForSQLite -e
		sudo winget install --id=DimitriVanHeesch.Doxygen -e
		sudo winget install --id=OpenJS.NodeJS- -e
		sudo winget install --id=Postman.Postman  -e
		sudo winget install --id=MSYS2.MSYS2 -e
		$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
		python -m pip install --upgrade pip
		pip install requirements-parser
		pacman -Syuu
    }
    $games = Read-Host -Prompt "Install games? (y/n) "
    if($games -eq "y" -or $games -eq "Y") { 
    	sudo winget install --id=Valve.Steam -e
    	sudo winget install --id=EpicGames.EpicGamesLauncher -e
    }
    Start-Process https://serato.com/dj/pro/downloads
}

function Install-NotepadThemes {
    git clone "https://github.com/hellon8/VS2019-Dark-Npp"
    cd VS2019-Dark-Npp
    sudo ./install.bat
    cd ..
    Remove-Item "VS2019-Dark-Npp" -Recurse -Force
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
    $install = Read-Host -Prompt "Install WSL? (y/n) "
    if($install -eq "y" -or $install -eq "Y") { 
        wsl --set-default-version 2
    	wsl --update
    	wsl --install --no-distribution
    }
}

function Install-Vcpkg {
    $install = Read-Host -Prompt "Install vcpkg? (y/n) "
    if($install -eq "y" -or $install -eq "Y") {
        [System.Environment]::SetEnvironmentVariable("VCPKG_DEFAULT_TRIPLET","x64-windows", "User")
    	[System.Environment]::SetEnvironmentVariable("VCPKG_ROOT","C:\Users\$env:UserName\vcpkg", "User")
    	cd %HOMEPATH%
    	git clone "https://github.com/microsoft/vcpkg"
    	cd vcpkg
    	Start-Process "bootstrap-vcpkg.bat"
    	.\vcpkg.exe install boost-date-time boost-json boost-gil cpr curl gettext-libintl glfw3 gtest libjpeg-turbo libnick maddy skia[core,fontconfig,freetype,gl,harfbuzz,icu,vulkan] sqlcipher
    }
}

function Invoke-Main {
    $ProgressPreference = 'SilentlyContinue'
    Start-Process powershell -ArgumentList "-Command & { sudo config --enable normal }" -Verb RunAs -Wait
    Install-Apps
    Install-NotepadThemes
    Install-PythonDependencies
    Add-EnvironmentVariables
    Add-PowerShellConfiguration
    Install-WSL
    Install-Vcpkg
}

Invoke-Main