@description('Environment name')
param environment string
@description('Workload name')
param workload string
@description('VNet name')
param vnetName string
@description('Subnet name')
param subnetName string
@description('VM size')
param vmSize string
@description('Network resource group name')
param networkResourceGroupName string
@description('VM name')
param vmname string
@description('Computer name')
param computerName string
@secure()
@description('VM admin user name')
param vmAdminUserName string
@secure()
@description('VM admin password')
param vmAdminPassword string
@description('VM image details')
param vmImageDetails string
@description('Location')
param location string = resourceGroup().location


// param Vmimage object = {
//   ADImage: '1'
//   NonADImage : '2'
// }


// resource ADImage 'Microsoft.Compute/galleries/images/versions@2023-07-03' existing = {
//   name: 'windows2022/windows/0.0.1'
// }

// resource NonADImage 'Microsoft.Compute/galleries/images/versions@2023-07-03' existing = {
//   name: 'test/test/0.0.2'
// }


@description('VNet Name to deploy VM')
resource vnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: vnetName
  scope: resourceGroup(networkResourceGroupName)
}
@description('Subnet Name to deploy VM')
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' existing = {
  name: subnetName
  parent: vnet
}



@description('Network Interface Card Name')
resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: '${uniqueString(deployment().name, location)}-VM-Nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}
@description('Virtual Machine Name')
resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmname
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: toUpper(computerName)
      adminUsername: vmAdminUserName
      adminPassword: vmAdminPassword
    }
    storageProfile: {
      osDisk: {
        name: 'app-osdsk-${workload}-${environment}-${location}'
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Delete'
      }
      imageReference: {
        id: vmImageDetails
      }
     }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
//@description(' Adding Windows System into Domain')
// resource virtualMachineExtension 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
//   name: '${virtualMachine.name}/joindomain'
//   location: location
//   properties: {
//     publisher: 'Microsoft.Compute'
//     type: 'JsonADDomainExtension'
//     typeHandlerVersion: '1.3'
//     autoUpgradeMinorVersion: true
//     settings: {
//       name: extensionDomainJoinDomainName
//       ouPath: ouPath
//       user: '${extensionDomainJoinDomainName}\\${extensionDomainJoinUserName}'
//       restart: true
//       options: domainJoinOptions
//     }
//     protectedSettings: {
//       password: extensionDomainJoinPassword
//     }
//   }
// }
