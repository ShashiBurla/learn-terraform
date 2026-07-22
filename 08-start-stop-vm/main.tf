resource "null_resource" "start_stop" {
  provisioner "local-exec" {
    when = create
    command = "az vm start --resource-group devops-practiece --name workstation"
  }

  provisioner "local-exec" {
    when = destroy
    command = "az vm stop --resource-group devops-practiece --name workstation"
  }
  provisioner "local-exec" {
    when = destroy
    command = "az vm deallocate --resource-group devops-practiece --name workstation"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "workstation-public-ip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
}

resource "null_resource" "bind_ip" {
  depends_on = [ azurerm_public_ip.public_ip ]
  provisioner "local-exec" {
    when = create
    command = "az network nic ip-config update  --resource-group devops-practiece  --nic-name workstation526_z1 --name ipconfig1 --public-ip-address workstation-public-ip"
  }

  provisioner "local-exec" {
    when = destroy
    command = "az network nic ip-config update  --resource-group devops-practiece  --nic-name workstation526_z1 --name ipconfig1 --public-ip-address null"
  }
}
