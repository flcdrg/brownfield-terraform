---
layout: image-right
image: ian-taylor-jOqJbvo1P9g-unsplash.jpg
---

# Moving resources

<PhotoCredit authorLink="https://unsplash.com/@carrier_lost?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash"
authorName="Ian Taylor"
unsplashLink="https://unsplash.com/photos/blue-and-red-cargo-ship-on-sea-during-daytime-jOqJbvo1P9g?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash" />

---

# Syntax

<QRCode value="https://developer.hashicorp.com/terraform/language/moved" bottomAdjust="0px" />

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
* Doesn't cause errors if the `from` address doesn't exist

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
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
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

# Check output

```text
  # module.plan.azurerm_service_plan.plan has moved to azurerm_service_plan.plan
    resource "azurerm_service_plan" "plan" {
        id                              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-web-dev-australiaeast"
        name                            = "plan-brownfield-web-dev-australiaeast"
        tags                            = {}
        # (12 unchanged attributes hidden)
    }

```

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

---
layout: image
image: /timo-volz-ZlFKIG6dApg-unsplash.jpg
backgroundSize: contain
---

<PhotoCredit
authorLink="https://unsplash.com/@magict1911?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash"
authorName="Timo Volz"
unsplashLink="https://unsplash.com/photos/orange-cat-stretching-on-white-surface-ZlFKIG6dApg?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash" />

---
layout: problem
type: warning
title: "Warning: Deprecated Resource"
---

# What's this?

   with azurerm_app_service.appservice,
   on app-service.tf line 6, in resource "azurerm_app_service" "appservice":
    6: resource "azurerm_app_service" "appservice" {

 The `azurerm_app_service` resource has been superseded by the `azurerm_linux_web_app` and `azurerm_windows_web_app`
 resources. Whilst this resource will continue to be available in the 2.x and 3.x releases it is feature-frozen for
 compatibility purposes, will no longer receive any updates and will be removed in a future major release of the Azure
 Provider.

<!--
We'll fix this next...
-->