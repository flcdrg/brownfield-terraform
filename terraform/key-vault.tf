locals {
  key_vault_name = {
    dev  = "kv-bf-dev-je7v-aue"
    test = "kv-bf-test-u48x-aue"
    prod = "kv-bf-prod-0meq-aue"
  }
}

import {
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.KeyVault/vaults/${local.key_vault_name[var.environment]}"
  to = azurerm_key_vault.kv
}

resource "azurerm_key_vault" "kv" {
  location                   = data.azurerm_resource_group.group.location
  name                       = local.key_vault_name[var.environment]
  resource_group_name        = data.azurerm_resource_group.group.name
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tenant_id                  = data.azurerm_client_config.current.tenant_id
}

import {
  for_each = contains(["dev", "prod"], var.environment) ? {
    enabled = true
    } : {
  }
  id = "${azurerm_key_vault.kv.id}/objectId/${data.azurerm_client_config.current.object_id}"
  to = azurerm_key_vault_access_policy.pipeline_spn[0]
}

resource "azurerm_key_vault_access_policy" "pipeline_spn" {
  count = contains(["dev", "prod"], var.environment) ? 1 : 0

  key_vault_id            = azurerm_key_vault.kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
  #   certificate_permissions = [ "all" ]
  #   secret_permissions      = [ "all" ]
  #   key_permissions         = [ "all" ]
  #   storage_permissions     = [ "all" ]
}

locals {
  function_app_object_id = {
    func-brownfield-f1-dev-aue      = "463e0df6-c77a-4977-9191-78ab9a27011d"
    func-brownfield-f2-dev-aue      = "88016e7a-c8ee-43c1-bd3c-d6c4ff2530c0"
    func-brownfield-f3-dev-aue      = "20465cbf-884a-42a6-a1e8-1212a28859c0"
    func-brownfield-app-f1-prod-aue = "d33dfb2e-6cef-488d-8114-a424dd16c096"
    func-brownfield-app-f2-prod-aue = "05747c5c-7679-4bb9-8897-80947287ba04"
    func-brownfield-app-f3-prod-aue = "f4aebadd-7490-4dd7-a20b-6edebfc4e71e"
  }
}

# Access policies for each function app
import {
  for_each = local.function_apps
  id       = "${azurerm_key_vault.kv.id}/objectId/${local.function_app_object_id[each.key]}"
  to       = azurerm_key_vault_access_policy.function_app[each.key]
}

resource "azurerm_key_vault_access_policy" "function_app" {
  for_each = local.function_apps

  key_vault_id       = azurerm_key_vault.kv.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_linux_function_app.func[each.key].identity[0].principal_id
  secret_permissions = ["Get", "List"]
}

# Secrets

locals {
  super_secret_version = {
    dev  = "31832b009fb24d688449eaa1a7b70e38"
    test = "cddced895f2c4ab4aaf7fb6891750c64"
    prod = "a11c58c1a63b40878b29f0582c4312e3"
  }
}
import {
  id = "${azurerm_key_vault.kv.vault_uri}secrets/super-secret/${local.super_secret_version[var.environment]}"
  to = azurerm_key_vault_secret.secret
}

resource "azurerm_key_vault_secret" "secret" {
  key_vault_id = azurerm_key_vault.kv.id
  name         = "super-secret"
  tags = {
    file-encoding = "utf-8"
  }
  value = ""

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
