resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "East US"
}

resource "azurerm_storage_account" "appstore06102022" {
  name                     = "appstore06102022"
  resource_group_name      = "app-grp"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"

  tags = {
    environment = "staging"
  }

  depends_on = [
    azurerm_resource_group.appgrp
  ]
}