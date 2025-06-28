# Yarn


## Setup

- Run `npm install -g yarn` to install Yarn globally.
- Set the version to the latest in the project by running: `yarn set version berry`.

## Gitignore[^yarn-gitignore]

=== &#34;Normal usage&#34;

    ```gitignore title=&#34;Normal Usage&#34;
    pnp.*
    .yarn/*
    !.yarn/patches
    !.yarn/plugins
    !.yarn/releases
    !.yarn/sdks
    !.yarn/versions
    ```

=== &#34;Zero Installs&#34;

    ```gitignore title=&#34;Zero Installs aka Plug &amp; Play&#34;
    .yarn/*
    !.yarn/cache
    !.yarn/patches
    !.yarn/plugins
    !.yarn/releases
    !.yarn/sdks
    !.yarn/versions
    ```

[^yarn-gitignore]: https://yarnpkg.com/getting-started/qa/#which-files-should-be-gitignored


