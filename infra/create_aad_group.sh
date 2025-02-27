#!/bin/bash

set -e 

echo "Starting AAD group creation and role assignment..."


ENVIRONMENT=${1:-DEV}
echo "Environment: $ENVIRONMENT"

SUBSCRIPTION_ID=${SUBSCRIPTION_ID}
RESOURCE_GROUP=${RESOURCE_GROUP}
ADLS_RESOURCE=${ADLS_RESOURCE}
DATABRICKS_RESOURCE=${DATABRICKS_RESOURCE}
DATAFACTORY_RESOURCE=${DATAFACTORY_RESOURCE}
KEYVAULT_RESOURCE=${KEYVAULT_RESOURCE}
SQLSERVER_RESOURCE=${SQLSERVER_RESOURCE}

if [[ -z "$SUBSCRIPTION_ID" || -z "$RESOURCE_GROUP" || -z "$ADLS_RESOURCE" || -z "$DATABRICKS_RESOURCE" || -z "$DATAFACTORY_RESOURCE" || -z "$KEYVAULT_RESOURCE" || -z "$SQLSERVER_RESOURCE" ]]; then
  echo "Error: One or more required environment variables are not set."
  exit 1
fi

# Define the list of groups
GROUP_LIST=(
  "CDNY-DWH-${ENVIRONMENT}-ADMINS"
  "CDNY-DWH-${ENVIRONMENT}-DATAENGINEERS"
  "CDNY-DWH-${ENVIRONMENT}-DATASCIENTISTS"
  "PBI-CXO-${ENVIRONMENT}"
  "PBI-HEALTHCAREMANAGEMENT-${ENVIRONMENT}"
  "PBI-QUALITY-${ENVIRONMENT}"
  "PBI-ADMIN-${ENVIRONMENT}"
  "PBI-OPERATIONS-${ENVIRONMENT}"
  "PBI-BLT-${ENVIRONMENT}"
  "PBI-CareManagement-${ENVIRONMENT}"
  "PBI-Finance-${ENVIRONMENT}"
  "PBI-Enrollment-${ENVIRONMENT}"
)

# Define resource scopes
declare -A SERVICE_SCOPES
SERVICE_SCOPES["ADLS"]="subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.Storage/storageAccounts/${ADLS_RESOURCE}"
SERVICE_SCOPES["Databricks"]="subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.Databricks/workspaces/${DATABRICKS_RESOURCE}"
SERVICE_SCOPES["DataFactory"]="subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/factories/${DATAFACTORY_RESOURCE}"
SERVICE_SCOPES["KeyVault"]="subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.KeyVault/vaults/${KEYVAULT_RESOURCE}"
SERVICE_SCOPES["SQLServer"]="subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.Sql/servers/${SQLSERVER_RESOURCE}"

# Custom Role Assignments
declare -A CUSTOM_ROLE_MAPPING=(
  ["CDNY-DWH-${ENVIRONMENT}-ADMINS:ADLS"]="Storage Blob Data Owner"
  ["CDNY-DWH-${ENVIRONMENT}-ADMINS:Databricks"]="Owner"
  ["CDNY-DWH-${ENVIRONMENT}-ADMINS:DataFactory"]="Owner"
  ["CDNY-DWH-${ENVIRONMENT}-ADMINS:KeyVault"]="Owner"
  ["CDNY-DWH-${ENVIRONMENT}-ADMINS:SQLServer"]="Owner"
  ["CDNY-DWH-${ENVIRONMENT}-DATAENGINEERS:ADLS"]="Storage Blob Data Contributor"
  ["CDNY-DWH-${ENVIRONMENT}-DATAENGINEERS:Databricks"]="Contributor"
  ["CDNY-DWH-${ENVIRONMENT}-DATAENGINEERS:DataFactory"]="Contributor"
  ["CDNY-DWH-${ENVIRONMENT}-DATAENGINEERS:KeyVault"]="Contributor"
  ["CDNY-DWH-${ENVIRONMENT}-DATAENGINEERS:SQLServer"]="Contributor"
  ["CDNY-DWH-${ENVIRONMENT}-DATASCIENTISTS:ADLS"]="Reader"
  ["CDNY-DWH-${ENVIRONMENT}-DATASCIENTISTS:KeyVault"]="Key Vault Secrets Reader"
  ["CDNY-DWH-${ENVIRONMENT}-DATASCIENTISTS:Databricks"]="Contributor"
  ["CDNY-DWH-${ENVIRONMENT}-DATASCIENTISTS:DataFactory"]="Contributor"
  ["CDNY-DWH-${ENVIRONMENT}-DATASCIENTISTS:SQLServer"]="Contributor"
)

# Function to check if a group exists
check_group_exists() {
  local group_name="$1"
  az ad group show --group "$group_name" --query "id" --output tsv 2>/dev/null
}

# Function to create a group
create_group() {
  local group_name="$1"
  echo "Creating group '$group_name'..."
  az ad group create --display-name "$group_name" --mail-nickname "$group_name" --query "id" --output tsv
  echo "Group '$group_name' created successfully."
}

# Function to get Group Object ID
get_group_object_id() {
  local group_name="$1"
  az ad group show --group "$group_name" --query "id" --output tsv
}

# Function to assign roles
assign_role() {
  local group_name="$1"
  local role_name="$2"
  local scope="$3"
  local group_id

  group_id=$(get_group_object_id "$group_name")
  echo "Assigning role '$role_name' to group '$group_name' (ID: $group_id) at scope '$scope'"
  az role assignment create --assignee "$group_id" --role "$role_name" --scope "$scope"
}

# Create groups if they do not exist
for group in "${GROUP_LIST[@]}"; do
  if check_group_exists "$group"; then
    echo "Group '$group' already exists. Skipping creation."
  else
    create_group "$group"
  fi

done

# Assign roles to groups
for group in "${GROUP_LIST[@]}"; do
  for service in "${!SERVICE_SCOPES[@]}"; do
    scope="${SERVICE_SCOPES[$service]}"
    role="${CUSTOM_ROLE_MAPPING[$group:$service]}"
    
    if [[ -n "$role" ]]; then
      assign_role "$group" "$role" "$scope"
    else
      echo "No role defined for '$group' on '$service'. Skipping..."
    fi
  done

done

echo "AAD Group creation and role assignment completed."
