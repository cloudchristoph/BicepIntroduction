targetScope = 'subscription'

// Parameters ---------------------------------------------------------------
@allowed(['dev', 'test', 'prod'])
param environment string

@allowed(['germanywestcentral', 'westeurope'])
param location string

// Variables ----------------------------------------------------------------
var resourceGroupNameNetwork = 'rg-demo-${environment}-network'
var resourceGroupNameVMs = 'rg-demo-${environment}-vms'
var vnetName = 'demo-${environment}'

var keyVaultResourceGroupName = 'rg-Bicep-Resources'
var keyVaultName = 'cc-bicep'


// Resources ----------------------------------------------------------------
resource rgNetwork 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupNameNetwork
  location: location
}

resource rgVMs 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupNameVMs
  location: location
}

module vnet 'modules/virtualNetwork.bicep' = {
  scope: rgNetwork
  name: 'deploy-demonet1-${environment}'
  params: {
    addressRange: '10.1.0.0/24'
    name: vnetName
    location: location
    subnets: [
      {
        name: 'default'
        addressRange: '10.1.0.0/26'
      }
      {
        name: 'app'
        addressRange: '10.1.0.64/26'
      }
    ]
  }
}

module vmDemoStandard 'modules/windowsVirtualMachine.bicep' = {
  scope: rgVMs
  name: 'vm-demo-standard-${environment}'
  params: {
    name: 'windemo-${environment}'
    location: location
    vmClass: 'Standard'
    subnetId: '${vnet.outputs.vnetId}/subnets/app'
    deployWithPublicIp: true
    joinDomain: false
    adminUsername: keyVault.getSecret('adminUsername')
    adminPassword: keyVault.getSecret('adminPassword')
  }
}

module vmDemoHighPerformance 'modules/windowsVirtualMachine.bicep' = {
  scope: rgVMs
  name: 'vm-demo-highperformance-${environment}'
  params: {
    name: 'windemo2-${environment}'
    location: location
    vmClass: 'HighPerformance'
    subnetId: '${vnet.outputs.vnetId}/subnets/app'
    deployWithPublicIp: true
    joinDomain: false
    adminUsername: keyVault.getSecret('adminUsername')
    adminPassword: keyVault.getSecret('adminPassword')
  }
}

// Existing Key Vault with Login Credentials
resource keyVault 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: keyVaultName
  scope: resourceGroup(keyVaultResourceGroupName)
}

// Outputs ------------------------------------------------------------------
output vmDemoStandardPublicIp string = vmDemoStandard.outputs.vmPublicIp
output vmDemoHighPerformancePublicIp string = vmDemoHighPerformance.outputs.vmPublicIp
