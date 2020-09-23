# Connect to Azure Account 

## Connect-AzAccount

# Get resource group
$resourceGroupName = 'AZ104'
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -Location 'East Us'

$VNetName  = "VNetData"
$FESubName = "FrontEnd"
$BESubName = "Backend"
$GWSubName = "GatewaySubnet"

# Create VirtualNetwork with 2 address prefix, front end, back end and gateway subnet

$vnet01AddressPrefix1 = '192.168.0.0/16'
$vnet01AddressPrefix2 = '10.254.0.0/16'

$feSubNetPrefix = '192.168.1.0/24'
$fesub = New-AzVirtualNetworkSubnetConfig -Name $FESubName -AddressPrefix $feSubNetPrefix

$beSubnetPrefix = '10.254.1.0/24'
$beSub= New-AzVirtualNetworkSubnetConfig -Name $BESubName -AddressPrefix $beSubnetPrefix

$gwSubnetPrefix = '192.168.200.0/26'
$gwSub= New-AzVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $gwSubnetPrefix

New-AzVirtualNetwork -Name $VNetName -Location $resourceGroup.Location -ResourceGroupName $resourceGroup.ResourceGroupName `
                     -AddressPrefix $vnet01AddressPrefix1, $vnet01AddressPrefix2 `
                     -Subnet $fesub, $besub, $gwsub

# Create public ip for Gateway, when creating the Gatway we will use this

## Get gateway subnet details 

$vnet = Get-AzVirtualNetwork -Name $VNetName `
                             -ResourceGroupName $resourceGroup.ResourceGroupName `                             

$gwSubnet = Get-AzVirtualNetworkSubnetConfig -Name $GWSubName `
                                             -VirtualNetwork $vnet

$GWIPName = "VNetDataGWPIP"
$pip = New-AzPublicIpAddress -Name $GWIPName `
                             -ResourceGroupName $resourceGroup.ResourceGroupName `
                             -Location $resourceGroup.Location `
                             -AllocationMethod Static `
                             -Sku Standard `
                             -IpAddressVersion IPv4 `

$GWIPconfName = "gwipconf"
$ipconf = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName `
                                              -PublicIpAddress $pip `
                                              -Subnet $gwSubnet                                   

# Create VPN Gateway

$GWName = "VNetDataGW"

New-AzVirtualNetworkGateway -Name $GWName `
                            -ResourceGroupName $resourceGroup.ResourceGroupName `
                            -Location $resourceGroup.Location `
                            -GatewayType Vpn `
                            -VpnType RouteBased `
                            -GatewaySku VpnGw1 `
                            -VpnClientProtocol IkeV2 `
                            -IpConfigurations $ipconf  `
                            -EnableBgp $false



