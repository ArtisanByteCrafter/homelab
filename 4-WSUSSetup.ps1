param(
[Parameter]
[string]$InstallDir = "$env:SystemDrive"
)

# https://blogs.technet.microsoft.com/heyscriptingguy/2013/04/15/installing-wsus-on-windows-server-2012/

Install-WindowsFeature -Name UpdateServices -IncludeManagementTools
If ((Test-Path $InstallDir) -eq $false) {
    New-Item -Path $InstallDir -Name WSUS -ItemType Directory
}

& "C:\Program Files\Update Services\Tools\wsusutil.exe" postinstall CONTENT_DIR=$InstallDir

Invoke-BpaModel -ModelId Microsoft/Windows/UpdateServices

Get-BpaResult -ModelId Microsoft/Windows/UpdateServices | Select-Object Title, Severity, Compliance | Format-List

#Get WSUS Server Object
$wsus = Get-WSUSServer

#Connect to WSUS server configuration
$wsusConfig = $wsus.GetConfiguration()
 
#Set to download updates from Microsoft Updates
Set-WsusServerSynchronization –SyncFromMU

#Set Update Languages to English and save configuration settings
$wsusConfig.AllUpdateLanguagesEnabled = $false           
$wsusConfig.SetEnabledUpdateLanguages(“en”)           
$wsusConfig.Save()

#Get WSUS Subscription and perform initial synchronization to get latest categories
$subscription = $wsus.GetSubscription()
$subscription.StartSynchronizationForCategoryOnly()

# for reference
$wsusproducts = @'
    'Active Directory Rights Management Services Client 2.0
    Active Directory
    Antigen for Exchange / SMTP
    Antigen
    ASP.NET Web and Data Frameworks
    ASP.NET Web Frameworks
    Azure Information Protection Client Dogfood Tool
    Bing Bar
    Bing
    BizTalk Server 2002
    BizTalk Server 2006R2
    BizTalk Server 2009
    BizTalk Server 2013
    BizTalk Server
    CAPICOM
    Category for System Center Online Client
    Compute Cluster Pack
    Data Protection Manager 2006
    Developer Tools, Runtimes, and Redistributables
    Device Health
    Device Health
    Dictionary Updates for Microsoft IMEs
    Exchange 2000 Server
    Exchange Server 2003
    Exchange Server 2007 and Above Anti-spam
    Exchange Server 2007
    Exchange Server 2010
    Exchange Server 2013
    Exchange Server 2016
    Exchange
    Expression Design 1
    Expression Design 2
    Expression Design 3
    Expression Design 4
    Expression Media 2
    Expression Media V1
    Expression Web 3
    Expression Web 4
    Expression
    Firewall Client for ISA Server
    Forefront Client Security
    Forefront Endpoint Protection 2010
    Forefront Identity Manager 2010 R2
    Forefront Identity Manager 2010
    Forefront Protection Category
    Forefront Server Security Category
    Forefront Threat Management Gateway, Definition Updates for HTTP Malware Inspection
    Forefront TMG MBE
    Forefront TMG
    Forefront
    HealthVault Connection Center Upgrades
    HealthVault Connection Center
    Host Integration Server 2000
    Host Integration Server 2004
    Host Integration Server 2006
    Host Integration Server 2009
    Host Integration Server 2010
    HPC Pack 2008
    HPC Pack
    Internet Security and Acceleration Server 2004
    Internet Security and Acceleration Server 2006
    Internet Security and Acceleration Server
    Local Publisher
    Locally published packages
    Microsoft Advanced Threat Analytics
    Microsoft Advanced Threat Analytics
    Microsoft Application Virtualization 4.5
    Microsoft Application Virtualization 4.6
    Microsoft Application Virtualization 5.0
    Microsoft Application Virtualization
    Microsoft Azure Information Protection Client
    Microsoft Azure Information Protection
    Microsoft Azure Site Recovery Provider
    Microsoft Azure
    Microsoft BitLocker Administration and Monitoring v1
    Microsoft BitLocker Administration and Monitoring
    Microsoft Dynamics CRM 2011 SHS
    Microsoft Dynamics CRM 2011
    Microsoft Dynamics CRM 2013
    Microsoft Dynamics CRM 2015
    Microsoft Dynamics CRM 2016 SHS
    Microsoft Dynamics CRM 2016
    Microsoft Dynamics CRM
    Microsoft HealthVault
    Microsoft Lync 2010
    Microsoft Lync Server 2010
    Microsoft Lync Server 2013
    Microsoft Lync Server and Microsoft Lync
    Microsoft Monitoring Agent (MMA)
    Microsoft Monitoring Agent
    Microsoft Online Services Sign -In Assistant
    Microsoft Online Services
    Microsoft Research AutoCollage 2008
    Microsoft Research AutoCollage
    Microsoft Security Essentials
    Microsoft SQL Server 2008 R2 - PowerPivot for Microsoft Excel 2010
    Microsoft SQL Server 2012
    Microsoft SQL Server 2014
    Microsoft SQL Server 2016
    Microsoft SQL Server Management Studio v17
    Microsoft SQL Server PowerPivot for Excel
    Microsoft StreamInsight V1.0
    Microsoft StreamInsight
    Microsoft System Center Data Protection Manager
    Microsoft System Center DPM 2010
    Microsoft System Center Virtual Machine Manager 2007
    Microsoft System Center Virtual Machine Manager 2008
    Microsoft Works 8
    Microsoft Works 9
    Microsoft
    MS Security Essentials
    Network Monitor 3
    Network Monitor
    New Dictionaries for Microsoft IMEs
    Office 2002 / XP
    Office 2003
    Office 2007
    Office 2010
    Office 2013
    Office 2016
    Office 365 Client
    Office Communications Server 2007 R2
    Office Communications Server 2007
    Office Communications Server And Office Communicator
    Office Communicator 2007 R2
    Office Live Add -in 
    Office Live
    Office
    OneCare Family Safety Installation
    OOBE ZDP
    Photo Gallery Installation and Upgrades
    Report Viewer 2005
    Report Viewer 2008
    Report Viewer 2010
    SDK Components
    Search Enhancement Pack
    Security Essentials
    Service Bus for Windows Server 1.1
    Silverlight
    Silverlight
    Skype for Business Server 2015, SmartSetup
    Skype for Business Server 2015
    Skype for Business
    Skype for Windows
    Skype
    SQL Server 2000
    SQL Server 2005
    SQL Server 2008 R2
    SQL Server 2008
    SQL Server 2012 Product Updates for Setup
    SQL Server 2014 - 2016 Product Updates for Setup
    SQL Server Feature Pack
    SQL Server
    System Center 2012 - App Controller
    System Center 2012 - Data Protection Manager
    System Center 2012 - Operations Manager
    System Center 2012 - Orchestrator
    System Center 2012 - Virtual Machine Manager
    System Center 2012 R2 - Data Protection Manager
    System Center 2012 R2 - Operations Manager
    System Center 2012 R2 - Orchestrator
    System Center 2012 R2 - Virtual Machine Manager
    System Center 2012 SP1 - App Controller
    System Center 2012 SP1 - Data Protection Manager
    System Center 2012 SP1 - Operation Manager
    System Center 2012 SP1 - Virtual Machine Manager
    System Center 2016 - Data Protection Manager
    System Center 2016 - Operations Manager
    System Center 2016 - Orchestrator
    System Center 2016 - Virtual Machine Manager
    System Center Advisor
    System Center Configuration Manager 2007
    System Center Online
    System Center Virtual Machine Manager
    System Center
    Systems Management Server 2003
    Systems Management Server
    Threat Management Gateway Definition Updates for Network Inspection System
    TMG Firewall Client
    Virtual PC
    Virtual Server
    Virtual Server
    Visual Studio 2005
    Visual Studio 2008
    Visual Studio 2010 Tools for Office Runtime
    Visual Studio 2010 Tools for Office Runtime
    Visual Studio 2010
    Visual Studio 2012
    Visual Studio 2013
    Windows 10 and later drivers
    Windows 10 and later upgrade & servicing drivers
    Windows 10 Anniversary Update and Later Servicing Drivers
    Windows 10 Anniversary Update and Later Upgrade & Servicing Drivers
    Windows 10 Creators Update and Later Servicing Drivers
    Windows 10 Creators Update and Later Servicing Drivers
    Windows 10 Creators Update and Later Upgrade & Servicing Drivers
    Windows 10 Dynamic Update
    Windows 10 Feature On Demand
    Windows 10 GDR-DU LP
    Windows 10 GDR-DU
    Windows 10 Language Interface Packs
    Windows 10 Language Packs
    Windows 10 LTSB
    Windows 10 S and Later Servicing Drivers
    Windows 10
    Windows 2000
    Windows 7
    Windows 8 Dynamic Update
    Windows 8 Embedded
    Windows 8 Language Interface Packs
    Windows 8 Language Packs
    Windows 8.1 and later drivers
    Windows 8.1 Drivers
    Windows 8.1 Dynamic Update
    Windows 8.1 Language Interface Packs
    Windows 8.1 Language Packs
    Windows 8.1
    Windows 8
    Windows Azure Pack - Web Sites
    Windows Azure Pack: Admin API
    Windows Azure Pack: Admin Authentication Site
    Windows Azure Pack: Admin Site
    Windows Azure Pack: Configuration Site
    Windows Azure Pack: Microsoft Best Practice Analyzer
    Windows Azure Pack: Monitoring Extension
    Windows Azure Pack: MySQL Extension
    Windows Azure Pack: PowerShell API
    Windows Azure Pack: SQL Server Extension
    Windows Azure Pack: Tenant API
    Windows Azure Pack: Tenant Authentication Site
    Windows Azure Pack: Tenant Public API
    Windows Azure Pack: Tenant Site
    Windows Azure Pack: Usage Extension
    Windows Azure Pack: Web App Gallery Extension
    Windows Azure Pack: Web Sites
    Windows Azure Pack
    Windows Defender
    Windows Dictionary Updates
    Windows Embedded Developer Update
    Windows Embedded Standard 7
    Windows Embedded
    Windows Essential Business Server 2008 Setup Updates
    Windows Essential Business Server 2008
    Windows Essential Business Server Preinstallation Tools
    Windows Essential Business Server
    Windows GDR-Dynamic Update
    Windows Internet Explorer 7 Dynamic Installer
    Windows Internet Explorer 8 Dynamic Installer
    Windows Live Toolbar
    Windows Live
    Windows Live
    Windows Live
    Windows Media Dynamic Installer
    Windows Next Graphics Driver Dynamic update
    Windows RT 8.1 and later drivers
    Windows RT 8.1 Drivers
    Windows RT 8.1
    Windows RT Drivers
    Windows RT
    Windows Server 2003, Datacenter Edition
    Windows Server 2003
    Windows Server 2008 R2
    Windows Server 2008 Server Manager Dynamic Installer
    Windows Server 2008
    Windows Server 2012 Language Packs
    Windows Server 2012 R2  and later drivers
    Windows Server 2012 R2 Drivers
    Windows Server 2012 R2 Language Packs
    Windows Server 2012 R2
    Windows Server 2012
    Windows Server 2016 and Later Servicing Drivers
    Windows Server 2016
    Windows Server Drivers
    Windows Server Manager – Windows Server Update Services (WSUS) Dynamic Installer
    Windows Server Solutions Best Practices Analyzer 1.0
    Windows Server Technical Preview Language Packs
    Windows Small Business Server 2003
    Windows Small Business Server 2008 Migration Preparation Tool
    Windows Small Business Server 2008
    Windows Small Business Server 2011 Standard
    Windows Small Business Server
    Windows Ultimate Extras
    Windows Vista Dynamic Installer
    Windows Vista Ultimate Language Packs
    Windows Vista
    Windows XP 64-Bit Edition Version 2003
    Windows XP Embedded
    Windows XP x64 Edition
    Windows XP
    Windows
    Works 6 - 9 Converter
    Works
    Writer Installation and Upgrades'
'@

#Configure the Platforms that we want WSUS to receive updates
Get-WsusProduct | Where-Object {

    $_.Product.Title -in (

        'Silverlight',
        
        'Windows 10 and later drivers',

        'Windows Server 2012 R2')

} | Set-WsusProduct

#Configure the Classifications
Get-WsusClassification | Where-Object {$_.Classification.Title -in (

    'Update Rollups',

    'Security Updates',

    'Critical Updates',

    'Service Packs',

    'Updates')

} | Set-WsusClassification

#Configure Synchronizations
$subscription.SynchronizeAutomatically=$true

#Set synchronization scheduled for midnight each night
$subscription.SynchronizeAutomaticallyTimeOfDay= (New-TimeSpan -Hours 0)
$subscription.NumberOfSynchronizationsPerDay=1
$subscription.Save()

#Kick off a synchronization
$subscription.StartSynchronization()
