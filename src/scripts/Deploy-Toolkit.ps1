<#
.SYNOPSIS
    Deploys a toolkit template or module for local testing purposes.
.DESCRIPTION
    Run this from the /src/scripts folder.
.EXAMPLE
    ./Deploy-Toolkit "finops-hub"
    Deploys a new FinOps hub instance.
.EXAMPLE
    ./Deploy-Toolkit -WhatIf
    Validates the deployment template or module without changing resources.
.PARAMETER Template
    Name of the template or module to deploy. Default = finops-hub.
.PARAMETER ResourceGroup
    Optional. Name of the resource group to deploy to. Will be created if it doesn't exist. Default = ftk-<username>-<computername>.
.PARAMETER Location
    Optional. Azure location to execute the deployment from. Default = westus.
.PARAMETER Parameters
    Optional. Parameters to pass thru to the deployment.
.PARAMETER Build
    Optional. Indicates whether the the Build-Toolkit command should be executed first. Default = false.
.PARAMETER Test
    Optional. Indicates whether to run the template or module test instead of the template or module itself. Default = false.
.PARAMETER WhatIf
    Optional. Displays a message that describes the effect of the command, instead of executing the command.
#>
Param(
    [Parameter(Position = 0)][string]$Template = "finops-hub",
    [string]$ResourceGroup,
    [string]$Location = "westus",
    [object]$Parameters,
    [switch]$Build,
    [switch]$Test,
    [switch]$WhatIf
)

# Use the debug flag from common parameters to determine whether to run in debug mode
$Debug = $DebugPreference -eq "Continue"

function iff([bool]$Condition, $IfTrue, $IfFalse) {
    if ($Condition) { $IfTrue } else { $IfFalse }
}

# Build toolkit if requested
if ($Build) {
    ./Build-Toolkit
}

# Generates a unique name based on the signed in username and computer name for local testing
function Get-UniqueName() {
    # NOTE: For some reason, using variables directly does not get the value until we write them
    $c = $env:ComputerName
    $u = $env:USERNAME
    $c | Out-Null
    $u | Out-Null
    return "ftk-$u-$c".ToLower()
}

# Local dev parameters
$defaultParameters = @{
    "finops-hub"      = @{ hubName = Get-UniqueName }
    "finops-hub/test" = @{ uniqueName = Get-UniqueName }
}

# Find bicep file (templates first)
@("../templates", "../bicep-registry", "../../release") `
| ForEach-Object { Get-Item (Join-Path $_ $Template (iff $Test test/main.test.bicep main.bicep)) -ErrorAction SilentlyContinue } `
| ForEach-Object {
    $templateFile = $_
    $templateName = iff $Test ($templateFile.Directory.Parent.Name + "/test") $templateFile.Directory.Name
    $targetScope = (Get-Content $templateFile | Select-String "targetScope = '([^']+)'").Matches[0].Captures[0].Groups[1].Value
    
    # Fall back to default parameters if none were provided
    $Parameters = iff ($null -eq $Parameters) $defaultParameters[$templateName] $Parameters
    $Parameters = iff ($null -eq $Parameters) @{} $Parameters
    
    Write-Host "Deploying $templateName..."
    switch ($targetScope) {
        "resourceGroup" {

            # Set default RG name to "ftk-<username>-<computername>"
            If ([string]::IsNullOrEmpty($ResourceGroup)) {
                $ResourceGroup = Get-UniqueName
            }
            
            Write-Host "  → [rg] $ResourceGroup..."
            $Parameters.Keys | ForEach-Object { Write-Host "         $($_) = $($Parameters[$_])" }
            
            if ($Debug) {
                Write-Host "         $templateFile"
            } else {
                # Create resource group if it doesn't exist
                $rg = Get-AzResourceGroup $ResourceGroup
                If ($null -eq $rg) {
                    New-AzResourceGroup `
                        -Name $ResourceGroup `
                        -Location $Location `
                    | Out-Null
                }

                # Start deployment
                New-AzResourceGroupDeployment `
                    -TemplateFile $templateFile `
                    -TemplateParameterObject $Parameters `
                    -ResourceGroupName $ResourceGroup `
                    -WhatIf:$WhatIf
            }

        }
        "subscription" {

            Write-Host "  → [sub] $((Get-AzContext).Subscription.Name)..."
            $Parameters.Keys | ForEach-Object { Write-Host "          $($_) = $($Parameters[$_])" }

            if ($Debug) {
                Write-Host "          $templateFile"
            } else {
                New-AzSubscriptionDeployment `
                    -TemplateFile $templateFile `
                    -TemplateParameterObject $Parameters `
                    -Location $Location `
                    -WhatIf:$WhatIf
            }

        }
        "managementGroup" {
            Write-Error "Management group deployments have not been implemented yet"
        }
        "tenant" {

            $azContext = (Get-AzContext).Tenant
            Write-Host "  → [tenant] $(iff ([string]::IsNullOrWhitespace($azContext.Name)) $azContext.Id $azContext.Name)..."
            $Parameters.Keys | ForEach-Object { Write-Host "             $($_) = $($Parameters[$_])" }

            if ($Debug) {
                Write-Host "             $templateFile"
            } else {
                New-AzTenantDeployment `
                    -TemplateFile $templateFile `
                    -TemplateParameterObject $Parameters `
                    -Location $Location `
                    -WhatIf:$WhatIf
            }

        }
        default { Write-Error "Unsupported target scope: $targetScope"; return }
    }

    Write-Host ''
}    
