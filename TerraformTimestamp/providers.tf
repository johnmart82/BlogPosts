terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      ## https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/CHANGELOG.md
      version = "2.45.1"
    }
  }
}

provider "azurerm" {
  features {
  }
}
