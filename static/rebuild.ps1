<#

good snippets here: https://github.com/envygeeks/jekyll-docker
#>
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Set-location $PSScriptRoot
docker-compose build --force-rm #--no-cache

# docker-compose pull
# docker-compose build
# docker-compose up
# docker-compose run sheldonhull.github.io -e JEKYLL_ENV=production


# for running docker container directly/and building, try
# docker build --rm -f "dockerfile.serve" -t blog .
# docker run blog