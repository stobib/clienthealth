@Echo Off
PowerShell Set-ExecutionPolicy -ExecutionPolicy ByPass
PowerShell Set-ExecutionPolicy Unrestricted
PowerShell Robocopy "\\utshare.local\netlogon" "$env:TEMP" "RepairWMI.ps1" /R:0 /W:0 /REG
PowerShell -noexit C:\Users\RO1000~1\AppData\Local\Temp\RepairWMI.ps1
@Echo On
Exit
