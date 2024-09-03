---
layout: default
grand_parent: PowerShell
parent: Open data
title: Get-FinOpsService
nav_order: 10
description: Gets the name and category for a service, publisher, and cloud provider.
permalink: /powershell/data/Get-FinOpsService
---

<span class="fs-9 d-block mb-4">Get-FinOpsService</span>
Gets the name and category for a service, publisher, and cloud provider.
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

The **Get-FinOpsService** command returns service details based on the specified filters. This command is designed to help map Cost Management cost data to the FinOps Open Cost and Usage Specification (FOCUS) schema but can also be useful for general data cleansing.

Please note that both ConsumedService and ResourceType are required to find a unique service in many cases.

<br>

## 🧮 Syntax

```powershell
Get-FinOpsService `
    [[‑ConsumedService] <String>] `
    [[‑ResourceId] <String>] `
    [[‑ResourceType] <String>] `
    [‑ServiceName <String>] `
    [‑ServiceCategory <String>] `
    [‑ServiceModel <String>] `
    [‑Environment <String>] `
    [‑PublisherName <String>] `
    [‑PublisherCategory <String>]
```

<br>

## 📥 Parameters

| Name | Description |
| ---- | ----------- |
| `‑ConsumedService` | Optional. ConsumedService value from a Cost Management cost/usage details dataset. Accepts wildcards. Default = * (all). |
| `‑ResourceId` | Optional. The Azure resource ID for resource you want to look up. Accepts wildcards. Default = * (all). |
| `‑ResourceType` | Optional. The Azure resource type for the resource you want to find the service for. Default = null (all). |
| `‑ServiceName` | Optional. The service name to find. Default = null (all). |
| `‑ServiceCategory` | Optional. The service category to find services for. Default = null (all). |
| `‑ServiceModel` | Optional. The service model the service aligns to. Expected values: IaaS, PaaS, SaaS. Default = null (all). |
| `‑Environment` | Optional. The environment the service runs in. Expected values: Cloud, Hybrid, On-Premises. Default = null (all). |
| `‑PublisherName` | Optional. The publisher name to find services for. Default = null (all). |
| `‑PublisherCategory` | Optional. The publisher category to find services for. Default = null (all). |

<br>

## 🌟 Examples

### Get services based on filter

```powershell
Get-FinOpsService -ConsumedService "Microsoft.C*"
```

Returns all services with a resource provider that starts with "Microsoft.C".

<br>

---

## 🧰 Related tools

{% include tools.md aoe="0" bicep="0" data="1" hubs="1" pbi="1" ps="0" %}

<br>

