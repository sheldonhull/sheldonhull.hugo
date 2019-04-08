Get-ChildItem 'C:\GIT\sheldonhull.hugo\content' -recurse -filter *.md | ForEach-Object {

    $Content = Get-Content -Raw -Path $_.FullName
    $slug = $_.basename -replace '\d{4}\-\d{2}\-\d{2}\-', '' -replace '\.', '' -replace '\s', '-'
    $slug = $slug.ToLower()
    $newslugline = "slug: `"$slug`""
    $content = $content -replace '(?s)slug\:.*', $newslugline
    Write-Warning $Content
    Read-Host "enter to continue"
}