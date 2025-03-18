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
* ip_restriction_default_action values are invalid. Set to 'Allow'

MACHINEKEY_DecryptionKey - For native Windows apps or containerized Windows apps
WEBSITES_ENABLE_APP_SERVICE_STORAGE - Indicates whether the /home directory is shared across scaled instances, with a default value of true. You should set this to false when deploying your function app in a container.
WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED - Indicates whether to use a specific cold start optimization when running .NET isolated worker process functions on the Consumption plan. Set to 0 to disable the cold-start optimization on the Consumption plan.
-->

---

# Function app config references

--

App settings reference for Azure Functions

<QRCode value="https://learn.microsoft.com/en-us/azure/azure-functions/functions-app-settings?WT.mc_id=DOP-MVP-5001655" />

Environment variables and app settings in Azure App Service

<QRCode value="https://learn.microsoft.com/en-us/azure/app-service/reference-app-settings?WT.mc_id=DOP-MVP-5001655" />

---

# Becomes

```hcl {2-4|8,9|*}{maxHeight: '80%' }
import {
  for_each = contains(["dev", "prod"], var.environment) ? toset(["f1", "f2", "f3"]) : toset([])
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Web/sites/func-brownfield-${each.key}-${var.environment}-aue"
  to = azurerm_linux_function_app.func[each.key]
}

resource "azurerm_linux_function_app" "func" {
  for_each = contains(["dev", "prod"], var.environment) ? toset(["f1", "f2", "f3"]) : toset([])

  name                = "func-brownfield-${each.key}-${var.environment}-aue"
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
```
<!-- 
* Use a for_each to do all 3 functions in one go - the include
* And the function resource
-->

---

# Review plan

```text {7|14|12|126,135|*}{maxHeight: '80%' }
Terraform will perform the following actions:

  # azurerm_linux_function_app.func["func-brownfield-f1-dev-aue"] will be updated in-place
  # (imported from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f1-dev-aue")
  ~ resource "azurerm_linux_function_app" "func" {
      ~ app_settings                                   = {
          - "MACHINEKEY_DecryptionKey"               = "B04BA733D3C25DC31250F7A7B35FE6096AFA4C3994887F2F473B61CD1960C638" -> null
            "WEBSITES_ENABLE_APP_SERVICE_STORAGE"    = "true"
            "WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED" = "1"
        }
        builtin_logging_enabled                        = true
        client_certificate_enabled                     = false
        client_certificate_exclusion_paths             = null
        client_certificate_mode                        = "Required"
        content_share_force_disabled                   = false
        custom_domain_verification_id                  = (sensitive value)
        daily_memory_time_quota                        = 0
        default_hostname                               = "func-brownfield-f1-dev-aue.azurewebsites.net"
        enabled                                        = true
        ftp_publish_basic_authentication_enabled       = true
        functions_extension_version                    = "~4"
        hosting_environment_id                         = null
        https_only                                     = false
        id                                             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f1-dev-aue"
        key_vault_reference_identity_id                = "SystemAssigned"
        kind                                           = "functionapp,linux"
        location                                       = "australiaeast"
        name                                           = "func-brownfield-f1-dev-aue"
        outbound_ip_address_list                       = [
            "4.200.80.125",
            "4.200.80.238",
            "4.200.80.244",
            "4.200.80.255",
            "4.200.80.132",
            "4.200.80.162",
            "20.227.103.244",
            "20.227.102.5",
            "20.227.99.27",
            "20.227.103.108",
            "20.227.102.28",
            "4.200.80.19",
            "20.211.64.30",
        ]
        outbound_ip_addresses                          = "4.200.80.125,4.200.80.238,4.200.80.244,4.200.80.255,4.200.80.132,4.200.80.162,20.227.103.244,20.227.102.5,20.227.99.27,20.227.103.108,20.227.102.28,4.200.80.19,20.211.64.30"
        possible_outbound_ip_address_list              = [
            "4.200.80.125",
            "4.200.80.238",
            "4.200.80.244",
            "4.200.80.255",
            "4.200.80.132",
            "4.200.80.162",
            "20.227.103.244",
            "20.227.102.5",
            "20.227.99.27",
            "20.227.103.108",
            "20.227.102.28",
            "4.200.80.19",
            "4.200.80.24",
            "20.227.97.19",
            "4.200.80.44",
            "4.200.80.81",
            "4.200.80.82",
            "4.200.80.84",
            "20.227.100.133",
            "20.227.102.135",
            "4.200.80.101",
            "4.200.80.104",
            "4.200.80.112",
            "4.200.80.115",
            "4.200.80.164",
            "4.200.80.177",
            "4.200.80.183",
            "4.200.80.207",
            "4.200.80.212",
            "4.200.80.232",
            "20.211.64.30",
        ]
        possible_outbound_ip_addresses                 = "4.200.80.125,4.200.80.238,4.200.80.244,4.200.80.255,4.200.80.132,4.200.80.162,20.227.103.244,20.227.102.5,20.227.99.27,20.227.103.108,20.227.102.28,4.200.80.19,4.200.80.24,20.227.97.19,4.200.80.44,4.200.80.81,4.200.80.82,4.200.80.84,20.227.100.133,20.227.102.135,4.200.80.101,4.200.80.104,4.200.80.112,4.200.80.115,4.200.80.164,4.200.80.177,4.200.80.183,4.200.80.207,4.200.80.212,4.200.80.232,20.211.64.30"
        public_network_access_enabled                  = true
        resource_group_name                            = "rg-brownfield-dev-australiaeast"
        service_plan_id                                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-dev-australiaeast"
        site_credential                                = (sensitive value)
        storage_account_access_key                     = (sensitive value)
        storage_account_name                           = "stbfdev"
        storage_key_vault_secret_id                    = null
        storage_uses_managed_identity                  = false
        tags                                           = {}
        virtual_network_subnet_id                      = null
        vnet_image_pull_enabled                        = false
        webdeploy_publish_basic_authentication_enabled = true
        zip_deploy_file                                = null

        identity {
            identity_ids = []
            principal_id = "463e0df6-c77a-4977-9191-78ab9a27011d"
            tenant_id    = "51b792d5-bfd3-4dbd-82d2-f42aef2fa7ee"
            type         = "SystemAssigned"
        }

      ~ site_config {
            always_on                                     = true
            api_definition_url                            = null
            api_management_api_id                         = null
            app_command_line                              = null
            app_scale_limit                               = 0
            application_insights_connection_string        = (sensitive value)
            application_insights_key                      = (sensitive value)
            container_registry_managed_identity_client_id = null
            container_registry_use_managed_identity       = false
            default_documents                             = [
                "Default.htm",
                "Default.html",
                "Default.asp",
                "index.htm",
                "index.html",
                "iisstart.htm",
                "default.aspx",
                "index.php",
            ]
            detailed_error_logging_enabled                = false
            elastic_instance_minimum                      = 1
            ftps_state                                    = "FtpsOnly"
            health_check_eviction_time_in_min             = 0
            health_check_path                             = null
            http2_enabled                                 = true
          + ip_restriction_default_action                 = "Allow"
            linux_fx_version                              = "DOTNET-ISOLATED|8.0"
            load_balancing_mode                           = "LeastRequests"
            managed_pipeline_mode                         = "Integrated"
            minimum_tls_version                           = "1.2"
            pre_warmed_instance_count                     = 0
            remote_debugging_enabled                      = false
            remote_debugging_version                      = null
            runtime_scale_monitoring_enabled              = false
          + scm_ip_restriction_default_action             = "Allow"
            scm_minimum_tls_version                       = "1.2"
            scm_type                                      = "None"
            scm_use_main_ip_restriction                   = false
            use_32_bit_worker                             = false
            vnet_route_all_enabled                        = false
            websockets_enabled                            = false
            worker_count                                  = 1

            application_stack {
                dotnet_version              = "8.0"
                java_version                = null
                node_version                = null
                powershell_core_version     = null
                python_version              = null
                use_custom_runtime          = false
                use_dotnet_isolated_runtime = true
            }
        }
    }
```

<!--
* Not sure why the decryption key is there
* client cert mode says "required" (though we aren't using client certs!)
* and enabled false, so ok
* Also default actions - quirk in provider - need to set these to "Allow"
-->

---

# And so we're good right?

---
layout: problem
---

# Error: reading Linux App Service

Resource Group Name: "rg-brownfield-prod-australiaeast"

Site Name: "func-brownfield-f1-prod-aue"): unexpected status 404 (404 Not Found) with error: ResourceNotFound: The Resource 'Microsoft.Web/sites/func-brownfield-f1-prod-aue' under resource group 'rg-brownfield-prod-australiaeast' was not found. For more details please go to <https://aka.ms/ARMResourceNotFoundFix>

<Link to="6">Back to Prod resources</Link>

<!--
Why?

* Silly mistake - different names in prod.
* New naming convention introduced before app went to production?
-->

---

# More conditionals

````md magic-move {lines: true}

```hcl
import {
  for_each = contains(["dev", "prod"], var.environment) ? toset(["f1", "f2", "f3"]) : toset([])
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Web/sites/func-brownfield-${each.key}-${var.environment}-aue"
  to = azurerm_linux_function_app.func[each.key]
}

resource "azurerm_linux_function_app" "func" {
  for_each = contains(["dev", "prod"], var.environment) ? toset(["f1", "f2", "f3"]) : toset([])

  name                = "func-brownfield-${each.key}-${var.environment}-aue"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
```

```hcl {1-4|7|8|9|13,15|*}
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
```

````

<!--
* Adjust names depending on environment name
-->
