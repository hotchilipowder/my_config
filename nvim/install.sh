#!/usr/bin/env bash
# Install isolated profiles; never replace the existing ~/.config/nvim.
set -euo pipefail
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
profile=all
config_root=${XDG_CONFIG_HOME:-"$HOME/.config"}
bin_dir="$HOME/.local/bin"
usage() {
  echo 'Usage: bash nvim/install.sh [light|daily|all] [--config-home DIR] [--bin-dir DIR]'
}
while (($#)); do
  case "$1" in
    light|daily|all) profile=$1; shift ;;
    --config-home|--bin-dir)
      if (($# < 2)) || [[ -z "$2" ]]; then usage >&2; exit 2; fi
      if [[ "$1" == --config-home ]]; then config_root=$2; else bin_dir=$2; fi
      shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done
command -v nvim >/dev/null || { echo 'Install Neovim first (macOS: brew install neovim).' >&2; exit 1; }
required=0.10
[[ "$profile" == light ]] || required=0.12
nvim --clean --headless -i NONE "+lua if vim.fn.has('nvim-$required') == 0 then vim.cmd('cquit 1') end" +qa || {
  echo "This profile requires Neovim $required+." >&2; exit 1;
}
mkdir -p "$config_root" "$bin_dir"
config_root=$(cd -- "$config_root" && pwd)
bin_dir=$(cd -- "$bin_dir" && pwd)
install_profile() {
  local app=$1 init=$2 destination backup launcher
  destination="$config_root/$app"
  if [[ -e "$destination" || -L "$destination" ]]; then
    backup=$(mktemp -d "$config_root/$app.backup.XXXXXXXX")
    mv -- "$destination" "$backup/config"
    echo "Previous config: $backup/config"
  fi
  mkdir -p "$destination"
  cp "$source_dir/$init" "$destination/init.lua"
  if [[ "$app" == nvim-daily ]]; then
    cp -R "$source_dir/../snippets/UltiSnips" "$destination/UltiSnips"
    if [[ -f "$source_dir/lazy-lock.json" ]]; then
      cp "$source_dir/lazy-lock.json" "$destination/lazy-lock.json"
    fi
  fi
  launcher="$bin_dir/$app"
  if [[ -e "$launcher" || -L "$launcher" ]]; then
    backup=$(mktemp -d "$bin_dir/$app.backup.XXXXXXXX")
    mv -- "$launcher" "$backup/launcher"
  fi
  {
    printf '#!/usr/bin/env bash\n'
    printf 'export XDG_CONFIG_HOME=%q\n' "$config_root"
    printf 'export NVIM_APPNAME=%q\n' "$app"
    printf 'exec nvim "$@"\n'
  } > "$launcher"
  chmod +x "$launcher"
  echo "Installed: $launcher"
}
if [[ "$profile" == light || "$profile" == all ]]; then install_profile nvim-lite init-lite.lua; fi
if [[ "$profile" == daily || "$profile" == all ]]; then install_profile nvim-daily init.lua; fi
printf '\nAdd this directory to PATH if needed: %s\n' "$bin_dir"
if [[ "$profile" != light ]]; then
  echo 'Daily: first launch installs plugins. Then :TSInstallDefaults installs parsers.'
  echo 'Optional language tools: NVIM_ENABLE_LSP=1 nvim-daily, then :LspInstall pyright (or another server).'
fi
