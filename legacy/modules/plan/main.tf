// https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/app_service_plan

resource "azurerm_app_service_plan" "plan" {
  name                = "plan-brownfield-web-dev-australiaeast"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  kind                = "Linux"

  sku {
    tier = "Basic"
    size = "B1"
  }
}
