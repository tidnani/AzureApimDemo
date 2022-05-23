@description('Tags that our resources need')
param tags object = {
  owner: 'todo: replace with application owner'
  costCenter: 'todo: replace'
  application: 'todo: replace with application name'
  description: 'todo: replace'
  repo: 'todo: replace with link to repo'
}

@description('The environment of the resource. E.g. sbx')
@minLength(1)
param environment string

@description('Name of the API Management service.')
@minLength(1)
param apimName string

@description('The email address of the owner of the service')
@minLength(1)
param publisherEmail string

@description('The name of the owner of the service')
@minLength(1)
param publisherName string

@description('The pricing tier of this API Management service')
param sku string = 'Consumption'

@description('The instance size of this API Management service.')
param skuCount int = 2

@description('Zone numbers e.g. 1,2,3.')
param availabilityZones array = [
  '1'
  '2'
]

@description('Location for all resources.')
param location string = resourceGroup().location

param apimRestoreFlag bool = true

var tags_var = {
  Owner: tags.owner
  Application: tags.application
  Description: tags.description
  Repo: tags.repo
  ManagedBy: 'ARM'
  Environment: environment
}

resource apim_resource 'Microsoft.ApiManagement/service@2021-01-01-preview' = {
  name: apimName
  location: location
  tags: tags_var
  sku: {
    name: sku
    capacity: ((sku == 'Consumption') ? 0 : skuCount)
  }
  zones: ((sku == 'Premium') ? availabilityZones : json('null'))
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    restore: apimRestoreFlag
  }
}

resource apim_internal 'Microsoft.ApiManagement/service/products@2019-01-01' = {
  parent: apim_resource
  name: 'internal'
  properties: {
    displayName: 'internal'
    description: 'internal'
    subscriptionRequired: false
    state: 'published'
  }
}

resource apim_internal_policy 'Microsoft.ApiManagement/service/products/policies@2021-01-01-preview' = {
  parent: apim_internal
  name: 'policy'
  properties: {
    value: loadTextContent('internal-product-policy.xml')
    format: 'rawxml'
  }
}
