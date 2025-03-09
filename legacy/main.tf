terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0.0, < 3.0.0"
    }
  }

  required_version = ">= 1.11.1"
}

provider "azurerm" {
  features {}
}

module "plan" {
  source                  = "./modules/plan"
  resource_group_name     = data.azurerm_resource_group.group.name
  resource_group_location = data.azurerm_resource_group.group.location
}

module "web" {
  source                  = "./modules/web"
  resource_group_name     = data.azurerm_resource_group.group.name
  resource_group_location = data.azurerm_resource_group.group.location
  app_service_plan_id     = module.plan.app_service_plan_id
}
