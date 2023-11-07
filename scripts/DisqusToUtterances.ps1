# work in progress: https://lazywinadmin.com/2019/04/moving_blog_comments.html

function Write-Build([ConsoleColor]$Color, [string]$Text)
{
    # [ConsoleColor].GetEnumValues()
    $i = $Host.UI.RawUI
    $_ = $i.ForegroundColor
    try
    {
        $i.ForegroundColor = $Color
        $Text
    }
    finally
    {
        $i.ForegroundColor = $_
    }
}


$file = Join-Path $ENV:USERPROFILE "Downloads\sheldonhull-2020-02-08T23_21_32.546868-all.xml\sheldonhull-2020-02-08T23_21_32.546868-all.xml"
# Load the file
$Disqus = Get-Content -Path $file

# Cast the file to XML format
$DisqusXML = ([xml]$Disqus).disqus

# Output result
# $DisqusXML


# Retrieve all Comments
$AllComments = $DisqusXML.post

# Retrieve properties available for each comments
$Properties = $AllComments | Get-Member -MemberType Property

# Process each Comments
$AllComments | ForEach-Object -process {

    # Store the current comment
    $Comment = $_

    # Create Hashtable to store properties of the current comment
    $Post = @{ }

    # Go through each properties of each comments
    foreach ($prop in $Properties.name)
    {
        if ($prop -eq 'id')
        {
            # Capture Unique IDs
            $Post.DsqID = $Comment.id[0]
            $Post.ID = $Comment.id[1]
        }
        elseif ($prop -eq 'author')
        {
            # Author information
            $Post.AuthorName = $Comment.author.name
            $Post.AuthorIsAnonymous = $Comment.author.isanonymous
        }
        elseif ($prop -eq 'thread')
        {
            # Here is the important data about the
            #  thread the comment belong to
            $Post.ThreadId = $Comment.thread.id
        }
        elseif ($prop -eq 'message')
        {
            $Post.Message = $Comment.message.'#cdata-section'
        }
        else
        {
            # Other properties
            $Post.$prop = ($Comment |
                    Select-Object -ExpandProperty $prop ) -replace '`r`n'
            }
            # Keep the original comment data structure if we need it later
            $Post.raw = $Comment
        }
        # Return a PowerShell object for the current comment
        New-Object -TypeName PSObject -Property $Post
    }


    # Retrieve threads
    $AllThreads = $DisqusXML.thread

    # Retrieve Thread properties
    $Properties = $AllThreads |
        Get-Member -MemberType Property

# Process each threads
$AllThreads = $AllThreads | ForEach-Object -process {

    # Capture Current ThreadItem
    $ThreadItem = $_

    # Create Hashtable for our final object
    $ThreadObj = @{ }

    # Go through each properties of each threads
    foreach ($prop in $Properties.name)
    {
        if ($prop -eq 'id')
        {
            # Thread ID
            $ThreadObj.ID = $ThreadItem.id[0]
        }
        elseif ($prop -eq 'author')
        {
            # Author
            $ThreadObj.AuthorName = $ThreadItem.author.name
            $ThreadObj.AuthorIsAnonymous = $ThreadItem.author.isanonymous
            $ThreadObj.AuthorUsername = $ThreadItem.author.username
        }
        elseif ($prop -eq 'message')
        {
            $ThreadObj.Message = $ThreadItem.message.'#cdata-section'
        }
        elseif ($prop -eq 'category')
        {
            $ThreadObj.Category = ($ThreadItem |
                    Select-Object -ExpandProperty $prop).id
            }
            else
            {
                # Other properties
                $ThreadObj.$prop = ($ThreadItem |
                        Select-Object -ExpandProperty $prop) -replace '`r`n'
                }
                $ThreadObj.raw = $ThreadItem
            }
            # Return a PowerShell object for the current ThreadItem
            New-Object -TypeName PSObject -Property $ThreadObj
        }

        # $AllThreads = $AllThreads |
        # Where-Object -FilterScript {
        #     $_.link -match "\.io\/\d{4}\/.+html$|
        #           \.com\/\d{4}\/.+html$|
        #           \.com\/p\/.+html$|
        #           \.io\/minimal-mistakes\/\d{4}\/.+html$|
        #           \.io\/powershell\/\d{4}\/.+html$|
        #           \.io\/usergroup\/\d{4}\/.+html$" -and
        #     $_.link -notmatch "googleusercontent\.com" }


        Write-Host "`$AllThreads : $($AllThreads.Count)"

        # Create 2 properties 'link2' and 'title2' that will contains the clean information
        #  then group per link (per thread or post)
        #  link2: trimed URL
        #  title2: Remove prefix, weird brackets or weird characters, Encoding issues
        $AllThreads = $AllThreads |
            Select-Object -Property *,
            @{L = 'link2'; E = {
                    $_.link -replace "
        https://|http://|www\.|
        sheldonhull\.com|
        sheldonhull\.github\.io|
        \/minimal-mistakes|
        \/powershell" }
            },
            @{L = 'title2'; E = {
                    $_.title -replace "^sheldonhull:\s" `
                        -replace 'â€™', "'" `
                        -replace "Ã¢â‚¬Â¦|â€¦" `
                        -replace 'â€', '-' `
                        -replace '\/\[', '[' `
                        -replace '\\\/\]', ']' }
            } |
            Group-Object -Property link2


# if we can't find the proper title, we are doing a lookup with the URL using Invoke-WebRequest
# We add a property 'RealTitle' which contain the real title to each thread
$ThreadsUpdated = $AllThreads |
    Sort-Object -Property count |
    ForEach-Object -Process {

        # Capture current post
        $CurrentPost = $_

        # if one comment is found
        if ($CurrentPost.count -eq 1)
        {
            if ($CurrentPost.group.title2 -notmatch '^http')
            {
                # Add REALTitle property
                $RealTitle = $CurrentPost.group.title2
                # output object
                $CurrentPost.group |
                    Select-Object -Property *,
                    @{L = 'RealTitle'; e = { $RealTitle } },
                    @{L = 'ThreadCount'; e = { $CurrentPost.count } }
                }
                elseif ($CurrentPost.group.title2 -match '^http')
                {
                    # lookup online
                    $result = Invoke-WebRequest -Uri $CurrentPost.group.link -Method Get
                    # add REALTitle prop
                    $RealTitle = $result.ParsedHtml.title
                    # output object
                    $CurrentPost.group |
                        Select-Object -Property *, @{L = 'RealTitle'; e = { $RealTitle } }, @{L = 'ThreadCount'; e = { $CurrentPost.count } }
                    }
                }
                if ($CurrentPost.count -gt 1)
                {
                    if ($CurrentPost.group.title2 -notmatch '^http')
                    {
                        # add REALTitle prop
                        $RealTitle = ($CurrentPost.group.title2 |
                                Where-Object -FilterScript {
                                    $_ -notmatch '^http' } |
                                Select-Object -first 1)

                            # Output object
                            $CurrentPost.group |
                                Select-Object -Property *,
                                @{L = 'RealTitle'; e = { $RealTitle } },
                                @{L = 'ThreadCount'; e = { $CurrentPost.count }
                                }
                            }
                            elseif ($CurrentPost.group.title2 -match '^http')
                            {
                                # get url of one
                                $u = ($CurrentPost.group |
                                        Where-Object {
                                            $_.title2 -match '^http' } |
                                        Select-Object -first 1).link

                                    # lookup online
                                    $result = Invoke-WebRequest -Uri $u -Method Get

                                    # add REALTitle prop
                                    $RealTitle = $result.ParsedHtml.title
                                    # output object
                                    $CurrentPost.group |
                                        Select-Object *, @{L = 'RealTitle'; e = { $RealTitle }
                                        }
                                    }
                                    else
                                    {
                                        # add REALTitle prop
                                        $RealTitle = 'unknown'
                                        # output object
                                        $CurrentPost.group | Select-Object *, @{L = 'RealTitle'; e = { $RealTitle } }
                                    }
                                }
                            }

# Append the thread information to the each comment object
# Here we just pass the realtitle and link2
$AllTogether = $AllComments | ForEach-Object -Process {
    $CommentItem = $_
    $ThreadInformation = $ThreadsUpdated |
        Where-Object -FilterScript {
            $_.id -match $CommentItem.ThreadId
        }

        $CommentItem |
            Select-Object -Property *,
            @{L = 'ThreadTitle'; E = { $ThreadInformation.Realtitle } },
            @{L = 'ThreadLink'; E = { $ThreadInformation.link2 } }
        } |
            Group-Object -Property ThreadLink |
            Where-Object -FilterScript { $_.name } | select-object -ExpandProperty group

Write-Build DarkGray "`$AllTogether : $($AllTogether.Count)"
#$AllTogether




# First fetch the module from the PowerShell Gallery
Install-Module -Name powershellforgithub -scope currentuser -verbose
# Import it
Import-Module -Name powershellforgithub

# Specify our Github Token
$key = $ENV:GITHUB_TOKEN
$KeySec = ConvertTo-SecureString $key -AsPlainText -Force
$cred = [pscredential]::new('sheldonhull', $KeySec)

#$cred = Get-Credential -UserName $null

# Set Connection and configuration
Set-GitHubAuthentication -Credential $cred
Set-GitHubConfiguration -DisableLogging -DisableTelemetry


# Define Github commands default params
$GithubSplat = @{
    OwnerName      = 'sheldonhull'
    RepositoryName = 'sheldonhull.hugo'
}
$BlogUrl = 'https://www.sheldonhull.com'

# Retrieve issues
#$issues = Get-GitHubIssue -Uri 'https://github.com/lazywinadmin/lazywinadmin.github.io'
$issues = Get-GitHubIssue @githubsplat

# Process each threads with their comments
# $AllTogether | Select-Object -ExpandProperty group | Sort-Object name -Descending | ForEach-Object -Process {
$AllTogether | Sort-Object name -Descending | ForEach-Object -Process {
    # Capture current thread
    $BlogPost = $_

    # Issue Title, replace the first / and
    #  remove the html at the end of the name
    $IssueTitle = $BlogPost.name -replace '^\/' -replace '\.html'

    # lookup for existing issue
    $IssueObject = $issues |
        Where-Object -filterscript { $_.title -eq $IssueTitle }

        if (-not $IssueObject)
        {
            # Build Header of the post
            $IssueHeader = $BlogPost.group.ThreadTitle |
                Select-Object -first 1

                # Define blog post link
                $BlogPostLink = "$($BlogUrl)$($BlogPost.name)"

                # Define body of the issue
                $Body = @"
# $IssueHeader

[$BlogPostLink]($BlogPostLink)

<!--
Imported via PowerShell on $(Get-Date -Format o)
-->
"@
                # Create an issue
                Write-Build DarkGray "$IssueTitle issue being created"

                $IssueObject = New-GitHubIssue @githubsplat `
                    -Title $IssueTitle `
                    -Body $body `
                    -Label 'blog comments' -WhatIf
            }

            # Sort comment by createdAt
            $BlogPost.group |
                Where-Object { $_.isspam -like '*false*' } |
                Sort-Object createdAt |
                ForEach-Object {

                    # Current comment
                    $CurrenComment = $_

                    # Author update
                    #  we replace my post author name :)
                    $AuthorName = $($CurrenComment.AuthorName)
                    switch -regex ($AuthorName)
                    {
                        'Sheldon' { $AuthorName = 'Sheldon Hull' }
                        default { }
                    }

                    # Define body of the comment
                    $CommentBody = @"

## **Author**: $AuthorName
**Posted on**: ``$($CurrenComment.createdAt)``
$($CurrenComment.message)

<!--
Imported via PowerShell on $(Get-Date -Format o)
Json_original_message:
$($CurrenComment|Select-Object -ExcludeProperty raw|ConvertTo-Json)
-->
"@
                    # Create Comment
                    Write-Build DarkGray "$($IssueObject.number) comment added"

                    New-GitHubComment @githubsplat `
                        -Issue $IssueObject.number `
                        -Body $CommentBody -WhatIf
                }
                # Close issue
                Update-GitHubIssue @githubsplat `
                    -Issue $IssueObject.number `
                    -State Closed -WhatIf

                read-host "enter to continue"
            }
