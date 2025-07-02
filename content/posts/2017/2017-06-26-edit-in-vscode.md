---
date: "2017-06-26T00:00:00Z"
last_modified_at: "2019-02-09"
tags:
- sql-server
- text-manipulation
- vscode
- tech
- cool-tools
title: "External Tool VSCODE called from SQL Management Studio"
slug: "edit-in-vscode"
---

Previous Related Post:
[Split personality text editing in SSMS with Sublime Text 3]([[2015-09-14-split-personality-text-eiting-in-ssms-with-sublime-text-3]])

In this prior post I wrote about how to call Sublime Text 3 from SSMS to allow improved text manipulation to be quickly called from an active query window in SQL Management Studio. Vscode is a newer editor from Microsoft, and the argument calls took a little work to get working. Here is what I found for having your SQL file open in vscode via call from SSMS (I imagine also works in Visual Studio 2017 this way as well).

### External Tools Setup for Vscode

```text
Title:  "Edit In VSCODE"
Command C:\Program Files (x86)\Microsoft VS Code\Code.exe
Arguments: --reuse-window --goto $(ItemPath):$(CurLine):$(CurCol)
```

Please note unsaved files such as "SQLQuery11.sql" that haven't been explictly saved are not accessible to this, so it will just open an empty file. I have not found any workaround for that, as I believe the tmp files are cached in one of the .DAT files. I've not had luck finding the Autorecover or temp files with the actual contents until saved.
