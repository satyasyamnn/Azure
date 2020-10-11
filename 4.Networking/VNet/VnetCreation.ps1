# Login to Azure Account

# Login-AzAccount

# Get Resource Group
$resourceGroup = Get-AzResourceGroup -Name AZ104 -Location 'East US'

# Method 1 

$vnet01Name = 'VNet01_Powershell'
$vnet01AddresPrefix = '10.0.0.0/16'

# Create subnet configuration

$vnet01FrontEndSubnet = New-AzVirtualNetworkSubnetConfig -Name frontEnd -AddressPrefix 10.0.0.0/24
$vnet01BackendSubnet = New-AzVirtualNetworkSubnetConfig -Name backEnd -AddressPrefix 10.0.1.0/24

# Create virtual network from subnet configuration

New-AzVirtualNetwork -Name $vnet01Name `
                     -ResourceGroupName $resourceGroup.ResourceGroupName `
                     -Location $resourceGroup.Location `
                     -AddressPrefix $vnet01AddresPrefix `
                     -Subnet $vnet01FrontEndSubnet, $vnet01BackendSubnet

# Get virtual network details 

$vnet01Network = Get-AzVirtualNetwork -Name $vnet01Name `
                                      -ResourceGroupName $resourceGroup.ResourceGroupName `

# Method 2 

$vnet02Name = 'VNet02_Powershell'
$vnet02AddresPrefix = '10.1.0.0/16'

# Create virtual network

$Vnet02Network = New-AzVirtualNetwork -Name $vnet02Name `
                                      -ResourceGroupName $resourceGroup.ResourceGroupName `
                                      -Location $resourceGroup.Location `
                                      -AddressPrefix $vnet02AddresPrefix 

# Create subnets 

$vnet02FrontEndSubnet =  Add-AzVirtualNetworkSubnetConfig -Name frontend -AddressPrefix 10.1.0.0/24 -VirtualNetwork $Vnet02Network
$vnet02BackEndSubnet = Add-AzVirtualNetworkSubnetConfig -Name backend -AddressPrefix 10.1.1.0/24 -VirtualNetwork $Vnet02Network


# save virtualnetwork

$Vnet02Network | Set-AzVirtualNetwork

# Get virtualnetwork details 
$vnet02Network = Get-AzVirtualNetwork -Name $vnet02Name `
                                      -ResourceGroupName $resourceGroup.ResourceGroupName `

