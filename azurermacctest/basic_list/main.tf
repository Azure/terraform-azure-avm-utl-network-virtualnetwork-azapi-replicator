terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azapi" {}

provider "random" {}

resource "random_integer" "number" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-${random_integer.number.result}"
  location = "eastus"
}

resource "azurerm_virtual_network" "test2" {
  name                = "acctestvnet2${random_integer.number.result}"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.2.1.0/24"]
  }
  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "test3" {
  name                = "acctestvnet3${random_integer.number.result}"
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.3.1.0/24"]
  }
  tags = {
    environment = "Production"
  }
}
