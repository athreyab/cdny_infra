@description('Storage Account Name')
param storageAccountName string
 param vnetName string
 param PrivatesubnetName string
 param PrivateendpontsubnetName string

@description('Location for the storage account')
param location string
param userManagedIdentityId string

@description('Tags to apply to the storage account')
param kind string 


resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' =  {
  name: storageAccountName
  location: location
  properties:{
     isHnsEnabled: true
     publicNetworkAccess: 'Enabled'
     allowBlobPublicAccess: false
     allowCrossTenantReplication: false
     allowSharedKeyAccess: false
     networkAcls: {
       defaultAction: 'Deny'
        bypass: 'AzureServices' 
       virtualNetworkRules: [
         {
           id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, PrivateendpontsubnetName)
           action: 'Allow'
         }
         {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, PrivatesubnetName)
          action: 'Allow'
        }
       ]
       ipRules: []
     }
     supportsHttpsTrafficOnly: true
     encryption: {
        services: {
          file: {
            keyType: 'Account'
            enabled: true
          }
          blob: {
            keyType: 'Account'
            enabled: true
          }
        }
        keySource: 'Microsoft.Storage'
     }
    minimumTlsVersion: 'TLS1_2'
    accessTier: 'Hot'
    }
    
  
  sku: {
    name: 'Standard_ZRS'
  }
  kind: kind
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userManagedIdentityId}': {}
    } 
  }
}


output storageAccountId string = storageAccount.id
//output storageAccountName string = ((newOrExisting == 'new') ? storageAccountnew.name : storageAccount.name)

