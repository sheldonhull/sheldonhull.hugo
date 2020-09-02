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
    npm install netlify-cli -g --no-warnings --quiet
}

# Synposis: Run lnk and build for netlify
check setup-node-modules {
    npm install --global --quiet netlify-cli
    npm install --global --quiet atomic-algolia
    npm install --quiet --no-warnings
}

# Synposis: Setup requirements
task setup setup-install-netlify-cli, setup-node-modules
