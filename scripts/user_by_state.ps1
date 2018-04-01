#accept command line input
param(
    #make this param required
    [parameter(Mandatory=$true)]
    [String]$State
)
#Set this powershell session to make all errors terminating
$ErrorActionPreference = "Stop"
#AD module will autoload when one of it's cmdlts is called but I like listing it
Import-Module ActiveDirectory

$raw_users = Get-ADUser -Filter * -Properties "State"
#instantiate the ArrayList object
$user_arraylist = [System.Collections.ArrayList]::new()
#swap these to an array list
foreach($user in $raw_users){
    $user_arraylist.add($user) | Out-Null
}
#filter them (arraylists are mutable this is why they are handy)
#remove any from the list that are not in the state asked
for($i=$user_arraylist.count; $i -gt 0; $i--){
    if ($user_arraylist[$i-1].State -ne $State){
        $user_arraylist.RemoveAt($i-1)
    }
}
#To output to CSV you create an array of hastables with the same keys
#instantiate powershell array
$csv_data = @()
foreach($user in $user_arraylist){
    $csv_data += New-Object PSObject -Property @{user=$user.SamAccountName;State=$user.State}
}

$csv_data | Export-Csv -NoTypeInformation -Path "user_state.csv"
