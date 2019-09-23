@Echo Off
Set /A Counter=0
Set Tempfile=%SystemDrive%
If Exist H:\ Goto Main
Net Use H: \\w16asccmdb01.inf.utshare.local\ClientHealth$
Set /A Counter+=1
:Main
CLS
Powershell Set-ExecutionPolicy -ExecutionPolicy ByPass
Powershell Set-ExecutionPolicy Unrestricted
Powershell Robocopy "\\w16asccmdb01.inf.utshare.local\ClientHealth$" "%Tempfile%\ClientHealth" "ConfigMgrClientHealth.ps1"
Powershell Robocopy "\\w16asccmdb01.inf.utshare.local\ClientHealth$" "%Tempfile%\ClientHealth" "Config.Xml"
CLS
Powershell "%Tempfile%\ClientHealth\ConfigMgrClientHealth.ps1" -Config "%Tempfile%\ClientHealth\Config.Xml" -Webservice https://w16asccmdb01.inf.utshare.local/ConfigMgrClientHealth
If %Counter% EQU 0 Goto End
DEL "%Tempfile%\ClientHealth" /S /F /Q
Net Use H: /D /Y
:End
CLS
@Echo On
