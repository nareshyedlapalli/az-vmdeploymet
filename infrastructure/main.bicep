
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
param imageType string
@description('VM Size')
param vmSize string

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


@description('VM Creation Module')
module vmCreation 'modules/vm.bicep' = {
  name: 'vmDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    imageType: imageType
    location: location
    networkResourceGroupName: networkResourceGroupName
    vnetName: vnetName
    subnetName: subnetName
    vmname: vmname
    vmSize: vmSize
    computerName: computerName
    vmAdminUserName: vmAdminUserName
    vmAdminPassword: vmAdminPassword
    vmDomainJoinDomainName: vmDomainJoinDomainName
    domainAdminUserName: domainAdminUserName
    domainAdminPassword: domainAdminPassword
    domainJoinOptions: domainJoinOptions
    ouPath: ouPath
    environment: environment
    workload: 'vm'
    // instance_count: instance_count
  }
  dependsOn: [
  ]
}
