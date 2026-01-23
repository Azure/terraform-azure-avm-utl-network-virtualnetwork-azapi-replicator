# Migration Track: azurerm_virtual_network to azapi_resource

## Resource Information

**Source Resource Type**: `azurerm_virtual_network`

**Target Resource Type**: `Microsoft.Network/virtualNetworks@2024-07-01`

**Evidence from AzureRM Provider Source Code**:
- Schema location: `github.com/hashicorp/terraform-provider-azurerm/internal/services/network/resourceVirtualNetwork()`
- Create function: `resourceVirtualNetworkCreate()` uses `virtualnetworks.VirtualNetwork` from SDK path `github.com/hashicorp/go-azure-sdk/resource-manager/network/2025-01-01/virtualnetworks`
- The SDK import path confirms this resource manages `Microsoft.Network/virtualNetworks` resource type
- Create function constructs the VirtualNetwork object at line: `vnet := virtualnetworks.VirtualNetwork{...}` and calls `client.CreateOrUpdateThenPoll(ctx, id, vnet)`
- API version 2024-07-01 is the latest stable API version available (2025-01-01 used in SDK is newer but not yet in Azure API list)

## Planning Task List

| No. | Path | Type | Required | Status | Proof Doc Markdown Link |
|-----|------|------|----------|--------|-------------------------|
| 1 | name | Argument | Yes | ✅ Completed | [1.name.md](1.name.md) |
| 2 | resource_group_name | Argument | Yes | ✅ Completed | [2.resource_group_name.md](2.resource_group_name.md) |
| 3 | location | Argument | Yes | ✅ Completed | [3.location.md](3.location.md) |
| 4 | address_space | Argument | No* | ✅ Completed | [4.address_space.md](4.address_space.md) |
| 5 | bgp_community | Argument | No | ✅ Completed | [5.bgp_community.md](5.bgp_community.md) |
| 6 | dns_servers | Argument | No | ✅ Completed | [6.dns_servers.md](6.dns_servers.md) |
| 7 | edge_zone | Argument | No | ✅ Completed | [7.edge_zone.md](7.edge_zone.md) |
| 8 | flow_timeout_in_minutes | Argument | No | ✅ Completed | [8.flow_timeout_in_minutes.md](8.flow_timeout_in_minutes.md) |
| 9 | private_endpoint_vnet_policies | Argument | No | ✅ Completed | [9.private_endpoint_vnet_policies.md](9.private_endpoint_vnet_policies.md) |
| 10 | tags | Argument | No | ✅ Completed | [10.tags.md](10.tags.md) |
| 11 | __check_root_hidden_fields__ | HiddenFieldsCheck | Yes | ✅ Completed | [11.check_root_hidden_fields.md](11.check_root_hidden_fields.md) |
| 12 | ddos_protection_plan | Block | No | ✅ Completed | [12.ddos_protection_plan.md](12.ddos_protection_plan.md) |
| 13 | ddos_protection_plan.id | Argument | Yes | ✅ Completed | [13.ddos_protection_plan.id.md](13.ddos_protection_plan.id.md) |
| 14 | ddos_protection_plan.enable | Argument | Yes | ✅ Completed | [14.ddos_protection_plan.enable.md](14.ddos_protection_plan.enable.md) |
| 15 | encryption | Block | No | ✅ Completed | [15.encryption.md](15.encryption.md) |
| 16 | encryption.enforcement | Argument | Yes | ✅ Completed | [16.encryption.enforcement.md](16.encryption.enforcement.md) |
| 17 | ip_address_pool | Block | No | ✅ Completed | [17.ip_address_pool.md](17.ip_address_pool.md) |
| 18 | ip_address_pool.id | Argument | Yes | ✅ Completed | [18.ip_address_pool.id.md](18.ip_address_pool.id.md) |
| 19 | ip_address_pool.number_of_ip_addresses | Argument | Yes | ✅ Completed | [19.ip_address_pool.number_of_ip_addresses.md](19.ip_address_pool.number_of_ip_addresses.md) |
| 20 | subnet | Block | No | ✅ Completed | [20.subnet.md](20.subnet.md) |
| 21 | subnet.name | Argument | Yes | ✅ Completed | [21.subnet.name.md](21.subnet.name.md) |
| 22 | subnet.address_prefixes | Argument | Yes | ✅ Completed | [22.subnet.address_prefixes.md](22.subnet.address_prefixes.md) |
| 23 | subnet.default_outbound_access_enabled | Argument | No | ✅ Completed | [23.subnet.default_outbound_access_enabled.md](23.subnet.default_outbound_access_enabled.md) |
| 24 | subnet.private_endpoint_network_policies | Argument | No | ✅ Completed | [24.subnet.private_endpoint_network_policies.md](24.subnet.private_endpoint_network_policies.md) |
| 25 | subnet.private_link_service_network_policies_enabled | Argument | No | ✅ Completed | [25.subnet.private_link_service_network_policies_enabled.md](25.subnet.private_link_service_network_policies_enabled.md) |
| 26 | subnet.route_table_id | Argument | No | ✅ Completed | [26.subnet.route_table_id.md](26.subnet.route_table_id.md) |
| 27 | subnet.security_group | Argument | No | ✅ Completed | [27.subnet.security_group.md](27.subnet.security_group.md) |
| 28 | subnet.service_endpoint_policy_ids | Argument | No | ✅ Completed | [28.subnet.service_endpoint_policy_ids.md](28.subnet.service_endpoint_policy_ids.md) |
| 29 | subnet.service_endpoints | Argument | No | ✅ Completed | [29.subnet.service_endpoints.md](29.subnet.service_endpoints.md) |
| 30 | subnet.id | Argument | No (Computed) | ✅ Completed | [30.subnet.id.md](30.subnet.id.md) |
| 31 | subnet.delegation | Block | No | ✅ Completed | [31.subnet.delegation.md](31.subnet.delegation.md) |
| 32 | subnet.delegation.name | Argument | Yes | ✅ Completed | [32.subnet.delegation.name.md](32.subnet.delegation.name.md) |
| 33 | subnet.delegation.service_delegation | Block | Yes | ✅ Completed | [33.subnet.delegation.service_delegation.md](33.subnet.delegation.service_delegation.md) |
| 34 | subnet.delegation.service_delegation.name | Argument | Yes | ✅ Completed | [34.subnet.delegation.service_delegation.name.md](34.subnet.delegation.service_delegation.name.md) |
| 35 | subnet.delegation.service_delegation.actions | Argument | No | ✅ Completed | [35.subnet.delegation.service_delegation.actions.md](35.subnet.delegation.service_delegation.actions.md) |
| 36 | timeouts | Block | No | ✅ Completed | [36.timeouts.md](36.timeouts.md) |
| 37 | timeouts.create | Argument | No | ✅ Completed | [37.timeouts.create.md](37.timeouts.create.md) |
| 38 | timeouts.read | Argument | No | ✅ Completed | [38.timeouts.read.md](38.timeouts.read.md) |
| 39 | timeouts.update | Argument | No | ✅ Completed | [39.timeouts.update.md](39.timeouts.update.md) |
| 40 | timeouts.delete | Argument | No | ✅ Completed | [40.timeouts.delete.md](40.timeouts.delete.md) |

**Notes**:
- `address_space` is marked as "No*" for Required because it has `ExactlyOneOf: []string{"address_space", "ip_address_pool"}` - meaning either `address_space` OR `ip_address_pool` must be present, but not both
- The schema definition shows `Timeouts: &pluginsdk.ResourceTimeout{Create: ..., Read: ..., Update: ..., Delete: ...}` confirming all four timeout fields are supported
- The `subnet.id` field is Computed only (output), not an input field
- `guid` (computed only field) is not included in the task list as it's read-only
- `ip_address_pool.allocated_ip_address_prefixes` (computed only field) is not included as it's read-only

## Timeout Configuration Evidence

From the schema definition in `resourceVirtualNetwork()`:
```go
Timeouts: &pluginsdk.ResourceTimeout{
    Create: pluginsdk.DefaultTimeout(30 * time.Minute),
    Read:   pluginsdk.DefaultTimeout(5 * time.Minute),
    Update: pluginsdk.DefaultTimeout(30 * time.Minute),
    Delete: pluginsdk.DefaultTimeout(30 * time.Minute),
},
```

This confirms that all four timeout operations (create, read, update, delete) are supported by the azurerm_virtual_network resource.
