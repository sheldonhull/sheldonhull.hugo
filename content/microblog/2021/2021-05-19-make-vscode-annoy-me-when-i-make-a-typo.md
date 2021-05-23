---
date: 2021-05-19T15:28:58-05:00
title: Make Vscode Annoy Me When I Make a Typo
slug: make-vscode-annoy-me-when-i-make-a-typo
tags:
  - tech
  - development
  - microblog
  - vscode
images: [/images/2021-05-19-15.32.06-vscode-highlight.png]
---

Not sure why, but I've had 2 typos that keep plauging me.

- `ngnix` should be `nginx`
- `chocolatey` should be `chocolatey`

With Go, I get compile errors with typos, so no problem.
With PowerShell or Bash, this can be really annoying and waste time in debugging.

You can configure many autocorrect tools on a system level, but I wanted a quick solution for making it super obvious in my code as I typed without any new spelling extensions.

Install Highlight: `fabiospampinato.vscode-highlight` [^highlight]

Configure a rule like this:

```jsonc
"highlight.regexes": {
    "(ngnix)": [
            {
                "overviewRulerColor": "#ff0000",
                "backgroundColor": "#ff0000",
                "color": "#1f1f1f",
                "fontWeight": "bold"
            },
            {
                "backgroundColor": "#d90000",
                "color": "#1f1f1f"
            }
        ],
}
```

[^highlight]: [vscode-highlight](https://github.com/fabiospampinato/vscode-highlight)
