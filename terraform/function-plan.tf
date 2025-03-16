import {
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Web/serverFarms/plan-brownfield-${var.environment}-australiaeast"
  to = azurerm_service_plan.func_plan
}

resource "azurerm_service_plan" "func_plan" {
  name                = "plan-brownfield-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  os_type             = "Linux"
  sku_name            = "B1"
}
