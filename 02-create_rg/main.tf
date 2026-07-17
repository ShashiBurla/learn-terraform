resource "azurerm_resource_group" "example1" {
  name     = "example2"
  location = "Denmark East"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}