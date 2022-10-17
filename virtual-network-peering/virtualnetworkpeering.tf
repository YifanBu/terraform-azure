/*

The following links provide the documentation for the new blocks used
in this terraform configuration file

1. azurerm_virtual_network_peering - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering

*/

resource "azurerm_virtual_network_peering" "peeringconnection1" {
  name                      = "stagingtotest"
  resource_group_name       = local.resource_group_name
  virtual_network_name      = azurerm_virtual_network.network["staging"].name
  remote_virtual_network_id = azurerm_virtual_network.network["test"].id
}

resource "azurerm_virtual_network_peering" "peeringconnection2" {
  name                      = "testtostaging"
  resource_group_name       = local.resource_group_name
  virtual_network_name      = azurerm_virtual_network.network["test"].name
  remote_virtual_network_id = azurerm_virtual_network.network["staging"].id
}

