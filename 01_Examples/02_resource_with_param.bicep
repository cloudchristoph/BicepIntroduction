param name string
param location string = resourceGroup().location
param skuName string = 'Standard_LRS'

resource myStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
}
