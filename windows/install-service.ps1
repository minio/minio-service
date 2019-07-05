#Check script run as administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Set-Location -Path $PSScriptRoot

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/kohsuke/winsw/releases/download/winsw-v2.2.0/WinSW.NET4.exe" -OutFile "minio-service.exe"

$config = @'
<service>
  <id>MinIO</id>
  <name>MinIO</name>
  <description>MinIO is a high performance object storage server</description>
  <executable>minio.exe</executable>
  <arguments>server C:\minio</arguments>
  <logmode>rotate</logmode>
</service>
'@

Set-Content "minio-service.xml" $config

Start-Process -WorkingDirectory $PSScriptRoot -FilePath "$($PSScriptRoot)\minio-service.exe" -ArgumentList "install" -NoNewWindow -PassThru -Wait

Write-Host "Installation done"