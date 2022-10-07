resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "East US"
}

resource "azurerm_storage_account" "appstore06102022" {
  # count = 3
  #name                     = "${count.index}appstore06102022"
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

resource "azurerm_storage_container" "data" {
  for_each              = toset(["data", "files", "documents"])
  name                  = each.key
  storage_account_name  = "appstore06102022"
  container_access_type = "blob"
  depends_on = [
    azurerm_storage_account.appstore06102022
  ]
}

resource "azurerm_storage_blob" "files" {
  for_each = {
    sample1 = "sample1.txt"
    sample2 = "sample2.txt"
    sample3 = "sample3.txt"
  }
  name                   = "${each.key}.txt"
  storage_account_name   = "appstore06102022"
  storage_container_name = "data"
  type                   = "Block"
  source                 = each.value
    depends_on = [
    azurerm_storage_container.data
  ]
}