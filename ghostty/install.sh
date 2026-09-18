#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
target_dir="$config_home/ghostty"
target="$target_dir/config.ghostty"
legacy="$target_dir/config"
stamp="$(date +%Y%m%d-%H%M%S)"

ghostty_bin="$(command -v ghostty || true)"
if [[ -z "$ghostty_bin" && -x /Applications/Ghostty.app/Contents/MacOS/ghostty ]]; then
  ghostty_bin=/Applications/Ghostty.app/Contents/MacOS/ghostty
fi

if [[ -z "$ghostty_bin" && "$(uname)" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
  brew install --cask ghostty
  ghostty_bin=/Applications/Ghostty.app/Contents/MacOS/ghostty
fi

if [[ -n "$ghostty_bin" && "$(uname)" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
  if ! "$ghostty_bin" +list-fonts 2>/dev/null | grep -qi 'FantasqueSansM'; then
    brew install --cask font-fantasque-sans-mono-nerd-font
  fi
fi

mkdir -p "$target_dir"
for f in "$target" "$legacy"; do
  if [[ -e "$f" ]] && ! cmp -s "$f" "$repo_dir/config.ghostty"; then
    mv "$f" "$f.bak.$stamp"
  fi
done
cp "$repo_dir/config.ghostty" "$target"
echo "installed: $target"

if [[ "$(uname)" == "Darwin" ]]; then
  app_support="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
  if [[ -e "$app_support" ]]; then
    if [[ ! -s "$app_support" ]]; then
      rm -f "$app_support"
    else
      echo "warning: $app_support is not empty and overrides $target, merge or remove it manually" >&2
    fi
  fi
fi

if [[ -n "$ghostty_bin" ]]; then
  "$ghostty_bin" +validate-config --config-file="$target"
else
  echo "warning: ghostty not found, skipping validation: https://ghostty.org/docs/install/binary" >&2
fi
