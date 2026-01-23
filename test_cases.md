# Test Configuration Functions for azurerm_virtual_network

## Basic/Foundation Cases (3 cases):
1. **`r.basic(data)`** - Basic virtual network with single subnet and single tag
   - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
   - Status: Pending

2. **`r.complete(data)`** - Complete configuration with multiple address spaces, DNS servers, encryption, private_endpoint_vnet_policies, and multiple subnets
   - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
   - Status: Pending

3. **`r.noSubnet(data)`** - Virtual network with no subnets (empty subnet array)
   - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
   - Status: Pending

## Feature-Specific Cases (11 cases):

### DDoS Protection (1 case):
4. **`r.ddosProtectionPlan(data)`** - Virtual network with DDoS protection plan enabled
   - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
   - Status: Pending

### Tags (2 cases):
5. **`r.withTags(data)`** - Virtual network with multiple tags (environment and cost_center)
   - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
   - Status: Pending

6. **`r.withTagsUpdated(data)`** - Virtual network with updated/different tags
   - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
   - Status: Pending

7. **`r.tagCount(data)`** - Virtual network with 50 tags (testing tag limits)
   - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
   - Status: Pending

### BGP Community (1 case):
8. **`r.bgpCommunity(data)`** - Virtual network with BGP community configuration
   - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
   - Status: Pending

### Flow Timeout (1 case):
9. **`r.updateFlowTimeoutInMinutes(data, 5)`** - Virtual network with flow_timeout_in_minutes set to 5
   - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
   - Status: Pending

10. **`r.updateFlowTimeoutInMinutes(data, 6)`** - Virtual network with flow_timeout_in_minutes set to 6
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

### Edge Zone (1 case):
11. **`r.edgeZone(data)`** - Virtual network with edge zone configuration
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

### IP Address Pool (5 cases):
12. **`r.ipAddressPool(data)`** - Virtual network with single IP address pool (IPv4, 100 addresses)
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

13. **`r.ipAddressPoolIPv6(data)`** - Virtual network with IPv6 IP address pool
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

14. **`r.ipAddressPoolMultiple(data)`** - Virtual network with multiple IP address pools (IPv4 and IPv6)
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

15. **`r.ipAddressPoolNumberUpdated(data)`** - Virtual network with IP address pool with updated number_of_ip_addresses (300)
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

## Advanced Configuration Cases (4 cases):

### Subnets (4 cases):
16. **`r.subnet(data)`** - Complex subnet configuration with dual-stack (IPv4/IPv6), delegations, service endpoints, and policies
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

17. **`r.subnetUpdated(data)`** - Updated subnet configuration with default_outbound_access_enabled and changed delegation
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

18. **`r.subnetRouteTable(data)`** - Virtual network with subnet that has a route table association
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

19. **`r.subnetRouteTableRemoved(data)`** - Virtual network with subnet after route table association is removed
    - File: [virtual_network_resource_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go)
    - Status: Pending

## List/Query Cases (2 cases):
20. **`r.basicList(data)`** - Multiple virtual networks for list/query testing
    - File: [virtual_network_resource_list_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_list_test.go)
    - Status: Pending

21. **`r.basicList_query(data)`** - List query configuration for virtual networks
    - File: [virtual_network_resource_list_test.go](https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_list_test.go)
    - Status: Pending

---

## Removed Cases:
- ❌ `r.requiresImport(data)` - Error test case (used with ExpectError to validate import rejection)
- ❌ Test function `TestAccVirtualNetwork_resourceIdentity` - Not a configuration function, it's a test that validates resource identity functionality using the basic config

---

## Test Case Summary Table

| Case Name | File URL | Status | Test Status |
| --- | --- | --- | --- |
| basic | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| complete | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| noSubnet | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| ddosProtectionPlan | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| withTags | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| withTagsUpdated | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| tagCount | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| bgpCommunity | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | step 5 in progress |
| updateFlowTimeoutInMinutes_5 | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| updateFlowTimeoutInMinutes_6 | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| edgeZone | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| ipAddressPool | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| ipAddressPoolIPv6 | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| ipAddressPoolMultiple | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| ipAddressPoolNumberUpdated | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| subnet | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| subnetUpdated | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| subnetRouteTable | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| subnetRouteTableRemoved | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_test.go | Completed | test success |
| basicList | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_list_test.go | Completed | test success |
| basicList_query | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/virtual_network_resource_list_test.go | Completed | invalid |

---

**Total Valid Test Cases**: 21

## Notes
- All test files for `azurerm_virtual_network` have been scanned (3 files found):
  - `virtual_network_resource_test.go` (main test file)
  - `virtual_network_resource_identity_gen_test.go` (identity validation test - no unique configs)
  - `virtual_network_resource_list_test.go` (list/query tests)
- No legacy test files found
- The `ipAddressPoolNumberUpdated` config is used in an error test step but also in valid test steps, so it's included
- The `updateFlowTimeoutInMinutes` function takes a parameter, so both variants (5 and 6) are listed as separate test cases
- List and query configurations are included as they test valid resource configurations



















