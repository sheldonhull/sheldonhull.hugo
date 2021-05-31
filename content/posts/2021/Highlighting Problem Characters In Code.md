---
title: highlighting-problem-characters-in-vscode
date: 2021-05-31T11:43:46-05:00
tags: [vscode, development]
modified: 2021-05-31T11:49:41-05:00
---

# Highlighting Problem Characters In Code

Use [Vscode Gremlins](https://github.com/nhoizey/vscode-gremlins) to help flag characters that shouldn't be in your code.

## Specifying a Range of Invalid Characters

You can give a range to flag multiple characters with a single rule.

For example, if using macOS and the option key is set to a modifier, it's easy to accidentally include a [Latin-1 Supplemental Character](https://unicode-table.com/en/blocks/latin-1-supplement/) that can be difficult to notice in your code.

To catch the entire range, the Latin-1-Supplement link provided shows a unicode range of: `0080—00FF`

Configure a rule like this:

```jsonc
"gremlins.characters": {
    "0080-00FF": {
        "level": "error",
        "zeroWidth": false,
        "description": "Latin-1 Supplement character identified",
        "overviewRulerColor": "rgba(255,127,80,1)",
    },
}
```

I submitted this as a [PR](https://github.com/nhoizey/vscode-gremlins/pull/185) to project repo but figured I'd document here as well in case it takes a while to get merged.
