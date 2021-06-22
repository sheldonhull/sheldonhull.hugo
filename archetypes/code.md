{{- $DateString := .Date | dateFormat "2006-01-02" -}}
{{- $TitleWithoutDate := trim (replace .TranslationBaseName $DateString "") "-" -}}
---
date: {{ .Date }}
title: {{ replace $TitleWithoutDate "-" " " | title }}
slug: {{ replace $TitleWithoutDate " " "-" | lower }}
area: VAR_LANGUAGE
round: VAR_ROUND
day_counter: VAR_DAYCOUNTER
tags:
  - tech
  - development
  - 100DaysOfCode
  - golang
  - microblog
# images: [/images/r1-dVAR_DAYCOUNTER-IMAGE.png]
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

## progress

-

## links

-
