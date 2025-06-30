---
title: 'observability'
slug: 'observability'
date: '2023-07-13'
toc: true
summary: Some notes related to observability, monitoring, and alerting.
permalink: /notes/observability/
tags:
  - observability
  - operations
comments: true
---

## Datadog

### Evaluate Impact on Pricing Based On Contributors in a Repository

Some pricing models reflect based on the number of active contributors in a repository.
For example, the CI/Pipeline integration is based on a model of active contributors.


This snippet will assess unique contributors in the repo and based on a rough [On-Demand pricing] you can find on the website, it will approximate the impact of enabling this feature directly against this repository.

> [!example] Figuring Out Pricing Based On Contributors in Git
>
> ```powershell title="CalcDatadogPricing.ps1"
>     $DatadogPerContributorPricing = 8 # Get from Datadog pricing site
>     $LookBack = -6
>     $month = Get-Date -Format 'MM'
>     $year = Get-Date -Format 'yyyy'
>     $since = "$((Get-Date -Day 1 -Month $month -Year $year).AddMonths($LookBack).AddDays(-1).ToString('yyyy-MM'))"
>     $until = "$((Get-Date).AddMonths(1).AddDays(-1).ToString('yyyy-MM'))"
>
>     # $contributors =
>     $stats = &git log --date="format-local:%Y-%m" --pretty=format:"%ad %ae" --since="$since" --until="$until" |
>     ConvertFrom-Csv -Delimiter ' ' -Header 'month', 'contributor' |
>     Sort-Object -Property 'month', 'contributor' -Descending -Unique
>
>     $report = $stats | Group-Object -Property 'month' | ForEach-Object {
>         [pscustomobject]@{
>             month            = $_.Name
>             ContributorCount = $_.Count
>             approxCost       = ($_.Count * $DatadogPerContributorPricing).ToString('C0')
>         }
>     }
>
>     Write-Host '==== Pricing Consideration for Observability on Repo Based on Contributors Per Month ====' -ForegroundColor Green
>     Write-Host "$($report | Format-Table -AutoSize -Wrap | Out-String)" -ForegroundColor DarkGray
> ```


[On-Demand Pricing]: https://www.datadoghq.com/pricing/?product=ci-visibility#products
