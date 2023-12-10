data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "mykeyvault" {
  name                        = "mykeyvault825329"
  location                    = local.azurerm_resource_group.location
  resource_group_name         = local.azurerm_resource_group.name
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

resource "azurerm_key_vault_secret" "ur2close2me" {
  name         = "ur2close2me"
  value        = "AZcloud@2023"
  key_vault_id = azurerm_key_vault.mykeyvault.id
  depends_on = [ azurerm_key_vault.mykeyvault ]
}
