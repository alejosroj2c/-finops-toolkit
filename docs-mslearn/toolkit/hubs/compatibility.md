---
title: Compatibility guide
description: Learn about which versions of Power BI reports work with each version of FinOps hubs.
author: bandersmsft
ms.author: banders
ms.date: 10/03/2024
ms.topic: concept-article
ms.service: finops
ms.reviewer: micflan
---

<!-- markdownlint-disable-next-line MD025 -->
# FinOps hubs compatibility guide

FinOps hubs supports in-place upgrades by simply redeploying the template. But what happens with the data? Will that break Power BI reports? What about my customized reports? This guide will help you identify what dependencies need to change when moving from one version of FinOps hubs to another. If you have any questions, please [start a discussion](https://aka.ms/ftk/discuss).

<br>

## Versioning in the FinOps toolkit

All FinOps toolkit tools and resources maintain the same version number. We do this to make it easier to know which tools work well together. As of today, this is mostly about FinOps hubs, but will expand as more tools are added in the future. If you can, we recommend updating all resources at the same time. However, we know this isn't always feasible. This guide will seek to help you understand what you can expect when you upgrade some but not all tools.

<br>

## Compatibility chart

The following table conveys different scenarios with specific types of Cost Management exports and FinOps hubs releases. Based on the combination you have (or plan to have), make note of the storage path and the Power BI version.

Storage path is important for any client that is utilizing the same datasets. This may be toolkit Power BI reports (covered by the Power BI version), Microsoft Fabric shortcuts, or other tools.

The Power BI version refers to the Power BI reports made available within that specific version of the FinOps toolkit. If you customized an older version of those reports, please make note of the version you started with, as that is what will be useful here.

| Cost Management exports                   | FinOps hubs | Storage path                    | Power BI      | Notes                                                                                                                                    |
| ----------------------------------------- | ----------- | ------------------------------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| FOCUS costs, Prices, Reservation datasets | 0.6         | {dataset}/{yyyy}/{MM}/{scope}   | 0.6+          | Reservation recommendations pulled from hub storage                                                                                      |
| FOCUS 1.0-preview(v1) or 1.0 costs        | 0.6         | {dataset}/{yyyy}/{MM}/{scope} ⚠️ | 0.6+ ⛓️‍💥       | Storage path updated; Reservation recommendations pulled from a separate, non-hub storage URL (or excluded from report)                  |
| FOCUS 1.0-preview(v1) or 1.0 costs        | 0.5         | {scope}/{yyyyMM}/{dataset}      | 0.4+ ⛓️‍💥       | Reservation recommendations pulled from a separate, non-hub storage URL (or excluded from report)                                        |
| FOCUS 1.0-preview(v1) or 1.0 costs        | 0.4         | {scope}/{yyyyMM}/{dataset}      | 0.4+ ⛓️‍💥       | Supports a mix of FOCUS 1.0 and 1.0-preview(v1) data; Reservation recommendations pulled from the Cost Management connector for Power BI |
| FOCUS 1.0-preview(v1) only                | 0.4         | {scope}/{yyyyMM}/{dataset} ⚠️    | 0.2+          | Storage path updated                                                                                                                     |
| FOCUS 1.0-preview(v1) costs only          | 0.2 - 0.3   | {path}/{yyyyMM}/{dataset}       | 0.2+ ⛓️‍💥       | Switched to FOCUS data only                                                                                                              |
| Actual or Amortized costs (not both)      | 0.1 - 0.1.1 | {path}/{yyyyMM}/{dataset}       | 0.0.1 - 0.1.1 | EA and MCA                                                                                                                               |
| Actual or Amortized costs (not both)      | 0.0.1       | {path}/{yyyyMM}/{dataset}       | 0.0.1 - 0.1.1 | EA only                                                                                                                                  |

<sup>⚠️ - When storage paths update, there is a risk that re-exported data will land in a new place and may cause duplicate data. To resolve, remove the old folders in the **ingestion** container.</sup><br>
<sup>⛓️‍💥 - Older Power BI reports will not work with this combination of FinOps hubs version and exported datasets.</sup><br>

<br>

## Looking for more?

Did this guide give you the answers you needed? If not, ask a question or share feedback to let us know how we can improve it. We're here to help!

[Ask a question](https://aka.ms/ftk/discuss) &nbsp; [Share feedback](https://aka.ms/ftk/idea)

<br>

## ⏭️ Next steps

- [Review the upgrade guide](./upgrade.md)
- [Deploy the latest release](./finops-hubs-overview.md#create-a-new-hub)

<br>
