---
date: "2019-02-07T23:55:00Z"
excerpt: Migrating from hipchat to slack can be a little painful if you have some
  issues similar to mine to cleanup. Maybe this will help save you some time.
last_modified_at: "2019-02-07 23:55:00"
published: true
tags:
- tech
- powershell
- development
title: "Migrating From Hipchat To Slack"
slug: "migrating-from-hipchat-to-slack"
toc: true
typora-copy-images-to: ..\assets\img
typora-root-url: ..\assets\img
---

# Last Minute Migration?
If you are about to perform a last minute migration here's a couple tips as you jump ship from Hipchat and move to Slack. Hipchat is sunsetting I believe on Feb 15th, so I figured I'd share what I do have in case it's helpful, as it won't stay tremendously relevant for long.

## Problem: Hipchat access will be removed and you need more time
Export the hipchat content to a file and upload to your own s3 bucket. That will ensure you have some time to work through the migration and reverse it and try again if you aren't happy with the results.

## Problem: You want to do an initial import of Hipchat content and then update with deltas.
Don't even consider it. The slack import can't add delta content for private messages and private rooms. This means you'd get a lot of duplicate rooms being created. It's better to do the migration import in one batch rather than try to incrementally pull in content. Don't go down this route, as I didn't discover this till later in the process resulting in a time-crunch.

## Problem: You have hipchat users that have email address that have been migrated to a new domain since they were created.
You've migrated to a new domain, but your Hipchat accounts all have the previous email which you've setup as email aliases. You can't easily change in Hipchat due to the fact it's set a profile level, "synced" to the Atlassian account. I had no luck in working on changing this so I instead leveraged the Slack API to bulk update during migration (after all the accounts were created). I mapped the active directory user to the current user by parsing out the email aliases and reversing this. I also created an alternative approach for those that had no matching email alias, and iffy full name matching to use fuzzy matching based soley on last name in the email address.

# Improving Your Migration Experience

## Rename Your Hipchat Rooms Prior to Migration (optional)
The Slack Migration tool is pretty good, but the auto renaming had some rename behavior that didn't align in a clean manner with what my naming convention was going to be. This means to simplify your migration, it's better to rename your Hipchat rooms prior to migration so all your rooms now create slack channels that don't have to be renamed again. Also, if you pull in a delta of content for public rooms, it can automatically match and incrementally add content (this doesn't work for private content).

## Getting Started with Hipchat CLI
It's painful. Hipchat's going into the great beyond so don't expect support for it.

{{< premonition type="warning" title="Important" >}}
API Key for personal won't access full list of rooms in the action `getRoomList` in the CLI. Instead, you'll need to obtain the room list using Add-On token which I found too complex for my one time migration. Instead, you can copy the raw html of the table list, and use a regex script to parse out the room name and number list and use this. You can still perform room rename, just not `sendmessage` action on the rooms using the API token.
{{< /premonition >}}

1.  Install integration from marketplace to the entire account
2.  Download the CLI for running locally
3.  Create API Key. **Important**. This is a 40 character _personal_ key, not the key you create as an admin in the administrators section. You need to go to your personal profile, and then create a key while selecting all permissions in the list to ensure full admin privileges.
4.  To get the raw HTML easily, simply try this Chrome extension for selecting the table and copying the raw html of the table. [CopyTables](http://bit.ly/2S1XwRn)
5.  Open the room listing in Hipchat. Using the extension select `Rows` as your selection criteria and then select `Next Table`. Copy the Raw html to an empty doc. Go to the next page (I had 3 pages to go through) and copy each full table contents to append to the raw html in your doc.
6.  Once you have obtained all the html rows, then run the following script to parse out the html content into a `[pscustomobject[]]` collection to work with in your script.

```powershell
[reflection.assembly]::loadwithpartialname('System.Web')
$HtmlRaw = Get-Content -Path '.\TableRowRawHtml.html'
$Matched = Select-String -InputObject $HtmlRaw -Pattern '((?<=rooms/show/)\d*(?="))(.*?\n*?.*?)(?<=[>])(.*?(?=<))' -AllMatches | Select-Object -ExpandProperty Matches

Write-PSFMessage -Level Important -Message "Total Match Count: $(@($Matched).Count)"

[pscustomobject[]]$RoomListing = $Matched | ForEach-Object -Process {
    $m = $_.Groups
    [pscustomobject]@{
            RoomId           = $m[1].Value
            OriginalRoomName = [system.web.httputility]::HtmlDecode($m[3].Value)
        }
}

Write-PSFMessage -Level Important -Message "Total Rooms Listed: $(@($RoomListing).Count)"
```

Now you'll at least have a listing of room id's and names to work with, even if it took a while to get to it. There are other ways to get the data, such as expanding the `column-format=999` but this timed out on me and this ended actually being the quickest way to proceed.

## Using CLI
To get started, cache your credentials using the fantastic BetterCredentials module. To install you'll need to run `Install-Module BetterCredentials -Scope CurrentUser -AllowClobber -Force`

Then set your cached credentials so we don't need to hard code them into scripts. This will cache it in your Windows Credential manager.

```powershell
$cred = @{
    credential   = ([pscredential]::new('myHipchatEmail' , ("APITokenHere" | ConvertTo-SecureString -AsPlainText -Force) ) )
    type         = 'generic'
    Persistence  = 'localcomputer'
    Target       = 'hipchatapi'
    description  = 'BetterCredentials cached credential for hipchat api'
}
BetterCredentials\Set-Credential @cred
```

Initialize the working directory and default parameters for the CLI so you can easily run other commands without having to redo this over and over.

```powershell
#----------------------------------------------------------------------------#
#                 set location for the java cli environment                  #
#----------------------------------------------------------------------------#
$Dir = Join-Path 'C:\PathToCli' 'atlassian-cli-8.1.0-distribution\atlassian-cli-8.1.0'
Set-Location $Dir
$Url = 'https://TACOS.hipchat.com'

#----------------------------------------------------------------------------#
#              configure default arguments for calling java cli              #
#----------------------------------------------------------------------------#
$JavaCommand = "java -jar $(Join-Path $dir 'lib/hipchat-cli-8.1.0.jar') --server $url --token $Password --autoWait --quiet"
```

Now you can issue some simple commands to start manipulating the CLI.

```powershell
#----------------------------------------------------------------------------#
#          Get Entire Room Listing -- Including Archived & Private           #
#----------------------------------------------------------------------------#
$Action = '--action getRoomList --includePrivate --includeArchived --outputFormat 1'
$result = Invoke-Expression -command "$JavaCommand $Action"
$RoomList = $result | ConvertFrom-CSV
$RoomList | Export-CliXml -Path (Join-Path $ScriptsDir 'CurrentRoomList.xml') -Encoding UTF8 -Force #just so we have a copy saved to review
```

I just tweaked this snippet for other types of commands, but this should get you pretty much what you need to run interactive commands via CLI. I've also written up some Slack functions and will likely share those soon as well as I've found them helpful in automatically fixing email addresses, activating & deactivating users, identifying active billed users, and other basic administrative focused actions.
