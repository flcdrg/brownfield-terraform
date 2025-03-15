module "plan" {
  source                  = "./modules/plan"
  environment             = var.environment
  resource_group_name     = data.azurerm_resource_group.group.name
  resource_group_location = data.azurerm_resource_group.group.location
}

module "web" {
  source                  = "./modules/web"
  environment             = var.environment
  resource_group_name     = data.azurerm_resource_group.group.name
  resource_group_location = data.azurerm_resource_group.group.location
  app_service_plan_id     = module.plan.app_service_plan_id
}
