# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

<#
    .SYNOPSIS
    Gets an Azure region ID and name to clean up Cost Management cost data during ingestion.

    .DESCRIPTION
    The Get-FinOpsRegion command returns an Azure region ID and name based on the specified resource location.

    .PARAMETER ResourceLocation
    Optional. Resource location value from a Cost Management cost/usage details dataset. Accepts wildcards. Default = * (all).

    .PARAMETER RegionId
    Optional. Azure region ID (lowercase English name without spaces). Accepts wildcards. Default = * (all).

    .PARAMETER RegionName
    Optional. Azure region name (title case English name with spaces). Accepts wildcards. Default = * (all).

    .PARAMETER IncludeResourceLocation
    Optional. Indicates whether to include the ResourceLocation property in the output. Default = false.

    .EXAMPLE
    Get-FinOpsRegion -ResourceLocation "US East"

    ### Get a specific region
    Returns the region ID and name for the East US region.

    .EXAMPLE
    Get-FinOpsRegion -RegionId "*asia*" -IncludeResourceLocation

    ### Get many regions with the original Cost Management value
    Returns all Asia regions with the original Cost Management ResourceLocation value.

    .LINK
    https://aka.ms/ftk/Get-FinOpsRegion
#>
function Get-FinOpsRegion()
{
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string]
        $ResourceLocation = "*",

        [Parameter()]
        [string]
        $RegionId = "*",

        [Parameter()]
        [string]
        $RegionName = "*",

        [switch]
        $IncludeResourceLocation
    )
    return Get-OpenDataRegion `
    | Where-Object {
        $_.OriginalValue -like $ResourceLocation `
            -and $_.RegionId -like $RegionId `
            -and $_.RegionName -like $RegionName
    } `
    | ForEach-Object {
        if ($IncludeResourceLocation)
        {
            $loc = $_.OriginalValue
            $exclude = @()
        }
        else
        {
            $loc = $null
            $exclude = @('ResourceLocation')
        }
        [PSCustomObject]@{
            ResourceLocation = $loc
            RegionId         = $_.RegionId
            RegionName       = $_.RegionName
        } `
        | Select-Object -ExcludeProperty $exclude
    } `
    | Select-Object -Property * -Unique
}
