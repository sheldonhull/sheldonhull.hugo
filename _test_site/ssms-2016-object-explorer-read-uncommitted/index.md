# SSMS 2016 - Object Explorer Read Uncommitted


I ran through some directions from others, including the very helpful post from [SqlVariant](http://bit.ly/2ku5dTz), but I had issues locating the correct keys. For my Windows 10 machine, running SSMS 2016, I found the registry keys related to the object explorer located in a different path.

I found matches for read committed/uncommitted string at: `HKCU\SOFTWARE\Microsoft\VisualStudio\14.0\SSDT\SQLEditorUserSettings`

Running the following powershell command:
`get-itemproperty -path &#39;Registry::HKCU\SOFTWARE\Microsoft\VisualStudio\14.0\SSDT\SQLEditorUserSettings&#39; &#39; select SetTransactionIsolationLevel &#39; format-list`

