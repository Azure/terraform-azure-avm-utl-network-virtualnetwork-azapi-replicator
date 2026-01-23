resource "azurerm_virtual_network" "test" {
  name                = "acctestvirtnet${random_integer.number.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.test.id
    enable = true
  }

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }
  tags = {
    environment = "Production"
  }
}
