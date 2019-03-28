---
date: "2016-10-28T00:00:00Z"
tags:
- cool-tools
- redgate
- sql-server
title: Data Compare on Temporal Tables
---

I hadn't seen much talk on doing data comparisons on temporal tables, as they are a new feature. I went through the exercise to compare current to historical to see how Red Gate & Devart handled this. I'm a part of the Friends of Red Gate program, so love checking out their latest updates, and I'm also a regular tester on Devart which also provides fantastic tools. Both handled Temporal Tables with aplomb, so here's a quick walk through on how I did this.

## SSMS 2016 View Of Temporal Table

With the latest version of SSMS, you can see the temporal tables labeled and expanded underneath the source table.

![SSMS 2016 View Of Temporal Table](/images/ssms-2016-view-of-temporal-table.png)

## Red Gate SQL Data Compare 12

To begin the comparison process, you need to do some custom mapping, which requires navigating into the Tables & Views settings in SQL Data Compare

![Red Gate SQL Data Compare 12](/images/red-gate-sql-data-compare-12-sm.png)

### Unmap the existing options

To remap the Customers to Customers_Archive, we need to select this in the tables and choose to unmap the Customer and the Customer-Archive Tables from each other. This is 2 unmapping operations.

![Unmap the existing options](/images/unmap-the-existing-options-sm.png)

### Setup Compare Key

Go into the comparison settings on the table now and designate the key as the value to compare against. For the purpose of this example, I'm just doing key, you can change this however you see fit for your comparison scenario.

![Setup Compare Key](/images/setup-compare-key.png)

### Remove any columns from comparison desired

In this example, I'm removing the datetime2 columns being used, to instead focus on the other columns.

![Remove any columns from comparison desired](/images/remove-any-columns-from-comparison-desired.png)

### Compare results

If you run into no results coming back, look to turn off the setting in compare options for Checksum comparison, which helps improve the initial compare performance. With this on, I had no results coming back, but once I turned off, the comparison results came back correctly.

![Compare results](/images/compare-results.png)

### Conflict Row

This entry was matched in DbForge SQL Data Compare as a conflict due to matching the key in a non-unique manner. The approach the two tools take is a little different. In RG Data Compare

![Conflict Row](/images/conflict-row.png)

### Conflict Entry Only In Destination

The entry identified as potential conflict  by DbForge is identified in the Only In Destination.

![Conflict Entry Only In Destination](/images/conflict-entry-only-in-destination-sm.png)

### Diff Report

Both tools report differences. RG's tool has focused on the diff report being simple CSV output. This is fine in the majority of cases, though I'm hoping for additional XLSX and HTML diff reports similar to DbForge eventually. In the case of the CSV output, you could consume the information easily in Power-BI, Excel, or even... SQL Server :-) No screenshot on this as it's just a csv output.

## Devart SQL Data Compare

Going into the mapping, you can see support for Customers and Customers_Archive, which is the temporal history table for this.
In this case, I mapped the current table against the temporal table to compare the current against the change history.

![Devart SQL Data Compare](/images/devart-sql-data-compare.png)

### Choose the key column to compare against

As a simple example, I just provided the primary key. You could get creative with this though if you wanted to compare specific sets of changes.

![Choose the key column to compare against](/images/choose-the-key-column-to-compare-against.png)

![84a38857-022c-4d68-8c00-1f79cfcac3b2-sm](/images/84a38857-022c-4d68-8c00-1f79cfcac3b2-sm.png)

### Handling Conflicts differently

Looks like the conflict is handled differently in the GUI than Red Gate, as this provides back a separate tab indicating a conflict. Their documentation indicates:
Appears only if there are conflict records (records, having non-unique values of the custom comparison key).
[DbForge Data Compare for SQL server Documentation - Data Comparison Document](https://www.devart.com/dbforge/sql/datacompare/docs/data_comparison_document.htm?zoom_highlightsub=conflict)

![Handling Conflicts differently](/images/handling-conflicts-differently-sm.png)

### Diff Report

The diff reports provided by DbForge Data Compare are very well designed, and have some fantastic output options for allowing review/audit of the rows.

![Diff Report](/images/diff-report.png)

### Diff Report Details

Here is a sample of a detail provided on the diff report. One feature I found incredibly helpful was the bold highlighting on the columns that had diffs detected. You can trim down the report output to only include the diff columns if you wish to further trim the information in the report.

![Diff Report Details](/images/diff-report-details.png)

Overall, good experience with both, and they both support a lot of flexibility with more specialized comparisons.
