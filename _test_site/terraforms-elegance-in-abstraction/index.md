# Terraform&#39;s Elegance in Abstraction


Migrated a forked copy of a module over to a new module with similar schema.
There were some additional properties that were removed.
In rerunning the plan I was expecting to see some issues with resources being broken down and rebuilt.
Instead, Terraform elegantly handled the module change.

I imagine this has to do with the resource name mapping being the same, but regardless it&#39;s another great example of how agile Terraform can be.

