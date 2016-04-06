<#
Created by DM 250316
Veeam Cloud Connect Report V1.0
#>
$script:veeamcloudsrv ="myveeamcloudsrv"
$script:session = new-PSSession -ComputerName $script:veeamcloudsrv -Credential admin
$script:emailServer = "emailsvr"
$script:sender = "blog@mcisaacit.com"
$script:recipients = "blog@mcisaacit.com"
    

Invoke-command { Add-PSSnapin VeeamPSSnapin } -session $script:session

Export-PSSession -session $script:session -commandname *-br* -outputmodule vbr -allowclobber -Force
Import-Module vbr

#style sheet
$script:Style = "
<style>
    H1{font: 14pt Calibri Light;font-weight: bold;color:#394F1B}
    H2{font: 14pt Calibri Light;font-weight: bold;color:#394F1B}
    P{font: 12pt Calibri Light;color:black}
    BODY{background-color:white;}
    TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
    TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#8EC14A; font: 10pt Calibri Light; font-weight: bold;}
    TD{border-width: 1px;padding: 3px;border-style: solid;border-color: black; font: 10pt Calibri Light;}
    tr:nth-child(odd) { background-color:#BFE373;} 
    tr:nth-child(even) { background-color:white;}    
</style>
"

function run-VeeamCloudReport
    {
        connect-veeamServer
        get-customerInfo
        start-sendmail
        disconnect-veeamServer
    }  

Function connect-veeamServer
    {#load snapin and connect to veeam server
    Add-PSSnapin VeeamPSSnapin
    Connect-VBRServer -Server $script:veeamcloudsrv -ErrorAction Ignore
    }
Function get-customerInfo
    {#Run and build report
    #param($Style)
    $runreport = Get-VBRCloudTenant|Select-Object -Property Name,VMcount,LastActive -ExpandProperty resources
    $buildreport = $runreport|select @{Label="Customer";expression={$_.Name}},@{Label="Virtual Machines";expression={$_.VMcount}},@{Label="Used Space GB";expression={"{0:N2}" -f ($_.UsedSpace/1024)}},LastActive,@{Label="Billed Usage in Pounds";expression={"{0:N2}" -f (($_.UsedSpace/1024)*0.18)}}|ConvertTo-HTML -AS Table -Fragment|Out-String  
    $totalvms = $runreport| Measure-Object -Property vmcount -Sum |select @{Label="Total";expression={$_.sum}} |ConvertTo-HTML -AS List -Fragment -PreContent "<h2>Total Virtual Machines Licences Required</h1>" |Out-String  
    $script:formatreport = ConvertTo-HTML -head $Style -PostContent $buildreport, $totalvms
    }

Function start-sendMail
    {#Generate email and send
    $Header = "Veeam Cloud Connect Report"
    $body =@" 
      <h2>Veeam Cloud Connect Monthly Customer Report</h2>
      <p>Report Generated on $(get-date) by $script:veeamcloudsrv</p>
      <p>$script:formatreport</p> 
      <p>
      Usage is calcualted at 18p per GB
      <br>
"@
    send-mailmessage -from $script:sender -to $script:recipients -subject "$header" -Bodyashtml "$body" -smtpserver $script:emailServer
    }
Function disconnect-veeamServer
    {
    Disconnect-VBRServer   
    }

#run report auto
run-VeeamCloudReport