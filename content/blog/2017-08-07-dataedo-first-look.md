---
date: "2017-08-07T00:00:00Z"
last_modified_at: "2019-02-22"
tags:
- sql-server
- cool-tools
- tech
title: "Dataedo - First Look"
slug: "dataedo-first-look"
---

{{< premonition type="info" title="update 2019-02-22" >}}
Image links broken. Since their product is continually improving, I'm going to just link to their product here instead so you can review their latest demo content there. [Dataedo](http://bit.ly/2U1OkgV).

Overall, I've enjoyed the product and think it has been improved over time. There are SQL scripts for bulk updating certain values on their website that can help improve building a project for an existing database as well.
{{< /premonition >}}


## Diagramming and Documentation

Previously, I've [written up on database diagramming]({{< relref "2015-12-09-documenting-your-database-with-diagrams.md" >}})for visualization of database structures. Check that out for more detailed review on what I've used.

I've recently taken a swing at this newer tool and found it very promising as a database documentation tool that bridged the gap of usability and flexibility.

## TL;DR

Promising future tool for diagramming, and worth evaluating if looking to build out some documentation for the first time. For my purposes, it was missing some diagramming options that prevent me from leveraging as a replacement for my existing toolkit.

## Setting Up Initial Diagrams

1.  This process was very manual, and did not allow filtering a selection of tables and dragging or bulk added to a module/category. I'm sure this will be an improvement quick to be implemented. At the current time, it was very tedious when dealing with a large database structure.
2.  Once assigning a module, and then clicking to the next table, a modal pop-up would ask if I wanted to save instead of letting me continue to assign modules. To bypass this I had to hit Ctrl+S to save prior to navigating to the next table or dismiss the dialogue by clicking.
3.  Discovered that moving to the Module > ERD tab allowed assignment of multiple tables or views to the ERD diagram. This provided the solution of easily assigning multiple objects to the ERD diagram, **_but did not add the tables to the Module itself_**, requiring the full manual step mentioned before. The filter tab was useful, though I was hoping for a basic search filter with a negation clause to help trim down the results selected. Example: CoreTables -ETL to allow easily filtering large amounts of objects. Maybe that would be a future enhancement the development team could add.

The only difference I could see for adding tables to the ERD when adding previously to the Module was that they were highlighted in bold before the other tables

## Exporting Customization Is Easy

Exporting documentation provided immediate feedback on generating a custom template, along with all the required files. This was a definite plus over some other tools I've worked with, as it promoted the customization that would be required by some, with all the necessary files generated. My props to the developers of this, as this showed a nice touch for their technical audience, not forcing the user into a small set of options, or making it complicated to customize.

No delete button for the CustomTemplate was a bit confusing, but an easy fix for them in the future. At this time, you'd just delete the folder in Dataedo/Templates/HTML and they won't show up in the template dialogue.

During the export process you also have the option of saving the export command options you already setup to a dataedo command file to make it easily automated. That's a nice touch!

## ERD Diagrams

**PROS**

1.  First, the snapping and arrangement of the connectors was excellent. This allows easy rearrangement with clean relationship lines shown.
2.  The generated documentation files looked fantastic, and with some improvements and customization, I could see this generating a full documentation set that would make any dba proud :-)

**CONS**

1.  I could not find any "auto-arrange" or "preferred layout" options to arrange in a set pattern if I didn't like the way I had changed it or it had laid it out initially
2.  No option to show the columns that have FK relationships. The relationship connector could be shown, with a label, but nothing to match Column5 that had a FK but was not part of the primary key to the matching column on another table. The diagram displayed only the PK columns. For my requirements, this was a critical omission as I need to display PK, and FK.

## Core Features I'd Like To See

1.  Search box so that I could replace CHM files with the local HTML document. This would require a search mechanism to allow easily finding what the user needed. Currently, no provider I've tested has implemented a local html package that included a static file search that worked well.
2.  Improved ERD with FK/PK
3.  Improved ERD with auto-layout options. Based on my initial research I'd say this is a tough one to implement, but giving a basic layout option to the user and then allowing customization from there would be a great help.
4.  Grouping objects in the ERD to group related elements in part of a larger module
5.  Producivity enhancements to allow quickly creating multiple modules, and dragging objects into the modules. Eliminate manual 1 by 1 actions to work with those.

## end comments

Well done Dataedo team :-) Looking forward to the continued improvements. I've found visualization of database structures is very helpful to design, and a new toolkit out like yours promises to provide even more great tools to use to do this.
