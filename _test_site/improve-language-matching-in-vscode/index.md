# Improve Language Matching in Vscode


Let&#39;s say you have the Red Hat YAML extension.
This does a great job with formatting and validation.

However, other directories contain files for Azure DevOps Pipelines that are also `yaml`.
You can tweak the matching logic based on common paths you&#39;d use and get those to default to a different language.

```json
&#34;files.associations&#34;: {
&#34;*.json5&#34;: &#34;json5&#34;,
&#34;CODEOWNERS&#34;: &#34;plaintext&#34;,
&#34;*.aliases&#34;: &#34;gitconfig&#34;,
&#34;{**/tasks/*.y*ml,**/jobs/*.y*ml,**/variables/*.y*ml,**/stages/*.y*ml,**/pipelines/*.y*ml,**/ci/*.y*ml,**/build/*.y*ml,**/templates/*.y*ml}&#34;: &#34;azure-pipelines&#34;
},
```

You can see the icon in the explorer switch to the new type as well to have a quick visual validation.

