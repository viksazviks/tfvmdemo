data "azurerm_policy_definition" "allowedresourcestypes" {
  display_name = "Allowed resource types"
}


resource "azurerm_resource_group_policy_assignment" "assignpolicy" {
  name                 = "Assign-Policy"
  resource_group_id    = azurerm_resource_group.myrg.id
  policy_definition_id = azurerm_policy_definition.allowedresourcestypes.id

  parameters = <<PARAMS
    {
      "listOfResourceTypesAllowed": {
        "value": ["microsoft.compute/virtualmachines"]
      }
      
    }
PARAMS

depends_on = [ azurerm_resource_group.myrg ]
}
