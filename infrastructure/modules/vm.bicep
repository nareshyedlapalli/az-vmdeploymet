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
@description('VM domain admin user name')
param domainAdminUserName string
@description('VM Domain Join Option ')
param vmDomainJoinDomainName string
@secure()
@description('VM domain admin user password')
param domainAdminPassword string
@description('VM Domain Join Option ')
param domainJoinOptions int
@description('ou Path')
param ouPath string
@secure()
@description('VM admin user name')
param vmAdminUserName string
@secure()
@description('VM admin password')
param vmAdminPassword string

@description('Location')
param location string = resourceGroup().location

@allowed(
  [
    'windows'
    'linux'
    'windows_domain_joined'
  ]
)
param imageType string

var imageDetails = {
  windows: {
    id: NonADImage.id
  }
  windows_domain_joined: {
    id: ADImage.id
  }
}

var vmDetails = imageDetails[imageType]
var ADJoin = imageType == 'windows_domain_joined'


resource ADImage 'Microsoft.Compute/galleries/images/versions@2023-07-03' existing = {
  name: 'windows2022/windows/0.0.1'
}

resource NonADImage 'Microsoft.Compute/galleries/images/versions@2023-07-03' existing = {
  name: 'test/test/0.0.2'
}


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
  name: '${computername, location)}-VM-Nic'
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
        id: vmDetails.id
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

@description(' Adding Windows System into Domain')
resource virtualMachineExtension 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = if (ADJoin) {
  name: '${virtualMachine.name}/joindomain'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      name: vmDomainJoinDomainName
      ouPath: ouPath
      user: '${vmDomainJoinDomainName}\\${domainAdminUserName}'
      restart: true
      options: domainJoinOptions
    }
    protectedSettings: {
      password: domainAdminPassword
    }
  }
}
