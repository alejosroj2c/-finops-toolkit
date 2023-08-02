// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

//==============================================================================
// Parameters
//==============================================================================

@description('Required. Name of the hub. Used to ensure unique resource names.')
param hubName string

@description('Required. Suffix to add to the storage account name to ensure uniqueness.')
param uniqueSuffix string

@description('Optional. Azure location where all resources should be created. See https://aka.ms/azureregions. Default: (resource group location).')
param location string = resourceGroup().location

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
])
@description('Optional. Storage SKU to use. LRS = Lowest cost, ZRS = High availability. Note Standard SKUs are not available for Data Lake gen2 storage. Allowed: Premium_LRS, Premium_ZRS. Default: Premium_LRS.')
param sku string = 'Premium_LRS'

@description('Optional. Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.')
param tags object = {}

@description('Optional. List of scope IDs to create exports for.')
param exportScopes array

@description('Optional. Number of days of cost data to retain in the ms-cm-exports container. Default: 0.')
param exportRetentionInDays int = 0

@description('Optional. Number of months of cost data to retain in the ingestion container. Default: 13.')
param ingestionRetentionInMonths int = 13

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

// Generate globally unique storage account name: 3-24 chars; lowercase letters/numbers only
var safeHubName = replace(replace(toLower(hubName), '-', ''), '_', '')
var storageAccountSuffix = uniqueSuffix
var storageAccountName = '${take(safeHubName, 24 - length(storageAccountSuffix))}${storageAccountSuffix}'
var schema_ea_normalized = loadTextContent('../schema/schema_ea_normalized.json')
var schema_mca_normalized = loadTextContent('../schema/schema_mca_normalized.json')
var uploadScript = loadTextContent('./scripts/Copy-FileToAzureBlob.ps1')

// Roles needed to auto-start triggers
var blobUploadRbacRoles = [
  'ba92f5b4-2d11-453d-a403-e96b0029c9fe' // Storage Blob Data Contributor - https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor
]

//==============================================================================
// Resources
//==============================================================================

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: sku
  }
  kind: 'BlockBlobStorage'
  tags: tags
  properties: {
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

//------------------------------------------------------------------------------
// Containers
//------------------------------------------------------------------------------

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storageAccount
  name: 'default'
}

resource configContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: blobService
  name: 'config'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}

resource exportContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: blobService
  name: 'msexports'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}

resource ingestionContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: blobService
  name: 'ingestion'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}

//------------------------------------------------------------------------------
// Settings.json
//------------------------------------------------------------------------------

// Create managed identity to upload files
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${storageAccountName}_${configContainer.name}_blobManager'
  location: location
}

// Assign access to the identity
resource identityRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for role in blobUploadRbacRoles: {
  name: guid(storageAccount.id, role, identity.id)
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role)
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}]

resource uploadSettings 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'uploadSettings'
  kind: 'AzurePowerShell'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity.id}': {}
    }
  }
  dependsOn: [
    configContainer
    identityRoleAssignments
  ]
  properties: {
    azPowerShellVersion: '8.0'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'exportScopes'
        value: join(exportScopes, '|')
      }
      {
        name: 'exportRetentionInDays'
        value: string(exportRetentionInDays)
      }
      {
        name: 'ingestionRetentionInMonths'
        value: string(ingestionRetentionInMonths)
      }
      {
        name: 'storageAccountName'
        value: storageAccountName
      }
      {
        name: 'containerName'
        value: 'config'
      }
      {
        name: 'schema_ea_normalized'
        value: schema_ea_normalized
      }
      {
        name: 'schema_mca_normalized'
        value: schema_mca_normalized
      }
    ]
    scriptContent: uploadScript
  }
}

//==============================================================================
// Outputs
//==============================================================================

@description('The resource ID of the storage account.')
output resourceId string = storageAccount.id

@description('The name of the storage account.')
output name string = storageAccount.name

@description('The name of the container used for configuration settings.')
output configContainer string = configContainer.name

@description('The name of the container used for Cost Management exports.')
output exportContainer string = exportContainer.name

@description('The name of the container used for normalized data ingestion.')
output ingestionContainer string = ingestionContainer.name
