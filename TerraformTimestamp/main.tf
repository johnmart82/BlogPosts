resource "azurerm_resource_group" "Demo" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation

  tags = merge(local.common_tags)

  lifecycle {
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }
}
