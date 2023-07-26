@maxLength(22) // 24 - 2 for the 'st' prefix
param name string

param location string = resourceGroup().location

@allowed([ 'Standard_LRS', 'Standard_GRS' ])
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
