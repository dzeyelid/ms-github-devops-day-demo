targetScope = 'subscription'

param workloadName string
param location string

resource resourceGroupManage 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${workloadName}-manage'
  location: location
}

resource resourceGroupProd 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${workloadName}-prod'
  location: location
}

resource resourceGroupStaging 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${workloadName}-staging'
  location: location
}

resource resourceGroupDev 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${workloadName}-dev'
  location: location
}

output resourceGroupManageName string = resourceGroupManage.name
output resourceGroupManageId string = resourceGroupManage.id
output resourceGroupProdId string = resourceGroupProd.id
output resourceGroupStagingId string = resourceGroupStaging.id
output resourceGroupDevId string = resourceGroupDev.id
