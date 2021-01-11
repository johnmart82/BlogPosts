USE [master];
GO

DECLARE @DatabaseName sysname = 'Adventureworks2019_TDE';

SELECT c.certificate_id,
       dek.database_id,
       DB_NAME(dek.database_id) AS DbName,
       dek.encryptor_thumbprint,
       dek.encryption_state_desc,
       dek.encryption_scan_state_desc,
       c.name AS CertName
FROM sys.dm_database_encryption_keys AS dek
    JOIN sys.certificates AS c
        ON dek.encryptor_thumbprint = c.thumbprint
WHERE dek.database_id = DB_ID(@DatabaseName)
;