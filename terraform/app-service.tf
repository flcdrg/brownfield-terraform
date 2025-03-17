moved {
  from = module.web.azurerm_app_service.appservice
  to   = azurerm_app_service.appservice
}

resource "azurerm_app_service" "appservice" {
  name                = "app-brownfield-${var.environment}-australiaeast"
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location
  app_service_plan_id = azurerm_service_plan.plan.id
  site_config {
    linux_fx_version = "DOTNETCORE|6.0"
    min_tls_version  = "1.0"
  }

  app_settings = {
    "SOME_KEY" = "SOME_VALUE"
  }
}
