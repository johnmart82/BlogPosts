variable "ResourceGroupName" {
  type        = string
  description = "Please provide a name for the resource group."
}
variable "ResourceGroupLocation" {
  type        = string
  description = "Please provide an Azure region for the resource group."
}
variable "AzSqlServerName" {
  type        = string
  description = "Please provide a name for the Azure SQL Server."
}
variable "AzSqlServerAdminAccountName" {
  type        = string
  sensitive   = true
  description = "Please provide a username for the Azure SQL Server Admin Account."
}
variable "AzSqlServerAdminAccountPassword" {
  type        = string
  sensitive   = true
  description = "Please provide a password for the Azure SQL Server Admin Account."
}
variable "AzSqlDbName" {
  type        = string
  description = "Please provide a name for the Azure SQL Database."
}
variable "AzSqlDbCollation" {
  type        = string
  description = "Please provide a name for the Azure SQL Database to be created."
}
variable "AzSqlDbMaxSizeGb" {
  type        = number
  description = "Please provide an Integer value for the max size of the SQL Database to be created."
}
variable "AzSqlDbSkuName" {
  type        = string
  description = "Please provide the SKU name for the Azure SQL Database tier. Can be obtained with \"az sql db list-editions -a -l <Azure Region> -o table\""
}

# Variables that need to be supplied for the tags.
variable "CostCentre" {
  description = "Please provide a cost center for the resource to be allocated to."
}
variable "Environment" {
  description = "Please provide details on the environment that the resource is assigned to."
}
variable "Contact" {
  description = "Please provide a contact that is responsible for this resource, this should be a valid distribution email list."
}
variable "Usage" {
  description = "Please provide some context for what the resources are being used for."
}
variable "BacpacStorageUri" {
  description = "Pleae provide the URI for the database bacpac file to load."
}
variable "BacpacStorageKey" {
  description = "Please provide the key for the storage account to allow the database bacpac file to be read."
}
variable "BacpackStorageKeyType" {
  description = "Pleaes provide the type of key used for the storage account. (StorageAccessKey or SharedAccessKey)"
}
variable "ServerAuthAccessType" {
  description = "Please provide the server authentication type (SQL or ADPassword) for the type of credentials provided."
}