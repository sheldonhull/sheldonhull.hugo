#!/usr/env/bin bash
if ! command -v asdf &>/dev/null; then
    echo "ℹ️ asdf command not detected"
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.9.0
    source "$HOME/.asdf/asdf.sh"
    asdf update
    echo "ℹ️ asdf installed: $(asdf version)"
    echo "source \"$HOME/.asdf/asdf.sh\"" >>"${HOME}/.bashrc"
    mkdir -p "$HOME/.config/fish"
    echo "source \"$HOME/.asdf/asdf.sh\"" >>"${HOME}/.config/fish/config.fish"

else
    source "$HOME/.asdf/asdf.sh"
    asdf update
    echo "ℹ️ asdf installed: $(asdf version)"
fi

export ASDF_DATA_DIR="$HOME/.asdf"
if [[ -e "$HOME/.asdf/asdf.sh" ]]; then
    CURRENT_ASDF_PLUGINS=$(asdf plugin list || true)
    # shellcheck disable=SC2034
    while read -r PLUGIN VERSION || [[ -n "$PLUGIN" ]]; do
        if ! (echo "$CURRENT_ASDF_PLUGINS" | grep "$PLUGIN" &>/dev/null); then
            asdf plugin-add "$PLUGIN" || true
        fi
        # Install tool
        asdf install "$PLUGIN" "$VERSION"
        # enable running tool outside of monorepo directory
        asdf global "$PLUGIN" "$VERSION"
    done <"$HOME/.tool-versions"
fi
