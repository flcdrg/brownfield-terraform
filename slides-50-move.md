---
layout: section
---

# Moving resources

---

# Syntax

https://developer.hashicorp.com/terraform/language/moved

```hcl
moved {
    from = <old address for the resource>
    to = <new address for the resource>
}
```

* Changes Terraform's state resource address. eg.
  * Rename a resource address
  * When a resource becomes an array (or the reverse)
  * When a resource moves into or out of a module
* Don't cause errors if the `from` address doesn't exist

---

# Remove pointless modules

```hcl
module "plan" {
  source                  = "./modules/plan"
  environment             = var.environment
  resource_group_name     = data.azurerm_resource_group.group.name
  resource_group_location = data.azurerm_resource_group.group.location
}

module "web" {
  source                  = "./modules/web"
  environment             = var.environment
  resource_group_name     = data.azurerm_resource_group.group.name
  resource_group_location = data.azurerm_resource_group.group.location
  app_service_plan_id     = module.plan.app_service_plan_id
}
```

---

# Add moved blocks

* Copy the original Terraform definition over
* Add moved block to indicate where it used to be

````md magic-move {lines: true}

```hcl {*}
resource "azurerm_service_plan" "plan" {
  name                = "plan-brownfield-web-${var.environment}-australiaeast"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"
}
```

```hcl
resource "azurerm_service_plan" "plan" {
  name                = "plan-brownfield-web-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  os_type             = "Linux"
  sku_name            = "B1"
}
```

```hcl {1-4|2|3,6|*}
moved {
  from = module.plan.azurerm_service_plan.plan
  to   = azurerm_service_plan.plan
}

resource "azurerm_service_plan" "plan" {
  name                = "plan-brownfield-web-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  os_type             = "Linux"
  sku_name            = "B1"
}
```

````

---

# And App Service

````md magic-move {lines: true}

```hcl
resource "azurerm_app_service" "appservice" {
  name                = "app-brownfield-${var.environment}-australiaeast"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  app_service_plan_id = var.app_service_plan_id
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

````
