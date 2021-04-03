Task hugo-serve {
    switch -Wildcard ($PSVersionTable.OS)
    {
        '*Windows*'
        {
            hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc

        }
        '*Darwin*'
        {
            Write-Build DarkGray 'Setting hugo path as fails to find in env variables'
            #not working and no time to debug this
            #$hugo = &bash -c 'which hugo'
            #&$hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc
            &/usr/local/bin/hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc
        }
        '*Linux*'
        {
            &hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc
        }
    }
}


task hugo-serve-nocache {
    Write-Build Red "Error. Going to try to clean mod cache. Try also `hugo serve --ignoreCache` and see if that helps.`nTry `$ENV:HUGO_CACHEDIR=./tmp as one additional fix"
    &/usr/bin/hugo mod clean
    $ENV:HUGO_CACHEDIR = '.cache'
    &/usr/bin/hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc --ignoreCache

}
#Synposis: Will need to adjust for Round 2 later. For now, this just generates a new
Task hugo-new-100-days-of-code {
    $Date = Read-Host -Message "Enter date override or enter to continue with $(Get-Date -Format 'yyyy-MM-dd')"
    if (-not $Date)
    {
        $Year = $(Get-Date -Format 'yyyy')
        $Date = $(Get-Date -Format 'yyyy-MM-dd')
    }

    $files = Get-ChildItem -Path content/microblog -Filter '*day*.md' -Recurse
    [int]$DayCounter = ($files.ForEach{
            $Day = ($_.Name -split '-')[-1]
            $day.Trim('.md')
        } | Sort-Object -Descending | Measure-Object -Maximum).Maximum
    [int]$NewDayCounter = ++$DayCounter

    $FileName = "microblog/$Year/$Date-go-R1-day-$NewDayCounter.md"
    $NewFile = Join-Path $BuildRoot 'content' $FileName
    Write-Build DarkGray "Creating file: $NewFile"


    switch -Wildcard ($PSVersionTable.OS)
    {
        '*Windows*'
        {
            &hugo new $FileName --kind 100DaysOfCode

        }
        '*Darwin*'
        {
            &/usr/local/bin/hugo new $FileName --kind 100DaysOfCode
        }
        '*Linux*'
        {
            &$(which hugo) new $FileName --kind 100DaysOfCode
        }
    }
    $Content = Get-Content $NewFile -Raw
    $Content = $Content.Replace('VAR_DAYCOUNTER', $NewDayCounter).Replace('VAR_DAYCOUNTERIMAGE', [string]"$NewDayCounter".PadLeft(3, '0')).Replace((Get-Date -Format 'yyyy-MM-dd'), $Date)
    $Content = $Content -replace 'title: \d{4}.\d{2}.\d{2}\s+', 'title: ' -replace 'slug: \d{4}.\d{2}.\d{2}-', 'slug: '

    $Content | Out-File $NewFile -Force
    Write-Build Green "Successfully created file: $NewFile"
}

#Synposis: Will need to adjust for Round 2 later. For now, this just generates a new
Task hugo-new-microblog {
    $Title = Read-Host 'Enter title'
    $Title = $Title.ToLower().Trim() -replace '\s', '-'
    $Date = Read-Host -Message "Enter date override or enter to continue with $(Get-Date -Format 'yyyy-MM-dd')"
    if (-not $Date)
    {
        $Year = $(Get-Date -Format 'yyyy')
        $Date = $(Get-Date -Format 'yyyy-MM-dd')
    }
    $FileName = "microblog/$Year/$Date-$Title.md"
    $NewFile = Join-Path $BuildRoot 'content' $FileName
    Write-Build DarkGray "Creating file: $NewFile"
    switch -Wildcard ($PSVersionTable.OS)
    {
        '*Windows*'
        {
            &hugo new $FileName --kind microblog
        }
        '*Darwin*'
        {
            &/usr/local/bin/hugo new $FileName --kind microblog
        }
        '*Linux*'
        {
            &$(which hugo) new $FileName --kind microblog
        }
    }
    $Content = Get-Content $NewFile -Raw
    $Content = $Content.Replace('VAR_TITLE', $Title)
    $Content = $Content.Replace((Get-Date -Format 'yyyy-MM-dd'), $Date)
    $Content | Out-File $NewFile -Force
    Write-Build Green "Successfully created file: $NewFile"
}

#Synposis: Will need to adjust for Round 2 later. For now, this just generates a new
Task hugo-new-blog {
    $Title = Read-Host 'Enter title'
    $Title = $Title.ToLower().Trim() -replace '\s', '-'
    $Date = Read-Host -Message "Enter date override or enter to continue with $(Get-Date -Format 'yyyy-MM-dd')"
    if (-not $Date)
    {
        $Year = $(Get-Date -Format 'yyyy')
        $Date = $(Get-Date -Format 'yyyy-MM-dd')
    }
    $FileName = "blog/$Year/$Date-$Title.md"
    $NewFile = Join-Path $BuildRoot 'content' $FileName
    Write-Build DarkGray "Creating file: $NewFile"
    switch -Wildcard ($PSVersionTable.OS)
    {
        '*Windows*'
        {
            &hugo new $FileName --kind blog
        }
        '*Darwin*'
        {
            &/usr/local/bin/hugo new $FileName --kind blog
        }
        '*Linux*'
        {
            &$(which hugo) new $FileName --kind blog

        }
    }
    $Content = Get-Content $NewFile -Raw
    $Content = $Content.Replace((Get-Date -Format 'yyyy-MM-dd'), $Date)
    $Content | Out-File $NewFile -Force
    Write-Build Green "Successfully created file: $NewFile"
}

task netlify-build {
    #&"$ENV:USERPROFILE\AppData\Roaming\npm\node_modules\netlify-cli\bin\run" build
    npm run netlify build

}

task algolia-update {
    Write-Warning 'Use task build-algolia algolia for this'
    #$ENV:ALGOLIA_INDEX_FILE = 'public/algolia.json'
    #npm run algolia "$BuildRoot/public/algolia.json"
    npm run algolia "$BuildRoot/_site/algolia.json"
}

# Synposis: Build and update index
task build netlify-build, algolia-update
