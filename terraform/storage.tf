import {
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Storage/storageAccounts/stbf${var.environment}"
  to = azurerm_storage_account.storage
}

resource "azurerm_storage_account" "storage" {
  name                            = "stbf${var.environment}"
  resource_group_name             = data.azurerm_resource_group.group.name
  location                        = data.azurerm_resource_group.group.location
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_0"
}
