---
title: direnv
description: Direnv for loading environment variables for projects.
date: 2023-03-24 14:46
tags:
  - tooling
categories: ""
lastmod: 2023-03-24 14:52
---

## Example Direnv

- Load `.envrc` from your home directory.
- Check for `aqua` tool for the project and warn if not found, to allow tooling to be installed.
- Ensure `$GOPATH/bin` is available in path so that Go tooling can be resolved.
  Put it at the end of PATH so that aqua-based tooling takes precedence.

```shell title=".envrc"
source_env "$HOME"
export DIRENV_WARN_TIMEOUT='10s'
# OPTIONAL: export PATH="${PATH}:${GOPATH}/bin"
export MAGEFILE_ENABLE_COLOR=1

INFO_COLOR="\033[1;30;40m"
RESET_COLOR="\033[0m"
WARNING_COLOR="\033[33m"
END_WARNING_COLOR="\033[0m"
WORKING_COLOR="\033[94m"
BACKGROUND_GREEN="\033[94m"
RESET_BACKGROUND="\033[0;49m"
BACKGROUND_LIGHT_GREEN="\033[1;102;30m"
BACKGROUND_BLUE="\033[44;30m"
BACKGROUND_LIGHT_YELLOW="\033[1;103;30m"

if command -v aqua >/dev/null 2>&1; then
  printf "${INFO_COLOR}✔️ aqua detected${RESET_COLOR}\n"
else
  printf "❌ ${WARNING_COLOR}aqua command not recognized${RESET_COLOR}\n"
  printf "\t${WORKING_COLOR}👉 Please install aqua to automatically set up all dev tools for the project:${RESET_COLOR}${BACKGROUND_GREEN}https://aquaproj.github.io/docs/tutorial${RESET_COLOR}\n"
  printf "\tYou'll need to make sure the following statement is in your profile (.zshrc, .bashrc, .profile, etc)\n"
  printf "\t${INFO_COLOR}${BACKGROUND_LIGHT_YELLOW}export PATH=\"\${AQUA_ROOT_DIR:-\${XDG_DATA_HOME:-\$HOME/.local/share}/aquaproj-aqua}/bin:\$PATH\"${RESET_COLOR}\n"
fi
```
