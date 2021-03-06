<#
Windows ASKER installation
version: 20190821
author: Francisco Vargas Ruiz
#>

If ([System.Security.Principal.WindowsIdentity]::GetCurrent().Groups -NotContains "S-1-5-32-544") {
    $Host.UI.WriteErrorLine("Must be run as administrator")
    Exit 1
}

$AskerPath = $env:ProgramFiles + "\asker"
$AskerUrl = "https://github.com/dvarrui/asker.git"

Write-Host "[0/6.INFO] WINDOWS ASKER installation"

Write-Host "[1/6.INFO] Installing PACKAGES..."
If (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
choco install -y git
choco install -y ruby

$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).path)\..\.."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

Write-Host "[2/6.INFO] Rake gem installation"
gem install rake -f

Write-Host "[3/6.INFO] Installing asker in $AskerPath"
git clone $AskerUrl $AskerPath -q

Write-Host "[4/6.INFO] Adding asker to system environment PATH variable"
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
If (!$CurrentPath.Contains($AskerPath)) {
    [Environment]::SetEnvironmentVariable("Path", $CurrentPath + ";$AskerPath", [EnvironmentVariableTarget]::Machine)
}

Write-Host "[5/6.INFO] Configuring..."
Push-Location
cd $AskerPath
rake gems
Pop-Location

refreshenv

Write-Host "[6/6.INFO] Finish!"
