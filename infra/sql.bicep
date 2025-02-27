@description('The name of the SQL logical server.')
param serverName string

@description('Location for all resources.')
param location string

//@description('The name of the Virtual Network to link with the Private DNS Zone.')
//param vnetName string

//@description('The ID of the Virtual Network to link with the Private DNS Zone.')
//param vnetId string

@description('The Log Analytics Workspace ID for Auditing')
param logAnalyticsWorkspaceId string 

//@description('Enable Auditing of Microsoft support operations (DevOps)')
//param isMSDevOpsAuditEnabled bool = true

@description('The administrator username of the SQL logical server.')
param administratorLogin string

@description('The Managed Identity of the SQL logical server.')
param userManagedIdentityId string 

@description('The administrator password of the SQL logical server.')
@secure()
param administratorLoginPassword string

//@description('Paramter New or Existing passed from main')
//param newOrExisting string 

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' =  {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    primaryUserAssignedIdentityId: userManagedIdentityId
    publicNetworkAccess: 'Disabled' // Disable public network access
    minimalTlsVersion: '1.2' // Enforce TLS 1.2
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userManagedIdentityId}': {}    
    }
    
  }
}


/*resource vnetRule 'Microsoft.Sql/servers/virtualNetworkRules@2021-02-01-preview' = {
  name: '${serverName}-${vnetName}'
  parent: sqlServer
  properties: {
    virtualNetworkSubnetId: vnetId
    ignoreMissingVnetServiceEndpoint: true
  }
}
*/
resource masterDb 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  parent: sqlServer
  location: location
  name: 'master'
  properties: {}
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: masterDb
  name: '${serverName}-masterDb'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logAnalyticsDestinationType: 'Dedicated'
    logs: [
      {
        category: 'SQLSecurityAuditEvents'
        enabled: true
        retentionPolicy: {
          days: 90
          enabled: false
        }
      }
      //{
      //  category: 'DevOpsOperationsAudit'
      //  enabled: true
      //  retentionPolicy: {
      //    days: 90
      //    enabled: false
      //  }
      //}
    ]
  }
}
// Enable auditing for the SQL Server - Disabling this as of 2-11-25 as it's not needed. 
//resource sqlAuditSettings 'Microsoft.Sql/servers/auditingSettings@2024-05-01-preview' = {
  //name: 'default'
  //parent: sqlServer
  //properties: {
  //  state: 'Enabled'
  //  isAzureMonitorTargetEnabled: true
  //  isManagedIdentityInUse: false
  // auditActionsAndGroups: [
  //  'BATCH_COMPLETED_GROUP'
  //    'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
  //    'FAILED_DATABASE_AUTHENTICATION_GROUP'
  //  ]
  // storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
//  }
//}

//resource devOpsAuditingSettings 'Microsoft.Sql/servers/devOpsAuditingSettings@2021-11-01-preview' = if (isMSDevOpsAuditEnabled) {
//  parent: sqlServer
//  name: 'default'
//  properties: {
//    state: 'Enabled'
//    isAzureMonitorTargetEnabled: true
//  }
//}
output sqlServerName string =  sqlServer.name
output sqlServerId string =  sqlServer.id





































