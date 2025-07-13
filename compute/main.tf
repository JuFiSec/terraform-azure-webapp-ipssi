# Responsable : FIENI DANNIE INNOCENT JUNIOR - Équipe Serveur

resource "azurerm_network_interface" "web" {
  name                = "nic-${var.project_name}-web"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }

  tags = var.common_tags
}

resource "azurerm_linux_virtual_machine" "web" {
  name                = "vm-${var.project_name}-web"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.web.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/install-webserver.tpl", {
    mysql_server = var.mysql_server_fqdn
    db_name      = var.mysql_database_name
  }))

  tags = var.common_tags
}
