# Terraform による Azure リソース管理

```bash
ENV="{prod | staging | dev}"
WORKLOAD_NAME="msgh-devops-demo"

RESOURCE_GROUP_MANAGE_NAME="rg-${WORKLOAD_NAME}-manage"
TERRAFORM_BACKEND_STORAGE_ACCOUNT_NAME=`az storage account list \
    --resource-group ${RESOURCE_GROUP_MANAGE_NAME} \
    --output json \
    --query "[?tags.purpose == 'terraform-state-store'].name" \
  | jq -r ".[0]"`

cd iac/terraform/envs/${ENV}

terraform init \
  -backend-config="resource_group_name=${RESOURCE_GROUP_MANAGE_NAME}" \
  -backend-config="storage_account_name=${TERRAFORM_BACKEND_STORAGE_ACCOUNT_NAME}"

terraform plan -var "workload_name=${WORKLOAD_NAME}"
terraform apply -var "workload_name=${WORKLOAD_NAME}"
```