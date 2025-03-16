# Functions

````md magic-move {lines: true}

```hcl {*}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-dev-australiaeast"
  to = azurerm_service_plan.res-22
}

resource "azurerm_service_plan" "res-22" {
  name                = "plan-brownfield-dev-australiaeast"
  resource_group_name = "rg-brownfield-dev-australiaeast"
  location            = "australiaeast"
  os_type             = "Linux"
  sku_name            = "B1"
}
```

```hcl {*}
import {
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Web/serverFarms/plan-brownfield-${var.environment}-australiaeast"
  to = azurerm_service_plan.func_plan
}

resource "azurerm_service_plan" "func_plan" {
  name                = "plan-brownfield-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  os_type             = "Linux"
  sku_name            = "B1"
}
```

````

---

# Import looks good

```text {*}{maxHeight: '80%' }
Terraform will perform the following actions:

  # azurerm_service_plan.func_plan will be imported
    resource "azurerm_service_plan" "func_plan" {
        app_service_environment_id      = null
        id                              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-dev-australiaeast"
        kind                            = "linux"
        location                        = "australiaeast"
        maximum_elastic_worker_count    = 1
        name                            = "plan-brownfield-dev-australiaeast"
        os_type                         = "Linux"
        per_site_scaling_enabled        = false
        premium_plan_auto_scale_enabled = false
        reserved                        = true
        resource_group_name             = "rg-brownfield-dev-australiaeast"
        sku_name                        = "B1"
        tags                            = {}
        worker_count                    = 1
        zone_balancing_enabled          = false
    }
```

---
layout: problem
---

# But hang on. Test environment has failed!

While attempting to import an existing object to "azurerm_service_plan.func_plan", the provider detected that no object exists with the given id. Only pre-existing objects can be imported; check that the id is correct and that it is associated with the provider's configured region or endpoint, or use "terraform apply" to create a new remote object for this resource.

<!-- Test doesn't have any Functions -->
---
layout: default
---

# Add conditions

````md magic-move {lines: true}

```hcl {*}
import {
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Web/serverFarms/plan-brownfield-${var.environment}-australiaeast"
  to = azurerm_service_plan.func_plan
}

resource "azurerm_service_plan" "func_plan" {
  name                = "plan-brownfield-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  os_type             = "Linux"
  sku_name            = "B1"
}
```

```hcl {2-5|11|7|*}
import {
  for_each = contains(["dev", "prod"], var.environment) ? {
    enabled = true
    } : {
  }
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Web/serverFarms/plan-brownfield-${var.environment}-australiaeast"
  to = azurerm_service_plan.func_plan[0]
}

resource "azurerm_service_plan" "func_plan" {
  count = contains(["dev", "prod"], var.environment) ? 1 : 0

  name                = "plan-brownfield-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  os_type             = "Linux"
  sku_name            = "B1"
}
```

````

---

# And the Function apps

<!-- Can't use maxHeight with magic-move https://github.com/slidevjs/slidev/issues/1531 -->
```text {*|6-10|12|13-14|21-22|28-30}{maxHeight: '80%' }
resource "azurerm_linux_function_app" "res-53" {
  name                       = "func-brownfield-f1-dev-aue"
  resource_group_name        = "rg-brownfield-dev-australiaeast"
  location                   = "australiaeast"

  app_settings = {
    MACHINEKEY_DecryptionKey               = "AAAAAABBBBBBBCCCCCCCDDDDDDDEEEEEEEEFFFFFF00000111222334445555"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE    = "true"
    WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED = "1"
  }
  client_certificate_mode    = "Required"
  service_plan_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-dev-australiaeast"
  storage_account_access_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=="
  storage_account_name       = "stbfdev"
  identity {
    type = "SystemAssigned"
  }
  site_config {
    ftps_state                        = "FtpsOnly"
    http2_enabled                     = true
    ip_restriction_default_action     = ""
    scm_ip_restriction_default_action = ""
    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }
  }
  depends_on = [
    azurerm_service_plan.res-22,
  ]
}
```

<!--
* Look at configuration.
* Useful to compare against ARM template values
* Identify any redundant configuration we can remove
* ip_restriction_default_action values are invalid. Remove those properties
-->

---

