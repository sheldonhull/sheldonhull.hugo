<#

good snippets here: https://github.com/envygeeks/jekyll-docker
#>
[Console]::OutputEncoding = [System.Text.Encoding]::Default
Set-location $PSScriptRoot
docker-compose pull
docker-compose run bundle update
docker-compose up
#docker-compose run sheldonhull.github.io -e JEKYLL_ENV=production