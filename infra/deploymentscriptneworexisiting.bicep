param resourcename string //= 'cdny-dwh-eus-dev-rg'
param location string = resourceGroup().location
param resourcetype string // = 
param managedidentityID string //=

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'neworexistingPS'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedidentityID}': {}
    }
  }
  properties: {
    azPowerShellVersion: '10.0'
    arguments: '-resourcename \'${resourcename}\' -resourcetype \'${resourcetype}\''
    scriptContent: '''
      param([string] $resourcename,
            [string] $resourcetype)
      Write-Output "Searching for the resource {0}." -f $resourcename 
      write-output "with the resource type of {1}." -f $resourcetype
      $result =  Get-AzResource -Name $resourcename -ResourceType $resourcetype
      if ($result) {$output='existing'} else {$output='new'}
      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs['resourceExists'] = $output
    '''
    cleanupPreference: 'OnExpiration'
    retentionInterval: 'PT1H'
  }
}

output resourceExists string = deploymentScript.properties.outputs.resourceExists
