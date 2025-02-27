
param privateEndpointName string 
param location string 
param privatesubnetid string 
param privateLinkServiceId string 
param groupID string 
param privateDnsZoneId string


resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: privatesubnetid
    }
    privateLinkServiceConnections: [
      {
        name: '${privateEndpointName}-link'
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: [groupID]
          
        }
      }
    ]
    
  }
}

resource privateDnsZone 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  parent: privateEndpoint
  name: '${privateEndpointName}-dns'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${privateEndpointName}-dns-config'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}
