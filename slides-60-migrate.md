---
layout: image-right
image: /justin-wilkens-Q7vObyijs0I-unsplash.jpg
---

# Migrate deprecated resources

<PhotoCredit
authorLink="https://unsplash.com/@jlwilkens?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash"
authorName="Justin Wilkens"
unsplashLink="https://unsplash.com/photos/a-flock-of-birds-flying-across-a-cloudy-sky-Q7vObyijs0I?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash" />

---

# Process

No native way to move from deprecated to supported resources

* Remove state of deprecated resource
* Import into supported resource

---

# Removing state

Add script task to pipeline:

```yaml {*|3|5-7}{lines: true}
- script: |
    # Remove state of old resources from Terraform
    mapfile -t RESOURCES < <( terraform state list )

    if [[ " ${RESOURCES[@]} " =~ "azurerm_app_service.appservice" ]]; then
      terraform state rm azurerm_app_service.appservice
    fi

    terraform state list

workingDirectory: terraform
displayName: "Script: Remove deprecated resources from Terraform state"
```

<!--
* Create string array from output of terraform command
* If any lines contain string, then run command
-->

---

# And use new resource with import

````md magic-move {lines: true}

```hcl
moved {
  from = module.web.azurerm_app_service.appservice
  to   = azurerm_app_service.appservice
}

resource "azurerm_app_service" "appservice" {
  name                = "app-brownfield-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  app_service_plan_id = azurerm_service_plan.plan.id
  site_config {
    linux_fx_version = "DOTNETCORE|6.0"
    min_tls_version  = "1.0"
  }

  app_settings = {
    "SOME_KEY" = "SOME_VALUE"
  }
}
```

```hcl{3,6}
moved {
  from = module.web.azurerm_app_service.appservice
  to   = azurerm_linux_web_app.appservice
}

resource "azurerm_linux_web_app" "appservice" {
  name                = "app-brownfield-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  app_service_plan_id = azurerm_service_plan.plan.id
  site_config {
    linux_fx_version = "DOTNETCORE|6.0"
    min_tls_version  = "1.0"
  }

  app_settings = {
    "SOME_KEY" = "SOME_VALUE"
  }
}
```

```hcl {1-4|5-21}
import {
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Web/sites/app-brownfield-${var.environment}-australiaeast"
  to = azurerm_linux_web_app.appservice
}
resource "azurerm_linux_web_app" "appservice" {
  name                = "app-brownfield-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    minimum_tls_version = "1.0"
    application_stack {
      dotnet_version = "6.0"
    }
  }

  app_settings = {
    "SOME_KEY" = "SOME_VALUE"
  }
}
```

````

<!--
* Use data resources and variables
* And new resource type, with different site_config structure
-->

---

# And check plan

```text {*|81|131}{maxHeight: '80%'}
  # azurerm_linux_web_app.appservice will be updated in-place
  # (imported from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/app-brownfield-dev-australiaeast")
  ~ resource "azurerm_linux_web_app" "appservice" {
        app_settings                                   = {
            "SOME_KEY" = "SOME_VALUE"
        }
        client_affinity_enabled                        = false
        client_certificate_enabled                     = false
        client_certificate_exclusion_paths             = null
        client_certificate_mode                        = "Required"
        custom_domain_verification_id                  = (sensitive value)
        default_hostname                               = "app-brownfield-dev-australiaeast.azurewebsites.net"
        enabled                                        = true
        ftp_publish_basic_authentication_enabled       = true
        hosting_environment_id                         = null
        https_only                                     = false
        id                                             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/app-brownfield-dev-australiaeast"
        key_vault_reference_identity_id                = "SystemAssigned"
        kind                                           = "app,linux"
        location                                       = "australiaeast"
        name                                           = "app-brownfield-dev-australiaeast"
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
        service_plan_id                                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-web-dev-australiaeast"
        site_credential                                = (sensitive value)
        tags                                           = {}
        virtual_network_subnet_id                      = null
        webdeploy_publish_basic_authentication_enabled = true
        zip_deploy_file                                = null

      ~ site_config {
          ~ always_on                                     = false -> true
            api_definition_url                            = null
            api_management_api_id                         = null
            app_command_line                              = null
            container_registry_managed_identity_client_id = null
            container_registry_use_managed_identity       = false
            default_documents                             = []
            detailed_error_logging_enabled                = false
          ~ ftps_state                                    = "FtpsOnly" -> "Disabled"
            health_check_eviction_time_in_min             = 0
            health_check_path                             = null
            http2_enabled                                 = false
          + ip_restriction_default_action                 = "Allow"
            linux_fx_version                              = "DOTNETCORE|6.0"
            load_balancing_mode                           = "LeastRequests"
            local_mysql_enabled                           = false
            managed_pipeline_mode                         = "Integrated"
            minimum_tls_version                           = "1.0"
            remote_debugging_enabled                      = false
            remote_debugging_version                      = "VS2022"
          + scm_ip_restriction_default_action             = "Allow"
            scm_minimum_tls_version                       = "1.2"
            scm_type                                      = "None"
            scm_use_main_ip_restriction                   = false
          ~ use_32_bit_worker                             = false -> true
            vnet_route_all_enabled                        = false
            websockets_enabled                            = false
            worker_count                                  = 1

            application_stack {
                docker_image_name        = null
                docker_registry_password = (sensitive value)
                docker_registry_url      = null
                docker_registry_username = null
                dotnet_version           = "6.0"
                go_version               = null
                java_server              = null
                java_server_version      = null
                java_version             = null
                node_version             = null
                php_version              = null
                python_version           = null
                ruby_version             = null
            }
        }
    }

...

Plan: 12 to import, 0 to add, 7 to change, 0 to destroy.
```

<!--
* A few minor differences
* Not significant, can ignore.
-->