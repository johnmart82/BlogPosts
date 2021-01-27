$newStorageAccountParams = @{
     ResourceGroupName = "rg-migrations" 
     Name = "stmigblogpost01" 
     SkuName = "Standard_LRS"
     Location = 'UK South' 
     Kind = "StorageV2" 
     AccessTier = "Hot"
     MinimumTlsVersion = "TLS1_2"
     AllowBlobPublicAccess = $false
}
$storageAccount = New-AzStorageAccount @newStorageAccountParams

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
     Destination = "mi-migrations.public.e42ec50b2f76.database.windows.net,3342"
     DestinationSqlCredential = (Get-Credential) 
     Name = $credential.Name
}
Copy-DbaCredential @copyCredentialParams

$backupDatabaseParams = @{
    SqlInstance = "sql-01"
    Database = "Adventureworks2019"
    AzureBaseUrl = $container.CloudBlobContainer.Uri.AbsoluteUri
    Type = "Full"
}
$restoreDatabaseParams = @{
    SqlInstance = "mi-migrations.public.e42ec50b2f76.database.windows.net,3342"
    SqlCredential = (Get-Credential)
    DatabaseName = "Adventureworks2019"
}
Backup-DbaDatabase @backupDatabaseParams | Restore-DbaDatabase @restoreDatabaseParams