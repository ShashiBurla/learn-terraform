data "azurerm_resources" "example" {
  resource_group_name = var.resource_group
}
output "data_source" {
    value       = data.azurerm_resources.example.resources[0].id
    description = "data fetched from Azure Resource Group."
}