#  管理用リソースのデプロイ

下記の管理に利用するリソースのデプロイは Bicep (ARMテンプレート）を用いて行う。

- Terraform の状態管理用の Storage Account

```bash
WORKLOAD_NAME="msgh-devops-demo"

az login

cd iac/bicep

# Create resource groups
RESOURCE_GROUPS=$(az deployment sub create \
  --location japaneast \
  --template-file resourceGroups.bicep \
  --parameters "workloadName=${WORKLOAD_NAME}" \
  --parameters "location=japaneast" \
  --query properties.outputs)

RESOURCE_GROUP_MANAGE_NAME=$(echo ${RESOURCE_GROUPS} | jq -r '.resourceGroupManageName.value')
RESOURCE_GROUP_MANAGE_ID=$(echo ${RESOURCE_GROUPS} | jq -r '.resourceGroupManageId.value')
RESOURCE_GROUP_PROD_ID=$(echo ${RESOURCE_GROUPS} | jq -r '.resourceGroupProdId.value')
RESOURCE_GROUP_STAGING_ID=$(echo ${RESOURCE_GROUPS} | jq -r '.resourceGroupStagingId.value')
RESOURCE_GROUP_DEV_ID=$(echo ${RESOURCE_GROUPS} | jq -r '.resourceGroupDevId.value')

# Create a service principal that has permission to access to project's resource groups
SERVICE_PRINCIPAL=$(az ad sp create-for-rbac \
  --role Contributor \
  --scopes ${RESOURCE_GROUP_MANAGE_ID} ${RESOURCE_GROUP_PROD_ID} ${RESOURCE_GROUP_STAGING_ID})

SERVICE_PRINCIPAL_DEV=$(az ad sp create-for-rbac \
  --role Contributor \
  --scopes ${RESOURCE_GROUP_MANAGE_ID} ${RESOURCE_GROUP_DEV_ID})

# Set the ARM_ environment variables to allow Terraform to authenticate to access Azure
# And, you should set the same environment variables to GitHub Actions secrets
export ARM_CLIENT_ID=$(echo ${SERVICE_PRINCIPAL_DEV} | jq -r '.appId')
export ARM_CLIENT_SECRET=$(echo ${SERVICE_PRINCIPAL_DEV} | jq -r '.password')
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
export ARM_TENANT_ID=$(az account show --query tenantId --output tsv)

# Create resources to store Terraform state
az deployment group create \
  --resource-group ${RESOURCE_GROUP_MANAGE_NAME} \
  --template-file resourcesManage.bicep \
  --parameters "workloadName=${WORKLOAD_NAME}"
```
