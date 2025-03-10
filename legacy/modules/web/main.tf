// https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/app_service

resource "azurerm_app_service" "appservice" {
  name                = "app-brownfield-dev-australiaeast"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id
  site_config {
    linux_fx_version = "DOTNETCORE|6.0"
    min_tls_version          = "1.0"
  }

  app_settings = {
    "SOME_KEY" = "SOME_VALUE"
  }
}
