// param storageAccountName string 
param linkedServiceNameforstorageAccount string 
param dataFactoryName string 

param keyVaultSecretName string

param linkedServiceNameforKV string
param storageaccounturl string 

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01'  existing= {
  name: dataFactoryName

  
}

resource databricksLinkedServiceforSA 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  parent: dataFactory
  name: linkedServiceNameforstorageAccount
  properties: {
    description: 'Linked Service to Azure storage account'
    type: 'AzureBlobFS'
    typeProperties: {
      url: storageaccounturl
      accountKey: {
        type: 'AzureKeyVaultSecret'
        store: {
          referenceName: linkedServiceNameforKV
          type: 'LinkedServiceReference'
        }
        secretName: keyVaultSecretName         
         
    } 
    
        
  }
  }
}
