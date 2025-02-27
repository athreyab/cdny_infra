@description('The location for the Private DNS Zone.')
param location string

@description('The name of the Private DNS Zone.')
param privateDnsZoneName string

@description('The name of the Virtual Network to link with the Private DNS Zone.')
param vnetName string

@description('The name of the Virtual Network the users use to link with the Private DNS Zone.')
param uservnetName string

@description('The ID of the Virtual Network to link with the Private DNS Zone.')
param vnetId string

@description('The ID of the Virtual Network the Users use to link with the Private DNS Zone.')
param uservnetId string

@description('The Prefix for naming resources')
param resourceprefix string

@description('String indicating if the Private DNS is new or existing')
param newOrExisting string 

resource privateDnsZonenew 'Microsoft.Network/privateDnsZones@2024-06-01' = if (newOrExisting == 'new') {
  name: privateDnsZoneName
   location: location
   properties: {}
}


resource privateDnsZoneexisting 'Microsoft.Network/privateDnsZones@2024-06-01' existing = if (newOrExisting == 'existing'){
  name: privateDnsZoneName
}

resource vnetLinknew 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' =  if (newOrExisting == 'new') {
  name: '${resourceprefix}-${vnetName}-link'
  location: location
  parent: privateDnsZonenew
    properties: {
      virtualNetwork: {
        id: vnetId
      }
      registrationEnabled: false // Set to true if you want automatic DNS record registration
      resolutionPolicy: 'Default'
    }
}

resource uservnetLinknew 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = if (newOrExisting == 'new'){
  name: 'PAYG-CDNYRG-${uservnetName}-link'
  location: location
  parent: privateDnsZonenew
   properties: {
     virtualNetwork: {
       id: uservnetId
     }
     registrationEnabled: false // Set to true if you want automatic DNS record registration
     resolutionPolicy: 'Default'
   }
}


resource vnetLinkexisting 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = if (newOrExisting == 'existing'){
  name: '${resourceprefix}-${vnetName}-link'
  location: location
  parent: privateDnsZoneexisting
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false // Set to true if you want automatic DNS record registration
    resolutionPolicy: 'Default'
  }
}

resource uservnetLinkexisting 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = if (newOrExisting == 'existing') {
  name: 'PAYG-CDNYRG-${uservnetName}-link'
  location: location
  parent: privateDnsZoneexisting
  properties: {
    virtualNetwork: {
      id: uservnetId
    }
    registrationEnabled: false // Set to true if you want automatic DNS record registration
    resolutionPolicy: 'Default'
  }
}

output privateDnsZoneId string = ((newOrExisting == 'new') ? privateDnsZonenew.id : privateDnsZoneexisting.id)
output vnetLinkId string = ((newOrExisting == 'new') ? vnetLinknew.id : vnetLinkexisting.id )
output vnetlinkuserId string = ((newOrExisting == 'new') ? uservnetLinknew.id : uservnetLinkexisting.id)


