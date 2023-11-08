---

date: 2023-05-03T18:07:04+0000
title: How Many Commits Did You Make in Last Month
slug: how-many-commits-did-you-make-in-last-month
tags:
- tech
- development
- microblog
- openai
- shell

images: [/images/2023-05-03-how-many-commits-did-you-make-in-last-month.png]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

Been playing with [opencommit](https://github.com/di-sukharev/opencommit) and wanted to assess how much using it on every single commit I still could track locally might cost me.

This script loops through all the `${HOME}/git` directories and totals the commits made in last month.

Looks like using OpenAI's api would cost me about $4-$5 if I'd used on every single commit and the size of the commits was smaller.

Not as bad as I'd thought it would be.

```shell
#!/usr/bin/env bash
# Use https://github.com/sharkdp/fd
set -e
# Initialize variables
total_commits=0
username=$(whoami)

# Capture the directories found by fd to a variable
directories=$(fd -H --max-depth 6 "^\.git$" "$HOME/git")

# Loop through each directory

for directory in $directories; do
    # Change to the git directory
    printf "...⚙️ $(dirname $directory)" &&
    pushd "$(dirname "$directory")" &&
    # Get the repo name
    repo=$(basename "$PWD") &&
    # Get the count of commits made by a user with the partial name match of "username"
    commits=$(git log \
                --branches \
                --author=".*${username}.*" \
                --since="1 month ago" \
                --no-merges \
                --format="%H" | wc -l | awk "{print \$1}"
    ) &&
    # Output the repo name and count of commits
    printf "\t%-50s %-50s \n" "$repo", "$commits" &&
    # Add to the total count of commits
    total_commits=$((total_commits + commits)) &&
    popd
done

# Output the total count of commits
echo "Total commits: $total_commits"

```
