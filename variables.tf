variable "location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
  nullable    = false

  validation {
    condition     = length(var.location) > 0
    error_message = "The location must not be empty."
  }
}

variable "name" {
  type        = string
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
  nullable    = false
}

variable "resource_group_id" {
  type        = string
  description = "The resource ID of the resource group where the virtual network will be created. Required for azapi_resource parent_id."
  nullable    = false
}

variable "address_space" {
  type        = set(string)
  default     = null
  description = "(Optional) The address space that is used the virtual network. You can supply more than one address space."

  validation {
    condition     = var.address_space == null || var.ip_address_pool == null
    error_message = "Only one of address_space or ip_address_pool can be specified."
  }
  validation {
    condition     = var.address_space == null || length(var.address_space) >= 1
    error_message = "address_space must contain at least one element when specified."
  }
  validation {
    condition = var.address_space == null || alltrue([
      for addr in var.address_space : length(addr) > 0
    ])
    error_message = "Each address prefix in address_space must not be empty."
  }
}

variable "bgp_community" {
  type        = string
  default     = null
  description = "(Optional) The BGP community attribute in format `<as-number>:<community-value>`."

  validation {
    condition     = var.bgp_community == null || can(regex("^[0-9]+:[0-9]+$", var.bgp_community))
    error_message = "Invalid notation of bgp community: expected \"x:y\"."
  }
  validation {
    condition = var.bgp_community == null || (
      tonumber(split(":", var.bgp_community)[0]) > 0 &&
      tonumber(split(":", var.bgp_community)[0]) < 65535
    )
    error_message = "ASN must be in range (0, 65535) (exclusive)."
  }
  validation {
    condition = var.bgp_community == null || (
      tonumber(split(":", var.bgp_community)[1]) > 0 &&
      tonumber(split(":", var.bgp_community)[1]) < 65535
    )
    error_message = "Community value must be in range (0, 65535) (exclusive)."
  }
}

variable "ddos_protection_plan" {
  type = object({
    enable = bool
    id     = string
  })
  default     = null
  description = <<-EOT
 - `enable` - (Required) Enable/disable DDoS Protection Plan on Virtual Network.
 - `id` - (Required) The ID of DDoS Protection Plan.
EOT

  validation {
    condition     = var.ddos_protection_plan == null || can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.Network/ddosProtectionPlans/[^/]+$", var.ddos_protection_plan.id))
    error_message = "The id must be a valid DDoS Protection Plan resource ID in the format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}"
  }
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "(Optional) List of IP addresses of DNS servers"

  validation {
    condition = var.dns_servers == null || alltrue([
      for dns in var.dns_servers : length(dns) > 0
    ])
    error_message = "Each DNS server address must not be empty."
  }
}

variable "edge_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created."

  validation {
    condition     = var.edge_zone == null || length(var.edge_zone) > 0
    error_message = "The edge_zone must not be empty when specified."
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "encryption" {
  type = object({
    enforcement = string
  })
  default     = null
  description = <<-EOT
 - `enforcement` - (Required) Specifies if the encrypted Virtual Network allows VM that does not support encryption. Possible values are `DropUnencrypted` and `AllowUnencrypted`.
EOT

  validation {
    condition     = var.encryption == null || contains(["DropUnencrypted", "AllowUnencrypted"], var.encryption.enforcement)
    error_message = "The enforcement must be either 'DropUnencrypted' or 'AllowUnencrypted'."
  }
}

variable "flow_timeout_in_minutes" {
  type        = number
  default     = null
  description = "(Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between `4` and `30` minutes."

  validation {
    condition     = var.flow_timeout_in_minutes == null || (var.flow_timeout_in_minutes >= 4 && var.flow_timeout_in_minutes <= 30)
    error_message = "The flow_timeout_in_minutes must be between 4 and 30 minutes."
  }
}

variable "ip_address_pool" {
  type = list(object({
    id                     = string
    number_of_ip_addresses = string
  }))
  default     = null
  description = <<-EOT
 - `id` - (Required) The ID of the Network Manager IP Address Management (IPAM) Pool.
 - `number_of_ip_addresses` - (Required) The number of IP addresses to allocated to the Virtual Network. The value must be a string that represents a positive number, e.g., `"100"`.
EOT

  validation {
    condition     = var.ip_address_pool == null || length(var.ip_address_pool) <= 2
    error_message = "ip_address_pool can contain at most 2 items."
  }
  validation {
    condition = var.ip_address_pool == null || alltrue([
      for pool in var.ip_address_pool : can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.Network/networkManagers/[^/]+/ipamPools/[^/]+$", pool.id))
    ])
    error_message = "Each id must be a valid IPAM Pool resource ID in the format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkManagers/{networkManagerName}/ipamPools/{ipamPoolName}"
  }
  validation {
    condition = var.ip_address_pool == null || alltrue([
      for pool in var.ip_address_pool : can(regex("^[1-9]\\d*$", pool.number_of_ip_addresses))
    ])
    error_message = "`number_of_ip_addresses` must be a string that represents a positive number"
  }
}

variable "private_endpoint_vnet_policies" {
  type        = string
  default     = "Disabled"
  description = "(Optional) The Private Endpoint VNet Policies for the Virtual Network. Possible values are `Disabled` and `Basic`. Defaults to `Disabled`."
  nullable    = false

  validation {
    condition     = contains(["Disabled", "Basic"], var.private_endpoint_vnet_policies)
    error_message = "The private_endpoint_vnet_policies must be either 'Disabled' or 'Basic'."
  }
}

variable "subnet" {
  type = set(object({
    address_prefixes                              = list(string)
    default_outbound_access_enabled               = optional(bool, true)
    id                                            = string
    name                                          = string
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = bool
    route_table_id                                = string
    security_group                                = string
    service_endpoint_policy_ids                   = set(string)
    service_endpoints                             = set(string)
    delegation = list(object({
      name = string
      service_delegation = list(object({
        actions = set(string)
        name    = string
      }))
    }))
  }))
  default     = null
  description = <<-EOT
 - `address_prefixes` - (Required) The address prefixes to use for the subnet.
 - `default_outbound_access_enabled` - (Optional) Enable default outbound access to the internet for the subnet. Defaults to `true`.
 - `id` - 
 - `name` - (Required) The name of the subnet.
 - `private_endpoint_network_policies` - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are `Disabled`, `Enabled`, `NetworkSecurityGroupEnabled` and `RouteTableEnabled`. Defaults to `Disabled`.
 - `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to `true`.
 - `route_table_id` - (Optional) The ID of the Route Table that should be associated with this subnet.
 - `security_group` - (Optional) The Network Security Group to associate with the subnet. (Referenced by `id`, i.e. `azurerm_network_security_group.example.id`)
 - `service_endpoint_policy_ids` - (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.
 - `service_endpoints` - (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage`, `Microsoft.Storage.Global` and `Microsoft.Web`.

 ---
 `delegation` block supports the following:
 - `name` - (Required) A name for this delegation.

 ---
 `service_delegation` block supports the following:
 - `actions` - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/publicIPAddresses/join/action`, `Microsoft.Network/publicIPAddresses/read`, `Microsoft.Network/virtualNetworks/read`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action`, and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.
 - `name` - (Required) The name of service to delegate to. Possible values are `GitHub.Network/networkSettings`, `Informatica.DataManagement/organizations`, `Microsoft.ApiManagement/service`, `Microsoft.Apollo/npu`, `Microsoft.App/environments`, `Microsoft.App/testClients`, `Microsoft.AVS/PrivateClouds`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureHostedService`, `Microsoft.BareMetal/AzureHPC`, `Microsoft.BareMetal/AzurePaymentHSM`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.BareMetal/MonitoringServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.CloudTest/hostedpools`, `Microsoft.CloudTest/images`, `Microsoft.CloudTest/pools`, `Microsoft.Codespaces/plans`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.ContainerService/TestClients`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/servers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.DelegatedNetwork/controller`, `Microsoft.DevCenter/networkConnection`, `Microsoft.DevOpsInfrastructure/pools`, `Microsoft.DocumentDB/cassandraClusters`, `Microsoft.Fidalgo/networkSettings`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.LabServices/labplans`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/applicationGateways`, `Microsoft.Network/dnsResolvers`, `Microsoft.Network/managedResolvers`, `Microsoft.Network/fpgaNetworkInterfaces`, `Microsoft.Network/networkWatchers.`, `Microsoft.Network/virtualNetworkGateways`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerAutomate/hostedRpa`, `Microsoft.PowerPlatform/enterprisePolicies`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.ServiceNetworking/trafficControllers`, `Microsoft.Singularity/accounts/networks`, `Microsoft.Singularity/accounts/npu`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/managedInstancesOnebox`, `Microsoft.Sql/managedInstancesStage`, `Microsoft.Sql/managedInstancesTest`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments`, `PaloAltoNetworks.Cloudngfw/firewalls`, `Qumulo.Storage/fileSystems`, and `Oracle.Database/networkAttachments`.
EOT

  validation {
    condition = var.subnet == null || alltrue([
      for s in var.subnet : s.name != null && s.name != ""
    ])
    error_message = "Each subnet's name must not be null or empty."
  }
  validation {
    condition = var.subnet == null || alltrue([
      for s in var.subnet : s.address_prefixes != null && length(s.address_prefixes) >= 1
    ])
    error_message = "Each subnet's address_prefixes must contain at least one element."
  }
  validation {
    condition = var.subnet == null || alltrue([
      for s in var.subnet : alltrue([
        for prefix in s.address_prefixes : prefix != null && prefix != ""
      ])
    ])
    error_message = "Each address prefix in subnet.address_prefixes must not be null or empty."
  }
  validation {
    condition = var.subnet == null || alltrue([
      for s in var.subnet : contains(["Disabled", "Enabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"], s.private_endpoint_network_policies)
    ])
    error_message = "Each subnet's private_endpoint_network_policies must be one of: 'Disabled', 'Enabled', 'NetworkSecurityGroupEnabled', 'RouteTableEnabled'."
  }
  validation {
    condition = var.subnet == null || alltrue([
      for s in var.subnet : s.service_endpoint_policy_ids == null || alltrue([
        for policy_id in s.service_endpoint_policy_ids : can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.Network/serviceEndpointPolicies/[^/]+$", policy_id))
      ])
    ])
    error_message = "Each service_endpoint_policy_ids must be a valid Service Endpoint Policy resource ID in the format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}"
  }
  validation {
    condition = var.subnet == null || alltrue(flatten([
      for s in var.subnet : s.delegation == null ? [true] : [
        for d in s.delegation : d.service_delegation == null || length(d.service_delegation) == 0 ? true : alltrue([
          for sd in d.service_delegation : sd.actions == null || alltrue([
            for action in sd.actions : contains([
              "Microsoft.Network/networkinterfaces/*",
              "Microsoft.Network/publicIPAddresses/join/action",
              "Microsoft.Network/publicIPAddresses/read",
              "Microsoft.Network/virtualNetworks/read",
              "Microsoft.Network/virtualNetworks/subnets/action",
              "Microsoft.Network/virtualNetworks/subnets/join/action",
              "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
              "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
            ], action)
          ])
        ])
      ]
    ]))
    error_message = "Each action in subnet.delegation.service_delegation.actions must be one of: 'Microsoft.Network/networkinterfaces/*', 'Microsoft.Network/publicIPAddresses/join/action', 'Microsoft.Network/publicIPAddresses/read', 'Microsoft.Network/virtualNetworks/read', 'Microsoft.Network/virtualNetworks/subnets/action', 'Microsoft.Network/virtualNetworks/subnets/join/action', 'Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action', 'Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action'."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "timeouts" {
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
    read   = optional(string, "5m")
    update = optional(string, "30m")
  })
  default = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "30m"
  }
  description = <<-EOT
 - `create` - (Optional) Specifies the timeout for create operations. Defaults to 30 minutes.
 - `delete` - (Optional) Specifies the timeout for delete operations. Defaults to 30 minutes.
 - `read` - (Optional) Specifies the timeout for read operations. Defaults to 5 minutes.
 - `update` - (Optional) Specifies the timeout for update operations. Defaults to 30 minutes.
EOT
  nullable    = false
}
