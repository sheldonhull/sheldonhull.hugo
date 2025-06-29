---
title: Yarn
date: 2023-03-08T13:49:00
tags:
  - front-end
  - yarn
  - package-management
lastmod: 2023-03-08T13:58:00
---

## Setup

- Run `npm install -g yarn` to install Yarn globally.
- Set the version to the latest in the project by running: `yarn set version berry`.

## Gitignore[^yarn-gitignore]

=== "Normal usage"

    ```gitignore title="Normal Usage"
    pnp.*
    .yarn/*
    !.yarn/patches
    !.yarn/plugins
    !.yarn/releases
    !.yarn/sdks
    !.yarn/versions
    ```

=== "Zero Installs"

    ```gitignore title="Zero Installs aka Plug & Play"
    .yarn/*
    !.yarn/cache
    !.yarn/patches
    !.yarn/plugins
    !.yarn/releases
    !.yarn/sdks
    !.yarn/versions
    ```

[^yarn-gitignore]: https://yarnpkg.com/getting-started/qa/#which-files-should-be-gitignored

