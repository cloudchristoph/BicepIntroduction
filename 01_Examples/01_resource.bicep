resource myStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'sysadminday2023'
  location: 'germanywestcentral'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
