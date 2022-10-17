terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.10.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "65cd6b9e-6117-4cf3-946b-a50b27d43683"
  tenant_id = "b424cbca-3d26-43bd-9988-c59d7447278b"
  client_id = "76baae3d-3302-45a9-873d-4ffc99614147"
  client_secret = var.client_secret
  features {}
}
