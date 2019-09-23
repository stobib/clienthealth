@Echo Off
Set Tempfile=%SystemDrive%
CLS
Powershell Set-ExecutionPolicy -ExecutionPolicy ByPass
Powershell Set-ExecutionPolicy Unrestricted
Powershell Robocopy "\\utshare.local\netlogon" "%Tempfile%\ClientHealth" "ClientHealthMonitor.ps1"
CLS
Powershell "%Tempfile%\ClientHealth\ClientHealthMonitor.ps1" -TestProvMode -TestGPOFiles
DEL "%Tempfile%\ClientHealth" /S /F /Q
CLS
@Echo On
