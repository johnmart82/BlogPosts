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

resource "azurerm_sql_firewall_rule" "allowAzureServices" {
  name                = "Allow_Azure_Services"
  resource_group_name = azurerm_sql_server.sql01.resource_group_name
  server_name         = azurerm_sql_server.sql01.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}