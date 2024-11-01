---
title: EA template app
description: Learn about the Cost Management template app for Enterprise Agreement accounts, including its features, usage insights, and available reports.
author: bandersmsft
ms.author: banders
ms.date: 10/10/2024
ms.topic: concept-article
ms.service: finops
ms.reviewer: micflan
#customer intent: As a FinOps user, I want to learn about the Cost Management template app so that I can determine if should use it.
---

<!-- markdownlint-disable-next-line MD025 -->
# Cost Management template app for Enterprise Agreement accounts

The **EA template app** is the PBIX version of the "Cost Management app" in Microsoft AppSource. The template app isn't customizable or downloadable, so we're making the PBIX file available here. We don't recommend using this report as it only works for Enterprise Agreement billing accounts and is no longer being updated. You're welcome to download and customize it as needed. However, you might want to check out the other [FinOps toolkit reports](reports.md), which were updated to cover new scenarios. The [Cost summary](cost-summary.md) and [Rate optimization](rate-optimization.md) reports were both created based on the template app, so you should find most capabilities within those reports. If you feel something is missing, [let us know](https://aka.ms/ftk/ideas)!

<br>

## About the Cost Management app

Using the Cost Management template app for Power BI, you can import and analyze your Azure cost and usage data within Power BI. The reports provided allow you to gain insights into which subscriptions or resource groups are consuming the most and visibility into spending trends and overall usage.

Included reports:

- Account overview
- Usage by subscriptions and resource groups
- Top 5 usage drivers
- Usage by services
- Windows Server AHB usage
- VM reservation coverage (shared recommendation)
- VM reservation coverage (single recommendation)
- Reservation savings
- Reservation chargeback
- Reservation purchases
- Price sheet

For more information, see [Analyze cost with the Cost Management Power BI app for Enterprise Agreements (EA)](/azure/cost-management-billing/costs/analyze-cost-data-azure-cost-management-power-bi-template-app).

<br>

## What's changed

In general, we don't plan to make changes to the template app. The following minor updates were made to resolve bugs:

- Added `Tags` and `TagsAsJson` columns to both the **Usage details** and **Usage details amortized** tables.

<br>

## Looking for more?

We'd love to hear about any reports, charts, or general reporting questions you're looking to answer. Create a new issue with the details that you'd like to see either included in existing or new reports.

[Share feedback](https://aka.ms/ftk/ideas)

<br>

## Related content

Related FinOps capabilities:

- [Reporting and analytics](../../framework/understand/reporting.md)

Related products:

- [Cost Management](/azure/cost-management-billing/costs/)
- [Azure Resource Graph](/azure/governance/resource-graph/)
- [Azure Monitor](/azure/azure-monitor/)

Related solutions:

- [FinOps hubs](../hubs/finops-hubs-overview.md)
- [FinOps workbooks](../workbooks/finops-workbooks-overview.md)
- [FinOps toolkit open data](../open-data.md)

<br>