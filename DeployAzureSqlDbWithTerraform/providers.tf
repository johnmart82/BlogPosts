terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.45.1"
    }
  }
}

provider "azurerm" {
  ## https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/CHANGELOG.md
  #version = "2.45.1"
  #subscription_id = ""
  #client_id       = "" ## appId from output
  #client_secret   = "" ## password from output
  #tenant_id       = "" ## tennant from output
  features {}
}