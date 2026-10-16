#!/usr/bin/env bash

# This script can be run from anywhere, as long as it stays in the top-level directory (root) of this repository.

set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}"

if [ ! -d .config ]; then
    mkdir .config
fi

if [ ! -d .oh-my-zsh ]; then
    mkdir .oh-my-zsh
fi

# Zsh
cp "$HOME/.zshrc" .

# Oh My Zsh custom folder (the .git folders of plugins and themes are left out,
# otherwise git would treat them as embedded repositories and skip their files)
rm -rf .oh-my-zsh/custom
cp -r "$ZSH_CUSTOM" .oh-my-zsh/custom
find .oh-my-zsh/custom -name .git -prune -exec rm -rf {} +

# Where each plugin/theme came from, so they can be re-cloned after a restore
: > plugin-sources.txt
for d in "$ZSH_CUSTOM"/plugins/*/ "$ZSH_CUSTOM"/themes/*/; do
    if [ -e "$d/.git" ]; then
        url="$(git -C "$d" remote get-url origin 2>/dev/null || true)"
        if [ -n "$url" ]; then
            echo "$(basename "$d") $url" >> plugin-sources.txt
        fi
    fi
done

# Alacritty
rm -rf .config/alacritty
cp -r "$HOME/.config/alacritty" .config

# Espanso
rm -rf .config/espanso
cp -r "$HOME/.config/espanso" .config

# Secrets check (only the files you wrote yourself, not the plugins)
if grep -rnIiE \
    '(token|secret|passw(or)?d|api[_-]?key)[a-z_]*[[:space:]]*[=:]|ghp_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,}|AKIA[A-Z0-9]{16}|BEGIN [A-Z ]*PRIVATE KEY' \
    .zshrc .config; then
    echo
    echo "WARNING: possible secrets found above. Review them before pushing to GitHub."
else
    echo "Backup finished. No obvious secrets found."
fi
