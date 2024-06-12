---
title: Workload management and automation
description: This article helps you understand the workload management and automation capability within the FinOps Framework and how to implement that in the Microsoft Cloud.
author: bandersmsft
ms.author: banders
ms.date: 06/12/2024
ms.topic: concept-article
ms.service: finops
ms.reviewer: micflan
# customer intent: As a FinOps practitioner, I want to understand the workload management and automation capability so that I can implement it in the Microsoft Cloud.
---

<!-- markdownlint-disable-next-line MD025 -->
# Workload management and automation

This article helps you understand the workload management and automation capability within the FinOps Framework and how to implement that in the Microsoft Cloud.

<br>

## Definition

**Workload management and automation refers to running resources only when necessary and at the level or capacity needed for the active workload.**

Tag resources based on their up-time requirements. Review your resource usage patterns and determine if they can be scaled down or even shutdown (to stop billing) during off-peak hours. To reduce costs, consider cheaper alternatives.

An effective workload management and automation plan can significantly reduce costs by adjusting configuration to match supply to demand dynamically, ensuring the most effective utilization.

<br>

## Getting started

When you first start working with a service, consider the following points:

- Can the service be stopped (and if so, stop billing)?
  - If the service can't be stopped, review alternatives to determine if there are any options that can be stopped to stop billing.
  - Pay close attention to noncompute charges that might continue to be billed when a resource is stopped so you're not surprised. Storage is a common example of a cost that continues to be charged even if a compute resource that was using the storage is no longer running.
- Does the service support serverless compute?
  - Serverless compute tiers can reduce costs when not active. Some examples: [Azure SQL Database](/azure/azure-sql/database/serverless-tier-overview.md), [Azure SignalR Service](/azure/azure-signalr/concept-service-mode.md), [Cosmos DB](/azure/cosmos-db/serverless.md), [Synapse Analytics](/azure/synapse-analytics/sql/on-demand-workspace-overview.md), [Azure Databricks](/azure/databricks/serverless-compute/.md).
- Does the service support autostop or autoshutdown functionality?
  - Some services support autostop natively, like [Microsoft Dev Box](/azure/dev-box/how-to-configure-stop-schedule.md), [Azure DevTest Labs](/azure/devtest-labs/devtest-lab-auto-shutdown.md), [Azure Lab Services](/azure/lab-services/how-to-configure-auto-shutdown-lab-plans.md), and [Azure Load Testing](/azure/load-testing/how-to-define-test-criteria#auto-stop-configuration.md).
  - If you use a service that supports being stopped, but not autostopping, consider using a lightweight flow in [Power Automate](/power-automate/getting-started) or [Logic Apps](/azure/logic-apps/logic-apps-overview.md).
- Does the service support autoscaling?
  - If the service supports [autoscaling](/azure/architecture/best-practices/auto-scaling.md), configure it to scale based on your application's needs.
  - Autoscaling can work with autostop behavior for maximum efficiency.
-  To avoid unnecessary costs, consider automatically stopping and manually starting nonproduction resources during work hours.
  - Avoid automatically starting nonproduction resources that aren't used every day.
  - If you choose to autostart, be aware of vacations and holidays where resources might get started automatically but not be used.
  - Consider tagging manually stopped resources. To ensure all resources are stopped, [Save a query in Azure Resource Graph](/azure/governance/resource-graph/first-query-portal.md) or a view in the All resources list and pin it to the Azure portal dashboard.
- Consider architectural models such as containers and serverless to only use resources when they're needed, and to drive maximum efficiency in key services.

<br>

## Building on the basics

At this point, you have setup autoscaling and autostop behaviors. As you move beyond the basics, consider the following points:

- Automate the process of automatically scaling or stopping resources that don't support it or have more complex requirements.
  - Consider using automation services, like [Azure Automation](/azure/automation/automation-solution-vm-management.md) or [Azure Functions](/azure/azure-functions/start-stop-vms/overview.md).
- [Assign an "Env" or Environment tag](/azure/azure-resource-manager/management/tag-resources.md) to identify which resources are for development, testing, staging, production, etc.
  - Prefer assigning tags at a subscription or resource group level. Then enable the [tag inheritance policy for Azure Policy](/azure/governance/policy/samples/built-in-policies#tags.md) and [Cost Management tag inheritance](/azure/cost-management-billing/costs/enable-tag-inheritance.md) to cover resources that don't emit tags with usage data.
  - Consider setting up automated scripts to stop resources with specific up-time profiles (for example, stop developer VMs during off-peak hours if they weren't used in 2 hours).
  - Document up-time expectations based on specific tag values and what happens when the tag isn't present.
  - [Use Azure Policy to track compliance](/azure/governance/policy/how-to/get-compliance-data.md) with the tag policy.
  - Use Azure Policy to enforce specific configuration rules based on environment.
  - Consider using "override" tags to bypass the standard policy when needed. To ensure accountability, track the cost and report them to stakeholders.
- Consider establishing and tracking KPIs for low-priority workloads, like development servers.

<br>

## Learn more at the FinOps Foundation

This capability is a part of the FinOps Framework by the FinOps Foundation, a non-profit organization dedicated to advancing cloud cost management and optimization. For more information about FinOps, including useful playbooks, training and certification programs, and more, see the [Workload management and automation capability](https://www.finops.org/framework/capabilities/workload-management-automation) article in the FinOps Framework documentation.

You can also find related videos on the FinOps Foundation YouTube channel:

> [!VIDEO https://www.youtube.com/embed/Fjp0Y9lOaXphvBc0?list=PLUSCToibAswnEoBY6zl_1bpIAqbdIDxUW]

<br>

## Related content

Related FinOps capabilities:

- [Resource utilization and efficiency](./utilization-efficiency.md)
- [Cloud policy and governance](../manage/policy.md)

Related products:

- [Azure Advisor](/azure/advisor/)
- [Azure Monitor](/azure/azure-monitor/)
- [Azure Resource Graph](/azure/governance/resource-graph/)
- [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator)
- [Cost Management](/azure/cost-management-billing/costs/)
- [Azure Policy](/azure/governance/policy/)

Related solutions:

- [Cost optimization workbook](../../toolkit/optimization-workbook/cost-optimization-workbook.md)
- [Governance workbook](https://microsoft.github.io/finops-toolkit/governance-workbook)
- [FinOps toolkit Power BI reports](https://aka.ms/ftk/pbi)
- [FinOps hubs](https://aka.ms/finops/hubs)

Other resources:

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/)
- [Well-Architected Framework](/azure/well-architected/)
- [Azure pricing](https://azure.microsoft.com/pricing#product-pricing)

<br>
