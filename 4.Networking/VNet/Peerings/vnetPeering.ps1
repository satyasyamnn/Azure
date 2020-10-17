# Login to azure account 

Login-AzAccount

# Get Virtual networks 

$resourceGroupName = 'Az104'
$vNet01 = Get-AzVirtualNetwork -Name VNet01-eastus -ResourceGroupName $resourceGroupName 
$vNet02 = Get-AzVirtualNetwork -Name VNet02-Westus -ResourceGroupName $resourceGroupName 

# Peering from Vnet2 to VNet1

Add-AzVirtualNetworkPeering -Name Vnet2-Vnet1 -VirtualNetwork $vNet02 -RemoteVirtualNetworkId $vNet01.Id 

# Peering from VNet1 to VNet2 

Add-AzVirtualNetworkPeering -Name Vnet1-VNet2 -VirtualNetwork $VNet01 -RemoteVirtualNetworkId $vNet02.Id



                                    