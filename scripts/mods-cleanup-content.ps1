#!/usr/bin/env pwsh

# Define the directory containing markdown files

filter updatefiles {
  [cmdletbinding()]
  param(
    $markdownDir,
    [switch]$ProcessOnlyFirst
  )
  $compactprompt = "you are looking for any logic issues in code snippets, maybe a typo or something simple I missed when in a hurry.  you are looking for any common typos or mistakes in grammar that could be helpful.  You will minimize these changes to only the ones that are important and useful for readers.  output the text raw as the response, since I'm going output your result straight into the file  preserve the original file otherwise, including front matter, formatting, and new lines, etc. Only fix the priority issues mentioned.  don't provide confirmation or explanation as I'm going to pipe this output back to a file. Don't make up anything if nothing is provided, just return the original content as if nothing wrong happened. Maintain the active present tense to keep things succint when it's already been used. code logging can preserve exist case, unless it's inconsistent. If a code comment contradicts the content then remove it or update it if it add's important context.Powershell snippets use code comments that are #."
  $markdownFiles = Get-ChildItem -Path $markdownDir -Filter *.md -Recurse
  $totalFiles = $markdownFiles.Count
  $processedFiles = 0

  foreach ($file in $markdownFiles) {
    $processedFiles++

    $fileContent = Get-Content -Path $file.FullName -Raw

    try {
      $transformedContent = $fileContent | &mods --no-cache --api ollama --quiet --no-limit "$compactprompt"
      Set-Content -Path $file.FullName -Value $transformedContent

      Write-Host "✔️ Processed $($file.Name) ($processedFiles of $totalFiles)"
    }
    catch {
      Write-Error "❌ Failed to process $($file.Name) due to : $($_.Exception.Message)"
    }
    if ($ProcessOnlyFirst ) {
      return
    }
  }
}
updatefiles 'content/notes'
