@description('The location for the network security group.')
param location string
param securityRules array

@description('The name of the network security group to create.')
param nsgName string

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  location: location
  name: nsgName
  properties: {
    securityRules: securityRules
  }
}

output nsgId string = nsg.id
