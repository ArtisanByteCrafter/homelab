#per best practices virtual DC with primary PDCEmulator role needs external time sync source.

$LocalComputer = Get-ADComputer -Identity $env:computername
$PDCEmulatorRole = Get-ADDomain | Select-Object PDCEmulator

#Set admin password to never expire
Set-ADUser -Identity Administrator -PasswordNeverExpires $true

If ($LocalComputer.dnshostname -eq $PDCEmulatorRole.PDCEmulator) {
    & w32tm /config /manualpeerlist:"0.us.pool.ntp.org,0x8 1.us.pool.ntp.org,0x8" /syncfromflags:manual /reliable:yes /update
    Restart-Service w32time
}
