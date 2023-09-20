resource myStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'azurebacktoschool'
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
