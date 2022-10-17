data "azurerm_policy_definition" "allowedresourcetypes" {
  display_name = "Allowed resource types"
}

resource "azurerm_resource_group_policy_assignment" "assignpolicy" {
  name                 = "Assign-Policy"
  resource_group_id    = azurerm_resource_group.appgrp.id
  policy_definition_id = data.azurerm_policy_definition.allowedresourcetypes.id

  parameters = <<PARAMS
    {
      "listOfResourceTypesAllowed": {
        "value": ["microsoft.compute/virtualmachines"]
      }
    }
PARAMS

depends_on = [
  azurerm_resource_group.appgrp
]
}