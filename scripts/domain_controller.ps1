param(
    [Bool]$InitialDomainController = $false,
    [parameter(Mandatory=$true)]
    [String]$ComputerName,
    [String]$PrimaryDNS = ""

    ) 

Import-Module PSWorkflow
$ErrorActionPreference="Stop"

workflow DeployDomainController{
    param([String]$ComputerName,[Bool]$InitialDomainController,[String]$PrimaryDNS="")
    InlineScript{
        $ErrorActionPreference="Stop"
        $domain_name = "ad.skoopycorp.com"
        try{
            $ipaddr = Get-NetIPAddress -InterfaceAlias "ethernet" | Where-Object{$_.AddressFamily -eq "IPv4"}
            if ($env:computername -ne $ComputerName.ToUpper){
                Rename-Computer -NewName $ComputerName -Restart
            }

            Install-WindowsFeature -Name "AD-Domain-Services","DNS" -IncludeManagmenTools | Out-Null
            
            #SetDNS servers
            if ($InitialDomainController){
                Set-DNSClientServerAddress -InterfaceAlias "ethernet" -ServerAddresses $ipaddr.IPAddress,127.0.0.1
                Install-ADDSForest -DomainName $domain_name -InstallDNS $true
            }
            else{
                Set-DNSClientServerAddress -InterfaceAlias "ethernet" -ServerAddresses $PrimaryDNS,$ipaddr.IPAddress,127.0.0.1
            }
            Set-DNSClient -InterfaceAlias "ethernet" -ConnectionSpecificSuffix $domain_name

        }
        catch{
            Write-EventLog -LogName "Application" -Source "DeployDomainController" -EntryType "Error" -EventID 1 -Message $error[0]
            exit
        }
    }
}


#Job to get workflow running again or remove the scheduled job
$jobtrig= New-JobTrigger -AtStartup

if (!("ResumeWorkflow" -in (Get-ScheduledJob).Name)){
    Register-ScheduledJob -Name "ResumeWorkflow" -Trigger $jobtrig -ScriptBlock {
        Import-Module PSWorkflow
        $jobs = Get-Job  -Name "DeployDomainController" -State "Suspended"
        if($jobs.Length -eq 1){
            Resume-Job $jobs
        }
        else{
            Unregister-ScheduledJob -Name "ResumeWorkflow"
        }
    } | Out-Null
}


if (!("DeployDomainController") -in (Get-EventLog -LogName "Application").Source){
    New-EventLog -Source "DeployDomainController" -LogName "Application" | Out-Null
}

if ($PrimaryDNS -eq ""){
    DeployDomainController -JobName "DeployDomainController" -ComputerName $ComputerName -InitialDomainController $InitialDomainController
}
else{
    DeployDomainController -JobName "DeployDomainController" -ComputerName $ComputerName -InitialDomainController $InitialDomainController -PrimaryDNS $PrimaryDNS
}