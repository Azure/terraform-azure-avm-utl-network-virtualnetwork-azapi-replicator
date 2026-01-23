resource "azurerm_virtual_network" "test" {
  name                           = "acctestvirtnet${random_integer.number.result}"
  address_space                  = ["10.0.0.0/16", "10.10.0.0/16"]
  location                       = azurerm_resource_group.test.location
  resource_group_name            = azurerm_resource_group.test.name
  dns_servers                    = ["10.7.7.2", "10.7.7.7", "10.7.7.1"]
  private_endpoint_vnet_policies = "Basic"

  encryption {
    enforcement = "AllowUnencrypted"
  }

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "subnet2"
    address_prefixes = ["10.10.1.0/24"]
  }
}
