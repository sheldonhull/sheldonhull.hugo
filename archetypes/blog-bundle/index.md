{{- $DateString := .Date | dateFormat "2006-01-02" -}}
{{- $TitleWithoutDate := trim ( replace .Name $DateString "") "-" -}}
---

date: {{ now.UTC.Format "2006-01-02T15:04:05-0700" }}
title: {{ replace $TitleWithoutDate "-" " " | title }}
slug: {{ replace $TitleWithoutDate " " "-" | lower }}
summary:
  Foo
tags:
draft: true
toc: true
---

{{<
gallery match="images/*"
sortOrder="desc"
rowHeight="150"
margins="5"
thumbnailResizeOptions="600x600 q90 Lanczos" showExif=true
previewType="blur"
embedPreview=true
loadJQuery=true
thumbnailHoverEffect="enlarge"
lastRow="justify"
>}}
