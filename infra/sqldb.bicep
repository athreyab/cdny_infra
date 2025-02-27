param sqlDBName string
param location string
param sqlServerName string
param logAnalyticsWorkspaceId string 

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: sqlServerName
  
}
resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 50
  }
}

output sqlDBName string = sqlDB.name

// Enable Transparent Data Encryption (TDE) for the SQL Database
resource tde 'Microsoft.Sql/servers/databases/transparentDataEncryption@2021-02-01-preview' = {
  name: 'current'
  parent: sqlDB
  properties: {
    state: 'Enabled'
  }
}

resource SqlDbDiagnostic 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'SqlDBDiganostic'
  scope: sqlDB
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'QueryStoreRuntimeStatistics'
        enabled: true
        retentionPolicy: {
          days: 90
          enabled: false
        }
      }
      {
        category: 'QueryStoreWaitStatistics'
        enabled: true
        retentionPolicy: {
          days: 90
          enabled: false
        }
      }
    ]
  }
}

resource backupofDb'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2022-05-01-preview'  = {

  parent: sqlDB 
  name: 'Default'
  properties: {
    monthlyRetention: 'P1M'
    weeklyRetention: 'P1W'
    weekOfYear: 1
    yearlyRetention: 'P1Y'   
    }

    // storageAccountUri: 'yourStorageAccountUri' // URI of your storage account

  }


