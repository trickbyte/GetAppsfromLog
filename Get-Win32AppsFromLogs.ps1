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
 $selectedApp