---
layout: default
grand_parent: PowerShell
parent: FinOps hubs
title: Remove-FinOpsHubScope
nav_order: 10
description: Stops monitoring a scope within a FinOps hub instance.
permalink: /powershell/hubs/Remove-FinOpsHubScope
---

<span class="fs-9 d-block mb-4">Remove-FinOpsHubScope</span>
Stops monitoring a scope within a FinOps hub instance.
{: .fs-6 .fw-300 }

[Syntax](#-syntax){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-4 }
[Examples](#-examples){: .btn .fs-5 .mb-4 .mb-md-0 .mr-4 }

<details open markdown="1">
   <summary class="fs-2 text-uppercase">On this page</summary>

- [🧮 Syntax](#-syntax)
- [📥 Parameters](#-parameters)
- [🌟 Examples](#-examples)
- [🧰 Related tools](#-related-tools)

</details>

---

The **Remove-FinOpsHubScope** command removes a scope from being monitored by a FinOps hub instance. Data related to that scope is kept by default. To remove the data, use the -RemoveData option.

<br>

## 🧮 Syntax

```powershell
Remove-FinOpsHubScope `
    [‑Id] <String> `
    [‑HubName] <String> `
    [[‑HubResourceGroupName] <String>] `
    [‑RemoveData] `
    [‑WhatIf]
```

<br>

## 📥 Parameters

| Name | Description |
| ---- | ----------- |
| `‑Id` | Required resource ID of the scope to remove. |
| `‑HubName` | Required. Name of the FinOps hub instance. |
| `‑HubResourceGroupName` | Optional. Name of the resource group the FinOps hub was deployed to. |
| `‑RemoveData` | Optional. Indicates whether to remove data for this scope from storage. Default = false |
| `‑WhatIf` | Optional. Shows what would happen if the command runs without actually running the command. Default = false. |

<br>

## 🌟 Examples

### Remove billing account and keep data

```powershell
Remove-FinOpsHubScope -Id "/providers/Microsoft.Billing/billingAccounts/123" -HubName "FooHub"
```

Deletes the exports configured to use the FooHub hub instance. Existing data is retained in the storage account.

### Remove subscription and historical data

```powershell
Remove-FinOpsHubScope -Id "/subscriptions/##-#-#-#-###" -HubName "FooHub" -RemoveData
```

Deletes the exports configured to use the FooHub hub instance and removes data for that scope.

<br>

---

## 🧰 Related tools

{% include tools.md aoe="1" bicep="0" data="0" hubs="1" pbi="1" ps="0" %}

<br>

