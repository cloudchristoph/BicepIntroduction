@maxLength(22) // 24 - 2 for the 'st' prefix
param name string

param location string = resourceGroup().location
param skuName string = 'Standard_LRS'

var storageAccountName = 'st${name}'

resource myStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
}

output storageAccountName string = myStorageAccount.name
output storageAccountResourceId string = myStorageAccount.id
output storageAccountBlobEndpoint string = myStorageAccount.properties.primaryEndpoints.blob
