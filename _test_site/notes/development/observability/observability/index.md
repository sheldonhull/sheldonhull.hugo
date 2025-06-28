# observability


## Datadog

### Evaluate Impact on Pricing Based On Contributors in a Repository

Some pricing models reflect based on the number of active contributors in a repository.
For example, the CI/Pipeline integration is based on a model of active contributors.

This snippet will assess unique contributors in the repo and based on a rough [On-Demand pricing] you can find on the website, it will approximate the impact of enabling this feature directly against this repository.

{{&lt; admonition type=&#34;example&#34; title=&#34;Figuring Out Pricing Based On Contributors in Git&#34; open=false &gt;}}

```powershell title=&#34;CalcDatadogPricing.ps1&#34;
    $DatadogPerContributorPricing = 8 # Get from Datadog pricing site
    $LookBack = -6
    $month = Get-Date -Format &#39;MM&#39;
    $year = Get-Date -Format &#39;yyyy&#39;
    $since = &#34;$((Get-Date -Day 1 -Month $month -Year $year).AddMonths($LookBack).AddDays(-1).ToString(&#39;yyyy-MM&#39;))&#34;
    $until = &#34;$((Get-Date).AddMonths(1).AddDays(-1).ToString(&#39;yyyy-MM&#39;))&#34;

    # $contributors =
    $stats = &amp;git log --date=&#34;format-local:%Y-%m&#34; --pretty=format:&#34;%ad %ae&#34; --since=&#34;$since&#34; --until=&#34;$until&#34; |
    ConvertFrom-Csv -Delimiter &#39; &#39; -Header &#39;month&#39;, &#39;contributor&#39; |
    Sort-Object -Property &#39;month&#39;, &#39;contributor&#39; -Descending -Unique

    $report = $stats | Group-Object -Property &#39;month&#39; | ForEach-Object {
        [pscustomobject]@{
            month            = $_.Name
            ContributorCount = $_.Count
            approxCost       = ($_.Count * $DatadogPerContributorPricing).ToString(&#39;C0&#39;)
        }
    }

    Write-Host &#39;==== Pricing Consideration for Observability on Repo Based on Contributors Per Month ====&#39; -ForegroundColor Green
    Write-Host &#34;$($report | Format-Table -AutoSize -Wrap | Out-String)&#34; -ForegroundColor DarkGray
```

{{&lt; /admonition &gt;}}

[On-Demand Pricing]: https://www.datadoghq.com/pricing/?product=ci-visibility#products


