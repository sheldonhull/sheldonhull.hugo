# 2020-07-06T12:00:00-05:00

Windows users, nice little win for making the great git-town tool even more accessible. 🎉

* install scoop: `iwr -useb get.scoop.sh | iex`
* `scoop install git-town`

This is one of my favorite tools for git workflow. If you use GitHub flow to keep a simple workflow, it&#39;s a life saver.

For example, on a branch and need to start a new bit of work to keep your commits atomic? `switch to master &gt; stash pending work &gt; pull latest with rebase &gt; create new branch &gt; push branch` to remote OR `git town hack feat/tacos`. Need to squash commits and ship to master? `git town ship` What about prune all those remote branches that have been merged? `git town prune-branches` This is one of my favorite git productivity tools (and it&#39;s written in Go 👍  so cross platform and fast)

