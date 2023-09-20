param storageAccountName string = 'sta01'

@allowed(['Standard_LRS', 'Premium_LRS'])
param storagePerformanceLevel string = 'Standard_LRS'

var finalStorageAccountName = 'abts${storageAccountName}' // abtssta01

resource myStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: finalStorageAccountName
  location: 'westeurope'
  sku: {
    name: storagePerformanceLevel
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
  }
}

output blobEndpoint string = myStorageAccount.properties.primaryEndpoints.blob
