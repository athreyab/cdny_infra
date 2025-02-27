
param dataFactoryName string 
param linkedServiceNameforkeyvault string 
param keyvaultbaseurl string
// param keyvaultcredential string
param Nameofthecreds string 
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01'  existing= {
  name: dataFactoryName
  
}

resource keyvaultLinkedservice 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  parent: dataFactory
  name: linkedServiceNameforkeyvault
  properties: {
    type: 'AzureKeyVault'
    typeProperties: {
      baseUrl: keyvaultbaseurl
      credential: {
        referenceName:Nameofthecreds
        type: 'CredentialReference'
      }
          
    }
    
    
  }
}
