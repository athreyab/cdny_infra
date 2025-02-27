
param dataFactoryName string 
param linkedServiceNameforsql string 
param Sqlservername string
param dbname string 
param linkedServiceNameforKV string 
param keyVaultSecretName string 
param SQLUserName string


resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01'  existing= {
  name: dataFactoryName
  
}

resource keyvaultLinkedservice 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  parent: dataFactory
  name: linkedServiceNameforsql
  properties: {
    type: 'AzureSqlDatabase'
    typeProperties: { 
      server: Sqlservername
      database: dbname
      authenticationType: 'SQL'         
            userName: SQLUserName
            password: {
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
    
    
  

