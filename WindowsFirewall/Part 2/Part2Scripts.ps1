Get-NetFirewallRule -DisplayName "Allow all In"

$FirewallRuleParams = @{
    Name = "AllowAll-In"
    DisplayName = "Allow All In"
    Description = "Rule to allow all inbound traffic for logging purposes."
    Action = "Allow"
    Direction = "Inbound"
    Profile = "Domain"
    Enabled = "False"
}
$Rule = New-NetFirewallRule @FirewallRuleParams

$MaxLogSizeMB = 32MB
$FirewallLoggingParams = @{
    Profile = "Domain"
    LogFileName = 'L:\Logs\Firewall\DomainProfile.log'
    LogAllowed = "True"
    LogBlocked = "True"
    LogIgnored = "True"
    LogMaxSizeKilobytes = (($MaxLogSizeMB/1KB)-1)
    Verbose = $True
}
Set-NetFirewallProfile @FirewallLoggingParams

$EnableFirewallRule = @{
    Name = "AllowAll-In"
    Enabled = "True"
    Verbose = $True
}
Set-NetFirewallRule @EnableFirewallRule

$EnableDomainProfile = @{
    Name = "Domain"
    Enabled = "True"
    Verbose = $True
}
Set-NetFirewallProfile @EnableDomainProfile