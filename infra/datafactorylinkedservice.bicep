param dataFactoryName string
param linkedServiceName string
param databricksWorkspaceUrl string
param workspaceresourceId string 
param existingClusterId string
// param linkedServiceNameforKV string
// param keyVaultSecretName string
 
//param Nameofthecreds string 
//param userManagedidentityId string
// param workspacename string



resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource databricksLinkedService 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  parent: dataFactory
  name: linkedServiceName
  properties: {
    description: 'Linked Service to Azure Databricks'
    type: 'AzureDatabricks'
    typeProperties: {      
      domain: databricksWorkspaceUrl      
      authentication: 'MSI'
      workspaceResourceId: workspaceresourceId
      // workspaceResourceId: '/subscriptions/cbd95f29-fad7-443a-8c4a-4afa332124d8/resourceGroups/CDNY-QA-DEV-SUB-CSP-test-RG/providers/Microsoft.Databricks/workspaces/cdny-dwh-eus-dev-databricks01'
      credential: {
        referenceName: 'MIcreds'
        type: 'CredentialReference'
      }
      
      // workspaceResourceId: workspaceresourceId
      existingClusterId: existingClusterId
    
  }
}
}

output linkedServiceUri string = databricksLinkedService.id
