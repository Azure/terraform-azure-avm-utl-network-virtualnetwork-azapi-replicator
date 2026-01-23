locals {
  address_space_should_suppress = var.ip_address_pool != null && length(var.ip_address_pool) > 0
  azapi_header = {
    type                      = "Microsoft.Network/virtualNetworks@2024-07-01"
    name                      = var.name
    location                  = local.normalized_location
    parent_id                 = var.resource_group_id
    tags                      = var.tags
    ignore_null_property      = true
    schema_validation_enabled = false
    retry                     = local.retry
  }
  # With ignore_null_property = true, you can directly assign null values
  # No need to use merge() to filter out null fields
  body = {
    extendedLocation = local.normalized_edge_zone != null ? {
      name = local.normalized_edge_zone
      type = "EdgeZone"
    } : null
    properties = {
      addressSpace = {
        addressPrefixes = local.effective_address_space
        ipamPoolPrefixAllocations = (var.ip_address_pool != null && length(var.ip_address_pool) > 0) ? [
          for pool in var.ip_address_pool : {
            numberOfIpAddresses = pool.number_of_ip_addresses
            pool = {
              id = pool.id
            }
          }
        ] : null
      }
      bgpCommunities = var.bgp_community != null ? {
        virtualNetworkCommunity = var.bgp_community
      } : null
      ddosProtectionPlan = var.ddos_protection_plan != null ? {
        id = var.ddos_protection_plan.id
      } : null
      dhcpOptions = {
        dnsServers = var.dns_servers
      }
      enableDdosProtection = var.ddos_protection_plan != null ? var.ddos_protection_plan.enable : null
      encryption = var.encryption != null ? {
        enabled     = true # Hardcoded to true by provider (hidden field)
        enforcement = var.encryption.enforcement
      } : null
      flowTimeoutInMinutes        = var.flow_timeout_in_minutes
      privateEndpointVNetPolicies = var.private_endpoint_vnet_policies
      subnets = (var.subnet != null && length(var.subnet) > 0) ? [
        for subnet in local.ordered_subnets : {
          name = subnet.name
          properties = merge(
            length(subnet.address_prefixes) == 1 ? {
              addressPrefix   = subnet.address_prefixes[0]
              addressPrefixes = null
              } : {
              addressPrefix   = null
              addressPrefixes = subnet.address_prefixes
            },
            {
              defaultOutboundAccess             = subnet.default_outbound_access_enabled
              privateEndpointNetworkPolicies    = subnet.private_endpoint_network_policies
              privateLinkServiceNetworkPolicies = subnet.private_link_service_network_policies_enabled ? "Enabled" : "Disabled"
              routeTable = subnet.route_table_id != null && subnet.route_table_id != "" ? {
                id = subnet.route_table_id
              } : null
              networkSecurityGroup = subnet.security_group != null && subnet.security_group != "" ? {
                id = subnet.security_group
              } : null
              serviceEndpointPolicies = subnet.service_endpoint_policy_ids != null && length(subnet.service_endpoint_policy_ids) > 0 ? [
                for policy_id in subnet.service_endpoint_policy_ids : {
                  id = policy_id
                }
              ] : null
              serviceEndpoints = subnet.service_endpoints != null && length(subnet.service_endpoints) > 0 ? [
                for service in local.service_endpoints_ordered_by_subnet[subnet.name] : {
                  service = service
                }
              ] : null
              delegations = subnet.delegation != null && length(subnet.delegation) > 0 ? [
                for delegation in subnet.delegation : {
                  name = delegation.name
                  properties = delegation.service_delegation != null && length(delegation.service_delegation) > 0 ? {
                    serviceName = delegation.service_delegation[0].name
                    actions     = delegation.service_delegation[0].actions != null && length(delegation.service_delegation[0].actions) > 0 ? tolist(delegation.service_delegation[0].actions) : null
                  } : null
                }
              ] : null
            }
          )
        }
      ] : null
    }
  }
  desired_address_space   = var.address_space != null ? tolist(var.address_space) : null
  effective_address_space = local.address_space_should_suppress ? try(coalesce(local.existing_address_space, local.desired_address_space), null) : local.desired_address_space
  existing_address_space  = local.should_read_existing_address_space && data.azapi_resource.existing.exists ? try(data.azapi_resource.existing.output.properties.addressSpace.addressPrefixes, null) : null
  # Read existing service endpoints order for each subnet
  existing_service_endpoints_by_subnet = data.azapi_resource.existing.exists ? try({
    for s in data.azapi_resource.existing.output.properties.subnets :
    s.name => try([for ep in s.properties.serviceEndpoints : ep.service], [])
  }, {}) : {}
  # Read existing subnet order from Azure to maintain consistency
  existing_subnet_names = data.azapi_resource.existing.exists ? try([for s in data.azapi_resource.existing.output.properties.subnets : s.name], []) : []
  locks                 = [] # Populated by Type 2 task
  # Edge zone normalization (matches edgezones.Normalize which uses location.Normalize)
  normalized_edge_zone = var.edge_zone != null ? lower(replace(var.edge_zone, " ", "")) : null
  # Location normalization (matches provider's location.Normalize)
  normalized_location = lower(replace(var.location, " ", ""))
  # Order subnets according to existing Azure order, fall back to sorted order for new subnets
  ordered_subnets = var.subnet != null ? (
    length(local.existing_subnet_names) > 0 ? [
      for name in local.existing_subnet_names : local.subnet_map[name] if contains(keys(local.subnet_map), name)
      ] : [
      # No existing order, sort alphabetically for consistency
      for item in sort([for s in var.subnet : jsonencode({ name = s.name, data = s })]) : jsondecode(item).data
    ]
  ) : []
  replace_triggers_external_values = {
    edge_zone = { value = local.normalized_edge_zone }
  }
  retry = null
  sensitive_body = {
    properties = {
      # Add sensitive fields directly here
    }
  }
  sensitive_body_version = {
    # All possible sensitive field paths with try(tostring(...), "null")
    # Example: "properties.virtualMachineProfile.userData" = try(tostring(var.user_data_version), "null")
  }
  # Helper: Determine service endpoints order for each subnet
  # If existing order exists and matches the desired endpoints, use it; otherwise sort alphabetically
  service_endpoints_ordered_by_subnet = var.subnet != null ? {
    for s in var.subnet : s.name => (
      s.service_endpoints != null && length(s.service_endpoints) > 0 ? (
        # Check if existing order exists and all endpoints match
        contains(keys(local.existing_service_endpoints_by_subnet), s.name) &&
        length(setsubtract(toset(local.existing_service_endpoints_by_subnet[s.name]), s.service_endpoints)) == 0 &&
        length(setsubtract(s.service_endpoints, toset(local.existing_service_endpoints_by_subnet[s.name]))) == 0 ?
        # Use existing order (filter to only include endpoints we want)
        [for ep in local.existing_service_endpoints_by_subnet[s.name] : ep if contains(tolist(s.service_endpoints), ep)] :
        # No existing match, sort alphabetically
        sort(tolist(s.service_endpoints))
      ) : []
    )
  } : {}
  # DiffSuppressFunc for address_space: suppress diff when ip_address_pool is used
  should_read_existing_address_space = var.ip_address_pool != null
  # Create a map of subnets by name for lookup
  subnet_map = var.subnet != null ? { for s in var.subnet : s.name => s } : {}
}

data "azapi_resource" "existing" {
  name                   = var.name
  parent_id              = var.resource_group_id
  type                   = local.azapi_header.type
  ignore_not_found       = true
  response_export_values = ["*"]
}
