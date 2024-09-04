
@description('Environment name')
param environment string

@description('Workload name')
param workload string

@description('Region for all resources in this module')
param location string = resourceGroup().location


@description('Vnet name')
param vnetName string

@description('Vm name')
param vmname string

@description('Computer name')
param computerName string

@description('Subnet name')
param subnetName string

@description('Network ResourceGroup Name')
param networkResourceGroupName string

@description('VM Username')
param vmAdminUserName string
@secure()
@description('VM Password')
param vmAdminPassword string
@description('Resource Group Name')
param resourceGroupName string
@description('VM Image Details')
param vmImageDetails string
@description('VM Size')
param vmSize string


@description('VM Creation Module')
module vmCreation 'modules/vm.bicep' = {
  name: 'vmDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    vmImageDetails: vmImageDetails
    location: location
    networkResourceGroupName: networkResourceGroupName
    vnetName: vnetName
    subnetName: subnetName
    vmAdminPassword: vmAdminPassword
    vmname: vmname
    vmSize: vmSize
    vmAdminUserName: vmAdminUserName
    computerName: computerName
    // extensionDomainJoinDomainName: extensionDomainJoinDomainName
    // extensionDomainJoinUserName: extensionDomainJoinUserName
    // extensionDomainJoinPassword: extensionDomainJoinPassword
    environment: environment
    workload: 'vm'
    // instance_count: instance_count
  }
  dependsOn: [
  ]
}
