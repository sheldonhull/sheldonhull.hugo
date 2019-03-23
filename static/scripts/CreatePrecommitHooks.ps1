@'
#!/bin/sh
# Contents of .git/hooks/pre-commit
# Precommit hook to automatically update any page with last_modified_at: with the latest date, thus I don't have to populate this.
git diff --cached --name-status | grep "^M" | while read a b; do
  cat $b | sed "/---.*/,/---.*/s/^last_modified_at:.*$/last_modified_at: $(date -u "+%Y-%m-%d")/" > tmp
  mv tmp $b
  git add $b
done
'@ | Out-File "$PSScriptRoot\..\.git\hooks\pre-commit" -force