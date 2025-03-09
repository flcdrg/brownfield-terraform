terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0.0, < 3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-brownfield-dev-australiaeast"
    storage_account_name = "stbfdevtf"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
  required_version = ">= 1.11.1"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "rg-tfdemo-australiaeast"
}
