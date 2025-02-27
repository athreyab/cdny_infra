param logAnalyticsName string 
param location string


resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  retentionInDays: 90
  }
}

output workspaceID string = logAnalyticsWorkspace.id
