// https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/service_plan

resource "azurerm_service_plan" "plan" {
  name                = "plan-brownfield-web-${var.environment}-australiaeast"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"
}
