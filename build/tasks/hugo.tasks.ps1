Task hugo-serve {

    switch -Wildcard ($PSVersionTable.OS)
    {
        '*Windows*'
        {
            hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc

        }
        '*Darwin*'
        {
            Write-Build DarkGray "Setting hugo path as fails to find in env variables"
            #not working and no time to debug this
            #$hugo = &bash -c 'which hugo'
            #&$hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc
            &/usr/local/bin/hugo serve -b localhost:1313 --verbose --enableGitInfo -d _site --buildFuture --buildDrafts --gc
        }
        '*Linux*'
        {
            throw "not implemented yet"
        }
    }

}

Task hugo-algolia-update {
    netlify build
    $ENV:ALGOLIA_INDEX_FILE = "public/algolia.json"
    run algolia "$BuildRoot/public/algolia.json"
}
