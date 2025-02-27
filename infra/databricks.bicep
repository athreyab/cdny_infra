@description('The location for the Databricks workspace.')
param location string

@description('The name of the Databricks workspace.')
param workspaceName string

@description('The pricing tier of the workspace.')
@allowed([
  'trial'
  'standard'
  'premium'
])
param pricingTier string

@description('The managed resource group ID for the workspace.')
param managedResourceGroupId string

@description('ID of the Virtual Network.')
param vnetId string

@description('Name of the public subnet.')
param publicSubnetName string

@description('Name of the private subnet.')
param privateSubnetName string

@description('Specifies whether to disable public IPs.')
param disablePublicIp bool = true
param logAnalyticsWorkspaceId string 


resource workspace 'Microsoft.Databricks/workspaces@2024-05-01' = {
  location: location
  name: workspaceName
  sku: {
    name: pricingTier
  }
  properties: {
    managedResourceGroupId: managedResourceGroupId
    publicNetworkAccess: 'Disabled' 
    requiredNsgRules: 'NoAzureDatabricksRules'// Disable public network access
    parameters: {
      customVirtualNetworkId: {
        value: vnetId
      }
      customPublicSubnetName: {
        value: publicSubnetName
      }
      customPrivateSubnetName: {
        value: privateSubnetName
      }
      enableNoPublicIp: {
        value: disablePublicIp
      }
    }
    enhancedSecurityCompliance: {
      automaticClusterUpdate: {
        value: 'Enabled'
      }
      complianceSecurityProfile: {
        complianceStandards: [
          'HIPAA'
        ]
        value: 'Enabled'
      }
      enhancedSecurityMonitoring: {
        value: 'Enabled'
      }
    }
  }
  
  
}



resource dataBricksDiagnostic 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'DatabricksDiganostics'
  scope: workspace
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'clusters'
        enabled: true
        
      }
      {
        category: 'jobs'
        enabled: true
        
      }
      {
        category: 'notebook'
        enabled: true

      }
      {
        category: 'workspace'
        enabled: true
        
      }
      {
        category: 'sqlPermissions'
        enabled: true
        
      }
      
    ]
  }
}

output workspaceId string =  workspace.id
output workspaceName string =  workspace.name
