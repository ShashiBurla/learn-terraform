resource "azurerm_network_interface" "main" {
  for_each = var.components
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "/subscriptions/e890e2a1-2eca-4c0b-8e51-dd98c583dd43/resourceGroups/devops-practiece/providers/Microsoft.Network/virtualNetworks/terraform-vnet/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  for_each = var.components
  name                  = "${each.key}-vm"
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.main[each.key].id]
  size                  = "${each.value}"

  source_image_id = var.image_id
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_password = "Shashi@80999"
  admin_username = "burlash"

  disable_password_authentication = false

  secure_boot_enabled = true
  vtpm_enabled        = true

}

resource "azurerm_dns_a_record" "frontend" {
  for_each = var.components
  name                = each.key
  zone_name           = "shashidevops.online"
  resource_group_name = var.resource_group
  ttl                 = 30
  records             = [azurerm_network_interface.main[each.key].private_ip_address]
}