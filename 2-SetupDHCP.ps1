Add-Dhcpserverv4ExclusionRange @ExclusionParams

$ServerV4Scope = @{
    ComputerName = 'DC1'
    ScopeID = '192.168.200.0'
    State = 'Active'
}

Set-DhcpServerv4Scope @ServerV4Scope

$DhcpOptions = @{
    ComputerName = 'dc1.testdomain.local'
    ScopeID = '192.168.200.0'
    DnsServer = '192.168.200.3'
    DnsDomain = 'testdomain.local'
    Router = '192.168.200.2'
}

Set-DhcpServerv4OptionValue @DhcpOptions

Add-DhcpServerSecurityGroup -ComputerName 'dc1.testdomain.local'
