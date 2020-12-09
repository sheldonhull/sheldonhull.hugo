---
date: "2018-07-23T00:00:00Z"
excerpt: Can't delete a directory due to some edge case in naming errors... like a
  trailing space. Here's the fix!
last_modified_at: "2019-03-18"
published: true
tags:
- tech
- powershell
title: "Deleting a Directory That Has a Trailing Space Shouldn't Be This Hard"
slug: "deleting-a-directory-that-has-a-trailing-space-shouldn-t-be-this-hard"
---

It shouldn't be this hard. This is a consumate #windowsmoment

![Removing Folder Fails](/images/ConEmu64_2018-07-23_11-42-59 - Copy.png)

If you occasionally use something like Robocopy, or other command line tool, it can be possible to create a directory with a trailing slash. For instance

```cmd
robocopy "C:\test\Taco" "C:\Burritos\are\delicious "
```

This trailing space would be actually used by Robocopy to initialize a directory that has a trailing space in the name. This can appear as a duplicator in explorer, until you try to rename and notice a trailing slash. Attempts to rename, delete, or perform any activity to manipulate this directory fail as Windows indicates that it can't find the directory as it no longer exists or might have been moved.

To resolve this I found details on SO about how to delete in response to the question ["Can't Delete a Folder on Windows 7 With a Trailing Space"](https://stackoverflow.com/a/21074385).

Apparently it's an issue with NFTS handling. To resolve you have to use cmd.exe to `rd` (remove directory), and change your path to a UNC path referring to your local path.

To resolve the error then you'd do:

```cmd
rm \\?\C:\Burritos\are\delicious
```

To confirm that PowerShell can't resolve this I did a quick test by running:

```cmd
cd C:\temp
md ".\ Taco "
```

```powershell
# Fails - No error
remove-item "\\?\C:\temp\taco "

# Fails with error: Remove-Item : Cannot find path '\\localhost\c$\temp\taco ' because it does not exist.
$verbosepreference = 'continue'; Remove-Item "\\localhost\c$\temp\taco "

# SUCCESS: Succeeds to remove it
GCI C:\Temp | Where-Object { $_.FullName -match 'taco'} | Remove-Item
```

So for me, I wanted to confirm that PowerShell was truly unable to resolve the issue without resorting to cmd.exe for this. Turns out it can, but you need to pass the matched object in, not expect it to match the filepath directly.

Now to go eat some tacos....
