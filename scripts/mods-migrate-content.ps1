# Define the directory containing markdown files
$markdownDir = 'content/notes'

# Get all markdown files in the directory
$prompt = @'

- you are helping me fix markdown formatting for hugo instead of the prior mkdocs.
- admonitions are signified by ??? and !!!
- ONLY help with admonitions, not any other content.
- there may be more than one occurence of these, so so make sure to end each instance once the indentation is back to the current body.
- refactor just the admonition sections into hugo admonitions, leave other content alone.
- provide back the entire original content exactly as it was sent except for the fixed admonition sections.
- don't provide confirmation or explanation as I'm going to pipe this output back to a file.
- extract the title from the mkdocs admonition when it's provided on the same line as the admonition.
- open=false when ??? is used and open=true when !!! is used.
- the valid admonition type to use based on the content can be set from this list.
- You can adjust the type to any of these that fit better than the current type.
- The admonition in the original continues until the indentation returns to normal
- blank line inside the admontion and before the close is required.

valid admonition types: note,abstract,info,tip,success,question,warning,failure,danger,bug,example,quote

Example of one valid transormation. The original is wrapped by --- to delimt start and finish and will be followed by another --- and --- to delimit the example transformation.
Do not consider the --- in the output, it's just to help parse the instructions.

---original
??? example "Help Me With Using Goldmark For Markdown Parsing"

    This failed repeatedly.
    The code examples were promising but made up quite a few methods and approaches that were non-existent in the actual code base and had no code examples matching in the repo.
    Goldmark doesn't have a lot of use examples compared to many projects, so I think the quality of the suggestions degraded with a broader question.

    It _looked_ great, but with improper method signatures it really suffered.

---

---transformation
{{< admonition type="example" title="Help Me With Using Goldmark For Markdown Parsing" open=false >}}

This failed repeatedly.
The code examples were promising but made up quite a few methods and approaches that were non-existent in the actual code base and had no code examples matching in the repo.
Goldmark doesn't have a lot of use examples compared to many projects, so I think the quality of the suggestions degraded with a broader question.

It _looked_ great, but with improper method signatures it really suffered.
{{< /admonition >}}
---
'@

filter updatefiles {
  [cmdletbinding()]
  param(
    $markdownDir,
    [switch]$ProcessOnlyFirst
  )
  $markdownFiles = Get-ChildItem -Path $markdownDir -Filter *.md -Recurse

  foreach ($file in $markdownFiles) {

    # Check for admonitions in the file
    $admonitionCount = Select-String -Path $file.FullName -Pattern '[!]{3}|[?]{3}' -AllMatches | Measure-Object

    if ($admonitionCount.Count -eq 0) {
      Write-Host "⚠️ No admonitions noted in $($file.Name)"
      continue
    }
    else {
      Write-Host "ℹ️ $($admonitionCount.Count) admonitions found in $($file.Name)"
    }

    # Read the content of the file
    $fileContent = Get-Content -Path $file.FullName -Raw

    try {
      # Transform the content using mods
      $transformedContent = $fileContent | mods --api ollama --raw -p $Prompt | Out-String

      # Overwrite the file with the transformed content
      Set-Content -Path $file.FullName -Value $transformedContent

      # Log the progress
      Write-Host "✔️ Processed $($file.Name)"
    }
    catch {
      Write-Error "❌ Failed to process $($file.Name) due to : $($_.Exception.Message)"
    }
    if ($ProcessOnlyFirst ) {
      return
    }
  }

}
