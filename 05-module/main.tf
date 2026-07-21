module "simple" {
  for_each = var.components
  source = "./simple_module"
  resource_group = var.resource_group
  component_name = each.key
  image_id = var.image_id
  location = var.location
  size = each.value
}