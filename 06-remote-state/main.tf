terraform {
  backend "azurerm" {
    resource_group_name = "devops-practiece"
    storage_account_name = "burlash"
    container_name       = "tfstate"
    key                  = "test/terraform.tfstate"
  }
}
output "test" {
  value = "completed successfully"
}