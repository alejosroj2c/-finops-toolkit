---
title: Use and customize the Cost optimization workbook
description: How to install and edit the Cost optimization workbook.
author: bandersmsft
ms.author: banders
ms.date: 06/06/2024
ms.topic: how-to
ms.service: finops
ms.reviewer: arclares
---

<!-- markdownlint-disable-next-line MD025 -->
# Use and customize FinOps workbooks

This article explains how to install and edit FinOps workbooks. FinOps workbooks are a central access point for common tools that can help achieve FinOps goals. Each workbook offers a range of insights aligned to FinOps capabilities, including:

- Advisor cost recommendations
- Idle resource identification
- Management of improperly deallocated virtual machines
- Insights into using Azure Hybrid Benefit options for Windows, Linux, and SQL databases

Workbooks include insights for compute, storage, networking, and more. Workbooks also offer some quick fix options to perform recommended actions directly from the workbook, streamlining the optimization process.

<br>

## Use workbooks

Azure Monitor workbooks provide a flexible canvas for data analysis and the creation of rich visual reports within the Azure portal. You can then customize them to display visual and interactive information about your Azure environment. It allows you to query various sources of data in Azure and modify or process the data if needed. Then you can choose to display it using any of the available visualizations and finally share the workbook with your team so everyone can use it.

The Cost optimization workbook is in the Azure Advisor's workbook gallery, and doesn't require any setup. However, if you want to deploy other workbooks or make changes to them, like adding or customizing queries, you can copy the workbook to your environment.

### View the Cost optimization workbook in Advisor

1. Sign in to the [Azure portal](https://portal.azure.com/).
2. Search for Azure Advisor.
3. In the left navigation menu, select **Workbooks**.
4. In the Workbooks Gallery, select the **Cost Optimization (Preview)** workbook template.
5. Select an area to explore.

### Deploy FinOps workbooks to Azure

If you want to make modifications to the Cost optimization workbook workbook or use other FinOps workbooks, deploy the FinOps workbooks template from the FinOps toolkit.

First, confirm you have the following least-privileged roles to deploy and use the workbook.

- [Workbook Contributor](/azure/role-based-access-control/built-in-roles#workbook-contributor) - allows you to import, save, and deploy the workbook.
- [Reader](/azure/role-based-access-control/built-in-roles#reader) allows you to view all the workbook tabs without saving.

Deploy the FinOps workbooks template with one of the following options:

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Ffinops-workbooks-latest.json/createUIDefinitionUri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Ffinops-workbooks-latest.ui.json"><img alt="Deploy To Azure" src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true" /></a>
&nbsp;
<a href="https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Ffinops-workbooks-latest.json/createUIDefinitionUri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Ffinops-workbooks-latest.ui.json"><img alt="Deploy To Azure Gov" src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true" /></a>
<!--
&nbsp;
<a href="https://portal.azure.cn/#create/Microsoft.Template/uri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Ffinops-workbooks-latest.json/createUIDefinitionUri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Ffinops-workbooks-latest.ui.json"><img alt="Deploy To Azure China" src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazurechina.svg?sanitize=true" /></a>
-->

Select a subscription, location, resource group, and give the workbook a name. Then, select **Review + create** to deploy the workbook template.

On the Review + create page, select **Create**.

After the deployment completes, you can view and copy the workbook URL on the **Outputs** page. The URL takes you directly to the workbook that you created.

<br>

## Edit and include new queries to the workbook

If you want to edit or include more queries in the workbook, you can edit the template for your needs.

Workbooks are primarily based on Azure Resource Graph queries. However, workbooks support many different sources. They include KQL, Azure Resource Manager, Azure Monitor, Azure Data Explorer, custom endpoints, and others.

You can also merge data from different sources to enhance your insights experience. Azure Monitor has several correlatable data sources that are often critical to your triage and diagnostic workflow. You can merge or join data to provide rich insights using the merge control.

Here's how to create and add a query to the Azure Hybrid benefit tab in the Cost optimization workbook. For this example, you add code from the [Code example](#code-example) section to help you identify which Azure Stack HCI clusters aren't using Azure Hybrid Benefit.

1. Open the Workbook and select **Edit**.
2. Select the **Rate optimization tab** , which shows virtual machines using Azure Hybrid Benefit.
3. At the bottom of the page on the right side, to the right of the last **Edit** option, select the ellipsis (**…**) symbol and then select **Add**. This action adds a new item after the last group.
4. Select **Add query**.
5. Change the **Data source** to **Azure Resource Graph**. Leave the Resource type as **Subscriptions**.
6. Under Subscriptions, select the list option and then under Resource Parameters, select **Subscriptions**.
7. Copy the example code from the [Code example](#code-example) section and paste it into the editor.
8. Change the _ResourceGroup_ name in the code example to the one where your Azure Stack HCI clusters reside.
9. At the bottom of the page, select **Done Editing**.
10. Save your changes to the workbook and review the results.

### Understand code sections

Although the intent of this article isn't to focus on Azure Resource Graph queries, it's important to understand what the query example does. The code example has three sections.

In the first section, the following code identifies and groups your own subscriptions.

```kusto
ResourceContainers
| where type =~ 'Microsoft.Resources/subscriptions'
| where tostring(properties.subscriptionPolicies.quotaId) !has "MSDNDevTest_2014-09-01" 
| extend SubscriptionName = name
```

It queries the `ResourceContainers` table and removes the ones that are Dev/Test because Azure Hybrid Benefit doesn't apply to Dev/Test resources.

In the second section, the query finds and assesses your Stack HCI resources.

```kusto
resources 
| where resourceGroup in ({ResourceGroup})
| where type == 'microsoft.azurestackhci/clusters'
| extend AHBStatus = tostring(properties.softwareAssuranceProperties.softwareAssuranceIntent)
| where AHBStatus == "Disable"
```

This section queries the `Resource` table. It filters by the resource type `microsoft.azurestackhci/clusters`. It creates a new column called `AHBStatus` with the property where we have the software assurance information. And, we want only resources where the `AHBStatus` is set to `Disable`.

In the last section, the query joins the `ResourceContainerstable` with the `resources` table. The join helps to identify the subscription that the resources belong to.

```kusto
ResourceContainers | "Insert first code section go here"
| join (
    resources  "Insert second code section here"
) on subscriptionId 
| order by type asc 
| project HCIClusterId,ClusterName,Status,AHBStatus
```

In the end, you view the most relevant columns. Because the workbook has a `ResourceGroup` parameter, the example code allows you to filter the results per resource group.

### Code example

Here's the full code example that you use to insert into the workbook.

```kusto
ResourceContainers | where type =~ 'Microsoft.Resources/subscriptions' | where tostring (properties.subscriptionPolicies.quotaId) !has "MSDNDevTest_2014-09-01"  | extend SubscriptionName=name 
| join (
  resources 
  | where resourceGroup in ({ResourceGroup})
  | where type == 'microsoft.azurestackhci/clusters'
  | extend AHBStatus = tostring(properties.softwareAssuranceProperties.softwareAssuranceIntent)
  | where AHBStatus == "Disable"
  | extend HCIClusterId=properties.clusterId, ClusterName=properties.clusterName, Status=properties.status, AHBStatus=tostring(properties.softwareAssuranceProperties.softwareAssuranceIntent)
) on subscriptionId 
| order by type asc 
| project HCIClusterId,ClusterName,Status,AHBStatus
```

<br>

## Learn more about workbooks

To learn more about Azure Monitor workbooks, see the [Visualize data combined from multiple data sources by using Azure Monitor Workbooks](/training/modules/visualize-data-workbooks/) training module.

<br>

## Next steps

To learn more about other FinOps workbook, see the [FinOps workbooks overview](finops-workbooks-overview.md).

<br>