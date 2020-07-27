task git-initialize-submodules {
    git submodule update --init --recursive
    git submodule update --recursive
}

task git-update-theme-from-remote {
    git submodule update --rebase --remote

}
