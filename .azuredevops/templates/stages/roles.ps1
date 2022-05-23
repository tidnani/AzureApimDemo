
function Assign-ApiRole {
    param (
        [Parameter(Mandatory=$true)] [string] $objectId,
        [Parameter(Mandatory=$true)] [string] $apiName,
        [Parameter(Mandatory=$false)] [string] $productName
    )

    $roleDefinitionName = "Demo API Management API Contributor"
    $deploymentRoleDefinitionName = "Demo Deployment Role"
    $azureResourceGroup = $env:AZURERESOURCEGROUP
    $subscriptionId = $env:SUBSCRIPTIONID
    $apimName = $env:APIMNAME

    $apiScope = "/subscriptions/$subscriptionId/resourcegroups/$azureResourceGroup/providers/Microsoft.ApiManagement/service/$apimName/apis/$apiName"
    $versionSetScope = "/subscriptions/$subscriptionId/resourcegroups/$azureResourceGroup/providers/Microsoft.ApiManagement/service/$apimName/apiVersionSets/$apiName"
    if ($productName) { $productScope = "/subscriptions/$subscriptionId/resourcegroups/$azureResourceGroup/providers/Microsoft.ApiManagement/service/$apimName/products/$productName/apis/$apiName" }

    $cnt = 0
    do {
        $cnt++
        try {
            $exist1 = Get-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $apiScope
            if ([string]::IsNullOrEmpty($exist1)) {
                New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $apiScope | Out-Null
                Write-Output "Role $roleDefinitionName for $objectId at $apiScope has been added"
            }
            $exist2 = Get-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $versionSetScope
            if ([string]::IsNullOrEmpty($exist2)) {
                New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $versionSetScope | Out-Null
                Write-Output "Role $roleDefinitionName for $objectId at $versionSetScope has been added"
            }
            if ($productName) {
                $exist3 = Get-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $productScope
                if ([string]::IsNullOrEmpty($exist3)) {
                    New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $productScope | Out-Null
                    Write-Output "Role $roleDefinitionName for $objectId at $productScope has been added"
                }
            }
            $exist4 = Get-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $deploymentRoleDefinitionName -ResourceGroupName $azureResourceGroup
            if ([string]::IsNullOrEmpty($exist4)) {
                New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $deploymentRoleDefinitionName -ResourceGroupName $azureResourceGroup | Out-Null
                Write-Output "Role $deploymentRoleDefinitionName for $objectId at $azureResourceGroup has been added"
            }
            return
        } catch {
            Start-Sleep 30
        }
    } while ($cnt -lt 3)
}


function Remove-ApiRole {
    param (
        [Parameter(Mandatory=$true)] [string] $objectId,
        [Parameter(Mandatory=$true)] [string] $apiName,
        [Parameter(Mandatory=$false)] [string] $productName
    )

    $roleDefinitionName = "Demo API Management API Contributor"
    $deploymentRoleDefinitionName = "Demo Deployment Automation"
    $azureResourceGroup = $env:AZURERESOURCEGROUP
    $subscriptionId = $env:SUBSCRIPTIONID
    $apimName = $env:APIMNAME

    $apiScope = "/subscriptions/$subscriptionId/resourcegroups/$azureResourceGroup/providers/Microsoft.ApiManagement/service/$apimName/apis/$apiName"
    $versionSetScope = "/subscriptions/$subscriptionId/resourcegroups/$azureResourceGroup/providers/Microsoft.ApiManagement/service/$apimName/apiVersionSets/$apiName"
    if ($productName) { $productScope = "/subscriptions/$subscriptionId/resourcegroups/$azureResourceGroup/providers/Microsoft.ApiManagement/service/$apimName/products/$productName/apis/$apiName" }

    $cnt = 0
    do {
        $cnt++
        try {
            $exist1 = Get-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $apiScope
            if ($exist1) {
                Remove-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $apiScope | Out-Null
                Write-Output "Role $roleDefinitionName for $objectId at $apiScope has been removed"
            }
            $exist2 = Get-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $versionSetScope
            if ($exist2) {
                Remove-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $versionSetScope | Out-Null
                Write-Output "Role $roleDefinitionName for $objectId at $versionSetScope has been removed"
            }
            if ($productName) {
                $exist3 = Get-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $productScope
                if ($exist3) {
                    Remove-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $roleDefinitionName -Scope $productScope | Out-Null
                    Write-Output "Role $roleDefinitionName for $objectId at $productScope has been removed"
                }
            }
            $exist4 = Get-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $deploymentRoleDefinitionName -ResourceGroupName $azureResourceGroup
            if ($exist4) {
                Remove-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $deploymentRoleDefinitionName -ResourceGroupName $azureResourceGroup | Out-Null
                Write-Output "Role $deploymentRoleDefinitionName for $objectId at $azureResourceGroup has been removed"
            }
            return
        } catch {
            Start-Sleep 30
        }
    } while ($cnt -lt 3)
}