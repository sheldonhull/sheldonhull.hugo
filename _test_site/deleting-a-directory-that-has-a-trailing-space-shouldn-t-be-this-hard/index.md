# Deleting a Directory That Has a Trailing Space Shouldn&#39;t Be This Hard


It shouldn&#39;t be this hard. This is a consumate #windowsmoment

![Removing Folder Fails](/images/ConEmu64_2018-07-23_11-42-59 - Copy.png)

If you occasionally use something like Robocopy, or other command line tool, it can be possible to create a directory with a trailing slash. For instance

```cmd
robocopy &#34;C:\test\Taco&#34; &#34;C:\Burritos\are\delicious &#34;
```

This trailing space would be actually used by Robocopy to initialize a directory that has a trailing space in the name. This can appear as a duplicator in explorer, until you try to rename and notice a trailing slash. Attempts to rename, delete, or perform any activity to manipulate this directory fail as Windows indicates that it can&#39;t find the directory as it no longer exists or might have been moved.

To resolve this I found details on SO about how to delete in response to the question [&#34;Can&#39;t Delete a Folder on Windows 7 With a Trailing Space&#34;](https://stackoverflow.com/a/21074385).

Apparently it&#39;s an issue with NFTS handling. To resolve you have to use cmd.exe to `rd` (remove directory), and change your path to a UNC path referring to your local path.

To resolve the error then you&#39;d do:

```cmd
rm \\?\C:\Burritos\are\delicious
```

To confirm that PowerShell can&#39;t resolve this I did a quick test by running:

```cmd
cd C:\temp
md &#34;.\ Taco &#34;
```

```powershell
# Fails - No error
remove-item &#34;\\?\C:\temp\taco &#34;

# Fails with error: Remove-Item : Cannot find path &#39;\\localhost\c$\temp\taco &#39; because it does not exist.
$verbosepreference = &#39;continue&#39;; Remove-Item &#34;\\localhost\c$\temp\taco &#34;

# SUCCESS: Succeeds to remove it
GCI C:\Temp | Where-Object { $_.FullName -match &#39;taco&#39;} | Remove-Item
```

So for me, I wanted to confirm that PowerShell was truly unable to resolve the issue without resorting to cmd.exe for this. Turns out it can, but you need to pass the matched object in, not expect it to match the filepath directly.

Now to go eat some tacos....

