param location string = resourceGroup().location
param administratorsGroupName string = 'cdny-admin-security-group'
param devSecOpsGroupName string = 'cdny-devsecops'
param engineersGroupName string = 'cdny-engineers'
param scientistsGroupName string = 'cdny-scientists'
param consumersGroupName string = 'cdny-consumers'

resource createAADGroupsScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'createAADGroups'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.43.0'
    scriptContent: '''
      #!/bin/bash
      echo "Starting creation of AAD groups..."

      administratorsPrincipalid=$(az ad group create --display-name ${administratorsGroupName} --mail-nickname ${administratorsGroupName} --query "id" --output "tsv")
      devSecOpsPrincipalid=$(az ad group create --display-name ${devSecOpsGroupName} --mail-nickname ${devSecOpsGroupName} --query "id" --output "tsv")
      engineersPrincipalid=$(az ad group create --display-name ${engineersGroupName} --mail-nickname ${engineersGroupName} --query "id" --output "tsv")
      scientistsPrincipalid=$(az ad group create --display-name ${scientistsGroupName} --mail-nickname ${scientistsGroupName} --query "id" --output "tsv")
      consumersPrincipalid=$(az ad group create --display-name ${consumersGroupName} --mail-nickname ${consumersGroupName} --query "id" --output "tsv")

      echo "AAD Groups created successfully."
    '''
    retentionInterval: 'P1D'    
    environmentVariables: [
      {
        name: 'administratorsGroupName'
        value: administratorsGroupName
      }
      {
        name: 'devSecOpsGroupName'
        value: devSecOpsGroupName
      }
      {
        name: 'engineersGroupName'
        value: engineersGroupName
      }
      {
        name: 'scientistsGroupName'
        value: scientistsGroupName
      }
      {
        name: 'consumersGroupName'
        value: consumersGroupName
      }
    ]
  }
}
