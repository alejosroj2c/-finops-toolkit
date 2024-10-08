---
title: Invoicing and chargeback
description: This article helps you understand the invoicing and chargeback capability in the FinOps Framework and how to implement that in the Microsoft Cloud.
author: bandersmsft
ms.author: banders
ms.date: 08/15/2024
ms.service: finops
ms.reviewer: micflan
ms.topic: concept-article
# customer intent: As a FinOps practitioner, I want to understand the invoicing and chargeback capability so that I can implement it in the Microsoft Cloud.
---

<!-- markdownlint-disable-next-line MD025 -->
# Invoicing and chargeback

This article helps you understand the invoicing and chargeback capability within the FinOps Framework and how to implement that in the Microsoft Cloud.

<br>

## Definition

**Invoicing and chargeback refers to the process of receiving, reconciling, and paying provider invoices, and then billing internal teams for their respective cloud costs using existing internal finance tools and processes.**

Plan the chargeback model with IT and Finance departments. Use the organizational cost allocation strategy that factors in how stakeholders agreed to account for shared costs and commitment discounts.

Use existing tools and processes to manage cloud costs as part of organizational finances. Chargeback is represented in the accounting system, [budgets](../quantify/budgeting.md) are managed through the budget system, etc.

invoicing and Chargeback enables increased transparency, more direct accountability for the costs each department incurs, and reduced overhead costs.

<br>

## Before you begin

Chargeback, cost allocation, and showback are all important components of your FinOps practice. While you can implement them in any order, we generally recommend most organizations start with [showback](../understand/reporting.md) to ensure each team has visibility of the charges they're responsible for – at least at a cloud scope level. Then implement [cost allocation](../understand/allocation.md) to align cloud costs to the organizational reporting hierarchies, and lastly implement chargeback based on that cost allocation strategy. Consider reviewing the [Data analysis and showback](../understand/reporting.md) and [Cost allocation](../understand/allocation.md) capabilities if you didn't implement them yet. You might also find the [Rate optimization](../optimize/rates.md) capability to be helpful in implementing a complete chargeback solution that covers commitment discounts.

<br>

## Getting started

Invoicing and chargeback is all about integrating with your own internal tools. Consider the following points:

- To plan and prepare for chargeback, collaborate with stakeholders across finance, business, and technology.
- Document how chargeback works and be prepared for questions.
- Use the organizational [cost allocation](../understand/allocation.md) strategy that factors in how stakeholders agreed to account for [shared costs](../understand/shared-cost.md) and [commitment discounts](../optimize/rates.md).
  - If you didn't establish one, consider simpler chargeback models that are fair and agreed upon by all stakeholders.
- Use existing tools and processes to manage cloud costs as part of organizational finances.

<br>

## Building on the basics

At this point, you have a basic chargeback model that all stakeholders agreed to. As you move beyond the basics, consider the following points:

- Think about setting up a one-way synchronization from your budget system to [Cost Management budgets](/azure/cost-management-billing/automate/automate-budget-creation.md). It  allows you to use automated alerts that are based on machine learning predictions.
- If you track manual forecasts, consider creating Cost Management budgets for your forecast values as well. It gives you separate tracking and alerting for budgets separate from your forecast.
- Automate your [cost allocation](../understand/allocation.md) strategy through tagging.
- Expand coverage of [shared costs](../understand/shared-cost.md) and [commitment discounts](../optimize/rates.md) if not already included.
- Fully integrate chargeback and showback reporting with the organization's finance tools.

<br>

## Learn more at the FinOps Foundation

This capability is a part of the FinOps Framework by the FinOps Foundation, a non-profit organization dedicated to advancing cloud cost management and optimization. For more information about FinOps, including useful playbooks, training and certification programs, and more, see the [invoicing and Chargeback capability](https://www.finops.org/framework/capabilities/invoicing-chargeback/) article in the FinOps Framework documentation.

You can also find related videos on the FinOps Foundation YouTube channel:

> [!VIDEO https://www.youtube.com/embed/SVkS0EjsZS56I1qO?list=PLUSCToibAswkALdvffeZWF-3L4ubFuobD]

<br>

## Related content

Related FinOps capabilities:

- [Reporting and analytics](../understand/reporting.md)
- [Allocation](../understand/allocation.md)
- [Rate optimization](../optimize/rates.md)

Related products:

- [Cost Management](/azure/cost-management-billing/costs/)
- [Billing](/azure/cost-management-billing/manage/)
- [Azure Monitor](/azure/azure-monitor/)
- [Azure Resource Graph](/azure/governance/resource-graph/)

Related solutions:

- [Cost Management connector for Power BI](/power-bi/connect-data/desktop-connect-azure-cost-management)
- [FinOps toolkit Power BI reports](https://aka.ms/ftk/pbi)
- [FinOps hubs](https://aka.ms/finops/hubs)
- [FinOps toolkit PowerShell module](https://aka.ms/ftk/ps)

<br>