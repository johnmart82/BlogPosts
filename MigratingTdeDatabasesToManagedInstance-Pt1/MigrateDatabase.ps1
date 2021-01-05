$backupDatabaseParams = @{
    SqlInstance = "sql-01"
    Database = "Adventureworks2019_TDE"
    AzureBaseUrl = $container.CloudBlobContainer.Uri.AbsoluteUri
    Type = "Full"
}
$backup = Backup-DbaDatabase @backupDatabaseParams

$restoreDatabaseParams = @{
    SqlInstance = "mi-migrations.public.000000000000.database.windows.net,3342"
    SqlCredential = (Get-Credential)
    DatabaseName = "Adventureworks2019_TDE"
    Path = $backup.BackupPath
}
Restore-DbaDatabase @restoreDatabaseParams
