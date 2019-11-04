{{- $DateString := .Date | dateFormat "2006-01-02" -}}
{{- $TitleWithoutDate := trim (replace .TranslationBaseName $DateString "") "-" -}}
---
date: {{ .Date }}
title: {{ replace $TitleWithoutDate "-" " " | title }}
slug: {{ replace $TitleWithoutDate " " "-" | lower }}
excerpt:
  excerpt here
tags:
  - tag1
  - tag2
  - tag3
draft: true
toc: true
---

## Intro

## Content 1

## Content 2
