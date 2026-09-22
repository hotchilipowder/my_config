#!/usr/bin/env bash
# Compatibility entry point: standalone light config, isolated data and plugins.
set -euo pipefail
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
export NVIM_APPNAME=nvim-lite
exec nvim -u "$source_dir/init-lite.lua" "$@"
