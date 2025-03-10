terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
  }

  required_version = ">= 1.11.1"
}

provider "azurerm" {
  features {}
}
