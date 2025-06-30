---

date: 2024-02-29T20:15:36+0000
title: Improve Language Matching in Vscode
slug: improve-language-matching-in-vscode
tags:

- tech
- development
- microblog

# images: [/images/]
---

Let's say you have the Red Hat YAML extension.
This does a great job with formatting and validation.

However, other directories contain files for Azure DevOps Pipelines that are also `yaml`.
You can tweak the matching logic based on common paths you'd use and get those to default to a different language.

```json
"files.associations": {
"*.json5": "json5",
"CODEOWNERS": "plaintext",
"*.aliases": "gitconfig",
"{**/tasks/*.y*ml,**/jobs/*.y*ml,**/variables/*.y*ml,**/stages/*.y*ml,**/pipelines/*.y*ml,**/ci/*.y*ml,**/build/*.y*ml,**/templates/*.y*ml}": "azure-pipelines"
},
```

You can see the icon in the explorer switch to the new type as well to have a quick visual validation.
