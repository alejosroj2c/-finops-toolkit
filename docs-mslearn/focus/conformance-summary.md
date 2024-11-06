---
title: FOCUS conformance summary
description: Summary of FOCUS conformance gaps in the Microsoft Cost Management FOCUS dataset with applicable workarounds.
author: bandersmsft
ms.author: banders
ms.date: 10/31/2024
ms.topic: reference
ms.service: finops
ms.reviewer: micflan
---

<!-- markdownlint-disable-next-line MD025 -->
# FOCUS conformance summary

This document summarizes the known conformance gaps for the latest FOCUS 1.0 dataset in Microsoft Cost Management compared to the FOCUS 1.0 specification. To learn more about FOCUS, refer to the [FOCUS overview](./what-is-focus.md).

<br>

## Overall conformance

The Microsoft Cost Management FOCUS 1.0 dataset has a conformance score of **96%**.

The remaining conformance gaps are summarized in the following sections. For details on these or other FOCUS requirements, refer to the [full conformance report](./conformance-full-report.md). The IDs provided in the tables are for reference purposes only. IDs aren't defined as part of FOCUS.

<br>

## Missing data

| Issue                                                                                                                                                                                                                   | Workaround                                    | Columns / Requirements                                                 |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- | ---------------------------------------------------------------------- |
| `ContractedUnitPrice` and `ContractedCost` are 0 for Enterprise Agreement (EA) Marketplace charges, EA reservation usage when cost allocation is enabled, and all Microsoft Customer Agreement (MCA) reservation usage. | Join with price sheet dataset.                | ContractedCost, ContractedUnitPrice<br>DH2.4.2, NH1-3, CnC1.2, CnUP3.1 |
| `ListCost` isn't supported and is 0 for EA or MCA Marketplace charges, EA or MCA reservation usage.                                                                                                                     | Join with price sheet dataset.                | ListCost, ListUnitPrice<br>DH2.4.2, NH1-3, LC1.2, LUP3.1               |
| `SkuId` is null when a charge doesn't have a corresponding price in the price sheet, like savings plan unused charges and Marketplace charges.                                                                          | No action needed.                             | SkuId<br>SkI3.1                                                        |
| `ChargeDescription` is null for savings plan unused charges and charges that aren't directly associated with a product SKU.                                                                                             | Replace with computed alternative as desired. | ChargeDescription<br>CD3                                               |
| `PublisherName` is null for reservation usage, reservation purchases, and savings plan unused charges.                                                                                                                  | Replace null with "Microsoft".                | PublisherName<br>PbN2.2                                                |
| `AvailabilityZone` isn't available in cost datasets and the column isn't included in the dataset.                                                                                                                       | Join with resource details.                   | AvailabilityZone<br>AZ1                                                |

<br>

## Incorrect data

| Issue                                                                                                        | Workaround                                                                                                                                                         | Columns / Requirements                                                                                                                                      |
| ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Date columns all follow the ISO 8601 standard, but don't include seconds (for example, "2024-01-01T00:00Z"). | Replace "T00:00Z" with "T00:00:00Z". Don'o't add ":00" without confirming seconds aren't present. Seconds will be included in a new FOCUS "1.0r2" dataset version. | BillingPeriodStart, BillingPeriodEnd, ChargePeriodStart, ChargePeriodEnd, x_BillingExchangeRateDate, x_ServicePeriodEnd, x_ServicePeriodStart<br>DTF5       |
| Some columns can be "-2" or "Unassigned" when there's no value.                                              | Replace "-2" and "Unassigned" with null.                                                                                                                           | SkuPriceId, SubAccountName, x_AccountId, x_AccountName, x_AccountOwnerId, x_InvoiceSectionId, x_InvoiceSectionName, x_PricingUnitDescription<br>NH1-3, SAN3 |

<br>

## Inconsistent data

| Issue                                                                                                                  | Workaround                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Columns / Requirements                          |
| ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `SkuPriceId` doesn't identify a single price and doesn't have an equivalent in the price sheet.                        | For EA accounts, join with the price sheet using `x_SkuMeterId`/`MeterId`, `x_SkuOfferId`/`OfferID`, `x_SkuTerm`/`Term`, and `CommitmentDiscountType`/`PriceType`. For MCA accounts, join with the price sheet using `SkuPriceId` and a concatenated "{ProductId}_{SkuId}_{MeterId}" string, `x_SkuTerm`/`Term`, and `CommitmentDiscountType`/`PriceType`. Note MCA accounts also require the tier, which isn't currently available in any cost details dataset. | SkuPriceId<br>SkPI4                             |
| `CommitmentDiscountId` doesn't match `ResourceId` exactly because ResourceId is lowercased to meet FOCUS requirements. | Convert `CommitmentDiscountId` to lowercase if comparing to ResourceId.                                                                                                                                                                                                                                                                                                                                                                                          | CommitmentDiscountId, ResourceId<br>DH3.12, SH2 |
| `ResourceName` may not be in the original case.                                                                        | Lowercase to ensure consistent casing when grouping and file a support request on the service responsible for the resource.                                                                                                                                                                                                                                                                                                                                      | ResourceName<br>SH2                             |

<br>

## Other nonfunctional gaps

| Issue                                                                 | Workaround                                                                                                           | Columns / Requirements                     |
| --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `ChargeDescription` max length isn't documented.                      | Evaluated maximum length as of October 2024 is 355 characters.                                                       | ChargeDescription<br>CD4                   |
| `BillingAccountType` and `SubAccountType` should be prefixed with x_. | Do nothing. These columns are pending closure and inclusion in a future FOCUS version. There's an open pull request. | BillingAccountType, SubAccountType<br>CNO2 |
| `BillingAccountName` isn't guaranteed to be unique.                   | Update billing account/profile name to be unique.                                                                    | BillingAccountName<br>BAN3                 |
| Provider-specified tags aren't prefixed.                              | No action needed.                                                                                                    | Tags<br>T10                                |

<br>

## Related content

Related resources:

- [FOCUS conformance full report](./conformance-full-report.md)
- [Microsoft Cost Management FOCUS dataset](/azure/cost-management-billing/dataset-schema/cost-usage-details-focus)

Related products:

- [Cost Management](/azure/cost-management-billing/costs)

Related solutions:

- [FinOps toolkit Power BI reports](https://aka.ms/ftk/pbi)
- [FinOps hubs](https://aka.ms/finops/hubs)
- [FinOps toolkit PowerShell module](https://aka.ms/ftk/ps)

<br>