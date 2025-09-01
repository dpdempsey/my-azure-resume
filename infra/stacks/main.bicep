// ---- SCOPE ----
targetScope = 'resourceGroup'

// ---- PARAMETERS ----
@description('Cosmos DB account name')
param accountName string = 'cosmos-${uniqueString(resourceGroup().id)}'

@description('Location for the Cosmos DB account.')
param location string = resourceGroup().location

@description('The name for the SQL API database')
param databaseName string

@description('The name for the SQL API container')
param containerName string

@description('Name of the storage account for the Function App')

param storageAccountNameFnApp string = 'funcappsa'

@description('Name of the storage account for the Function App')
param storageAccountNameWeb string = 'staticwebsitesa'

@description('Name of the Function App')
param functionAppName string = 'funcapp-azure-resume'

@description('The path to the web index document.')
param indexDocumentPath string = 'index.html'

@description('The path to the web error document.')
param errorDocument404Path string = 'error.html'

// ---- DEPLOYMENTS ----
// Storage Account for Function App
resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountNameFnApp
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

// App Service Plan (Consumption)
resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'func-asp-${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: false
  }
}
// Function App
resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${storage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'CosmosDBConnection'
          value: account.listConnectionStrings().connectionStrings[0].connectionString
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
      windowsFxVersion: 'DOTNET-ISOLATED|8.0'
    }
    httpsOnly: true
  }
}

// Comos DB Account
resource account 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
  name: toLower(accountName)
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    enableFreeTier: true
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

// Database for Cosmos
resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-11-15' = {
  parent: account
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

// Container to store counter document/s
resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-11-15' = {
  parent: database
  name: containerName
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          '/id'
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/_etag/?'
          }
        ]
      }
    }
  }
}

// resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
//   scope: subscription()
//   // This is the Storage Account Contributor role, which is the minimum role permission we can give. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#:~:text=17d1049b-9a84-46fb-8f53-869881c3d3ab
//   name: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
// }

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountNameWeb
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

// resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
//   name: 'DeploymentScript'
//   location: location
// }

// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   scope: storageAccount
//   name: guid(resourceGroup().id, managedIdentity.id, contributorRoleDefinition.id)
//   properties: {
//     roleDefinitionId: contributorRoleDefinition.id
//     principalId: managedIdentity.properties.principalId
//     principalType: 'ServicePrincipal'
//   }
// }

// resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'deploymentScript'
//   location: location
//   kind: 'AzurePowerShell'
//   identity: {
//     type: 'UserAssigned'
//     userAssignedIdentities: {
//       '${managedIdentity.id}': {}
//     }
//   }
//   dependsOn: [
//     // we need to ensure we wait for the role assignment to be deployed before trying to access the storage account
//     roleAssignment
//   ]
//   properties: {
//     azPowerShellVersion: '11.0'
//     scriptContent: loadTextContent('./scripts/enable-static-website.ps1')
//     retentionInterval: 'PT4H'
//     environmentVariables: [
//       {
//         name: 'ResourceGroupName'
//         value: resourceGroup().name
//       }
//       {
//         name: 'StorageAccountName'
//         value: storageAccount.name
//       }
//       {
//         name: 'IndexDocumentPath'
//         value: indexDocumentPath
//       }
//       {
//         name: 'ErrorDocument404Path'
//         value: errorDocument404Path
//       }
//     ]
//   }
// }

output location string = location
output name string = container.name
output resourceGroupName string = resourceGroup().name
output resourceId string = container.id
