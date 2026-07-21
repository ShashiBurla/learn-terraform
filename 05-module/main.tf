module "app_deploy" {
  depends_on = [ module.db_deploy ]
  for_each = var.App_components
  source = "./simple_module"
  resource_group = var.resource_group
  component_name = each.key
  image_id = var.image_id
  location = var.location
  size = each.value
}
module "db_deploy" {
  for_each = var.db_components
  source = "./simple_module"
  resource_group = var.resource_group
  component_name = each.key
  image_id = var.image_id
  location = var.location
  size = each.value
}
module "ui_deploy" {
  depends_on = [ module.app_deploy ]
  for_each = var.ui_components
  source = "./simple_module"
  resource_group = var.resource_group
  component_name = each.key
  image_id = var.image_id
  location = var.location
  size = each.value
}