---
# You can also start simply with 'default'
theme: default
title: Order from chaos - Importing brownfield Azure applications into Terraform
info: |
  

# apply unocss classes to the current slide
# class: text-center
# https://sli.dev/features/drawing
drawings:
  persist: false
# slide transition: https://sli.dev/guide/animations.html#slide-transitions
transition: slide-left
# enable MDC Syntax: https://sli.dev/features/mdc
mdc: true
---

# Order from chaos

Importing brownfield Azure applications into Terraform

<div @click="$slidev.nav.next" class="mt-12 py-1" hover:bg="white op-10">
  Press Space for next page <carbon:arrow-right />
</div>

<div class="abs-br m-6 text-xl">
  <button @click="$slidev.nav.openInEditor" title="Open in Editor" class="slidev-icon-btn">
    <carbon:edit />
  </button>
  <a href="https://github.com/flcdrg/csharp-refactoring-slidev" target="_blank" class="slidev-icon-btn">
    <carbon:logo-github />
  </a>
</div>

<!--
The last comment block of each slide will be treated as slide notes. It will be visible and editable in Presenter Mode along with the slide. [Read more in the docs](https://sli.dev/guide/syntax.html#notes)
-->

---

# Outline

* aztfexport
* import
* move
* Migrate TF deprecated resources

---

# Variables

```hcl
variable "environment" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev"
}
```

---

# Data resources

```hcl
data "azurerm_client_config" "client" {
}

data "azurerm_resource_group" "group" {
  name = "rg-brownfield-dev-australiaeast"
}

```

---

# Key Vault

````md magic-move {lines: true}

<!-- Original exported HCL -->
```hcl {*}
import {
  id = "/subscriptions/7037474c-e5fd-4336-8ffa-ff8ef9d34930/resourceGroups/
    rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue"
  to = azurerm_key_vault.res-3
}

resource "azurerm_key_vault" "res-3" {
  location                   = "australiaeast"
  name                       = "kv-bf-dev-je7v-aue"
  resource_group_name        = "rg-brownfield-dev-australiaeast"
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tenant_id                  = "51b792d5-bfd3-4dbd-82d2-f42aef2fa7ee"
}
```

<!-- Use data resource references -->
```hcl {*}
import {
  id = "/subscriptions/${data.azurerm_client_config.client.subscription_id}/resourceGroups/
    ${data.azurerm_resource_group.group.name}/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue"
  to = azurerm_key_vault.res-3
}

resource "azurerm_key_vault" "res-3" {
  location                   = data.azurerm_resource_group.group.location
  name                       = "kv-bf-dev-je7v-aue"
  resource_group_name        = data.azurerm_resource_group.group.name
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tenant_id                  = data.azurerm_client_config.client.tenant_id
}
```

<!-- Add locals for KV names -->
```hcl {*}
locals {
  key_vault_name = {
    dev  = "kv-bf-dev-je7v-aue"
    test = "kv-bf-test-u48x-aue"
    prod = "kv-bf-prod-je7v-aue"
  }
}

import {
  id = "/subscriptions/${data.azurerm_client_config.client.subscription_id}/resourceGroups/
    ${data.azurerm_resource_group.group.name}/providers/Microsoft.KeyVault/vaults/${local.key_vault_name[var.environment]}"
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
```

<!-- resource names -->
```hcl {*}
locals {
  key_vault_name = {
    dev  = "kv-bf-dev-je7v-aue"
    test = "kv-bf-test-u48x-aue"
    prod = "kv-bf-prod-je7v-aue"
  }
}

import {
  id = "/subscriptions/${data.azurerm_client_config.client.subscription_id}/resourceGroups/
    ${data.azurerm_resource_group.group.name}/providers/Microsoft.KeyVault/vaults/${local.key_vault_name[var.environment]}"
  to = azurerm_key_vault.kv
}

resource "azurerm_key_vault" "kv" {
  location                   = data.azurerm_resource_group.group.location
  name                       = local.key_vault_name[var.environment]
  resource_group_name        = data.azurerm_resource_group.group.name
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tenant_id                  = data.azurerm_client_config.client.tenant_id
}
```


````

<!-- 
* Original
* Data resources
* KV names
* resource names
-->
---

# Extract Variable

````md magic-move {lines: true}

```csharp {*|2|3|4}
// before
return order.Quantity * order.ItemPrice 
  - Math.Max(0, order.Quantity - 500) * order.ItemPrice * 0.05 
  + Math.Min(order.Quantity * order.ItemPrice * 0.1, 100);

```

```csharp {2|3|4|*}
// after
var basePrice = order.Quantity * order.ItemPrice;
var quantityDiscount = Math.Max(0, order.Quantity - 500) * order.ItemPrice * 0.05;
var shipping = Math.Min(order.Quantity * order.ItemPrice * 0.1, 100);
return basePrice - quantityDiscount + shipping;
```

````

---

# Inline Variable

````md magic-move {lines: true}

```csharp {*|2}
// before
var basePrice = order.BasePrice;
return (basePrice > 1000);
```

```csharp {*}
// after
return order.BasePrice > 1000;
```

````

---

# Change Function Declaration

## Rename Function

````md magic-move {lines: true}

```csharp {*|4}
// before
public Circum(double radius)
{
  return 2 * Math.PI * radius;
}
```

```csharp {4|7-10|*}
// extract function
public Circum(double radius)
{
  return Circumference(radius);
}

public Circumference(double radius)
{
  return 2 * Math.PI * radius;
}
```

```csharp {*}
// inline function
public Circumference(double radius)
{
  return 2 * Math.PI * radius;
}
```

````

---

# Encapsulate Variable

````md magic-move {lines: true}

<!-- snippet: EncapsulateVariable-before -->
```cs
var defaultOwner = new { FirstName = "Martin", LastName = "Fowler" };
```
<!-- endSnippet -->

```csharp {*}
// inline function
public Circumference(double radius)
{
  return 2 * Math.PI * radius;
}
```

````
