# Test-ADReplication.ps1

$SMTPServer = 'smtp.nasps.org'
$MailSender = "AD Health Check Monitor <ADHealthCheck@nasps.org>"
$MailTo = "a.lotfy@nasps.org"
$DClist = (get-adgroupmember "Domain Controllers").name

Import-Module Active-Directory

$DClist = (get-adgroupmember "Domain Controllers").name

Foreach ($server in $DClist) {
    $Result = (Get-ADReplicationFailure -Target $server).failurecount
    
        If ($result -ne $null -or $result -gt 0){
        
        $Subject = "Replication Failure on $Server"
        $EmailBody = @"
  
  
 There is a replication failure on $Server<br/>
 Time of Event:$((get-date))</b></font><br/>
 <br/>
 THIS EMAIL WAS AUTO-GENERATED. PLEASE DO NOT REPLY TO THIS EMAIL.
"@

    Send-MailMessage -To $MailTo -From $MailSender -SmtpServer $SMTPServer 
    -Subject $Subject -Body $EmailBody -BodyAsHtml

    }
  }