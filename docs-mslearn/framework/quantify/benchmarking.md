---
title: Benchmarking
description: This article helps you understand the benchmarking capability within the FinOps Framework and how to implement that in the Microsoft Cloud.
author: bandersmsft
ms.author: banders
ms.date: 08/15/2024
ms.topic: concept-article
ms.service: finops
ms.reviewer: micflan
# customer intent: As a FinOps practitioner, I want to understand the FinOps practice operations capability so that I can implement it in the Microsoft Cloud.
---

<!-- markdownlint-disable-next-line MD025 -->
# FinOps practice operations

This article helps you understand the benchmarking capability within the FinOps Framework and how to implement that in the Microsoft Cloud.

<br>

## Definition

**Benchmarking is a systematic process of evaluating the performance and value of cloud services using efficiency metrics, either within an organization or against industry peers.**

Identify and automate key performance indicators (KPIs) based on organizational priorities. Compare across internal teams and divisions or other companies, when possible, to identify areas to improve and possibly learn from others. Remember that cloud usage is unique to each organization, and there isn't a single "correct" approach when comparing KPIs across teams and organizations.

Leverage benchmarking as a tool to measure performance and progress against organizational goals. Encourage teams to mature and make informed decisions based on available data rather than deferring in anticipation of "better" data. Establish well-defined metrics, maintain transparent communication regarding goals and objectives, ensure precise data collection and effective dashboards, and garner management support to maximize your return on investment from benchmarking efforts.

<br>

## Getting started

When you first start managing cost in the cloud, leverage the existing guidance and recommendations which are based on benchmarks established across all Microsoft Cloud customers:

- Review the [Azure Advisor score](/azure/advisor/azure-advisor-score.md) at the primary scope you manage, whether that's a subscription, resource group, or based on tags.
  - The Advisor score consists of an overall score, which can be further broken down into five category scores. One score for each category of Advisor represents the five pillars of the Well-Architected Framework.
  - Leverage the [Workload optimization](../optimize/workloads.md] capability to prioritize and implement recommendations with the highest priority.
  - Leverage the [Rate optimization](../optimize/rates.md) capability to maximize savings with commitment discounts, like reservations and savings plans.
- Complete the [Azure Well-Architected Review self-assessment](/azure/well-architected/cross-cutting-guides/implementing-recommendations.md) to identify areas your existing workloads can be improved based on the Azure Well-Architected Framework.
  - Link your subscription to include Azure Advisor recommendations in the assessment.

<br>

## Building on the basics

At this point, you have implemented best practices based on cross-company benchmarks integrated into the Well-Architected Framework. As you move beyond the basics, consider the following:

- Establish and automate KPIs, such as:
  - Number of anomalies each month or quarter.
  - Total cost impact of idle resources each month or quarter.
  - Response time to detect and resolve anomalies.
  - Number of false positives and false negatives.
- Build and share reports covering your KPIs to publicize benchmarks within the organization.
- Foster a culture of continuous learning, innovation, and collaboration by celebrating successes and sharing proven practices.
  - Regularly review and refine the benchmarking baseline based on feedback, industry best practices, and emerging technologies.
  - Promote knowledge sharing and cross-functional collaboration to drive continuous improvement in the benchmarking capability.

<br>

## Learn more at the FinOps Foundation

This capability is a part of the FinOps Framework by the FinOps Foundation, a non-profit organization dedicated to advancing cloud cost management and optimization. For more information about FinOps, including useful playbooks, training and certification programs, and more, see to the [benchmarking](https://www.finops.org/framework/capabilities/benchmarking) article in the FinOps Framework documentation.

<br>

## Related content

Related FinOps capabilities:

- [Forecasting](./forecasting.md)
- [Budgeting](./budgeting.md)
- [Unit economics](./unit-economics.md)
- [Workload optimization](../optimize/workloads.md)
- [Rate optimization](../optimize/rates.md)

Related products:

- [Azure Advisor](/azure/advisor/)

Related solutions:

- [FinOps toolkit Power BI reports](https://aka.ms/ftk/pbi)
- [FinOps hubs](https://aka.ms/finops/hubs)

<br>