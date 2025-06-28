# How Many Commits Did You Make in Last Month


Been playing with [opencommit](https://github.com/di-sukharev/opencommit) and wanted to assess how much using it on every single commit I still could track locally might cost me.

This script loops through all the `${HOME}/git` directories and totals the commits made in last month.

Looks like using OpenAI&#39;s api would cost me about $4-$5 if I&#39;d used on every single commit and the size of the commits was smaller.

Not as bad as I&#39;d thought it would be.

```shell
#!/usr/bin/env bash
# Use https://github.com/sharkdp/fd
set -e
# Initialize variables
total_commits=0
username=$(whoami)

# Capture the directories found by fd to a variable
directories=$(fd -H --max-depth 6 &#34;^\.git$&#34; &#34;$HOME/git&#34;)

# Loop through each directory

for directory in $directories; do
    # Change to the git directory
    printf &#34;...⚙️ $(dirname $directory)&#34; &amp;&amp;
    pushd &#34;$(dirname &#34;$directory&#34;)&#34; &amp;&amp;
    # Get the repo name
    repo=$(basename &#34;$PWD&#34;) &amp;&amp;
    # Get the count of commits made by a user with the partial name match of &#34;username&#34;
    commits=$(git log \
                --branches \
                --author=&#34;.*${username}.*&#34; \
                --since=&#34;1 month ago&#34; \
                --no-merges \
                --format=&#34;%H&#34; | wc -l | awk &#34;{print \$1}&#34;
    ) &amp;&amp;
    # Output the repo name and count of commits
    printf &#34;\t%-50s %-50s \n&#34; &#34;$repo&#34;, &#34;$commits&#34; &amp;&amp;
    # Add to the total count of commits
    total_commits=$((total_commits &#43; commits)) &amp;&amp;
    popd
done

# Output the total count of commits
echo &#34;Total commits: $total_commits&#34;

```

