$getKeyVaultKeyParams = @{
    VaultName = "kv-migtesting"
    Name = "Adventureworks2019-TDEKV"
}
$tdeKey = Get-AzKeyVaultKey @getKeyVaultKeyParams

$setManagedInstanceByokParams = @{
    ResourceGroupName = "rg-migrations"
    InstanceName = "mi-migrations"
    Type = "AzureKeyVault"
    KeyId = $tdeKey.Id
    Force = $true
}
Set-AzSqlInstanceTransparentDataEncryptionProtector @setManagedInstanceByokParams