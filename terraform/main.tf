terraform {
  required_providers {
    azurerm = {
      version = ">= 3.95"
    }

    http = {
      version = ">= 3.4"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# Get the public IP address
data "http" "public_ip" {
  url = "https://ifconfig.co/ip"
}

locals {
  # Lookup and set the location abbreviation, defaults to na (not available).
  location_abbreviation = try(var.location_abbreviation[var.location], "na")

  # Construct the name suffix.
  suffix = "${var.app}-${local.location_abbreviation}"

  # Clean and set the public IP address
  public_ip = chomp(data.http.public_ip.response_body)

  # Set the authorized IP ranges for the Kubernetes cluster.
  authorized_ip_ranges = ["${local.public_ip}/32"]
}

# Create the resource group.
resource "azurerm_resource_group" "default" {
  name     = "rg-${local.suffix}"
  location = var.location
}

# Create the managed identity for the Kubernetes cluster.
resource "azurerm_user_assigned_identity" "kubernetes_cluster" {
  name                = "id-aks-${local.suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name
}

# Assign the 'Network Contributor' role to the Kubernetes cluster managed identity on the resource group.
resource "azurerm_role_assignment" "network_contributor_kubernetes_cluster_resource_group" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.kubernetes_cluster.principal_id
}

# Assign the 'Cluster Admin' role to the current user on the Kubernetes cluster.
resource "azurerm_role_assignment" "cluster_admin_current_user_kubernetes_cluster" {
  scope                = azurerm_kubernetes_cluster.default.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Assign the 'Managed Identity Operator' role to the Kubernetes cluster managed identity on the Kubernetes cluster.
resource "azurerm_role_assignment" "managed_identity_operator_kubernetes_cluster" {
  scope                = azurerm_user_assigned_identity.kubernetes_cluster.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.kubernetes_cluster.principal_id
}
