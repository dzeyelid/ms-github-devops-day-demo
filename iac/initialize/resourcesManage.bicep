targetScope = 'resourceGroup'

param workloadName string
param resourceGroupLocation string = resourceGroup().location

@allowed(['Premium_LRS', 'Premium_ZRS', 'Standard_GRS', 'Standard_GZRS', 'Standard_LRS', 'Standard_RAGRS', 'Standard_RAGZRS', 'Standard_ZRS'])
param storageSkuName string = 'Standard_LRS'

// to store Terraform's state
resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'st${sys.uniqueString(resourceGroup().id)}'
  location: resourceGroupLocation
  kind: 'StorageV2'
  sku: {
    name: storageSkuName
  }
  tags: {
    purpose: 'terraform-state-store'
    workloadName: workloadName
  }

  resource blob 'blobServices@2021-09-01' = {
    name: 'default'

    resource containerTfstate 'containers@2021-09-01' = {
      name: 'tfstate'
      properties: {
        publicAccess: 'None'
      }
    }
  }
}

resource storageLock 'Microsoft.Authorization/locks@2017-04-01' = {
  name: 'preventDelete'
  scope: storage
  properties: {
    level: 'CanNotDelete'
  }
}

output storageTerraformStateStoreName string = storage.name
