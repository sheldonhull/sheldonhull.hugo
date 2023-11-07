Get-ChildItem 'C:\GIT\sheldonhull.hugo\content' -recurse -filter *.md | ForEach-Object {

    $Content = Get-Content -Raw -Path $_.FullName
    $slug = $_.basename -replace '\d{4}\-\d{2}\-\d{2}\-', '' -replace '\.', '' -replace '\s', '-'
    $slug = $slug.ToLower()
    $newslugline = "slug: `"$slug`""
    $content = $content -replace 'slug\:\s\".*?\"', $newslugline
    #Write-Warning $Content
    #Read-Host "enter to continue"
    [System.IO.File]::WriteAllLines($_.FullName, $Content, [System.Text.UTF8Encoding]::new($false))
}
