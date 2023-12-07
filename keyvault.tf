data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "mykeyvault" {
  name                        = "mykeyvault825329"
  location                    = local.azurerm_resource_group.name
  resource_group_name         = local.azurerm_resource_group.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "Set"
    ]

  }
}