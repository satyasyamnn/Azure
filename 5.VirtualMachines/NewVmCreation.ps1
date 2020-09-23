# Connect-AzAccount

$resourceGroup = Get-AzResourceGroup -Name AZ104 -Location 'East US'

# Create virtual network with front end subnet

$frontEndsubnet = New-AzVirtualNetworkSubnetConfig -Name frontend -AddressPrefix 10.0.0.0/24
New-AzVirtualNetwork -Name VNet01 `
                     -ResourceGroupName $resourceGroup.ResourceGroupName `
                     -Location $resourceGroup.Location `
                     -AddressPrefix 10.0.0.0/16 `
                     -Subnet $frontEndsubnet

# Add backend subnet 

$backEndsubnet = New-AzVirtualNetworkSubnetConfig -Name backend -AddressPrefix 10.0.1.0/24
$virtualnetwork = Get-AzVirtualNetwork -Name VNet01 -ResourceGroupName $resourceGroup.ResourceGroupName
$virtualnetwork.Subnets.Add($backEndsubnet)
Set-AzVirtualNetwork -VirtualNetwork $virtualnetwork

# Create New Public IP Address 

New-AzPublicIpAddress -Name VM01pip `
                      -ResourceGroupName $resourceGroup.ResourceGroupName `
                      -Location $resourceGroup.Location `
                      -Sku Standard `
                      -AllocationMethod Static `
                      -IpAddressVersion IPv4                      

$vm01pip = Get-AzPublicIpAddress -Name VM01pip -ResourceGroupName $resourceGroup.ResourceGroupName

# Create New VM

## Get-AzVMSize -Location $resourceGroup.ResourceGroupName | where Name -EQ 'Standard_DS4_v2'

                                  
$credentials = Get-Credential -Message "Provide Credentials" 

New-AzVM -ResourceGroupName $resourceGroup.ResourceGroupName `
         -Location $resourceGroup.Location `
         -Name VM01 `
         -Credential $credentials `
         -VirtualNetworkName $virtualnetwork.Name `
         -SubnetName $frontEndsubnet.Name `
         -PublicIpAddressName $vm01pip.Name `
         -Size 'Standard_DS4_v2' `
         -Image Win2016Datacenter


        
         
