@maxLength(19)
param storageAccountName string

param location string = 'germanywestcentral'

var finalStorageAccountName = replace(toLower('stswo${storageAccountName}'), ' ', '')

resource myStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: finalStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

output yourFinalStorageAccountName string = myStorageAccount.name
output yourBlobEndpoint string = myStorageAccount.properties.primaryEndpoints.blob
