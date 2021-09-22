
Connect-VIServer -Server vcsa-01a.corp.local -Protocol https -User administrator@corp.local -Password VMware1!

$NewNetwork = "LabNet" 
$OldNetwork = "web-seg"
$VMName = "phoenix-web-01"
Get-VM -Name $VMName |Get-NetworkAdapter |Where-Object {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -Portgroup $NewNetwork -Confirm:$false

$VMName = "phoenix-web-02"
Get-VM -Name $VMName |Get-NetworkAdapter |Where-Object {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -Portgroup $NewNetwork -Confirm:$false

$VMName = "RDSH-sv-01a"
Get-VM -Name $VMName |Get-NetworkAdapter |Where-Object {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -Portgroup $NewNetwork -Confirm:$false

$VMName = "srv-findata"
Get-VM -Name $VMName |Get-NetworkAdapter |Where-Object {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -Portgroup $NewNetwork -Confirm:$false


$OldNetwork = "app-seg"
$VMName = "phoenix-app-01"
Get-VM -Name $VMName |Get-NetworkAdapter |Where-Object {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -Portgroup $NewNetwork -Confirm:$false

$OldNetwork = "db-seg"
$VMName = "phoenix-db-01"
Get-VM -Name $VMName |Get-NetworkAdapter |Where-Object {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -Portgroup $NewNetwork -Confirm:$false
