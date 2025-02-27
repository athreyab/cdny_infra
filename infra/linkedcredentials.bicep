
param dataFactoryName string 
// param linkedServiceNameforcreds string 
// param keyvaultcredential string
// param userManagedIdentityName string 
// param credentialsforlikedservice string
param resourceId string 
param credstobeusedformi string 


resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01'  existing= {
  name: dataFactoryName
  
}

resource credentials 'Microsoft.DataFactory/factories/credentials@2018-06-01' = {
  name: credstobeusedformi
  parent: dataFactory
  properties: {
    type: 'ManagedIdentity'
    typeProperties: {
      resourceId: resourceId
    }
  }
 
}
