---
layout: section
---

# Migrate deprecated resources

---

# Process

No native way to move from deprecated to supported resources

* Remove state of deprecated resource
* Import into supported resource

---

# Removing state

Add script task to pipeline:

```yaml {*|3|5-7}
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

---

# And use new resource with import

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

```hcl
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
