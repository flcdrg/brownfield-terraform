locals {
  prod_extra    = var.environment == "prod" ? "app-" : ""
  function_apps = contains(["dev", "prod"], var.environment) ? toset(["func-brownfield-${local.prod_extra}f1-${var.environment}-aue", "func-brownfield-${local.prod_extra}f2-${var.environment}-aue", "func-brownfield-${local.prod_extra}f3-${var.environment}-aue"]) : toset([])
}

import {
  for_each = local.function_apps
  id       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Web/sites/${each.key}"
  to       = azurerm_linux_function_app.func[each.key]
}

resource "azurerm_linux_function_app" "func" {
  for_each = local.function_apps

  name                = each.key
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location

  client_certificate_mode    = "Required"
  service_plan_id            = azurerm_service_plan.func_plan[0].id
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  storage_account_name       = azurerm_storage_account.storage.name
  identity {
    type = "SystemAssigned"
  }
  site_config {
    ftps_state                        = "FtpsOnly"
    http2_enabled                     = true
    ip_restriction_default_action     = "Allow"
    scm_ip_restriction_default_action = "Allow"
    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }
  }
}
