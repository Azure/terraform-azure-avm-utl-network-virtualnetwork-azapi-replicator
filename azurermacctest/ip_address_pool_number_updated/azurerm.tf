resource "azurerm_virtual_network" "test" {
  name                = "acctestvirtnet${random_integer.number.result}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ip_address_pool {
    id                     = azurerm_network_manager_ipam_pool.test.id
    number_of_ip_addresses = "300"
  }
}
