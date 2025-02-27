@description('The name of the Application Insights resource.')
param applicationInsightsName string
param WorkspaceResourceID string 

@description('Location for Application Insights.')
param appInsightsLocation string

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: appInsightsLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: WorkspaceResourceID
  }
}

output instrumentationKey string = applicationInsights.properties.InstrumentationKey
