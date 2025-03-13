locals {
  key_vault_name = {
    dev  = "kv-bf-dev-je7v-aue"
    test = "kv-bf-test-u48x-aue"
    prod = "kv-bf-prod-0meq-aue"
  }
}

import {
  id = "/subscriptions/${data.azurerm_client_config.client.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.KeyVault/vaults/${local.key_vault_name[var.environment]}"
  to = azurerm_key_vault.res-3
}

resource "azurerm_key_vault" "res-3" {
  location                   = data.azurerm_resource_group.group.location
  name                       = local.key_vault_name[var.environment]
  resource_group_name        = data.azurerm_resource_group.group.name
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tenant_id                  = data.azurerm_client_config.client.tenant_id
}
