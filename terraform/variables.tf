variable "app" {
  description = "Required. The name of the application."
  type        = string
  default     = "agc"
}

variable "location" {
  description = "Required. The location (region) for the resources."
  type        = string
}

variable "location_abbreviation" {
  description = "Optional. The abbreviation of the location."
  type        = map(string)
  default = {
    "westeurope"  = "weu"
    "northeurope" = "neu"
    "eastus"      = "eus"
    "westus"      = "wus"
    "ukwest"      = "ukw"
    "uksouth"     = "uks"
  }
}

variable "kubernetes_cluster_sku_tier" {
  description = "Optional. The SKU tier that should be used for the Kubernetes cluster."
  type        = string
  default     = "Free"
}

variable "kubernetes_cluster_node_pool_system_vm_size" {
  description = "Optional. The size of the virtual machines for the system node pool."
  type        = string
  default     = "Standard_D4ds_v5"
}

variable "kubernetes_cluster_node_pool_system_os_disk_size_gb" {
  description = "Optional. The size of the OS disk for the system node pool."
  type        = number
  default     = 150
}

variable "kubernetes_cluster_node_pool_system_os_sku" {
  description = "Optional. The operating system SKU that should be used for the systen node pool."
  type        = string
  default     = "AzureLinux"
}

variable "kubernetes_cluster_node_pool_user_vm_size" {
  description = "Optional. The size of the virtual machines for the user node pool."
  type        = string
  default     = "Standard_D4ds_v5"
}

variable "kubernetes_cluster_node_pool_user_os_disk_size_gb" {
  description = "Optional. The size of the OS disk for the user node pool."
  type        = number
  default     = 150
}

variable "kubernetes_cluster_node_pool_user_os_sku" {
  description = "Optional. The operating system SKU that should be used for the user node pool."
  type        = string
  default     = "AzureLinux"
}
