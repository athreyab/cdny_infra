@description('Key Vault Name')
param keyVaultName string

@description('Location for the Key Vault')
param location string
param tenantResourceId string 
param keyVaultAccessPolicy array
param logAnalyticsWorkspaceId string
@description('Networks to allow traffic for Keyvault')
param privateEndpointSubnetId string
param privateSubnetId string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantResourceId
    accessPolicies: keyVaultAccessPolicy
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
      ]
      virtualNetworkRules: [
        {id: privateEndpointSubnetId
         ignoreMissingVnetServiceEndpoint: false
        }
        {id:privateSubnetId
        ignoreMissingVnetServiceEndpoint: false
      }
      ]
    }
    publicNetworkAccess: 'Enabled'
    enableSoftDelete: true
    enablePurgeProtection: true
    softDeleteRetentionInDays: 90
   }
 
}


 //Enable diagnostic settings for the Key Vault with 90-day retention
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'set1'
  scope: keyVault
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 0
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 0
        }
      }
    ]
  }
}

 output keyVaultId string =  keyVault.id 
 output keyVaultName string =  keyVault.name
 output keyVaultUri string =  keyVault.properties.vaultUri
//  output administratorLoginSecret string = reference(keyVault.id, '2022-07-01').secrets['administratorusername'].value
//  output administratorLoginPasswordSecret string = reference(keyVault.id, '2022-07-01').secrets['administratorpassword'].value
//  output accessToken string = reference(keyVault.id, '2022-07-01').secrets['databricks-access-token'].value
//  output connectionstring string = reference(keyVault.id, '2022-07-01').secrets['dbconnectionstring'].value

