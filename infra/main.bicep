// main Bicep File
@description('Location for all resources.')
var location  = resourceGroup().location
@description('Build the ResourcePrefix from two supplied parameters and the resourceprefix')
param prefix string 
param app string
param region string
param environment string
var resourceprefix = '${prefix}-${app}-${region}-${environment}'
param newOrExistingPrivateDNS string 
param PrivateDNSSub string 
param PrivateDNSRG string 
var PrivateDNSLocation = 'Global'

// Databricks Parameters
@description('The name of the Azure Databricks workspace.')
var workspaceName = '${resourceprefix}-databricks01'
param managedDatabricksResourceGroupId string 
@description('The pricing tier of the Databricks workspace.')
@allowed([
  'trial'
  'standard'
  'premium'
])
param pricingTier string = 'premium'
@description('Specifies whether to disable public IPs.')
param disablePublicIp bool = true
//Vpc Parameters
var vnetName  = '${resourceprefix}-vnet01'
var vnetdisplayname = 'vnet01'
@description('CIDR range for the Virtual Network.')
param vnetCidr string 
@description('CIDR range for the public subnet.')
param publicSubnetCidr string 
@description('The name of the public subnet.')
var  publicSubnetName  = 'public-subnet'
@description('CIDR range for the private subnet.')
param privateSubnetCidr string 
@description('The name of the private subnet.')
var privateSubnetName = 'private-subnet'
@description('CIDR range of private-endpoint-subnet')
param privateEndpointSubnetCidr string 
@description('private endpoint subnet name')
var privateEndpointSubnetName = 'private-endpoint-subnet'
// Sql Parameters
var sqlDBName = '${resourceprefix}-sqldb01'
var serverName  = '${resourceprefix}-sqlserver01'
param administratorLoginPassword string 
var administratorLogin = 'sql-admin-${environment}'

// This is the Vnet that the users will access Purview, Databricks, DataFactory from using the Private Link DNS resoluiton
var uservnetName  = 'CDNY-vnet'
var uservnetid  = '/subscriptions/1cf870d1-ae93-44c9-b1e6-79e9a4794d1c/resourceGroups/CDNYRG/providers/Microsoft.Network/virtualNetworks/CDNY-vnet'

// StorageAccount parameters
param kind string = 'StorageV2'
var storageAccountName = '${prefix}${app}${region}${environment}sa01'
// DataFactory Parameters
var dataFactoryName = '${resourceprefix}-datafactory01'
var purviewResourceId = '/subscriptions/85dad2f5-5ab0-45c2-ba19-d46ea748b457/resourceGroups/Purview-rg-cdny-Prod-EUS/providers/Microsoft.Purview/accounts/CDNY'
//param enableManagedVNet bool = false 
param tenantResourceID string 
//param mediskedcx_properties_MediskedCX_pipeline_parameters_creds string = '/Workspace/Users/anuragm@caredesignny.org/configs/creds.yaml'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_source_type string = 'mediskedcx'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_pimi_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/pimi_schema.yaml'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_log_file_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_file_schema.yaml'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_log_job_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_job_schema.yaml'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_destination_path string = '/dbfs/mnt/raw/'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_sub_source_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/sourceToBronze.yaml'
//param mediskedcx_properties_MediskedCX_pipeline_parameters_validation_config_file_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/silver_validation.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_creds string = '/Workspace/Users/anuragm@caredesignny.org/configs/creds.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_source_type string = 'sharepoint'
//param sharepoint_properties_Sharepoint_pipeline_parameters_pimi_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/pimi_schema.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_log_file_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_file_schema.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_log_job_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_job_schema.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_destination_path string = '/dbfs/mnt/raw/'
//param sharepoint_properties_Sharepoint_pipeline_parameters_sub_source_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/subSource.yaml'
//param sharepoint_properties_Sharepoint_pipeline_parameters_validation_config_file_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/silver_validation.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_creds string = '/Workspace/Users/anuragm@caredesignny.org/configs/creds.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_source_type string = 'mediskedsftp'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_pimi_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/pimi_schema.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_file_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_file_schema.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_job_schema_path string = '/Workspace/Users/anuragm@caredesignny.org/schemas/log_job_schema.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_destination_path string = '/dbfs/mnt/raw/'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_sub_source_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/subSource.yaml'
//param mediskedsftp_properties_MediskedSFTP_pipeline_parameters_validation_config_file_path string = '/Workspace/Users/anuragm@caredesignny.org/configs/silver_validation.yaml'

var userManagedIdentity = '${resourceprefix}-mi01'

// Loganalytics and AppInsights Parameters 
var logAnalyticsName  = '${resourceprefix}-logworkspace01'
var applicationInsightsName  = '${resourceprefix}-appinsights01'
// NatGateway, NetworksecurityGropus and PublicIP parameters
var nsgName = '${resourceprefix}-nsg01'
var natGatewayName  = '${resourceprefix}-nat01'
var natPublicIP  = '${resourceprefix}-pubip01'
param securityRules array = [
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound'
    properties: {
      description: 'Required for worker nodes communication within a cluster.'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 100
      direction: 'Outbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-cp'
    properties: {
      description: 'Required for workers communication with Databricks control plane.'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'AzureDatabricks'
      access: 'Allow'
      priority: 101
      direction: 'Outbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql'
    properties: {
      description: 'Required for workers communication with Azure SQL services.'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '3306'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Sql'
      access: 'Allow'
      priority: 102
      direction: 'Outbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage'
    properties: {
      description: 'Required for workers communication with Azure Storage services.'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Storage'
      access: 'Allow'
      priority: 103
      direction: 'Outbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub'
    properties: {
      description: 'Required for worker communication with Azure Eventhub services.'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '9093'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'EventHub'
      access: 'Allow'
      priority: 104
      direction: 'Outbound'
    }
  }
  {
    name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound'
    properties: {
      description: 'Required for worker nodes communication within a cluster.'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 100
      direction: 'Inbound'
    }
  }  
  {
    name: 'Microsoft.Databricks-workspaces_worker_to_cdny_sql'
    properties: {
      description: 'This is for the Databricks Worker VMs to connect to the Production SQL server over the private IP'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '3342'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '10.0.0.17'
      access: 'Allow'
      priority: 105
      direction: 'Outbound'
    }
  }
]
// keyVault Parameters
var keyVaultName = '${resourceprefix}-kv01'
param keyVaultAccessPolicy array = [
  {
    tenantId: subscription().tenantId
    objectId: subscription().subscriptionId
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
        'delete'
        'backup'
        'recover'
        'restore'
        'purge'
      ]
    }
  }
  {
    tenantId: subscription().tenantId
    objectId: '119fc890-9e0c-4759-9bde-4b570a57873e'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
        'delete'
        'backup'
        'recover'
        'restore'
        'purge'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: 'd2599752-a2f7-402e-a700-45476db5672e'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: '5a9245cc-f543-4fd8-a618-140260ec7060'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
        'delete'
        'recover'
        'backup'
        'restore'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: '1cc1d56f-5b9c-4c35-b2c3-cc7cf4fcecf1'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: 'cf5ef860-010e-41cc-a2ca-e95d6116f72d'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
        'delete'
        'recover'
        'backup'
        'restore'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: '51a4ae40-179c-4a10-8ec3-d262ad81a08e'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
        'delete'
        'recover'
        'backup'
        'restore'
      ]
    }
  }
  {
    tenantId: subscription().tenantId
    objectId: 'f8e3996b-66bf-4f61-9ff3-62f580e186e4'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
        'delete'
        'recover'
        'backup'
        'restore'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: 'd2da1af2-a1e1-4f48-8e1a-0bbd4c15e0b0'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
        'delete'
        'recover'
        'backup'
        'restore'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: 'f7fabdfd-7a7d-40e0-85cf-b620f296a0b8'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
        'delete'
        'recover'
        'backup'
        'restore'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: '03961281-a816-4b18-9982-db8e81774a5a'
    permissions: {      
      secrets: [
        'list'        
        'get'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: '13ef26a6-0814-4d7f-af9c-87cc3ba75fc2'
    permissions: {      
      secrets: [
        'list'
        'get'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: '36d06aec-efef-472f-94a8-5c201e949a89'
    permissions: {      
      secrets: [
        'get'
        'list'
        'set'
        'delete'
        'recover'
        'backup'
        'restore'
      ]
    }
  } 
  {
    tenantId: subscription().tenantId
    objectId: 'b20cddcf-107a-45c3-88b8-b8505a58e621'
    permissions: {      
      secrets: [
        'list'
        'get'
      ]
    }
  } 
]

module managedidentity 'managedidentity.bicep' = {
  name: 'ManagedIdentityDeployment'
  params : {
    userManagedIdentity: userManagedIdentity
    location: location
  }
  
}

output userManagedIdentityId string = managedidentity.outputs.userManagedIdentityId

module logAnalyticsWorkspaceModule 'loganalyticsworkspace.bicep' = {
  name:'logAnalyticsdeployment'
  params: {
    location: location
    logAnalyticsName: logAnalyticsName
  }
}

output workspaceResourceId string  = logAnalyticsWorkspaceModule.outputs.workspaceID

module AppInsighhtsModule 'appinsight.bicep' = {
  name:'AppInsightsDeployment'
  params: {
    appInsightsLocation: location
    applicationInsightsName: applicationInsightsName
    WorkspaceResourceID: logAnalyticsWorkspaceModule.outputs.workspaceID
  }
}
module ActionGroupModule 'actiongroup.bicep' = {
  name:'ActionGroupDeployment'
  params: {

  }


}
module nsgModule 'nsg.bicep' = {
  name: 'nsgDeployment'
  params: {
    location: location
    nsgName: nsgName
    securityRules: securityRules
  }
}

module natGatewayModule 'natgateway.bicep' = {
  name: 'natGatewayDeployment'
  params: {
    location: location
    natGatewayName: natGatewayName
    natGatewayPublicIpName: natPublicIP
  }
}


module vnetModule 'vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    location: location
    vnetName: vnetName
    vnetCidr: vnetCidr
    publicSubnetCidr: publicSubnetCidr
    publicSubnetName: publicSubnetName
    privateSubnetCidr: privateSubnetCidr
    privateSubnetName: privateSubnetName
    nsgId: nsgModule.outputs.nsgId
    natGatewayId: natGatewayModule.outputs.natGatewayId
    privateEndpointSubnetName:privateEndpointSubnetName
    privateEndpointSubnetCidr:privateEndpointSubnetCidr
  }
}

output privatesubnetId string = vnetModule.outputs.privateSubnetId
output publicSubnetId string = vnetModule.outputs.publicSubnetId
output privateEndpointSubnetId string = vnetModule.outputs.privateEndpointSubnetId


module workspaceModule 'databricks.bicep' = {
  name: 'workspaceDeployment'
  params: {
    location: location
    workspaceName: workspaceName
    pricingTier: pricingTier
    disablePublicIp: disablePublicIp
    managedResourceGroupId: managedDatabricksResourceGroupId
    vnetId: vnetModule.outputs.vnetId
    publicSubnetName: publicSubnetName
    privateSubnetName: privateSubnetName   
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceModule.outputs.workspaceID
  }
}

output workspaceId string = workspaceModule.outputs.workspaceId


module storageAccount 'storage-account.bicep' = {
  name: 'storageAccountDeployment'
  params: {
    kind: kind
    location: location
    storageAccountName: storageAccountName
    userManagedIdentityId: managedidentity.outputs.userManagedIdentityId
    vnetName: vnetName
    PrivateendpontsubnetName: privateEndpointSubnetName
    PrivatesubnetName: privateSubnetName
  }

}
output storageaccountID string = storageAccount.outputs.storageAccountId


/*var resourcetypeKV = 'Microsoft.KeyVault/vaults'
module KVneworexisting 'deploymentscriptneworexisting.bicep' = {
  name:'KVCheck'
  params: {
    resourcetype: resourcetypeKV
    resourcename:keyVaultName
    managedidentityID: managedidentity.outputs.userManagedIdentityId
  }
 }
*/
module keyVaultModule 'keuvault.bicep' = {
  name: 'KeyVaultDeployment'
  params: {
    keyVaultName: keyVaultName
    location: location
    tenantResourceId: tenantResourceID  
    keyVaultAccessPolicy: keyVaultAccessPolicy
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceModule.outputs.workspaceID 
    privateEndpointSubnetId: vnetModule.outputs.privateEndpointSubnetId
    privateSubnetId: vnetModule.outputs.privateSubnetId
  }
}
output Keyvaultname  string = keyVaultModule.outputs.keyVaultName
output Keyvaultid string = keyVaultModule.outputs.keyVaultId

// // Reference Key Vault to access its outputs

// param secretName string = 'administratorusername'
// // Reference the administrator username secret
// resource secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' existing = {
//   parent: keyVault
//   name: secretName
// }
// // Outputs for the secrets' values
// output secretUri string = secret.properties.value

//var resourcetypeSQL = 'Microsoft.Sql/servers'
//module SQLServerneworexisting 'deploymentscriptneworexisting.bicep' = {
 // name:'SQLServerCheck'
 // params: {
 //   resourcetype: resourcetypeSQL
 //   resourcename: serverName
 //   managedidentityID: managedidentity.outputs.userManagedIdentityId
 // }
 //}

module Sqlserevr 'sql.bicep' = {
  name:'SqlServerDeployment'
  params: {
    serverName: serverName
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    location:location   
    userManagedIdentityId: managedidentity.outputs.userManagedIdentityId
    //vnetId: vnetModule.outputs.privateEndpointSubnetId
    //vnetName: vnetName
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceModule.outputs.workspaceID
    //newOrExisting: SQLServerneworexisting.outputs.resourceExists      
  }
  
}
output sqlServerName string = Sqlserevr.outputs.sqlServerName
output SqlserverId string = Sqlserevr.outputs.sqlServerId

module sqlDBModule 'sqldb.bicep' = {
  name: 'sqlDBDeployment'
  params: {
    sqlDBName: sqlDBName
    location: resourceGroup().location
    sqlServerName: serverName
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceModule.outputs.workspaceID
  }
}


module dataFactory 'datafactory.bicep' = {
  name: 'dataFactoryDeployment' 
  params: {
    dataFactoryName: dataFactoryName
    location: location
    //enableManagedVNet: enableManagedVNet
    userManagedIdentityId: managedidentity.outputs.userManagedIdentityId
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceModule.outputs.workspaceID
    purviewResourceId: purviewResourceId
    //mediskedcx_properties_MediskedCX_pipeline_parameters_creds : mediskedcx_properties_MediskedCX_pipeline_parameters_creds  
    //mediskedcx_properties_MediskedCX_pipeline_parameters_source_type : mediskedcx_properties_MediskedCX_pipeline_parameters_source_type  
    //mediskedcx_properties_MediskedCX_pipeline_parameters_pimi_schema_path : mediskedcx_properties_MediskedCX_pipeline_parameters_pimi_schema_path
    //mediskedcx_properties_MediskedCX_pipeline_parameters_log_file_schema_path : mediskedcx_properties_MediskedCX_pipeline_parameters_log_file_schema_path  
    //mediskedcx_properties_MediskedCX_pipeline_parameters_log_job_schema_path : mediskedcx_properties_MediskedCX_pipeline_parameters_log_job_schema_path 
    //mediskedcx_properties_MediskedCX_pipeline_parameters_destination_path : mediskedcx_properties_MediskedCX_pipeline_parameters_destination_path 
    //mediskedcx_properties_MediskedCX_pipeline_parameters_sub_source_path : mediskedcx_properties_MediskedCX_pipeline_parameters_sub_source_path 
    //mediskedcx_properties_MediskedCX_pipeline_parameters_validation_config_file_path : mediskedcx_properties_MediskedCX_pipeline_parameters_validation_config_file_path 
    //sharepoint_properties_Sharepoint_pipeline_parameters_creds : sharepoint_properties_Sharepoint_pipeline_parameters_creds 
    //sharepoint_properties_Sharepoint_pipeline_parameters_source_type : sharepoint_properties_Sharepoint_pipeline_parameters_source_type
    //sharepoint_properties_Sharepoint_pipeline_parameters_pimi_schema_path : sharepoint_properties_Sharepoint_pipeline_parameters_pimi_schema_path 
    //sharepoint_properties_Sharepoint_pipeline_parameters_log_file_schema_path : sharepoint_properties_Sharepoint_pipeline_parameters_log_file_schema_path
    //sharepoint_properties_Sharepoint_pipeline_parameters_log_job_schema_path : sharepoint_properties_Sharepoint_pipeline_parameters_log_job_schema_path 
    //sharepoint_properties_Sharepoint_pipeline_parameters_destination_path : sharepoint_properties_Sharepoint_pipeline_parameters_destination_path  
    //sharepoint_properties_Sharepoint_pipeline_parameters_sub_source_path : sharepoint_properties_Sharepoint_pipeline_parameters_sub_source_path  
    //sharepoint_properties_Sharepoint_pipeline_parameters_validation_config_file_path : sharepoint_properties_Sharepoint_pipeline_parameters_validation_config_file_path
    //mediskedsftp_properties_MediskedSFTP_pipeline_parameters_creds : mediskedsftp_properties_MediskedSFTP_pipeline_parameters_creds  
    //mediskedsftp_properties_MediskedSFTP_pipeline_parameters_source_type : mediskedsftp_properties_MediskedSFTP_pipeline_parameters_source_type
    //mediskedsftp_properties_MediskedSFTP_pipeline_parameters_pimi_schema_path : mediskedsftp_properties_MediskedSFTP_pipeline_parameters_pimi_schema_path 
    //mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_file_schema_path : mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_file_schema_path
    //mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_job_schema_path  : mediskedsftp_properties_MediskedSFTP_pipeline_parameters_log_job_schema_path
    //mediskedsftp_properties_MediskedSFTP_pipeline_parameters_destination_path : mediskedsftp_properties_MediskedSFTP_pipeline_parameters_destination_path
    //mediskedsftp_properties_MediskedSFTP_pipeline_parameters_sub_source_path : mediskedsftp_properties_MediskedSFTP_pipeline_parameters_sub_source_path  
    //mediskedsftp_properties_MediskedSFTP_pipeline_parameters_validation_config_file_path : mediskedsftp_properties_MediskedSFTP_pipeline_parameters_validation_config_file_path 
    //newOrExisting: DFneworexisting.outputs.resourceExists 
   
  }
}


module credsforlinkedservice 'linkedcredentials.bicep' = {
  name: 'credsdeploymentforlinkedservice'
 params:{
  credstobeusedformi: 'MIcreds'
  dataFactoryName: dataFactoryName
  resourceId: managedidentity.outputs.userManagedIdentityId
}
}



module dataFactorylinkedserviceforkeyvault 'datafactorylinkedserviceforkv.bicep' = {
  name: 'databfactoryLinkedserviceDeploymentforKV'
  dependsOn: [dataFactory]
  params: {    
    Nameofthecreds: 'MIcreds'
    dataFactoryName: dataFactoryName
    keyvaultbaseurl: 'https://${resourceprefix}-kv01.vault.azure.net/'
    linkedServiceNameforkeyvault: 'datafactory-keyvault'   
  }
}


module dataFactorylinkedservice 'databrickslinkedservice.bicep' = {
  name: 'databricksLinkedserviceDeployment'
  dependsOn: [dataFactory]
  params: {    
    // Nameofthecreds: 'MIcreds'
    dataFactoryName: dataFactoryName
    linkedServiceName: 'AzureDatabricks1'
    databricksWorkspaceUrl: 'https://adb-538701492298588.8.azuredatabricks.net'
    existingClusterId: '0105-081646-lul8dxop'
    linkedServiceNameforKV: 'datafactory-keyvault'
    keyVaultSecretName: 'databricks-access-token'
    workspaceresourceId: workspaceModule.outputs.workspaceId
    // userManagedidentityId: managedidentity.outputs.userManagedIdentityId
    

  }
}




module dataFactorylinkedserviceforsa 'datafactory;linkedserviceforsa.bicep' = {
  name: 'databfactoryLinkedserviceDeploymentforSA'
  dependsOn: [dataFactory]
  params: {    
    dataFactoryName: dataFactoryName
    keyVaultSecretName : 'storageaccountkey'
    linkedServiceNameforstorageAccount: 'datafactory-storageaccount'
    linkedServiceNameforKV: 'datafactory-keyvault'
    storageaccounturl: 'https://${storageAccountName}.dfs.core.windows.net'
    
    // storageaccountconnectionstring: storageaccountconnectionstring
    

  }
}


module dataFactorylinkedserviceforSQLDB 'datafactorylinkedserviceforsql.bicep' = {
  name: 'databfactoryLinkedserviceDeploymentforSQLDB'
  dependsOn: [dataFactory]
  params: {    
    // Nameofthecreds: 'MIcreds'
    dataFactoryName: dataFactoryName
    // DBConnectionstring: DBConnectionstring
    linkedServiceNameforsql: 'datafactory-SQLDB' 
    linkedServiceNameforKV:'datafactory-keyvault'
    keyVaultSecretName: 'administratorpassword'
    Sqlservername: '${resourceprefix}-sqlserver01.database.windows.net'
    dbname: sqlDBName
    SQLUserName: 'sql-admin-${environment}'
  }
}


module dataFactorylinkedserviceusingmi 'datafactorylinkedservice.bicep' = {
  name: 'databricksLinkedserviceDeploymentusingmi'
  dependsOn: [dataFactory]
  params: {    
    //Nameofthecreds: 'MIcreds'
    dataFactoryName: dataFactoryName    
    linkedServiceName: 'AzureDatabricks2'
    databricksWorkspaceUrl: 'https://adb-538701492298588.8.azuredatabricks.net'
    existingClusterId: '0105-081646-lul8dxop'
    // linkedServiceNameforKV: 'datafactory-keyvault'
    // keyVaultSecretName: 'databricks-access-token'
    workspaceresourceId: workspaceModule.outputs.workspaceId
    //userManagedidentityId: managedidentity.outputs.userManagedIdentityId
    

  }
}

 // For each PrivateEndpoint type a Private DNS connection must be made to the VNET
 module PrivateDnsZoneforSAblob 'privateDnsZone.bicep' = {
  name:'privateDNSforSAblob'
  scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
  params: {
    location: PrivateDNSLocation
    resourceprefix: resourceprefix
    privateDnsZoneName: 'privatelink.blob.core.windows.net' 
    vnetId: vnetModule.outputs.vnetId
    vnetName: vnetdisplayname
    uservnetId: uservnetid
    uservnetName: uservnetName
    newOrExisting: newOrExistingPrivateDNS
  }
}

module PrivateDnsZoneforSAfile 'privateDnsZone.bicep' = {
  name:'privateDNSforSAfile'
  scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
  params: {
    location: PrivateDNSLocation   
    resourceprefix: resourceprefix 
    privateDnsZoneName: 'privatelink.file.core.windows.net' 
    vnetId: vnetModule.outputs.vnetId
    vnetName: vnetdisplayname
    uservnetId: uservnetid
    uservnetName: uservnetName
    newOrExisting: newOrExistingPrivateDNS
  }
}

module PrivateDnsZoneforSATable 'privateDnsZone.bicep' = {
  name:'privateDNSforSATable'
  scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
  params: {
    location: PrivateDNSLocation
    resourceprefix: resourceprefix
    privateDnsZoneName: 'privatelink.table.core.windows.net' 
    vnetId: vnetModule.outputs.vnetId
    vnetName: vnetdisplayname
    uservnetId: uservnetid
    uservnetName: uservnetName
    newOrExisting: newOrExistingPrivateDNS
  }
}

module PrivateDnsZoneforSAQueue 'privateDnsZone.bicep' = {
  name:'privateDNSforSAQueue'
  scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
  params: {
    location: PrivateDNSLocation
    resourceprefix: resourceprefix
    privateDnsZoneName: 'privatelink.queue.core.windows.net' 
    vnetId: vnetModule.outputs.vnetId
    vnetName: vnetdisplayname
    uservnetId: uservnetid
    uservnetName: uservnetName
    newOrExisting: newOrExistingPrivateDNS
  }
}

module PrivateDnsZoneforSADFS 'privateDnsZone.bicep' = {
  name:'privateDNSforSADFS'
  scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
  params: {
    location: PrivateDNSLocation
    resourceprefix: resourceprefix
    privateDnsZoneName: 'privatelink.dfs.core.windows.net' 
    vnetId: vnetModule.outputs.vnetId
    vnetName: vnetdisplayname
    uservnetId: uservnetid
    uservnetName: uservnetName
    newOrExisting: newOrExistingPrivateDNS
  }
}
module PrivateDnsZoneforSQL 'privateDnsZone.bicep' = {
 name:'privateDNSforSQL'
 scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
 params: {
   location: PrivateDNSLocation
   resourceprefix: resourceprefix
   privateDnsZoneName: 'privatelink.database.windows.net'   
   vnetId: vnetModule.outputs.vnetId
   vnetName: vnetdisplayname
   uservnetId: uservnetid
   uservnetName: uservnetName
   newOrExisting: newOrExistingPrivateDNS
 }
}

module PrivateDnsZoneforKV 'privateDnsZone.bicep' = {
 name:'privateDNSforKV'
 scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
 params: {
   location: PrivateDNSLocation
   resourceprefix: resourceprefix
   privateDnsZoneName: 'privatelink.vaultcore.azure.net' 
   vnetId: vnetModule.outputs.vnetId
   vnetName: vnetdisplayname
   uservnetId: uservnetid
   uservnetName: uservnetName
   newOrExisting: newOrExistingPrivateDNS
 }
}

module PrivateDnsZoneforDB 'privateDnsZone.bicep' = {
  name:'privateDNSforDataBricks'
  scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
  params: {
    location: PrivateDNSLocation
    resourceprefix: resourceprefix
    privateDnsZoneName: 'privatelink.azuredatabricks.net' 
    vnetId: vnetModule.outputs.vnetId
    vnetName: vnetdisplayname
    uservnetId: uservnetid
    uservnetName: uservnetName
    newOrExisting: newOrExistingPrivateDNS
  }
 }
 module PrivateDnsZoneforDF 'privateDnsZone.bicep' = {
  name:'privateDNSforDataFactory'
  scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
   params: {
    location: PrivateDNSLocation
    resourceprefix: resourceprefix
    privateDnsZoneName: 'privatelink.datafactory.azure.net' 
    vnetId: vnetModule.outputs.vnetId
    vnetName: vnetdisplayname
    uservnetId: uservnetid
    uservnetName: uservnetName
    newOrExisting: newOrExistingPrivateDNS
  }
 }

 module PrivateDnsZoneforDFP 'privateDnsZone.bicep' = {
  name:'privateDNSforDataFactoryPortal'
  scope: resourceGroup(PrivateDNSSub,PrivateDNSRG)
  params: {
    location: PrivateDNSLocation    
    resourceprefix: resourceprefix
    privateDnsZoneName: 'privatelink.adf.azure.com' 
    vnetId: vnetModule.outputs.vnetId
    vnetName: vnetdisplayname
    uservnetId: uservnetid
    uservnetName: uservnetName
    newOrExisting: newOrExistingPrivateDNS
  }
 }

// Each module below configures a private endpoint connection, with a optional service name as the GroupID
   module PrivatendpointforstorageaccountBlob 'privatelink.bicep' = {
     name: 'privateendpointforSABlob'
     params: {
       location: resourceGroup().location
       privateLinkServiceId:storageAccount.outputs.storageAccountId
       privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
       privateEndpointName: '${resourceprefix}-pep-${storageAccountName}-blob'
       groupID: 'blob'
       privateDnsZoneId: PrivateDnsZoneforSAblob.outputs.privateDnsZoneId
     }
   }

   module PrivatendpointforstorageaccountFile 'privatelink.bicep' = {
    name: 'privateendpointforSAFile'
    params: {
      location: resourceGroup().location
      privateLinkServiceId:storageAccount.outputs.storageAccountId
      privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
      privateEndpointName: '${resourceprefix}-pep-${storageAccountName}-file'
      groupID: 'file'
      privateDnsZoneId: PrivateDnsZoneforSAfile.outputs.privateDnsZoneId
    }
  }

  module PrivatendpointforstorageaccountTable 'privatelink.bicep' = {
    name: 'privateendpointforSATable'
    params: {
      location: resourceGroup().location
      privateLinkServiceId:storageAccount.outputs.storageAccountId
      privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
      privateEndpointName: '${resourceprefix}-pep-${storageAccountName}-table'
      groupID: 'table'
      privateDnsZoneId: PrivateDnsZoneforSATable.outputs.privateDnsZoneId
    }
  }

  module PrivatendpointforstorageaccountQueue 'privatelink.bicep' = {
    name: 'privateendpointforSAQueue'
    params: {
      location: resourceGroup().location
      privateLinkServiceId:storageAccount.outputs.storageAccountId
      privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
      privateEndpointName: '${resourceprefix}-pep-${storageAccountName}-queue'
      groupID: 'queue'
      privateDnsZoneId: PrivateDnsZoneforSAQueue.outputs.privateDnsZoneId
    }
  }

  module PrivatendpointforstorageaccountDFS 'privatelink.bicep' = {
    name: 'privateendpointforSADFS'
    params: {
      location: resourceGroup().location
      privateLinkServiceId:storageAccount.outputs.storageAccountId
      privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
      privateEndpointName: '${resourceprefix}-pep-${storageAccountName}-dfs'
      groupID: 'dfs'
      privateDnsZoneId: PrivateDnsZoneforSADFS.outputs.privateDnsZoneId
    }
  }

  module PrivatendpointforSQL 'privatelink.bicep' = {
    name: 'privateendpointforSQL'
    params: {
      location: resourceGroup().location
      privateLinkServiceId:Sqlserevr.outputs.sqlServerId
      privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
      privateEndpointName: '${resourceprefix}-pep-${serverName}'
      groupID: 'sqlServer'
      privateDnsZoneId: PrivateDnsZoneforSQL.outputs.privateDnsZoneId
    }
  }

  module PrivatendpointforKV 'privatelink.bicep' = {
    name: 'privateendpointforKV'
    params: {
      location: resourceGroup().location
      privateLinkServiceId:keyVaultModule.outputs.keyVaultId
      privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
      privateEndpointName: '${resourceprefix}-pep-${keyVaultName}'
      groupID: 'vault'
      privateDnsZoneId: PrivateDnsZoneforKV.outputs.privateDnsZoneId
    }
  }

   module PrivatendpointforDatabricksba 'privatelink.bicep' = {
     name: 'privateendpointforDataBricksba'
     dependsOn: [dataFactory]
     params: {
       location: resourceGroup().location
       privateLinkServiceId:workspaceModule.outputs.workspaceId
       privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
       privateEndpointName: '${resourceprefix}-adb-pep-ba-${workspaceName}'
       groupID: 'browser_authentication'
       privateDnsZoneId: PrivateDnsZoneforDB.outputs.privateDnsZoneId
     }
   }

   module PrivatendpointforDatabricksdua 'privatelink.bicep' = {
     name: 'privateendpointforDataBricksdua'
     dependsOn: [dataFactory]
     params: {
       location: resourceGroup().location
       privateLinkServiceId:workspaceModule.outputs.workspaceId
       privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
       privateEndpointName: '${resourceprefix}-adb-pep-dua-${workspaceName}'
       groupID: 'databricks_ui_api'
       privateDnsZoneId: PrivateDnsZoneforDB.outputs.privateDnsZoneId
     }
   }

   module PrivatendpointforDataFactory 'privatelink.bicep' = {
    name: 'privateendpointforDataFactory'
    params: {
      location: resourceGroup().location
      privateLinkServiceId:dataFactory.outputs.dataFactoryId
      privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
      privateEndpointName: '${resourceprefix}-df-pep-df-${dataFactoryName}'
      groupID: 'dataFactory'
      privateDnsZoneId: PrivateDnsZoneforDF.outputs.privateDnsZoneId
    }
  }


  module PrivatendpointforDataFactoryPortal 'privatelink.bicep' = {
    name: 'privateendpointforDataFactoryPortal'
    params: {
      location: resourceGroup().location
      privateLinkServiceId:dataFactory.outputs.dataFactoryId
      privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
      privateEndpointName: '${resourceprefix}-df-pep-dfp-${dataFactoryName}'
      groupID: 'portal'
      privateDnsZoneId: PrivateDnsZoneforDFP.outputs.privateDnsZoneId
    }
  }

  // Due to the Integration Runtime VNET integration the Private Endpoints are created by Purview using another subscription that is not accessable.  
  // module PrivatendpointforPurview 'privatelink.bicep' = {
  //   name: 'privateendpointforPurview'
  //   params: {
  //     location: resourceGroup().location
  //     privateLinkServiceId:keyVaultModule.outputs.keyVaultId
  //     privatesubnetid:vnetModule.outputs.privateEndpointSubnetId
  //     privateEndpointName: '${resourceprefix}-pep-asql001'
    
  //   }
  // }

  
 
