## Setup working variables.
$FwProfileName = "Domain"
$FwLog = Get-NetFirewallProfile -Name $FwProfileName | Select-Object LogFileName
$WorkingFile = "$env:TEMP\FWLog_Temp.csv"

## Get the column headers from the Firewall Log File and turn it into a String Array to use as a header later.
[string]$FieldList = Select-String -Path $FwLog.LogFileName -Pattern "Fields"
$HeaderFields = $FieldList.Substring($FieldList.IndexOf(": ")+2).Replace(" ",',')
$CsvHeader = $HeaderFields -split ","

## Pull data from Firewall Log file (Need to run as admin), skip the first 5 rows of junk and then create our working CSV data.
$CsvBody = Get-Content -Path $FwLog.LogFileName | Select-Object -Skip 5
$CsvBody | Out-File -FilePath $WorkingFile -Force
$CsvFinal = Import-Csv -Path $WorkingFile -Delimiter " " -Header $CsvHeader

## Clean up after ourselves.
Remove-Item -Path $WorkingFile -Force

## Let's see what is talking to our server.
## https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
$CsvFinal | Where-Object {
    $_.Path -eq "RECEIVE"
} `
    | Group-Object -Property "src-ip","Protocol","dst-port" `
    | Sort-Object -Property Count -Descending `
    | Select-Object -Property Name, Count

## Now foucs on SQL Server
$CsvFinal | Where-Object {
    ($_.Path -eq "RECEIVE") -and 
    ($_."dst-port" -eq "1433" -or $_."dst-port" -eq "5022")
} `
    | Group-Object -Property "src-ip","Protocol","dst-port" `
    | Sort-Object -Property Count -Descending `
    | Select-Object -Property Name, Count

## Now we set the Firewall Rules which we want on the Server.
## https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-firewall/create-an-inbound-program-or-service-rule
## TDS Traffic to SQL Server.
$FirewallRuleParams = @{
    Name = "Allow_TCP_1433_In"
    DisplayName = "Allow TCP 1433 In"
    Description = "Rule to allow all inbound TCP traffic to port 1433 for SQL Server."
    Action = "Allow"
    Direction = "Inbound"
    Profile = "Domain"
    RemoteAddress = "192.168.1.10"
    LocalPort = "1433"
    Service = "MSSQLSERVER"
    Enabled = "False"
}
New-NetFirewallRule @FirewallRuleParams
## AG Synchronisation Traffic to SQL Server.
$FirewallRuleParams = @{
    Name = "Allow_TCP_5022_In"
    DisplayName = "Allow TCP 5022 In"
    Description = "Rule to allow all inbound TCP traffic to port 5022 for SQL Server Availability Group syncronisation traffic."
    Action = "Allow"
    Direction = "Inbound"
    Profile = "Domain"
    RemoteAddress = "192.168.1.13"
    LocalPort = "5022"
    Service = "MSSQLSERVER"
    Enabled = "False"
}
New-NetFirewallRule @FirewallRuleParams

## Enable new rules, disable allow all.
Set-NetFirewallRule -Name "Allow_TCP_5022_In" -Enabled "True"
Set-NetFirewallRule -Name "Allow_TCP_1433_In" -Enabled "True"
Set-NetFirewallRule -Name "AllowAll-In" -Enabled "False"

