/*

  Module: Azure Virtual Machine - Windows

*/

// Parameters -------------------------------------------------

@maxLength(15)
param name string
param location string = resourceGroup().location

@description('The virtual machine class - Standard or HighPerformance')
@allowed([ 'Standard', 'HighPerformance' ])
param vmClass string

param subnetId string
param deployWithPublicIp bool = false

@secure()
param adminUsername string
@secure()
param adminPassword string

param joinDomain bool = false
param domainName string = 'contoso.com'
param domainOU string = 'OU=AzureVMs,DC=contoso,DC=com'

@secure()
param domainJoinUsername string = ''
@secure()
param domainJoinPassword string = ''

// Variables --------------------------------------------------
var vmClassData = {
  Standard: {
    vmSize: 'Standard_D2s_v3'
    osDiskSku: 'StandardSSD_LRS'
  }
  HighPerformance: {
    vmSize: 'Standard_D4s_v3'
    osDiskSku: 'Premium_LRS'
  }
}

var vmSize = vmClassData[vmClass].vmSize
var osDiskSku = vmClassData[vmClass].osDiskSku

var vmName = '${name}-vm'
var nicName = '${name}-vm-nic'
var osDiskName = '${name}-vm-osdisk'

// Resources --------------------------------------------------

resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: vmName
  location: location
  tags: {
    'vm-class': vmClass
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        name: osDiskName
        osType: 'Windows'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskSku
        }
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-datacenter-gensecond'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmNic.id
        }
      ]
    }
    osProfile: {
      adminUsername: adminUsername
      adminPassword: adminPassword
      computerName: name
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource vmNic 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: deployWithPublicIp ? {// only add if deployWithPublicIp is true
            id: vmPublicIp.id
          } : null
        }
      }
    ]
  }
}

// Public IP Address - will only be created if deployWithPublicIp is true
resource vmPublicIp 'Microsoft.Network/publicIPAddresses@2022-11-01' = if (deployWithPublicIp) {
  name: '${name}-vm-pip'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// Domain Join - will only be created if joinDomain is true
resource vmDomainJoin 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = if (joinDomain) {
  parent: virtualMachine
  name: 'joindomain'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      name: domainName
      OUPath: domainOU
      user: domainJoinUsername
      restart: 'true'
      options: '3'
    }
    protectedSettings: {
      Password: domainJoinPassword
    }
  }
}

// Outputs ----------------------------------------------------
output vmName string = virtualMachine.name
output vmId string = virtualMachine.id
output vmPrivateIp string = vmNic.properties.ipConfigurations[0].properties.privateIPAddress
output vmPublicIp string = deployWithPublicIp ? vmPublicIp.properties.ipAddress : ''
