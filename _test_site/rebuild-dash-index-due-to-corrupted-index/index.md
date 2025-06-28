# Rebuild Dash Index Due to Corrupted Index


I use [Dash](https://bit.ly/3gWSLEJ) for improved doc access.
Terraform updated recently to `0.13.x` and I began having odd issues with AWS provider results coming through.
If you need to rollback, just go to the preferences and pick an older docset, in my case `0.13.0` worked correctly.
Make sure to remove the problematic version (the uninstall refers to just the most recent, not any additional versions you selected under the dropdown)

If the index doesn&#39;t rebuild, you can close the app, manually remove the index, and it will rebuild on open.
I&#39;m pretty sure you don&#39;t need to do this if you use the uninstall option in the dialogue.

On macOS 10.15, you can find the index at `~/Library/Application Support/Dash/Data/manIndex.dsidx` and delete this.
Reopen Dash and it will rebuild the index.

