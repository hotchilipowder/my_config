#!/usr/bin/env bash
# Export an installed profile back to the matching single-file source.
set -euo pipefail
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
case "${1:-daily}" in
  daily) app=nvim-daily; target=init.lua ;;
  light) app=nvim-lite; target=init-lite.lua ;;
  *) echo 'Usage: update_init_lua_from_current_os.sh [daily|light]' >&2; exit 2 ;;
esac
cp "${XDG_CONFIG_HOME:-$HOME/.config}/$app/init.lua" "$source_dir/$target"
