docker run --rm --volume="$PWD":/srv/jekyll -it -p 4000:4000 jekyll/jekyll:builder jekyll serve --force_polling --host 0.0.0.0 -config _config.yml,_config.dev.yml --verbose
