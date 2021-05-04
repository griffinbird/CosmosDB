param rgname string
param location string
param failoverLocation string
param accountName string
param databaseName string
param containerName string
//@description('Enable automatic failover for regions')
//param automaticFailover bool = true

//param location string = 'australiaeast'
//param failoverLocation string = 'australiasoutheast'

resource cosmos_account 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: '${accountName}'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        failoverPriority: 1
        locationName: failoverLocation
      }
      {
        failoverPriority: 0
        locationName: location
      }
    ]
  }

  resource cosmos_sqldb 'sqlDatabases' = {
    name: '${databaseName}'
    properties: {
      options: {
        throughput: 400
      }
      resource: {
        id: '${databaseName}'
      }
    }

    resource cosmos_sqldb_container 'containers' = {
      name: '$containerName'
      properties: {
        options: {
          throughput: 400
        }
        resource: {
          partitionKey: {
            paths: [
              '/partitionKey'
            ]
            kind: 'Hash'
          }
          id: '${containerName}'
          uniqueKeyPolicy: {
            uniqueKeys: [
              {
                paths: [
                  '/uid'
                ]
              }
            ]
          }
        }
      }
    }
  }
}
