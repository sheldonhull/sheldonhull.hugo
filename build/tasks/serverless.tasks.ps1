task serverless-deploy {
    switch -Wildcard ($PSVersionTable.OS)
    {
        'Windows' { choco install aws-vault -y --no-progress --quiet }
        'Darwin' { brew cask install aws-vault }
        'Linux'
        {
            sudo aws-vault exec $ENV:AWS_PROFILE --no-session
            export PATH="$HOME/.serverless/bin:$PATH"
            export AWS_DEFAULT_REGION="eu-west-1"
            serverless deploy --verbose
        }
    }

}
