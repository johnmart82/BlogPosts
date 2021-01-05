$sourceSqlServer = 'SQL-01'
$sourceDatabase = "master"
$CertName = "TdeServerCert01"
$certBackupPath = "C:\SQLServer\Backup"
$certSecurePassword = Read-Host -Prompt "Please provide the password for the certificate." -AsSecureString

$certBackupParams = @{
    SqlInstance = $sourceSqlServer
    Database = $sourceDatabase
    Certificate = $CertName
    EncryptionPassword = $certSecurePassword
    Path = $certBackupPath
}
$certBackup = Backup-DbaDbCertificate @certBackupParams

## -- Need Windows SDK for pvk2pfx (C++ tools)
## - https://developer.microsoft.com/en-US/windows/downloads/windows-10-sdk/

$pvk2pfxLocation = 'C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64'
$pfxOutput = "$certBackupPath\$CertName.pfx"

$convertCertParams = @{
    ScriptBlock = { Set-Location $pvk2pfxLocation
        .\pvk2pfx.exe -pvk $args[0] -pi $args[1] -spc $args[2] -pfx $args[3]
        }
        ArgumentList = $certBackup.Key, (Read-Host -Prompt "Please provide the password for the certificate."), $certBackup.Path, $pfxOutput
}
Invoke-Command @convertCertParams

$pfxBinData = [System.Convert]::ToBase64String([IO.File]::ReadAllBytes($pfxOutput)) | ConvertTo-SecureString -AsPlainText -Force

$managedInstanceName = "mi-migrations"
$managedInstanceTdeCertparams = @{
    ResourceGroupName = ((Get-AzSqlInstance -Name $managedInstanceName).ResourceGroupName)
    ManagedInstanceName = $managedInstanceName
    PrivateBlob = $pfxBinData
    Password = $certSecurePassword
}
Add-AzSqlManagedInstanceTransparentDataEncryptionCertificate @managedInstanceTdeCertparams

#'Really Str0ng P@ssw0rd!'