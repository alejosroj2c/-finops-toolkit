# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

<#
    .SYNOPSIS
    Converts Microsoft Cost Management data to comply with the FinOps Open Cost and Usage Specification (FOCUS) schema version 0.5.

    .DESCRIPTION
    The ConvertTo-FinOpsSchema PowerShell script takes cost data adhering to the Microsoft Cost Management schema and converts it into a format that complies with the FinOps Open Cost and Usage Specification (FOCUS) schema version 0.5. 
    This conversion aids in data management, analytics, and reporting by ensuring data consistency and adherence to standards. 
    It's important to note that the script is specifically designed for schema version 0.5 (as of September 2023) and may not fully support older versions.
    Please review output and report any issues to https://aka.ms/ftk.

    .PARAMETER ActualCost
    Specifies the input cost data that will be converted. The object must adhere to a supported Microsoft Cost Management schema. Provide the filepath of the data to be converted. Example usage: ..\..\sample-data\EA_ActualCost.csv

    .EXAMPLE
    ConvertTo-FinOpsSchema -ActualCost ActualCost.csv | Export-Csv -Path FOCUS.csv -NoTypeInformation

    Converts the input data found in ActualCost.csv to FOCUS and saves it to a FOCUS.csv file.

    .LINK
    https://aka.ms/ftk/ConvertTo-FinOpsSchema
#>
function ConvertTo-FinOpsSchema {
    [CmdletBinding()]
    param(
        [array]
        $ActualCost,

        [array]
        $AmortizedCost
    )

    # Validate we have both input files
    $hasActual = $ActualCost -is [array] -and $ActualCost.Count -gt 0
    $hasAmortized = $AmortizedCost -is [array] -and $AmortizedCost.Count -gt 0
    if (-not $hasActual -and -not $hasAmortized) {
        Write-Error "ActualCost and AmortizedCost are empty. Nothing to convert."
        return @()
    } elseif (-not $hasActual) {
        Write-Warning "ActualCost was not specified. Results will not include commitment purchases."
    } elseif (-not $hasAmortized) {
        Write-Warning "AmortizedCost was not specified. Results will not include amortized costs for purchased commitments."
    }

    # Start measuring progress
    $start = [DateTime]::Now
    $rowCount = $ActualCost.Count + $AmortizedCost.Count
    $processedCount = 0
    $estimatedSecPerRow = 0.01  # Estimated time to process a single row of data based on local testing

    # TODO: Consider adding validation to ensure the files are consistent (same on-demand usage, same non-commitment purcahses, no commitment purchases in amortized, etc.)
    
    # TODO: Add SchemaVersion
    # TODO: Warn if schema version is not supported (option to continue anyway?)

    # Loop thru each dataset -- Amortized first since that takes longer because most of actual will be filtered out
    $response = @(
        @{ DataSet = 'AmortizedCost'; Data = $AmortizedCost },
        @{ DataSet = 'ActualCost'; Data = $ActualCost }
    ) | ForEach-Object {
        $dataSet = $_.DataSet
        $data = $_.Data
        
        # Need to determien the default dataset to pull costs from so we don't get duplicate rows
        # Amortized cost is the default unless not provided, then fall back to the actual cost dataset
        $isDefaultDataset = $dataSet -eq 'AmortizedCost' -or -not $hasAmortized
        
        $data | ForEach-Object { 
            New-FinOpsSchemaRow `
                -DataSet $dataSet `
                -IsDefault:$isDefaultDataSet `
                -Row $_
                
            # Time Estimation Logic.
            # If we have processed less than 10 rows, we will use an estimated seconds per row based on testing.
            # This is to avoid a divide by zero error. After 10 rows, we will use the average time per row.
            $percent = [Math]::Min([Math]::Round((++$processedCount / $rowCount) * 100, 1), 100)
            # $secPerRow is the average processing time per row.
            $secPerRow = if ($processedCount -lt 10) { $estimatedSecPerRow } else { ([DateTime]::Now - $start).TotalSeconds / $processedCount }
            # $remaining is the estimated remaining time for the processing of the rest of the data based on that average.
            $remaining = $secPerRow * ($rowCount - $processedCount)
        
            # Number Formatting.
            # We want to format the numbers to be more readable. 
            # We will use the current culture to determine the appropriate formatting.
            $formattedProcessedCount = $processedCount.ToString('N0', [System.Globalization.CultureInfo]::CurrentCulture)
            $formattedRowCount = $rowCount.ToString('N0', [System.Globalization.CultureInfo]::CurrentCulture)
        
            Write-Progress -Activity "Converting to FOCUS" `
                -Status "$percent% complete - $formattedProcessedCount of $formattedRowCount" `
                -PercentComplete $percent `
                -SecondsRemaining $remaining
        }
    }

    Write-Progress -Activity "Converting to FOCUS" -Completed
    return $response
}

function New-FinOpsSchemaRow {
    param(
        [ValidateSet('ActualCost', 'AmortizedCost')]
        [string]
        $DataSet,

        [switch]
        $IsDefault,

        [PSCustomObject]
        $Row
    )

    function Select-First([array]$List) {
        return $List | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -First 1
    }

    # Determine what type of cost this is
    $isCommitment = (
        @('microsoft.billingbenefits', 'microsoft.capacity') -contains $Row.ConsumedService.ToLower() `
            -or @('Reservation', 'SavingsPlan') -contains $Row.PricingModel `
            -or $Row.ReservationId `
            -or $Row.BenefitId `
    )
    $isCommitmentPurchase = $isCommitment -and $Row.ChargeType -eq 'Purchase'
    $isCommitmentUsage = $isCommitment `
        -and @('Usage', 'UnusedReservation', 'UnusedSavingsPlan') -contains $Row.ChargeType `
        -and ((Select-First @($Row.Cost, $Row.CostInBillingCurrency, $Row.PreTaxCost)) -as [double]) -gt 0.0
    $isActualCost = -not $isCommitmentUsage
    $isAmortizedCost = -not $isCommitmentPurchase

    # Write error if dataset doesn't match data
    if ($DataSet -eq 'ActualCost' -and $isCommitmentUsage -and -not $script:foundCommitmentUsage) {
        $script:foundCommitmentUsage = $true
        Write-Error "Commitment usage found in actual cost data. Your cost may not be accurate. Please verify you specified the datasets correctly."
    } elseif ($DataSet -eq 'AmortizedCost' -and $isCommitmentPurchase -and -not $script:foundCommitmentPurchase) {
        $script:foundCommitmentPurchase = $true
        Write-Error "Commitment purchase found in amortized cost data. Your cost may not be accurate. Please verify you specified the datasets correctly."
    }

    # Only convert rows non-commitment purchase records from the default dataset
    if (-not $IsDefault -and -not $isCommitmentPurchase) {
        return $null
    }
    
    # TODO: Move outside the loop
    $accountType = Get-AccountType $Row    
    $schemaVersion = "$($accountType)_2023-10-preview"
    
    $resourceInfo = Split-AzureResourceId ($Row.ResourceId ?? $Row.InstanceName)
    $regionInfo = Get-FinOpsSchemaRegion -ResourceLocation ($Row.ResourceLocation ?? $Row.Location ?? $Row.ResourceLocationNormalized ?? $Row.MeterRegion)
    $serviceInfo = Get-FinOpsSchemaService `
        -ConsumedService $Row.ConsumedService `
        -ResourceId $Row.ResourceId `
        -MeterCategory $Row.MeterCategory `
        -ProductName $Row.ProductName `
        -PublisherId $Row.PublisherId `
        -PublisherName $Row.PublisherName `
        -PublisherType $Row.PublisherType
    $unitInfo = Get-FinOpsSchemaUnits -UnitOfMeasure $Row.UnitOfMeasure    

    # Create a new object with the mapped column names
    # This will ensure that the output CSV has the correct column names
    # If exporting all columns, we will use the columnnames mapped here.
    return [PSCustomObject]@{
        AmortizedCost                  = -not $isAmortizedCost ? 0.0 : (Select-First @($Row.Cost, $Row.CostInBillingCurrency, $Row.PreTaxCost)) -as [double]
        AvailabilityZone               = $Row.AvailabilityZone
        BilledCost                     = -not $isActualCost ? 0.0 : (Select-First @($Row.Cost, $Row.CostInBillingCurrency, $Row.PreTaxCost)) -as [double]
        BillingAccountId               = if ($accountType -eq 'EA') { "/providers/Microsoft.Billing/billingAccounts/$($Row.BillingAccountId)" } elseif ($accountType -eq 'MCA') { "/providers/Microsoft.Billing/billingAccounts/$($Row.BillingAccountId)/billingProfiles/$($Row.BillingProfileId)" } else { "/subscriptions/$($Row.SubAccountId)" }
        BillingAccountName             = $Row.BillingAccountName ?? $Row.SubscriptionName
        BillingCurrency                = $Row.BillingCurrency ?? $Row.BillingCurrencyCode ?? $Row.Currency
        BillingPeriodEnd               = (Parse-Date $Row.BillingPeriodEndDate -EndDate)
        BillingPeriodStart             = (Parse-Date $Row.BillingPeriodStartDate)
        ChargePeriodEnd                = (Parse-Date ($Row.Date ?? $Row.UsageDate) -EndDate)
        ChargePeriodStart              = (Parse-Date ($Row.Date ?? $Row.UsageDate))
        ChargeType                     = if ($Row.ChargeType.StartsWith('Unused')) { 'Usage' } elseif (@('Usage', 'Purchase') -contains $Row.ChargeType) { $Row.ChargeType } else { 'Adjustment' }
        InvoiceIssuerName              = $Row.PartnerName ?? 'Microsoft'
        ServiceCategory                = $serviceInfo.ServiceCategory
        ServiceName                    = $serviceInfo.ServiceName
        ProviderName                   = $serviceInfo.ProviderName
        PublisherName                  = $serviceInfo.PublisherName
        Region                         = $regionInfo.RegionName
        ResourceId                     = $resourceInfo.ResourceId
        ResourceName                   = $resourceInfo.Name
        SubAccountId                   = "/subscriptions/$($Row.SubscriptionId ?? $Row.SubscriptionGuid)"
        SubAccountName                 = $Row.SubscriptionName
        
        ftk_AccountName                = $Row.AccountName
        ftk_AccountOwnerId             = $Row.AccountOwnerId
        ftk_AccountType                = $accountType
        # TODO: Add an -ExpandJSON parameter to expand objects so we don't break CSV output by default
        ftk_AdditionalInfo             = $Row.AdditionalInfo
        ftk_AmortizedCostInUsd         = -not $isAmortizedCost ? 0.0 : $Row.CostInUsd -as [double]
        ftk_AmortizedPricingCost       = -not $isAmortizedCost ? 0.0 : $Row.CostInPricingCurrency -as [double]
        ftk_BilledCostInUsd            = -not $isActualCost ? 0.0 : $Row.CostInUsd -as [double]
        ftk_BilledPricingCost          = -not $isActualCost ? 0.0 : $Row.CostInPricingCurrency -as [double]
        ftk_BillingAccountId           = $Row.BillingAccountId
        ftk_BillingAccountName         = $Row.BillingAccountName
        ftk_BillingAccountResourceType = if ($accountType -eq 'EA') { 'Microsoft.Billing/billingAccounts' } elseif ($accountType -eq 'MCA') { 'Microsoft.Billing/billingAccounts/billingProfiles' } else { 'Microsoft.Resources/subscriptions' }
        ftk_BillingAccountType         = if ($accountType -eq 'EA') { 'Billing Account' } elseif ($accountType -eq 'MCA') { 'Billing Profile' } else { 'Subscription' }
        ftk_BillingExchangeRate        = (Select-First @($original.ExchangeRate, $Row.ExchangeRatePricingToBilling, 1)) -as [double]
        ftk_BillingExchangeRateDate    = Parse-Date -Date (Select-First @($Row.ExchangeRateDate, $Row.BillingPeriodStartDate, $Row.Date, $Row.UsageDate)) -StartOfMonth
        ftk_BillingProfileId           = $Row.BillingProfileId
        ftk_BillingProfileName         = $Row.BillingProfileName
        ftk_ChargeId                   = $null
        ftk_ChargeType                 = $Row.ChargeType
        ftk_CommitmentDiscountId       = $Row.BenefitId
        ftk_CommitmentDiscountName     = $Row.BenefitName
        ftk_CommitmentDiscountProgram  = if (-not $Row.BenefitId) { $null } elseif ($Row.BenefitId.ToLower() -contains "/microsoft.capacity/reservation") { "Reservation" } elseif ($Row.BenefitId.ToLower() -contains "microsoft.billingbenefits/savingsplan") { "Savings Plan" } else { $null }
        ftk_CostAllocationRuleName     = $Row.CostAllocationRuleName
        ftk_CostCenter                 = $Row.CostCenter
        ftk_CustomerName               = $Row.CustomerName
        ftk_CustomerId                 = $Row.CustomerTenantId
        ftk_DataSet                    = $DataSet
        ftk_EffectivePrice             = $Row.EffectivePrice
        ftk_Frequency                  = $Row.Frequency
        ftk_InvoiceId                  = $Row.InvoiceId
        ftk_InvoiceIssuerId            = $Row.PartnerTenantId
        ftk_InvoiceSectionId           = $Row.InvoiceSectionId
        ftk_InvoiceSectionName         = $Row.InvoiceSectionName
        ftk_IsCreditEligible           = $Row.IsAzureCreditEligible
        ftk_ListCost                   = $Row.PayGPrice * $Row.Quantity
        ftk_ListCostInUsd              = $Row.PayGPriceUSD * $Row.Quantity
        ftk_ListPricingCost            = $Row.PayGPrice * $Row.Quantity
        ftk_ListPrice                  = $Row.PayGPrice
        ftk_MeterCategory              = $Row.MeterCategory
        ftk_MeterId                    = $Row.MeterId
        ftk_MeterName                  = $Row.MeterName
        ftk_MeterRegion                = $Row.MeterRegion
        ftk_MeterSubCategory           = $Row.MeterSubCategory
        ftk_OfferId                    = $Row.OfferId
        ftk_PartNumber                 = $Row.PartNumber
        ftk_PartnerCreditApplied       = $Row.PartnerEarnedCreditApplied
        ftk_PartnerCreditRate          = $Row.PartnerEarnedCreditRate
        ftk_PlanName                   = $Row.PlanName
        ftk_PreviousInvoiceId          = $Row.PreviousInvoiceId
        ftk_PricingCurrency            = $Row.PricingCurrency ?? $Row.BillingCurrency
        ftk_PricingModel               = $Row.PricingModel
        ftk_PricingBlockSize           = $unitInfo.PricingBlockSize
        ftk_PricingQuantity            = $Row.Quantity * $unitInfo.PricingBlockSize
        ftk_PricingUnit                = $unitInfo.PricingUnit
        ftk_ProductId                  = $Row.ProductId
        ftk_ProductName                = $Row.ProductName
        ftk_ProductOrderId             = $Row.ProductOrderId
        ftk_ProductOrderName           = $Row.ProductOrderName
        ftk_Provider                   = $Row.Provider
        ftk_PublisherId                = $serviceInfo.PublisherId
        ftk_PublisherType              = $serviceInfo.PublisherType
        ftk_ResourceGroupId            = $resourceInfo.ResourceGroupId
        ftk_ResourceGroupName          = $resourceInfo.ResourceGroupName
        ftk_ResellerId                 = $Row.ResellerMpnId
        ftk_ResellerName               = $Row.ResellerName
        ftk_ResourceType               = $resourceInfo.ResourceType
        ftk_SchemaVersion              = $schemaVersion
        ftk_ServiceFamily              = $Row.ServiceFamily
        # TODO: Add an -ExpandJSON parameter to expand objects so we don't break CSV output by default
        ftk_Tags                       = if (-not $Row.Tags) { "{}" } elseif ($Row.Tags.StartsWith("{")) { $Row.Tags } else { "{$($Row.Tags)}" }
        ftk_Term                       = $Row.Term
        ftk_UsageQuantity              = $Row.Quantity ?? $Row.UsageQuantity
        ftk_UsageUnit                  = $unitInfo.DistinctUnits
    }
}

function Get-AccountType {
    [CmdletBinding()]
    param(
        [PSCustomObject]
        $Row
    )

    $ftk_AccountType = switch ($true) {
        { $Row.BillingAccountId -eq $Row.BillingProfileId } { "EA" }
        { $Row.BillingAccountId.Contains(":") } { "MCA" }
        default { "Other" }
    }
    
    return $ftk_AccountType
}

# TODO: Make this its own public function
function Get-FinOpsSchemaRegion([string]$ResourceLocation) {
    # TODO: Look up from Regions.csv
    return @{
        RegionId   = ($ResourceLocation ?? "").ToLower() -replace " ", ""
        RegionName = $ResourceLocation
    }
}

# TODO: Make this its own public function
function Get-FinOpsSchemaService([string]$ConsumedService, [string]$ResourceId, [string]$MeterCategory, [string]$ProductName, [string]$PublisherId, [string]$PublisherName, [string]$PublisherType) {
    # TODO: Look up from Services.csv
    return @{
        # ServiceType values = Infrastructure, Platform, Software, Other
        ServiceType     = $ConsumedService
        ServiceCategory = $ConsumedService -replace "[Mm]icrosoft\.", ""
        ServiceName     = $ConsumedService -replace "[Mm]icrosoft\.", ""
        PublisherId     = $PublisherId
        PublisherName   = $PublisherName
        # PublisherType values = Cloud Provider, Vendor, Other???
        PublisherType   = ($PublisherType -eq "Marketplace") ? "Vendor" : "Cloud Provider"
        ProviderName    = $PublisherName ?? "Microsoft"
        ProviderType    = "Cloud Provider" # Cloud Provider, Vendor, Other???
    }
}

# TODO: Make this its own public function
function Get-FinOpsSchemaUnits([string]$UnitOfMeasure) {
    # TODO: Look up from PricingUnits.csv
    return @{
        DistinctUnit     = $UnitOfMeasure
        PricingBlockSize = 1
        PricingUnit      = $UnitOfMeasure
    }
}

function Parse-Date([string]$Date, [switch]$EndDate, [switch]$StartOfMonth) {
    try {
        $parsedDate = [datetime]::ParseExact($Date, "MM/dd/yyyy", [System.Globalization.CultureInfo]::InvariantCulture).ToUniversalTime().Date
        return ($EndDate `
                ? $parsedDate.AddDays(1) `
                : ($StartOfMonth `
                    ? (Get-Date $parsedDate -Day 1) `
                    : $parsedDate `
            ) `
        )
    } catch {
        return $null
    }
}
