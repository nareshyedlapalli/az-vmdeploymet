using '../main.bicep'
param vmSize = ''
param workload = ''
param environment = ''
param resourceGroupName =  ''
param vmImageDetails = ''
param vnetName = 'dev-vnet'
param subnetName = ''
param vmname  = ''
param computerName = ''
param networkResourceGroupName = 'NW-dev-rg'
param vmAdminUserName = 'azadmin'
param vmAdminPassword = ''
// param extensionDomainJoinPassword = ''
// param extensionDomainJoinDomainName = ''
// param extensionDomainJoinUserName = ''
// param domainJoinOptions = 3
// param ouPath = ''
