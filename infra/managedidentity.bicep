
param userManagedIdentity string
param location string 
resource managedidentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31'   = {
  name: userManagedIdentity
  location: location
}

output userManagedIdentityId string = managedidentity.id
