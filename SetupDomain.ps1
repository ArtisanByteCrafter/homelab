$IPParams = @{
    'InterfaceAlias' =              'Ethernet0'
    'IPAddress' =                   '192.168.200.3'
    'PrefixLength' =                '24'
    'DefaultGateway' =              '192.168.200.2'
}

New-NetIPAddress @IPParams

Set-DnsClientServerAddress -InterfaceAlias Ethernet0 -ServerAddresses 127.0.0.1

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment


$ADDSForestParams = @{
    'CreateDnsDelegation' =         $false
    'DatabasePath' =                "$env:windir\NTDS"
    'DomainMode' =                  "Win2012R2"
    'DomainName' =                  "testdomain.local"
    'DomainNetbiosName' =           "TESTDOMAIN"
    'ForestMode' =                  "Win2012R2"
    'InstallDNS' =                  $true
    'LogPath' =                     "$env:windir\NTDS"
    'NoRebootOnCompletion' =        $false
    'SysvolPath' =                  "$env:windir\SYSVOL"
    'Force' =                       $true
    'SafeModeAdministratorPassword' = ('secretpassword' | ConvertTo-SecureString -AsPlainText -Force)
}

Install-ADDSForest @ADDSForestParams
