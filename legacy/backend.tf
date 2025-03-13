terraform {
  backend "azurerm" {
    # resource_group_name  = "rg-brownfield-dev-australiaeast"
    # storage_account_name = "stbfdevtf"
    container_name = "tfstate"
    key            = "terraform.tfstate"
  }
}
