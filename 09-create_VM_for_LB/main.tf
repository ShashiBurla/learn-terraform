resource "azurerm_network_interface" "main" {
  for_each            = var.components
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
  for_each                        = var.components
  name                            = "${each.key}-vm"
  location                        = var.location
  resource_group_name             = var.resource_group
  network_interface_ids           = [azurerm_network_interface.main[each.key].id]
  size                            = each.value
  admin_password                  = "Shashi@80999"
  admin_username                  = "burlash"
  disable_password_authentication = false
  secure_boot_enabled             = true
  vtpm_enabled                    = true
  source_image_id                 = var.image_id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_public_ip" "example" {
  name                = "LB-pip"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
}
resource "azurerm_network_security_group" "main_nsg" {
  name                = "main-nsg"
  location            = "Denmark East"
  resource_group_name = "devops-practiece"

  # Allow SSH traffic (Port 22)
  security_rule {
    name                       = "Allow-SSH-22"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" # For better security, replace with your specific IP (e.g., "203.0.113.50/32")
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = "/subscriptions/e890e2a1-2eca-4c0b-8e51-dd98c583dd43/resourceGroups/devops-practiece/providers/Microsoft.Network/virtualNetworks/terraform-vnet/subnets/default"
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}
