output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "ci_runner_private_ip" {
  value = azurerm_network_interface.ci_runner.private_ip_address
}

output "ci_runner_ssh_private_key" {
  value     = tls_private_key.ci_runner.private_key_pem
  sensitive = true
}
