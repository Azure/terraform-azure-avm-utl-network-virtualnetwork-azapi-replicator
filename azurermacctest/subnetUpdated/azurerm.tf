resource "azurerm_virtual_network" "test" {
  name                = "acctestvirtnet${random_integer.number.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  subnet {
    name                                          = "subnet1"
    address_prefixes                              = ["10.0.1.0/24"]
    default_outbound_access_enabled               = false
    private_link_service_network_policies_enabled = true
    private_endpoint_network_policies             = "Enabled"
    service_endpoints                             = ["Microsoft.Storage"]

    delegation {
      name = "first"
      service_delegation {
        name = "Microsoft.ContainerInstance/containerGroups"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action",
        ]
      }
    }
  }

  tags = {
    environment = "Production"
  }
}
