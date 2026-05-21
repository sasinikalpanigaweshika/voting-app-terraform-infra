resource "azurerm_user_assigned_identity" "ci_runner" {
  name                = "ci-runner-identity"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_role_assignment" "ci_runner_acr" {
  principal_id                     = azurerm_user_assigned_identity.ci_runner.principal_id
  role_definition_name             = "AcrPush"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "azurerm_network_interface" "ci_runner" {
  name                = "ci-runner-nic"
  location            = "westus"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ci_runner.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "tls_private_key" "ci_runner" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "ci_runner" {
  name                = "ci-runner-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westus"
  size                = "Standard_B2s"
  admin_username      = "azureuser"

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ci_runner.public_key_openssh
  }

  network_interface_ids = [azurerm_network_interface.ci_runner.id]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.ci_runner.id]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
