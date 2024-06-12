---
title: Managing commitment-based discounts
description: This article helps you understand the managing commitment-based discounts capability within the FinOps Framework and how to implement that in the Microsoft Cloud.
author: bandersmsft
ms.author: banders
ms.date: 06/12/2024
ms.topic: concept-article
ms.service: finops
ms.reviewer: micflan
# customer intent: As a FinOps practitioner, I want to understand the managing commitment-based discounts capability so that I can implement it in the Microsoft Cloud.
---

<!-- markdownlint-disable-next-line MD025 -->
# Managing commitment-based discounts

This article helps you understand the managing commitment-based discounts capability within the FinOps Framework and how to implement that in the Microsoft Cloud.

<br>

## Definition

**Managing commitment-based discounts is the practice of obtaining reduced rates on cloud services by committing to a certain level of usage or spend over a specific period.**

Review daily usage and cost trends to estimate how much you expect to use or spend over the next one to five years. Use [Forecasting](../quantify/forecasting.md) and account for future plans.

Commit to specific hourly usage targets to receive discounted rates and save up to 72% with [Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations.md). Or for more flexibility, commit to a specific hourly spend to save up to 65% with [Azure savings plans for compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview.md). Reservation discounts can be applied to resources of the specific type, SKU, and location only. Savings plan discounts are applied to a family of compute resources across types, SKUs, and locations. The extra specificity with reservations is what drives more favorable discounting.

Adopting a commitment-based strategy allows organizations to reduce their overall cloud costs while maintaining the same or higher usage by taking advantage of discounts on the resources they already use.

<br>

## Before you begin

While you can save by using reservations and savings plans, there's also a risk that you might not end up using that capacity. You could end up under-utilizing the commitment and lose money. While losing money is rare, it's possible. We recommend starting small and making targeted, high-confidence decisions. We also recommend not waiting too long to decide on how to approach commitment-based discounts when you do have consistent usage because you're effectively losing money. Start small and learn as you go. But first, learn how [reservation](/azure/cost-management-billing/reservations/reservation-discount-application.md) and [savings plan](/azure/cost-management-billing/savings-plan/discount-application.md) discounts are applied.

Consider the usage you want to commit to before you purchase either a reservation or a savings plan. If you have high confidence, you maintain a specific level of usage for that type, SKU, and location, strongly consider starting with a reservation. For maximum flexibility, you can use savings plans to cover a wide range of compute costs by committing to a specific hourly spend instead of hourly usage.

<br>

## Getting started

Microsoft offers several tools to help you identify when you should consider purchasing reservations or savings plans. You can choose whether you want to start by analyzing usage or by reviewing the system-generated recommendations based on your historical usage and cost. We recommend starting with the recommendations to focus your initial efforts:

- One of the most common starting points is [Azure Advisor cost recommendations](/azure/advisor/advisor-reference-cost-recommendations.md).
- For more flexibility, you can view and filter recommendations in the [reservation](/azure/cost-management-billing/reservations/reserved-instance-purchase-recommendations.md) and [savings plan](/azure/cost-management-billing/savings-plan/purchase-recommendations#purchase-recommendations-in-the-azure-portal.md) purchase experiences.
- Lastly, you can also view reservation recommendations in [Power BI](/power-bi/connect-data/desktop-connect-azure-cost-management).
- After you know what to look for, you can [analyze your usage data](/azure/cost-management-billing/reservations/determine-reservation-purchase#analyze-usage-data.md) to look for the specific usage you want to purchase a reservation for.

After purchasing commitments, you can:

- View utilization from the [reservation](/azure/cost-management-billing/reservations/reservation-utilization.md) or [savings plan](/azure/cost-management-billing/savings-plan/view-utilization.md) page in the portal.
  - Consider expanding the scope or enabling instance size flexibility (when available) to increase utilization and maximize savings of an existing commitment.
  - [Configure reservation utilization alerts](/azure/cost-management-billing/costs/reservation-utilization-alerts.md) to notify stakeholders if utilization drops below a desired threshold.
- View showback and chargeback reports for [reservations](/azure/cost-management-billing/reservations/charge-back-usage.md) and [savings plans](/azure/cost-management-billing/savings-plan/charge-back-costs.md).

<br>

## Building on the basics

You have commitment-based discounts in place at this point. As you move beyond the basics, consider the following points:

- Configure commitments to automatically renew for [reservations](/azure/cost-management-billing/reservations/reservation-renew.md) and [savings plans](/azure/cost-management-billing/savings-plan/renew-savings-plan.md).
- Calculate cost savings for [reservations](/azure/cost-management-billing/reservations/calculate-ea-reservations-savings.md) and [savings plans](/azure/cost-management-billing/savings-plan/calculate-ea-savings-plan-savings.md).
- If you use multiple accounts, clouds, or providers, expand coverage of your commitment-based discounts efforts to include all accounts.
  - Consider implementing a consistent utilization and coverage monitoring system that covers all accounts.
- Establish a process for centralized purchasing of commitment-based offers, assigning responsibility to a dedicated team or individual.
- Consider programmatically aligning governance policies with commitments to prioritize SKUs and locations that are covered by reservations and aren't fully utilized when deploying new applications.

<br>

## Learn more at the FinOps Foundation

This capability is a part of the FinOps Framework by the FinOps Foundation, a non-profit organization dedicated to advancing cloud cost management and optimization. For more information about FinOps, including useful playbooks, training and certification programs, and more, see the [Managing commitment-based discounts capability](https://www.finops.org/framework/capabilities/manage-commitment-based-discounts/) article in the FinOps Framework documentation.

You can also find related videos on the FinOps Foundation YouTube channel:

> [!VIDEO https://www.youtube.com/embed/CR6D5DlPwtm7Bbdr?list=PLUSCToibAswm37b7-VLl3nJ7A4wuGSpCI]

<br>

## Related content

Related FinOps capabilities:

- [Data analysis and showback](../understand/reporting.md)
- [Cloud policy and governance](../manage/policy.md)

Related products:

- [Azure Advisor](/azure/advisor/)
- [Cost Management](/azure/cost-management-billing/costs/)
- [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator)
- [Azure Monitor](/azure/azure-monitor/)

Related solutions:

- [Cost Management connector for Power BI](/power-bi/connect-data/desktop-connect-azure-cost-management)
- [FinOps toolkit Power BI reports](https://aka.ms/ftk/pbi)
- [Cost optimization workbook](../../toolkit/optimization-workbook/cost-optimization-workbook.md)
- [FinOps hubs](https://aka.ms/finops/hubs)

Other resources:

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/)
- [Well-Architected Framework](/azure/well-architected/)
- [Azure pricing](https://azure.microsoft.com/pricing#product-pricing)

<br>
