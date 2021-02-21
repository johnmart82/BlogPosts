resource "azurerm_sql_database" "appdb01" {
  depends_on                       = [azurerm_sql_firewall_rule.allowAzureServices]
  name                             = var.AzSqlDbName
  resource_group_name              = azurerm_sql_server.sql01.resource_group_name
  location                         = azurerm_sql_server.sql01.location
  server_name                      = azurerm_sql_server.sql01.name
  collation                        = var.AzSqlDbCollation
  max_size_gb                      = var.AzSqlDbMaxSizeGb
  requested_service_objective_name = var.AzSqlDbSkuName

  create_mode = "Default"
  import {
    storage_uri                  = var.BacpacStorageUri
    storage_key                  = var.BacpacStorageKey
    storage_key_type             = var.BacpackStorageKeyType
    administrator_login          = var.AzSqlServerAdminAccountName
    administrator_login_password = var.AzSqlServerAdminAccountPassword
    authentication_type          = var.ServerAuthAccessType
    operation_mode               = "Import"
  }

  tags = local.tags
}