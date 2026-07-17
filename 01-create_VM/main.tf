# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_network_interface" "main" {
  name                = "test-nic"
  location            = "Denmark East"
  resource_group_name = "devops-practiece"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "/subscriptions/e890e2a1-2eca-4c0b-8e51-dd98c583dd43/resourceGroups/devops-practiece/providers/Microsoft.Network/virtualNetworks/terraform-vnet/subnets/default"
    private_ip_address_allocation = "Dynamic"
    # THIS LINE BINDS THE PUBLIC IP TO THE PRIVATE IP CONFIGURATION
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "test-vm"
  location              = "Denmark East"
  resource_group_name   = "devops-practiece"
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = "Standard_D2s_v3"

  source_image_id = "/subscriptions/e890e2a1-2eca-4c0b-8e51-dd98c583dd43/resourceGroups/devops-practiece/providers/Microsoft.Compute/galleries/rhel10.1/images/1.0.0"

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
resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = "devops-practiece"
  location            = "Denmark East"
  allocation_method   = "Static"
}

# Create a Network Security Group with Ports 22 & 80 Allowed
resource "azurerm_network_security_group" "nsg" {
  name                = "test-nsg"
  location            = "Denmark East"
  resource_group_name = "devops-practiece"

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the NSG with the Network Interface
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}