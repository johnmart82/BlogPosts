## Create storage account for us to backup to.
$newStorageAccountParams = @{
    ResourceGroupName = "rg-migrations" 
    Name = "stmigblogpost" 
    SkuName = "Standard_LRS"
    Location = 'UK South' 
    Kind = "StorageV2" 
    AccessTier = "Hot"
    MinimumTlsVersion = "TLS1_2"
    AllowBlobPublicAccess = $false
}
$storageAccount = New-AzStorageAccount @newStorageAccountParams

## Create a container in the storage account for the backup files.
$newStorageAccountContainerParams = @{
    Name = "dbbackups"
    Context = $storageAccount.Context
}
$container = New-AzStorageContainer @newStorageAccountContainerParams

$newSasTokenParams = @{
    Context = $storageAccount.Context
    Service = "Blob"
    ResourceType = "Container","Object"
    Permission = "racwdlup"
    StartTime = ((Get-Date).AddDays(-1))
    ExpiryTime = ((Get-Date).AddDays(7))
}
$sasToken = New-AzStorageAccountSASToken @newSasTokenParams

$newDbaCredentialParams = @{
    SqlInstance = "SQL-01"
    Name = $container.CloudBlobContainer.Uri.AbsoluteUri
    Identity = "Shared Access Signature"
    SecurePassword = (ConvertTo-SecureString -AsPlainText -Force ($sasToken.Replace("?","")))
}
$credential = New-DbaCredential @newDbaCredentialParams

$copyCredentialParams = @{
    Source = "SQL-01"
    Destination = "mi-migrations.public.000000000000.database.windows.net,3342"
    DestinationSqlCredential = (Get-Credential) 
    Name = $credential.Name
}
Copy-DbaCredential @copyCredentialParams