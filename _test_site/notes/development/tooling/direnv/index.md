# direnv


## Example Direnv

- Load `.envrc` from your home directory.
- Check for `aqua` tool for the project and warn if not found, to allow tooling to be installed.
- Ensure `$GOPATH/bin` is available in path so that Go tooling can be resolved.
  Put it at the end of PATH so that aqua-based tooling takes precedence.

```shell title=&#34;.envrc&#34;
source_env &#34;$HOME&#34;
export DIRENV_WARN_TIMEOUT=&#39;10s&#39;
# OPTIONAL: export PATH=&#34;${PATH}:${GOPATH}/bin&#34;
export MAGEFILE_ENABLE_COLOR=1

INFO_COLOR=&#34;\033[1;30;40m&#34;
RESET_COLOR=&#34;\033[0m&#34;
WARNING_COLOR=&#34;\033[33m&#34;
END_WARNING_COLOR=&#34;\033[0m&#34;
WORKING_COLOR=&#34;\033[94m&#34;
BACKGROUND_GREEN=&#34;\033[94m&#34;
RESET_BACKGROUND=&#34;\033[0;49m&#34;
BACKGROUND_LIGHT_GREEN=&#34;\033[1;102;30m&#34;
BACKGROUND_BLUE=&#34;\033[44;30m&#34;
BACKGROUND_LIGHT_YELLOW=&#34;\033[1;103;30m&#34;

if command -v aqua &gt;/dev/null 2&gt;&amp;1; then
  printf &#34;${INFO_COLOR}✔️ aqua detected${RESET_COLOR}\n&#34;
else
  printf &#34;❌ ${WARNING_COLOR}aqua command not recognized${RESET_COLOR}\n&#34;
  printf &#34;\t${WORKING_COLOR}👉 Please install aqua to automatically set up all dev tools for the project:${RESET_COLOR}${BACKGROUND_GREEN}https://aquaproj.github.io/docs/tutorial${RESET_COLOR}\n&#34;
  printf &#34;\tYou&#39;ll need to make sure the following statement is in your profile (.zshrc, .bashrc, .profile, etc)\n&#34;
  printf &#34;\t${INFO_COLOR}${BACKGROUND_LIGHT_YELLOW}export PATH=\&#34;\${AQUA_ROOT_DIR:-\${XDG_DATA_HOME:-\$HOME/.local/share}/aquaproj-aqua}/bin:\$PATH\&#34;${RESET_COLOR}\n&#34;
fi
```

