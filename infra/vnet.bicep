@description('The location for the Virtual Network.')
param location string

@description('The name of the Virtual Network.')
param vnetName string

@description('CIDR range for the Virtual Network.')
param vnetCidr string

@description('CIDR range for the public subnet.')
param publicSubnetCidr string

@description('The name of the public subnet.')
param publicSubnetName string

@description('CIDR range for the private subnet.')
param privateSubnetCidr string

@description('The name of the private subnet.')
param privateSubnetName string

@description('ID of the Network Security Group.')
param nsgId string

@description('ID of the NAT Gateway.')
param natGatewayId string

@description('The name and CDIR for the Private Endpoint subnet')
param privateEndpointSubnetCidr string
param privateEndpointSubnetName string


resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  location: location
  name: vnetName
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetCidr
      ]
    }
    enableDdosProtection: false
    virtualNetworkPeerings: []
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: publicSubnetName
        properties: {
          addressPrefix: publicSubnetCidr
          networkSecurityGroup: {
            id: nsgId
          }
          natGateway: {
            id: natGatewayId
          }
          delegations: [
            {
              name: 'databricks-del-private'
              properties: {
                serviceName: 'Microsoft.Databricks/workspaces'
              }
            }
          ]
        }
      }
      {
        name: privateSubnetName
        properties: {
          addressPrefix: privateSubnetCidr
          serviceEndpoints: [
            {
            service: 'Microsoft.Storage'
            locations: [
              'eastus'
              'westus'
              'westus3'
            ]
            }
            {
              service: 'Microsoft.KeyVault'
              locations: [
                '*'
              ]
            }
          ]
          networkSecurityGroup: {
            id: nsgId
          }
          natGateway: {
            id: natGatewayId
          }
          delegations: [
            {
              name: 'databricks-del-private'
              properties: {
                serviceName: 'Microsoft.Databricks/workspaces'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: privateEndpointSubnetName
        properties: {
          addressPrefix: privateEndpointSubnetCidr
          serviceEndpoints: [
            {
            service: 'Microsoft.Storage'
            locations: [
              'eastus'
              'westus'
              'westus3'
            ]
            }
            {
            service: 'Microsoft.KeyVault'
            locations: [
              '*'
            ]
          }
          {
            service: 'Microsoft.Sql'
            locations: [
                'eastus'
            ]
          }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
  }
}



output vnetId string =  vnet.id 
output privateSubnetId string =  '${vnet.id}/subnets/${privateSubnetName}' 
output publicSubnetId string = '${vnet.id}/subnets/${publicSubnetName}' 
output privateEndpointSubnetId string = '${vnet.id}/subnets/${privateEndpointSubnetName}' 
