#!/usr/bin/env bash
set -euo pipefail
NVIM_PROFILE=server NVIM_ENABLE_LSP=0 nvim "$@"
