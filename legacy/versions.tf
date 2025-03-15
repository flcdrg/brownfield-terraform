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
