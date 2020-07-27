check setup-hugo {

    switch -Wildcard ($PSVersionTable.OS)
    {
        'Windows' { choco install hugo --version $HUGO_VERSION ---quiet }
        'Darwin' { brew install 'https://raw.githubusercontent.com/Homebrew/homebrew-core/5c50ad9cf3b3145b293edbc01e7fa88583dd0024/Formula/hugo.rb' }
        'Linux'
        {
            throw "not implemented yet"
        }
    }

}

Task setup-install-netlify-cli {
    npm install netlify-cli -g
}
