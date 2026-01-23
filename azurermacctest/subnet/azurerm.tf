resource "azurerm_virtual_network" "test" {
  name                = "acctestvirtnet${random_integer.number.result}"
  address_space       = ["10.0.0.0/16", "ace:cab:deca::/48"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  subnet {
    name                                          = "subnet1"
    address_prefixes                              = ["10.0.1.0/24", "ace:cab:deca::/64"]
    private_link_service_network_policies_enabled = false
    private_endpoint_network_policies             = "Enabled"
    service_endpoints                             = ["Microsoft.Sql", "Microsoft.Storage"]
    service_endpoint_policy_ids                   = [azurerm_subnet_service_endpoint_storage_policy.test.id]

    delegation {
      name = "nginx"
      service_delegation {
        name = "NGINX.NGINXPLUS/nginxDeployments"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
        ]
      }
    }
  }

  subnet {
    name                                          = "subnet2"
    address_prefixes                              = ["10.0.2.0/24"]
    private_link_service_network_policies_enabled = false
    service_endpoints                             = ["Microsoft.Storage"]
    service_endpoint_policy_ids                   = [azurerm_subnet_service_endpoint_storage_policy.test.id]

    delegation {
      name = "containers"
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
