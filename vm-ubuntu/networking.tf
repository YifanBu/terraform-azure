resource "azurerm_virtual_network" "appnetwork" {
  name                = local.virtual_network.name
  location            = azurerm_resource_group.appgrp.location
  resource_group_name = azurerm_resource_group.appgrp.name
  address_space       = local.virtual_network.address_space

  depends_on = [
    azurerm_resource_group.appgrp
  ]
}

resource "azurerm_subnet" "subnets" {
  count                = var.number_of_subnets
  name                 = "Subnet${count.index}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
  depends_on = [
    azurerm_virtual_network.appnetwork
  ]
}

resource "azurerm_network_interface" "appinterface" {
  count               = var.number_of_machines
  name                = "appinterface${count.index}"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip[count.index].id
  }

  depends_on = [
    azurerm_subnet.subnets,
    azurerm_public_ip.appip
  ]
}

resource "azurerm_public_ip" "appip" {
  count                   = var.number_of_machines
  name                    = "app-ip${count.index}"
  location                = local.location
  resource_group_name     = local.resource_group_name
  allocation_method       = "Static"
  sku                     = "Standard"
  depends_on = [
    azurerm_resource_group.appgrp
  ]
}


resource "azurerm_network_security_group" "appnsg" {
  name                = "app-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 300
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
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }  

  depends_on = [
    azurerm_resource_group.appgrp
  ]
}

resource "azurerm_subnet_network_security_group_association" "appnsglink" {
  count                     = var.number_of_subnets
  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.appnsg.id
  depends_on = [
    azurerm_virtual_network.appnetwork,
    azurerm_network_security_group.appnsg
  ]
}