resource "random_integer" "number" {
  max = 999999
  min = 100000
}

resource "azurerm_resource_group" "test" {
  location = "eastus"
  name     = "acctestRG-${random_integer.number.result}"
}

module "replicator" {
  source = "../.."

  location          = azurerm_resource_group.test.location
  name              = "acctestvirtnet${random_integer.number.result}"
  resource_group_id = azurerm_resource_group.test.id
  address_space     = toset(["10.0.0.0/16"])
  enable_telemetry  = var.enable_telemetry
  subnet = toset([
    {
      name                                          = "subnet1"
      address_prefixes                              = ["10.0.1.0/24"]
      default_outbound_access_enabled               = true
      id                                            = ""
      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
      route_table_id                                = ""
      security_group                                = ""
      service_endpoint_policy_ids                   = toset([])
      service_endpoints                             = toset([])
      delegation                                    = []
    }
  ])
  tags = {
    environment = "Production"
  }
}

resource "azapi_resource" "this" {
  location                         = module.replicator.azapi_header.location
  name                             = module.replicator.azapi_header.name
  parent_id                        = module.replicator.azapi_header.parent_id
  type                             = module.replicator.azapi_header.type
  body                             = module.replicator.body
  ignore_null_property             = module.replicator.azapi_header.ignore_null_property
  locks                            = module.replicator.locks
  replace_triggers_external_values = module.replicator.replace_triggers_external_values
  retry                            = module.replicator.retry
  sensitive_body                   = module.replicator.sensitive_body
  sensitive_body_version           = module.replicator.sensitive_body_version
  tags                             = module.replicator.azapi_header.tags

  dynamic "identity" {
    for_each = can(module.replicator.azapi_header.identity) ? [module.replicator.identity] : []

    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }
  dynamic "timeouts" {
    for_each = module.replicator.timeouts != null ? [module.replicator.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

