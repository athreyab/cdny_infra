#!/bin/bash

RESOURCE_GROUP="cdny-dwh-eus-qa-rg"
WORKSPACE_NAME="cdny-dwh-eus-qa-databricks01"
WORKSPACE_URL=$(az databricks workspace show --resource-group "$RESOURCE_GROUP" --name "$WORKSPACE_NAME" --query workspaceUrl -o tsv)

DATABRICKS_GLOBAL_RESOURCE="2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"

# Get Azure Access Token for Databricks
TOKEN=$(az account get-access-token --resource "$DATABRICKS_GLOBAL_RESOURCE" --query accessToken -o tsv)
AZ_TOKEN=$(az account get-access-token --resource=https://management.core.windows.net/ --query accessToken -o tsv)

# Get Workspace ID
WORKSPACE_ID=$(az resource show --resource-type "Microsoft.Databricks/workspaces" --resource-group "$RESOURCE_GROUP" -n "$WORKSPACE_NAME" --query id -o tsv)

# API Call to Create a PAT Token
CREATE_TOKEN_API="https://$WORKSPACE_URL/api/2.0/token/create"
BODY='{"lifetime_seconds": 86400, "comment": "Token to create databricks related resource while deploying"}'

RESPONSE=$(curl -s -X POST "$CREATE_TOKEN_API" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-Databricks-Azure-SP-Management-Token: $AZ_TOKEN" \
  -H "X-Databricks-Azure-Workspace-Resource-Id: $WORKSPACE_ID" \
  -H "Content-Type: application/json" \
  -d "$BODY")

PAT_TOKEN=$(echo "$RESPONSE" | jq -r '.token_value')
if [[ -z "$PAT_TOKEN" || "$PAT_TOKEN" == "null" ]]; then
  echo "Error: Failed to generate Databricks token!"
  exit 1
fi

echo "$PAT_TOKEN"
