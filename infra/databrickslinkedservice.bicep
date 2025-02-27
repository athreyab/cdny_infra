param dataFactoryName string
param linkedServiceName string
param databricksWorkspaceUrl string
param workspaceresourceId string 
param existingClusterId string
param linkedServiceNameforKV string
param keyVaultSecretName string
 
// param Nameofthecreds string 
// param userManagedidentityId string
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
      
        // type: 'ManagedIdentity'
        // resourceId: userManagedidentityId  
        accessToken : {
          
          type: 'AzureKeyVaultSecret'
          store: {
            referenceName: linkedServiceNameforKV
            type: 'LinkedServiceReference'
          }
          secretName: keyVaultSecretName

        }

         
                
      
      workspaceResourceId: workspaceresourceId
      existingClusterId: existingClusterId
    
  }
}
}

output linkedServiceUri string = databricksLinkedService.id
