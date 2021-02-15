resource "azurerm_resource_group" "rgsqldb" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation
  tags     = local.tags
}

resource "azurerm_sql_server" "sql01" {
  name                         = var.AzSqlServerName
  location                     = azurerm_resource_group.rgsqldb.location
  resource_group_name          = azurerm_resource_group.rgsqldb.name
  version                      = "12.0"
  administrator_login          = var.AzSqlServerAdminAccountName
  administrator_login_password = var.AzSqlServerAdminAccountPassword
  tags                         = local.tags
}

resource "azurerm_mssql_database" "appdb01" {
  name           = var.AzSqlDbName
  server_id      = azurerm_sql_server.sql01.id
  collation      = var.AzSqlDbCollation
  max_size_gb    = var.AzSqlDbMaxSizeGb
  sku_name       = var.AzSqlDbSkuName
  zone_redundant = var.AzSqlDbZoneRedundant
  tags           = local.tags
}