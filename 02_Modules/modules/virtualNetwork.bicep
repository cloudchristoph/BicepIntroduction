param name string
param location string = resourceGroup().location

@description('The address range for the virtual network in CIDR notation.')
param addressRange string

@description('The subnets to create within the virtual network.')
param subnets subnet[]

var vnetName = '${name}-vnet'
var nsgName = '${name}-default-nsg'

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressRange
      ]
    }
    subnets: [for item in subnets: {
      name: item.name
      properties: {
        addressPrefix: item.addressRange
        networkSecurityGroup: {
          id: networkSecurityGroup.id
        }
      }
    }]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDPInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 1000
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
    ]
  }
}

// User defined types
type subnet = {
  name: string
  addressRange: string
}

// Output
output vnetId string = vnet.id
output vnetName string = vnet.name
