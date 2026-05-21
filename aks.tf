# Managed Identity for AKS
resource "azurerm_user_assigned_identity" "aks" {
  name                = "aks-identity"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Role assignment - AKS to ACR (pull images)
resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_user_assigned_identity.aks.principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "voting-app"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_DC2s_v3"
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  oidc_issuer_enabled = true
}
