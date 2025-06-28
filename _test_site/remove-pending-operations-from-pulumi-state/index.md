# Remove Pending Operations From Pulumi State


If you need to work through some issues with a deployment and remove a pending operation in Pulumi state file, you can do this pretty easily manually, or save a quick bit of scrolling and use `gojq` (or `jq` if you want).

- Export: `pulumi stack export --file state.json`
- Align formatting: `cat state.json | gojq &gt; stateFormatted.json`
- Remove pending operation: `cat stateFormatted.json | gojq &#39;.deployment.pending_operations = []&#39; &gt; stateNew.json`
- Now you can compare the results without any whitespace variance.
- Import: `pulumi stack import --file stateNew.json`

