{{- $DateString := .Date | dateFormat "2006-01-02" -}}
{{- $TitleWithoutDate := trim (replace .TranslationBaseName $DateString "") "-" -}}
---
date: {{ .Date }}
title: {{ replace $TitleWithoutDate "-" " " | title }}
slug: {{ replace $TitleWithoutDate " " "-" | lower }}
area: go
round: 1
day_counter: VAR_DAYCOUNTER
tags:
    - tech
    - development
    - 100-days-of-code
    - 100DaysOfCode
    - golang
featuredImg: /images/image.png
---

## Day VAR_DAYCOUNTER of 100

## progress

- note
- note
- note

## links

- [link](github.com)
- [link](github.com)
- [link](github.com)
