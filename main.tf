provider "azurerm" {
  #version = "= 2.18"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-storage-rg" 
  location = "East us"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "rg" {
  name                = "kvult-demofortesting"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "get", "list", "create", "delete", "update",
    ]
    secret_permissions = [
      "get", "list", "set", "delete",
    ]
  }
}

resource "azurerm_storage_account" "rg" {
  name                     = "mystrageacctfortformbend"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "rg" {
  name                  = "tfstatefiles"
  storage_account_name  = azurerm_storage_account.rg.name
  container_access_type = "private"
}