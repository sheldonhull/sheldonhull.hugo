---
date: "2013-04-17T00:00:00Z"
tags:
  - sql-server
title : "How to default SSRS date parameters to the first and last day of the the previous month"
slug: "how-to-default-ssrs-date-parameters-to-the-first-and-last-day-of-the-the-previous-month"
---

Populating default dates in SSRS can be helpful to save the user from having to constantly input the date range they normally would use. When a report is pulled for last month's information, defaulting the date fields for the user can help streamline their usage of the report, instead of them manually selecting with the date-picker control in SSRS. The formula's I used were:

```ssrs
Beginning of Current Month (EOM) DateSerial(Year(Date.Now), Month(Date.Now), 1)
Beginning of Last Month (BOM) DateAdd(DateInterval.Month, -1, DateSerial(Year(Date.Now), Month(Date.Now), 1))
End of Last Month (EOM) DateAdd(DateInterval.Minute, -1, DateSerial(Year(Date.Now), Month(Date.Now), 1))
```

To set the default date of the parameters:

1. First open up the Report Data Window, and choose your date parameters.

<!--  -->
2. Navigate to Default values, and click the Fx button to edit the expression for the field.
3. Paste the formula into the expression field and save.

Result: Your default dates should now show last month's date range. You can apply your own rounding or date types if you wish, this provides the time as well, since I was working with smalldatetime, datetime, and datetime2 datatypes.
