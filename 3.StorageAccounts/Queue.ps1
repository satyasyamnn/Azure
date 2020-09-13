### Queue ### 

# Create Queue
$QueueName = "thumbnail-queue"
$Queue = New-AzStorageQueue -Name $QueueName

# Add message to a queue
function Add-Message() {
  [CmdletBinding()]
  param(
    $Queue,
    $Blob
  )
  # Generate read-only SAS token for the blob
  $Sas = New-AzStorageBlobSASToken -CloudBlob $Blob.ICloudBlob -Permission r

  # Message contains blob StorageUri and Name (what is needed to generate the thumbnail)
  $MessageHashTable = @{ StorageUri = $Blob.ICloudBlob.StorageUri.PrimaryUri;
                         Sas = $Sas;
                         Name = "$($Blob.ICloudBlob.Container.Name)\$($Blob.Name)" }

  # Convert the hash table to a JSON string
  $Message = ConvertTo-Json -InputObject $MessageHashTable

  # Construct a CloudQueueMessage with the serialized message
  $QueueMessage = New-Object -TypeName Microsoft.Azure.Storage.Queue.CloudQueueMessage `
                             -ArgumentList $Message

  # Add the message to the queue
  $Queue.CloudQueue.AddMessage($QueueMessage)
}

Add-Message -Queue $Queue -Blob $logo
Add-Message -Queue $Queue -Blob $wallpaper

New-AzStorageContainer -Name thumbnails -Permission Container

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://gallery.technet.microsoft.com/scriptcenter/Resize-Image-A-PowerShell-3d26ef68/file/135684/1/Resize-Image.psm1 `
 -OutFile .\Resize-Image.psm1
Import-Module .\Resize-Image.psm1 

function Process-Message() {
 [CmdletBinding()]
 param(
  $Queue
 )
# Set the number of seconds to make a queue message invisible while processing
  $InvisibleTimeout = [System.TimeSpan]::FromSeconds(10)

  # Attempt to get a message from the queue
  $QueueMessage = $Queue.CloudQueue.GetMessage($InvisibleTimeout)

  if ($QueueMessage -eq $null) { 
    Write-Host "Empty queue"
    return
  }

  # Deserialize the JSON message
  $MessageHashTable = ConvertFrom-Json -InputObject $QueueMessage.AsString

  # Download the image to a temp file
  $TempFile = [System.IO.Path]::GetTempFileName()
  Invoke-WebRequest -Uri "$($MessageHashTable.StorageUri)$($MessageHashTable.Sas)" `
                    -OutFile $TempFile

  # Resize the image
  $ThumbnailFile = "$($TempFile)_thumb"
  Resize-Image -InputFile $TempFile -OutputFile $ThumbnailFile -Height 100 -Width 300

  # Upload the thumbnail to the thumbnails container
  Set-AzStorageBlobContent -File $ThumbnailFile `
                           -Container thumbnails `
                           -Blob $MessageHashTable.Name

  Write-Host "Finished Processing"

  # Delete the message from the queue
  $Queue.CloudQueue.DeleteMessage($QueueMessage)
}

Process-Message -Queue $Queue
Process-Message -Queue $Queue
Process-Message -Queue $Queue