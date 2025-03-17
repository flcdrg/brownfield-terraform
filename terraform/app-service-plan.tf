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
