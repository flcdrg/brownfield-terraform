---
layout: section
---

# The Problem

* Three separate environments in Azure (Dev/Test/Prod)
* Some automation has been used, but not consistently
* There may be manual configuration changes present

---
zoom: 0.8
---

# Dev

| **Name** | **Type** |
|------|------|
|<img src="/10245-icon-service-Key-Vaults.svg" align="center" style="display:inline"> kv-bf-dev-je7v-aue      | Microsoft.KeyVault/vaults|
|<img src="/10086-icon-service-Storage-Accounts.svg" align="center" style="display:inline"> stbfdev | Microsoft.Storage/storageAccounts|
|<img src="/10086-icon-service-Storage-Accounts.svg" align="center" style="display:inline"> stbfdevtf       | Microsoft.Storage/storageAccounts|
|<img src="/00046-icon-service-App-Service-Plans.svg" align="center" style="display:inline"> plan-brownfield-dev-australiaeast | Microsoft.Web/serverFarms|
|<img src="/00046-icon-service-App-Service-Plans.svg" align="center" style="display:inline"> plan-brownfield-web-dev-australiaeast   | Microsoft.Web/serverFarms|
|<img src="/10029-icon-service-Function-Apps.svg" align="center" style="display:inline"> func-brownfield-f1-dev-aue      | Microsoft.Web/sites|
|<img src="/10029-icon-service-Function-Apps.svg" align="center" style="display:inline"> func-brownfield-f2-dev-aue      | Microsoft.Web/sites|
|<img src="/10029-icon-service-Function-Apps.svg" align="center" style="display:inline"> func-brownfield-f3-dev-aue      | Microsoft.Web/sites|
|<img src="/10035-icon-service-App-Services.svg" align="centre" style="display:inline"> app-brownfield-dev-australiaeast        | Microsoft.Web/sites|

---

# Test

| **Name** | **Type** |
|------|------|
| <img src="/10245-icon-service-Key-Vaults.svg" align="center" style="display:inline"> kv-bf-test-u48x-aue     | Microsoft.KeyVault/vaults |
| <img src="/10086-icon-service-Storage-Accounts.svg" align="center" style="display:inline"> stbftest        | Microsoft.Storage/storageAccounts |
| <img src="/10086-icon-service-Storage-Accounts.svg" align="center" style="display:inline"> stbftesttf      | Microsoft.Storage/storageAccounts |
| <img src="/00046-icon-service-App-Service-Plans.svg" align="center" style="display:inline"> plan-brownfield-web-test-australiaeast  | Microsoft.Web/serverFarms |
| <img src="/10035-icon-service-App-Services.svg" align="centre" style="display:inline">app-brownfield-test-australiaeast       | Microsoft.Web/sites |

---
zoom: 0.8
---

# Prod

| **Name** | **Type** |
|------|------|
| <img src="/10245-icon-service-Key-Vaults.svg" align="center" style="display:inline"> kv-bf-prod-0meq-aue     | Microsoft.KeyVault/vaults |
| <img src="/10086-icon-service-Storage-Accounts.svg" align="center" style="display:inline"> stbfprod        | Microsoft.Storage/storageAccounts |
| <img src="/10086-icon-service-Storage-Accounts.svg" align="center" style="display:inline"> stbfprodtf      | Microsoft.Storage/storageAccounts |
| <img src="/00046-icon-service-App-Service-Plans.svg" align="center" style="display:inline"> plan-brownfield-prod-australiaeast      | Microsoft.Web/serverFarms |
| <img src="/00046-icon-service-App-Service-Plans.svg" align="center" style="display:inline"> plan-brownfield-web-prod-australiaeast  | Microsoft.Web/serverFarms |
| <img src="/10029-icon-service-Function-Apps.svg" align="center" style="display:inline"> func-brownfield-app-f1-prod-aue | Microsoft.Web/sites |
| <img src="/10029-icon-service-Function-Apps.svg" align="center" style="display:inline"> func-brownfield-app-f2-prod-aue | Microsoft.Web/sites |
| <img src="/10029-icon-service-Function-Apps.svg" align="center" style="display:inline"> func-brownfield-app-f3-prod-aue | Microsoft.Web/sites |
| <img src="/10035-icon-service-App-Services.svg" align="center" style="display:inline"> app-brownfield-prod-australiaeast       | Microsoft.Web/sites |

---

# Existing Terraform

```hcl {*|2-5|8-11|*}
terraform {
  backend "azurerm" {
    container_name = "tfstate"
    key            = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }

  required_version = ">= 1.11.1"
}

provider "azurerm" {
  features {}
}
```

---

# Old pipeline

```yaml {*|44-50|52-62}{maxHeight: '80%',lines:true }
parameters:
  - name: Environment
    type: string
    values:
      - "dev"
      - "test"
      - "prod"
  - name: Environments
    type: object
    default:
      - name: "dev"
        backendServiceArm: "sp-brownfield-dev-australiaeast"
        backendAzureRmResourceGroupName: "rg-brownfield-dev-australiaeast"
        backendAzureRmStorageAccountName: "stbfdevtf"
      - name: "test"
        backendServiceArm: "sp-brownfield-test-australiaeast"
        backendAzureRmResourceGroupName: "rg-brownfield-test-australiaeast"
        backendAzureRmStorageAccountName: "stbftesttf"
      - name: "prod"
        backendServiceArm: "sp-brownfield-prod-australiaeast"
        backendAzureRmResourceGroupName: "rg-brownfield-prod-australiaeast"
        backendAzureRmStorageAccountName: "stbfprodtf"

trigger: none

pr: none

pool:
  vmImage: ubuntu-latest

jobs:
  - ${{ each Environment in parameters.Environments }}:
      - ${{ if eq(parameters.Environment, Environment.name) }}:
          - job: build_${{ Environment.name }}
            displayName: "Terraform ${{ Environment.name }}"
            steps:
              - checkout: self

              - task: TerraformInstaller@2
                displayName: "Terraform: Installer"
                inputs:
                  terraformVersion: "latest"

              - script: |
                  # Fail on errors
                  set -e

                  cp environment.${{ lower(Environment.name) }}.tfvars environment.auto.tfvars
                displayName: "Script: Copy environment.auto.tfvars"
                workingDirectory: legacy

              - task: TerraformCLI@2
                displayName: "Terraform: init"
                inputs:
                  command: init
                  workingDirectory: legacy
                  backendType: azurerm
                  backendServiceArm: ${{ Environment.backendServiceArm }}
                  backendAzureRmResourceGroupName: ${{ Environment.backendAzureRmResourceGroupName }}
                  backendAzureRmStorageAccountName: ${{ Environment.backendAzureRmStorageAccountName }}
                  commandOptions: -no-color -input=false
                  allowTelemetryCollection: false
```

---

# Existing Terraform (2)

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

# Plan module

```hcl
resource "azurerm_app_service_plan" "plan" {
  name                = "plan-brownfield-web-${var.environment}-australiaeast"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}
```

---

# Web module

* Uses deprecated resource
* Old TLS version

```hcl
resource "azurerm_app_service" "appservice" {
  name                = "app-brownfield-${var.environment}-australiaeast"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
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

---
layout: fact
title: azurerm_app_service deprecation
---

This resource has been deprecated in version 3.0 of the AzureRM provider and will be removed in version 4.0. Please use azurerm_linux_web_app and azurerm_windows_web_app resources instead.

<!-- We will want to -->
