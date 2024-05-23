resource "azurerm_resource_group" "k8-rg01" {
  name     = "cptak8s-resources"
  location = "Westus2"
}

resource "azurerm_kubernetes_cluster" "k8-cluster" {
  name                = "cptk8s-aks1"
  location            = azurerm_resource_group.k8-rg01.location
  resource_group_name = azurerm_resource_group.k8-rg01.name
  dns_prefix          = "k8aks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.k8-cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8-cluster.kube_config_raw

  sensitive = true
}