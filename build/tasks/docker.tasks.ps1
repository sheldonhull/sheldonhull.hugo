# Synopsis: Pull latest
Task docker-pull {
    docker build --pull --rm -f ".devcontainer\Dockerfile" -t sheldonhull:latest ".devcontainer"
}
