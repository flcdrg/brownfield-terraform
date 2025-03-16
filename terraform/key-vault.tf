# locals {
#   key_vault_name = {
#     dev  = "kv-bf-dev-je7v-aue"
#     test = "kv-bf-test-u48x-aue"
#     prod = "kv-bf-prod-0meq-aue"
#   }
# }

# import {
#   id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.KeyVault/vaults/${local.key_vault_name[var.environment]}"
#   to = azurerm_key_vault.kv
# }

# resource "azurerm_key_vault" "kv" {
#   location                   = data.azurerm_resource_group.group.location
#   name                       = local.key_vault_name[var.environment]
#   resource_group_name        = data.azurerm_resource_group.group.name
#   sku_name                   = "standard"
#   soft_delete_retention_days = 7
#   tenant_id                  = data.azurerm_client_config.current.tenant_id
# }

# import {
#   for_each = contains(["dev", "prod"], var.environment) ? {
#     enabled = true
#     } : {
#   }
#   id = "${azurerm_key_vault.kv.id}/objectId/${data.azurerm_client_config.current.object_id}"
#   to = azurerm_key_vault_access_policy.pipeline_spn[0]
# }

# resource "azurerm_key_vault_access_policy" "pipeline_spn" {
#   count = contains(["dev", "prod"], var.environment) ? 1 : 0

#   key_vault_id            = azurerm_key_vault.kv.id
#   tenant_id               = data.azurerm_client_config.current.tenant_id
#   object_id               = data.azurerm_client_config.current.object_id
#   certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
#   secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
#   key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
#   storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
# }
