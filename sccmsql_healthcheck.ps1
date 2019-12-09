<#
MP Control Manager detected management point is not responding to HTTP requests.  The HTTP status code and text is 500, Internal Server Error.

Possible cause: Management point encountered an error when connecting to SQL Server. 
Solution: Verify that the SQL Server is properly configured to allow Management Point access. Verify that management point computer account or the Management Point Database Connection Account is a member of Management Point Role (smsdbrole_MP) in the SQL Server database.

Possible cause:  The SQL Server Service Principal Names (SPNs) are not registered correctly in Active Directory
Solution:  Ensure SQL Server SPNs are correctly registered.  Review Q829868.

Possible cause: Internet Information Services (IIS) isn't configured to listen on the ports over which the site is configured to communicate. 
Solution: Verify that the designated Web Site is configured to use the same ports which the site is configured to use.

Possible cause: The designated Web Site is disabled in IIS. 
Solution: Verify that the designated Web Site is enabled, and functioning properly.

Possible cause: The MP ISAPI Application Identity does not have the requisite logon privileges. 
Solution: Verify that the account that the MP ISAPI is configured to run under has not been denied batch logon rights through group policy.

For more information, refer to Microsoft Knowledge Base article 838891.
#>
$Global:SccmPSA=$null
$Global:SccmPSB=$null
$Global:LogonServer=(($env:LOGONSERVER).ToLower().Replace( "\",""))
Set-Variable -Name Domain -Value ($env:USERDNSDOMAIN).ToLower()
Set-Variable -Name CM_Base -Value "sccm"
Set-Variable -Name CM_Svcs -Value @("cas","mp","dp","db")
Set-Variable -Name CM_Sites -Value @("a","b")
Set-Variable -Name SubDomain -Value ("inf."+$Domain)
Set-Variable -Name TestSites -Value @("mplist","mpcert")
Set-Variable -Name LaunchApp -Value ($env:ProgramFiles+"\Internet Explorer\iexplore.exe")

Function VerifyManagementPoint{
	ForEach($Site In $CM_Sites){
        For($i=1;$i-le2;$i++){
		    $MP_Server=("w19"+$CM_Base+$CM_Svcs[$i]+$Site+"01."+$SubDomain)
            If($i-eq1){
                Switch ($Site){
                    "a"{$SccmPSA=$MP_Server;Break}
                    "b"{$SccmPSB=$MP_Server;Break}
                }
            }
            ForEach($TestSite In $TestSites){
		        $SiteName=("http://"+$MP_Server+"/sms_mp/.sms_aut?"+$TestSite)
                Start-Process -FilePath $LaunchApp -ArgumentList ($SiteName) -Wait
            }
        }
	}
}
# $Return=VerifyManagementPoint
Switch ($LogonServer){
    {"dca01"-or"dca02"}{$CM_Sites="a";Break}
    {"dcb01"-or"dcb02"}{$CM_Sites="b";Break}
    Default{$CM_Sites="a";Break}
}