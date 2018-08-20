Install-WindowsFeature -Name DHCP -IncludeManagementTools

Import-Module DhcpServer

Add-DhcpServerInDC -DnsName 'dc1.testdomain.local' -IPAddress 192.168.202.3

$DHCPScope = @{
    Name        = 'TestNetwork'
    StartRange  = '192.168.202.1'
    EndRange    = '192.168.202.254'
    SubnetMask  = '255.255.255.0'
    Description = 'Network for TestDomain'
    LeaseDuration = (New-TimeSpan -Hours 2)
    ComputerName = 'dc1.testdomain.local'
    Type = 'Both'
    State = 'Active'   
}

Add-DHCPServerv4Scope @DHCPScope

$ExclusionParams = @{
    DCDnsName = 'dc1.testdomain.local'
    ComputerName = 'DC1'
    StartRange = '192.168.202.1'
    EndRange = '192.168.202.40'
    ScopeID = '192.168.202.0'
}


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
