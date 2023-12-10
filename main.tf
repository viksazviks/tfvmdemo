locals {
  azurerm_resource_group = { 
    name = "my-rg"
    location = "West Europe"
  }

  azurerm_virtual_network = { 
    name = "vnet12"
    address_space = "10.0.0.0/16"
  }

  azurerm_subnets = [ 
    { 
      name = "subnet1"
      address_prefix = "10.0.1.0/24"
    },
    { 
      name = "subnet2"
      address_prefix = "10.0.2.0/24"
    }
  ]

}

resource "azurerm_resource_group" "myrg" {
  name     = local.azurerm_resource_group.name
  location = local.azurerm_resource_group.location
}

resource "azurerm_virtual_network" "vnet12" {
  name                = local.azurerm_virtual_network.name
  location            = local.azurerm_resource_group.location
  resource_group_name = local.azurerm_resource_group.name
  address_space       = [local.azurerm_virtual_network.address_space]
  depends_on = [azurerm_resource_group.myrg]

}

resource "azurerm_subnet" "subnet1" {
  name                 = local.azurerm_subnets[0].name
  resource_group_name  = local.azurerm_resource_group.name
  virtual_network_name = local.azurerm_virtual_network.name
  address_prefixes     = [local.azurerm_subnets[0].address_prefix]
  depends_on = [ azurerm_virtual_network.vnet12 ]

}

resource "azurerm_subnet" "subnet2" {
  name                 = local.azurerm_subnets[1].name
  resource_group_name  = local.azurerm_resource_group.name
  virtual_network_name = local.azurerm_virtual_network.name
  address_prefixes     = [local.azurerm_subnets[1].address_prefix]
  depends_on = [ azurerm_virtual_network.vnet12 ]

}

resource "azurerm_network_interface" "mynic" {
  name                = "mynic"
  location            = local.azurerm_resource_group.location
  resource_group_name = local.azurerm_resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id
  }
      depends_on = [ azurerm_subnet.subnet1 ]

}

resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip"
  resource_group_name = local.azurerm_resource_group.name
  location            = local.azurerm_resource_group.location
  allocation_method   = "Dynamic"
  depends_on = [ azurerm_resource_group.myrg ]

}

resource "azurerm_network_security_group" "mynsg" {
  name                = "mynsg"
  location            = local.azurerm_resource_group.location
  resource_group_name = local.azurerm_resource_group.name

  security_rule {
    name                       = "rule1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [ azurerm_resource_group.myrg ]

}

resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.mynsg.id

}

resource "azurerm_windows_virtual_machine" "myvm" {
  name                = "myvm"
  resource_group_name = local.azurerm_resource_group.name
  location            = local.azurerm_resource_group.location
  size                = "Standard_D2S_v3"
  admin_username      = azurerm_key_vault_secret.ur2close2me.name
  admin_password      = azurerm_key_vault_secret.ur2close2me.value
  network_interface_ids = [
    azurerm_network_interface.mynic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [ azurerm_network_interface.mynic, azurerm_resource_group.myrg ]
  
}










