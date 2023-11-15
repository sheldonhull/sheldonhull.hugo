---
title: Yarn
date: 2023-03-08 13:49
tags:
  - front-end
  - yarn
  - package-management
lastmod: 2023-03-08 13:58
---

## Setup

- `npm install -g yarn`
- Now set the version to latest in the project by running: `yarn set version berry`.

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
