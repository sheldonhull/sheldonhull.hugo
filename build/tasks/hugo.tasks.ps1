Task hugo-serve {

    switch -Wildcard ($PSVersionTable.OS) {
        '*Windows*' {
            hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc

        }
        '*Darwin*' {
            Write-Build DarkGray 'Setting hugo path as fails to find in env variables'
            #not working and no time to debug this
            #$hugo = &bash -c 'which hugo'
            #&$hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc
            &/usr/local/bin/hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc
        }
        '*Linux*' {
            &/usr/bin/hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc
        }
    }

}

#Synposis: Will need to adjust for Round 2 later. For now, this just generates a new
Task hugo-new-100daysOfCode {

    $files = Get-ChildItem -Path content/microblog -Filter '*day*.md'
    [int]$DayCounter = $files.ForEach{
        $Day = ($_.Name -split '-')[-1]
        $day.Trim('.md')
    } | Sort-Object -Descending | Select-Object -First 1
    [int]$NewDayCounter = ++$DayCounter

    $FileName =  "microblog/$(Get-Date -Format 'yyyy-MM-dd')-go-R1-day-$NewDayCounter.md"
    $NewFile = Join-Path $BuildRoot 'content' $FileName
    Write-Build DarkGray "Creating file: $NewFile"


    switch -Wildcard ($PSVersionTable.OS) {
        '*Windows*' {
            &hugo new $FileName --kind 100DaysOfCode

        }
        '*Darwin*' {
            &/usr/local/bin/hugo new $FileName --kind 100DaysOfCode
        }
        '*Linux*' {
            throw 'not implemented yet'
        }
    }
    $Content = Get-Content $NewFile -Raw
    $Content = $Content.Replace('VAR_DAYCOUNTER', $NewDayCounter).Replace('VAR_DAYCOUNTERIMAGE', [string]"$NewDayCounter".PadLeft(3, '0'))
    $Content | Out-File $NewFile -Force
    Write-Build Green "Successfully created file: $NewFile"
}

#Synposis: Will need to adjust for Round 2 later. For now, this just generates a new
Task hugo-new-microblog {
    $Title = Read-Host "Enter title"
    $Title = $Title.ToLower().Trim() -replace '\s', '-'
    $FileName =  "microblog/$(Get-Date -Format 'yyyy-MM-dd')-$Title.md"
    $NewFile = Join-Path $BuildRoot 'content' $FileName
    Write-Build DarkGray "Creating file: $NewFile"
    switch -Wildcard ($PSVersionTable.OS) {
        '*Windows*' {
            &hugo new $FileName --kind microblog
        }
        '*Darwin*' {
            &/usr/local/bin/hugo new $FileName --kind microblog
        }
        '*Linux*' {
            throw 'not implemented yet'
        }
    }
    $Content = Get-Content $NewFile -Raw
    $Content = $Content.Replace('VAR_TITLE', $Title)
    $Content | Out-File $NewFile -Force
    Write-Build Green "Successfully created file: $NewFile"
}

#Synposis: Will need to adjust for Round 2 later. For now, this just generates a new
Task hugo-new-blog {
    $Title = Read-Host 'Enter title'
    $Title = $Title.ToLower().Trim() -replace '\s', '-'
    $FileName =  "blog/$(Get-Date -Format 'yyyy-MM-dd')-$Title.md"
    $NewFile = Join-Path $BuildRoot 'content' $FileName
    Write-Build DarkGray "Creating file: $NewFile"
    switch -Wildcard ($PSVersionTable.OS) {
        '*Windows*' {
            &hugo new $FileName --kind blog
        }
        '*Darwin*' {
            &/usr/local/bin/hugo new $FileName --kind blog
        }
        '*Linux*' {
            throw 'not implemented yet'
        }
    }
    # $Content = Get-Content $NewFile -Raw
    # $Content = $Content.Replace('VAR_TITLE', $Title)
    # $Content | Out-File $NewFile -Force
    Write-Build Green "Successfully created file: $NewFile"
}

task netlify-build {
    #&"$ENV:USERPROFILE\AppData\Roaming\npm\node_modules\netlify-cli\bin\run" build
    npm run netlify build

}

task algolia-update {
    #$ENV:ALGOLIA_INDEX_FILE = 'public/algolia.json'
    #npm run algolia "$BuildRoot/public/algolia.json"
    npm run algolia "$BuildRoot/_site/algolia.json"
}

# Synposis: Build and update index
task build netlify-build,algolia-update