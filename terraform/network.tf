# Create the virtual network.
resource "azurerm_virtual_network" "default" {
  name                = "vnet-${local.suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.10.0.0/16"]
}

# Create the subnet.
resource "azurerm_subnet" "aks" {
  name                 = "aks"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.10.4.0/22"]
}

# Create the network security group.
resource "azurerm_network_security_group" "aks" {
  name                = "nsg-aks-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name
}

# Associate the network security group with the subnet.
resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

# Create the security rule for inbound web traffic.
resource "azurerm_network_security_rule" "allow_internet_web_inbound" {
  name                        = "AllowInternetWebInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.default.name
  network_security_group_name = azurerm_network_security_group.aks.name
}
