resource "azurerm_virtual_network" "test" {
  name                    = "acctestvirtnet${random_integer.number.result}"
  address_space           = ["10.0.0.0/16"]
  location                = azurerm_resource_group.test.location
  resource_group_name     = azurerm_resource_group.test.name
  flow_timeout_in_minutes = 5
}
