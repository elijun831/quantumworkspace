provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "qtumwkspce" {
  name     = "qtumwkspce"
  location = "eastus"
}

resource "azurerm_storage_account" "qtumwkspcestorage" {
  name                     = "qtumwkspcestorage"
  resource_group_name      = azurerm_resource_group.qtumwkspce.name
  location                 = azurerm_resource_group.qtumwkspce.location
  account_tier             = "Standard"
  account_replication_type = "GZRS"
}

resource "azurerm_storage_share" "qtumwkspcestorage" {
  name                 = "qtumwkspcestorage"
  storage_account_name = azurerm_storage_account.qtumwkspcestorage.name
  quota                = 20
}
