targetScope = 'subscription'

@minLength(1)
@maxLength(17)
@description('Enter the name of your resource group')
param rgName string
@description('Enter the location for the resource group to be created in')
param rgLocation string
@description('The primary replica region for the Cosmos DB account.')
param primaryRegion string
@description('The secondary replica region for the Cosmos DB account.')
param secondaryRegion string
@description('Cosmos DB account name, max length 44 characters, lowercase')
param accountName string = 'sql-${uniqueString(subscription().id)}'
@description('The name for the database')
param databaseName string
@description('The name for the container')
param containerName string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${rgName}'
  location: rgLocation
}

module resources 'modules/resources.bicep' = {
  name: '${rg.name}-resources'
  scope: rg
  params: {
    rgname: toLower(rgName)
    location: primaryRegion
    failoverLocation: secondaryRegion
    accountName: accountName
    databaseName: databaseName
    containerName: containerName
  }
}
