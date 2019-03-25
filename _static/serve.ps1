#JEKYLL_ENV=development make it crash,
#good snippets here: https://github.com/envygeeks/jekyll-docker
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Set-location $PSScriptRoot
#docker-compose pull
#docker-compose run bundle update
docker-compose up
#docker-compose run sheldonhull.github.io -e JEKYLL_ENV=production


# write-verbose (get-variable pwd | Ft -AutoSize -wrap | out-string)
# docker run --volume=".":/srv/jekyll  `
# -it -p 127.0.0.1:4000:4000 -e JEKYLL_ENV=production jekyll/jekyll:latest `