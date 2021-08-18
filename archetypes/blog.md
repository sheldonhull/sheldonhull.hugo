{{- $DateString := .Date | dateFormat "2006-01-02" -}}
{{- $TitleWithoutDate := trim (replace .TranslationBaseName $DateString "") "-" -}}
---

date: {{ now.UTC.Format "2006-01-02T15:04:05-0700" }}
title: {{ replace $TitleWithoutDate "-" " " | title }}
slug: {{ replace $TitleWithoutDate " " "-" | lower }}
summary:
  Foo
tags:

- tech
- development
- azure-devops
- powershell
- devops
draft: true
toc: true

# images: [/images/]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

## Header
