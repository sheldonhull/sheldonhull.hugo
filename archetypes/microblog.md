{{- $DateString := .Date | dateFormat "2006-01-02" -}}
{{- $TitleWithoutDate := trim (replace .TranslationBaseName $DateString "") "-" -}}
---

date: {{ .Date }}
title: {{ replace $TitleWithoutDate "-" " " | title }}
slug: {{ replace $TitleWithoutDate " " "-" | lower }}
tags:

- tech
- development
- microblog

# images: [/images/]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---
