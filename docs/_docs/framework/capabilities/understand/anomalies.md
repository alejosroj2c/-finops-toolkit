---
layout: default
parent: Understand
title: Anomalies
permalink: /framework/capabilities/understand/anomalies
nav_order: 4
description: This article helps you understand the managing anomalies capability within the FinOps Framework and how to implement that in the Microsoft Cloud.
author: bandersmsft
---

<!--
ms.author: banders
ms.date: 06/22/2023
ms.topic: conceptual
ms.service: finops
ms.reviewer: micflan
-->

<span class="fs-9 d-block mb-4">Managing anomalies</span>
This article helps you understand the managing anomalies capability within the FinOps Framework and how to implement that in the Microsoft Cloud.
{: .fs-6 .fw-300 }

<details open markdown="1">
    <summary class="fs-2 text-uppercase">On this page</summary>

- [Getting started](#getting-started)
- [Building on the basics](#building-on-the-basics)
- [Learn more at the FinOps Foundation](#learn-more-at-the-finops-foundation)
- [Next steps](#next-steps)

</details>

---

<a name="definition"></a>
**Managing anomalies refers to the practice of detecting and addressing abnormal or unexpected cost and usage patterns in a timely manner.**
{: .fs-6 .fw-300 }

Use automated tools to detect anomalies and notify stakeholders. Review usage trends periodically to reveal anomalies automated tools may have missed.

Investigate changes in application behaviors, resource utilization, and resource configuration to uncover the root cause of the anomaly.

With a systematic approach to anomaly detection, analysis, and resolution, organizations can minimize unexpected costs that impact budgets and business operations. And, they can even identify and prevent security and reliability incidents that can surface in cost data.

<br>

## Getting started

When you first start managing cost in the cloud, you use the native tools available in the portal.

- Start with proactive alerts.
  - [Subscribe to anomaly alerts](https://learn.microsoft.com/azure/cost-management-billing/understand/analyze-unexpected-charges.md#create-an-anomaly-alert) for each subscription in your environment to receive email alerts when an unusual spike or drop has been detected in your normalized usage based on historical usage.
  - Consider [subscribing to scheduled alerts](https://learn.microsoft.com/azure/cost-management-billing/costs/save-share-views.md#subscribe-to-scheduled-alerts) to share a chart of the recent cost trends with stakeholders. It can help you drive awareness as costs change over time and potentially catch changes the anomaly model may have missed.
  - Consider [creating a budget in Cost Management](https://learn.microsoft.com/azure/cost-management-billing/costs/tutorial-acm-create-budgets.md) to track that specific scope or workload. Specify filters and set alerts for both actual and forecast costs for finer-grained targeting.
- Review costs periodically, using detailed cost breakdowns, usage analytics, and visualizations to identify potential anomalies that may have been missed.
  - Use smart views in Cost analysis to [review anomaly insights](https://learn.microsoft.com/azure/cost-management-billing/understand/analyze-unexpected-charges.md#identify-cost-anomalies) that were automatically detected for each subscription.
  - Use customizable views in Cost analysis to [manually find unexpected changes](https://learn.microsoft.com/azure/cost-management-billing/understand/analyze-unexpected-charges.md#manually-find-unexpected-cost-changes).
  - Consider [saving custom views](https://learn.microsoft.com/azure/cost-management-billing/costs/save-share-views.md) that show cost over time for specific workloads to save time.
  - Consider creating more detailed usage reports using [Power BI](../../../../_reporting/power-bi/README.md).
- Once an anomaly is identified, take appropriate actions to address it.
  - Review the anomaly details with the engineers who manage the related cloud resources. Some auto-detected "anomalies" are planned or at least known resource configuration changes as part of building and managing cloud services.
  - If you need lower-level usage details, review resource utilization in [Azure Monitor metrics](https://learn.microsoft.com/azure/azure-monitor/essentials/metrics-getting-started.md).
  - If you need resource details, review [resource configuration changes in Azure Resource Graph](https://learn.microsoft.com/azure/governance/resource-graph/how-to/get-resource-changes.md).

<br>

## Building on the basics

At this point, you have automated alerts configured and ideally views and reports saved to streamline periodic checks.

- Establish and automate KPIs, such as:
  - Number of anomalies each month or quarter.
  - Total cost impact of anomalies each month or quarter
  - Response time to detect and resolve anomalies.
  - Number of false positives and false negatives.
- Expand coverage of your anomaly detection and response process to include all costs.
- Define, document, and automate workflows to guide the response process when anomalies are detected.
- Foster a culture of continuous learning, innovation, and collaboration.
  - Regularly review and refine anomaly management processes based on feedback, industry best practices, and emerging technologies.
  - Promote knowledge sharing and cross-functional collaboration to drive continuous improvement in anomaly detection and response capabilities.

<br>

## Learn more at the FinOps Foundation

This capability is a part of the FinOps Framework by the FinOps Foundation, a non-profit organization dedicated to advancing cloud cost management and optimization. For more information about FinOps, including useful playbooks, training and certification programs, and more, see the [Managing anomalies capability](https://www.finops.org/framework/capabilities/manage-anomalies/) article in the FinOps Framework documentation.

<br>

## Next steps

- [Budget management](../quantify/budgeting.md)

<br>