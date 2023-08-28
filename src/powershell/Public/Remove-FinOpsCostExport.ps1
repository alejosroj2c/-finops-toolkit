# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

<#
    .SYNOPSIS
    Delete a Cost Management export and optionally data associated with the export.

    .PARAMETER Name
    Name of the Cost Management export.

    .PARAMETER Scope
    Required. Resource ID of the scope to export data for.

    .PARAMETER RemoveData
    Optional. Indicates that all cost data associated with the Export scope should be deleted.

    .PARAMETER APIVersion
    Optional. API version to use when calling the Cost Management Exports API. Default = 2023-03-01.

    .EXAMPLE
    Remove-FinOpsCostExport -Name MyExport -Scope "/subscriptions/00000000-0000-0000-0000-000000000000" -RemoveData

    Deletes a Cost Management Export named MyExport scoped to /subscriptions/00000000-0000-0000-0000-000000000000, and deletes all data associated with that scope.
#>

function Remove-FinOpsCostExport
{
  [CmdletBinding(SupportsShouldProcess)]
  param
  (
    [Parameter(Mandatory = $true)]
    [string]
    $Name,

    [Parameter(Mandatory = $true)]
    [string]
    $Scope,

    [Parameter()]
    [switch]
    $RemoveData,

    [Parameter()]
    [string]
    $ApiVersion = '2023-03-01'
  )

  $context = Get-AzContext
  if (-not $context)
  {
      throw $script:localizedData.ContextNotFound
  }

  try
  {
    $additionalParamaters = @{
      scope = $scope
    }
    $payload = ConvertTo-Json -InputObject $additionalParamaters -Depth 100

    $invokeAzRestMethodParams = @{
      ResourceProviderName = "Microsoft.CostManagement"
      ResourceType = "exports"
      Name = $Name
      ApiVersion = $ApiVersion
      Payload = $payload
    }

    $httpResponse = Invoke-AzRestMethod @invokeAzRestMethodParams -Method "GET"

    if ($httpResponse.StatusCode -eq 404) { break }
    elseif ($httpResponse.StatusCode -ne 200)
    {
      throw ($script:localizedData.GetCostExportNotFound -f $($httpResponse.Content))
    }
    else
    {
      # Delete associated data from storage account
      if ($RemoveData)
      {
        # Export details retreived
        $exportDetails = ConvertFrom-Json -InputObject $httpResponse.Content
        $storageAccountId = $exportDetails.properties.deliveryInfo.destination.resourceId
        $resourceGroupName = $storageAccountID.Split('/')[4]
        $storageAccountName = $storageAccountID.Split('/')[8]
        $path = $scope + "/" + $Name

        if ($PSCmdlet.ShouldProcess($scope, 'DeleteCostReports'))
        {
          Write-Verbose "Resource group: $resourceGroupName"
          Write-Verbose "Storage account: $storageAccountName"
          Write-Verbose "Scope: $scope"
          Write-Verbose "Path: $path"

          $getSta = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
          if ($getSta.EnableHierarchicalNamespace)
          {
            $getSta | Remove-AzDataLakeGen2Item -FileSystem "msexports" -Path $path -Force
          }
        }
      }
    }

    if ($PSCmdlet.ShouldProcess($Name, 'DeleteCostExport'))
    {
      $httpResponse = Invoke-AzRestMethod @invokeAzRestMethodParams -Method "DELETE"

      if ($httpResponse.StatusCode -eq 404) { break }
      elseif ($httpResponse.StatusCode -ne 200)
      {
        throw ($script:localizedData.DeleteCostExportFailed -f $($httpResponse.Content))
      }
    }
  }
  catch
  {
    throw $_.Exception
  }
}
