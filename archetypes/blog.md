{{- $DateString := .Date | dateFormat "2006-01-02" -}}
{{- $TitleWithoutDate := trim (replace .TranslationBaseName $DateString "") "-" -}}
---
date: {{ .Date }}
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
---

## Intro

## Content 1

## Content 2
