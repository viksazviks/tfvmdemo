terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.82.0"
    }
  }
}
 
provider "azurerm" {
    subscription_id = "14f8f031-cef7-405e-9b14-4809f8953574"
    tenant_id = "35938538-cc40-430f-870b-4571ebde8ac6"
    client_id = "3cabe042-6a7a-445f-8466-ec8c3d909fd0"
    client_secret = "QoM8Q~vOpQrYrEE5VkNjV_tR2ClOfnZgm7oOob6d"
    features {}
}