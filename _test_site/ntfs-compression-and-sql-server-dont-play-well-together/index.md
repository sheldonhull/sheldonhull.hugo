# NTFS Compression and SQL Server Do Not Play Well Together


Wanted to be proactive and move a database that was in the default path on `C:\` to a secondary drive as it was growing pretty heavily.

What I didn&#39;t realize was the adventure that would ensure.

## Lesson 1
Don&#39;t move a SQL Server database to a volume that someone has set NTFS Compression on at the drive level.

## Lesson 2
Copy the database next time, instead of moving. Would have eased my anxious dba mind since I didn&#39;t have a backup. *before you judge me.. it was a dev oriented enviroment, not production... disclaimer finished*

## The Nasty Errors and Warnings Ensue
First, you&#39;ll get an error message if you try to mount the database and it has been compressed. Since I&#39;d never done this before I didn&#39;t realize the mess I was getting into. It will tell you that you can&#39;t mount the database without marking as read-only as it&#39;s a compressed file.

Ok... so just go to `file explorer &gt; properties &gt; advanced &gt; uncheck compress` ... right?

Nope...

```cmd
Changing File Attributes &#39;E:\DATA\FancyTacos.mdf&#39; The requested operation could not be completed due to a file system limitation`
```

I found that message about as helpful as the favorite .NET error message `object reference not found` that is of course so easy to immediately fix.

## The Fix
- Pull up volume properties. Uncheck compress drive
OR
- If you really want this compression, then make sure to uncompress the folders containing SQL Server files and apply.

Since I wasn&#39;t able to fix this large of a file by toggling the file (it was 100gb&#43;), I figured to keep it simple and try copying the database back to the original drive, unmark the archive attribute, then copy back to the drive I had removed compression on and see if this worked. While it sounded like a typical &#34;IT Crowd&#34; fix (have you tried turning it on and off again) I figured I&#39;d give it a shot.

... It worked. Amazingly enough it just worked.

Here&#39;s a helpful script to get you on your way in case it takes a while. Use at your own risk, and please... always have backups! #DontBlameMeIfYouDidntBackThingsUp #CowsayChangedMyLife

{{&lt; gist sheldonhull  c13eec8bbd570f762fd3834b19464465 &gt;}}

and finally to remount the database after copying it back to your drive ...

{{&lt; gist sheldonhull  274861a17a7db002bddd55861b781719 &gt;}}

