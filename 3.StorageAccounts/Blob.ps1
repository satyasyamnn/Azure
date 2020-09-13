## Code excercise 

## Install Required modules 

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module Az.Storage
Install-Module Az.Resources

## Adding storage account 
Add-AzAccount

## Get storage account 
$storageAccount =  Get-AzStorageAccount

## Deploy storage account from template 
New-AzResourceGroupDeployment -ResourceGroupName $storageAccount.ResourceGroupName `
                              -TemplateFile .\template.json `
                              -Name storage-deployment  

## Set Default storage account to use 
Set-AzCurrentStorageAccount -ResourceGroupName $storageAccount.ResourceGroupName -Name castorstivgg75oorpx6m

## Save image on desktop
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/cloudacademy/azure-lab-provisioners/master/azure-storage/image.png" -OutFile C:\Users\student\Desktop\image.png

## Create blob container 
New-AzStorageContainer -Name images -Permission Off

## Save image to container
Set-AzStorageBlobContent -Container images -File .\Desktop\image.png

## Get blob uploaded 
$blob = Get-AzStorageBlob -Container images -Blob image.png
$blob.ICloudBlob.StorageUri

# Generator SAS Token
New-AzStorageBlobSASToken -Container images -Blob image.png -Permission r

# Create another blob with metadata
$Metadata = @{ Type = "Wallpaper" }
Set-AzStorageBlobContent -Container images -File  C:\Windows\Web\Wallpaper\Theme1\img13.jpg  -Metadata $Metadata

# Query blob container to have blobs with metadata wallpaper
$wallpaper = Get-AzStorageBlob -Container images | Where-Object {$_.ICloudBlob.Metadata["Type"] -eq "Wallpaper"}
Get-AzStorageBlobContent -CloudBlob $wallpaper.ICloudBlob

# Create one more container
New-AzStorageContainer -Name wallpapers -Permission Container

# Copy blobk from images container to wall papers container 
Start-AzStorageBlobCopy -CloudBlob $wallpaper.ICloudBlob -DestContainer wallpapers

# Get Copy state 
Get-AzStorageBlobCopyState -Blob $wallpaper.Name -Container wallpapers

# Remove blob from a container
Remove-AzStorageBlob -CloudBlob $wallpaper.ICloudBlob


