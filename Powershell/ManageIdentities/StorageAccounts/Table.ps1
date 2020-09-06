
# Create a table with name blobFiles
$tblName = "blobFiles"
New-AzStorageTable -Name $tblName

# Get table details 
$tbl = Get-AzStorageTable -Name $tblName

# Get blob from container images 
$logo = Get-AzStorageBlob -Container images 

# Function that helps in adding the 
function Add_Entity() {
  [CmdletBinding()]
  param(
     $Table,
     $Blob,
     $Type
  ) 
  # Use the container name as the partition key 
  $PartitionKey = $Blob.ICloudBlob.Container.Name

  #use the blob name as the row key 
  $RowKey = $Blob.Name

  $Entity = New-Object -TypeName Microsoft.Azure.Cosmos.Table.DynamicTableEntity
  $Entity.PartitionKey = $PartitionKey
  $Entity.RowKey = $RowKey
  $Entity.Properties.Add("Type", $Type)
  $Entity.Properties.Add("StorageUri", $Blob.ICloudBlob.StorageUri.PrimaryUri.AbsoluteUri)

  $Table.CloudTable.Execute([Microsoft.Azure.Cosmos.Table.TableOperation]::Insert($Entity))

}

Add_Entity -Table $tbl -Blob $logo -Type "logo"
Add_Entity -Table $tbl -Blob $wallpaper -Type "wallpaper"

$Query = New-Object Microsoft.Azure.Cosmos.Table.TableQuery 
$tbl.CloudTable.ExecuteQuery($Query)

$Query.FilterString ="Type eq 'wallpaper'"
$Entity = $tbl.CloudTable.ExecuteQuery($Query)

$Columns = New-Object System.Collections.Generic.List[string]
$Columns.Add("StorageUri")
$Query.SelectColumns = $Columns
$Entity = $tbl.CloudTable.ExecuteQuery($Query)
$Entity

