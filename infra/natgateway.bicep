@description('The location for the NAT Gateway and Public IP.')
param location string

@description('Name of the NAT Gateway to create.')
param natGatewayName string

@description('Name of the NAT Gateway Public IP.')
param natGatewayPublicIpName string

// Create Public IP for NAT Gateway
resource publicIp 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  name: natGatewayPublicIpName
  location: location
  sku: {
      name: 'Standard'
      tier: 'Regional'
    }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    ddosSettings: {
    protectionMode: 'VirtualNetworkInherited'
    }
  }
}

// Create NAT Gateway
resource natGateway 'Microsoft.Network/natGateways@2024-03-01' = {
  name: natGatewayName
  location: location
  sku: {
    name: 'Standard'
    //tier: 'Regional'
  }
  properties: {
    publicIpAddresses: [
      {
        id: publicIp.id
      }
    ]
    idleTimeoutInMinutes: 4  // Optional: Timeout for idle connections
  }
}


output natGatewayId string = natGateway.id
