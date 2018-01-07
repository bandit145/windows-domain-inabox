<#
.Synopsis
    This script allows you to bulk creat users and computers (in nested ous if wished)
.Example
    ./ad_populate.ps1 -TopOuName test -NumberofADObjects 500 $NumberofOUChildren 4 -AccountType computer

#>

param(
    [parameter(Mandatory=$true)]
    [String]$TopOUName,
    [parameter(Mandatory=$true)]
    [Int]$NumberofADObjects,
    [Int]$NumberofOUChildren=0,
    [parameter(Mandatory=$true)]
    [ValidateSet('user','computer')]$AccountType
)

$ErrorActionPreference = "Stop"

Import-Module ActiveDirectory
$start_location = Get-Location
try{
    Set-Location -Path (-join("AD:\",(Get-ADRootDSE -ErrorAction "Stop").defaultnamingcontext))
    New-ADOrganizationalUnit -Name $TopOUName -ProtectedFromAccidentalDeletion $false
    Set-Location -Path (-join("ou=",$TopOUName))

    foreach($ou in 0..$NumberofOUChildren){
        foreach($adobj in 0..($NumberofADObjects-1)){
            if($AccountType -eq "user"){
                New-ADUser -Name (-join("user_",(Get-Random)))
            }
            else{
                New-ADComputer -Name (-join("computer_",(Get-Random)))
            }
        }
        #If not at end keep creating ous
        if ($ou -ne $NumberofOUChildren){
            $ou_num = Get-Random
            New-ADOrganizationalUnit -Name (-join("ou_",$ou_num)) -ProtectedFromAccidentalDeletion $false
            Set-Location -Path (-join("ou=ou_",$ou_num))
        }

    }
    Set-Location -Path $start_location
}
catch{
    Set-Location -Path $start_location
    Write-Error $Error[0]
}
