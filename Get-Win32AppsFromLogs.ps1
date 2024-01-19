<#
.SYNOPSIS
    Get Win32 Apps deployed on the Machine from IntuneManagementExtension Log

.DESCRIPTION
    This script will get all the Win32 Apps deployed from the IntuneManagementExtension Logs along with the App id
    
.NOTES
    FileName:    Get-Win32AppsFromLogs.ps1
    Author:      Nakul Bhargava
    Date:        19 Jan 2024

.PARAMETER Log Folder
        The path the script will look for is C:\ProgramData\Microsoft\IntuneManagementExtension\Logs



.EXAMPLE
    .\Get-Win32AppsFromLogs.ps1


    
#>

$allLogspath=Get-ChildItem "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs" | where {$_.name -match "IntuneManagementExtension"} | select -ExpandProperty fullname
foreach($logs in $allLogspath)
    {
    $allLogs=Get-Content $logs
    $allpol=$allLogs | where{$_ -match "Get Policies"}
    $splitLogs=$allpol.Split(",")
    $finObj=@()
 
    for($i=0;$i -le $splitLogs.Count;$i++)
        {
            if($splitLogs[$i] -match '{"Id":')
                {
                    $ID=$splitLogs[$i] -replace ".*(:)","" -replace '"',""  
                    $name=$splitLogs[$i+1] -replace ".*(:)","" -replace ".*({)","" -replace '"',""  
                    $obj=New-Object PSobject
                    $obj | Add-Member -MemberType NoteProperty -Name AppID -Value $ID
                    $obj  | Add-Member -MemberType NoteProperty -Name Name -Value $name
                    $finObj+=$obj
                }
        }
  
}
 $selectedApp= $finObj | select -Unique -Property Name,AppID | Out-GridView -Title "Win32 Apps in these Logs" -PassThru
