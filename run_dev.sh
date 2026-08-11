#!/usr/bin/env bash
set -euo pipefail

HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-8000}"

if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
  echo "PORT must be numeric, got: $PORT" >&2
  exit 1
fi

pick_free_port() {
  python - "$HOST" "$PORT" <<'PY'
import socket
import sys

host = sys.argv[1]
start = int(sys.argv[2])

for port in range(start, start + 200):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        try:
            s.bind((host, port))
        except OSError:
            continue
        print(port)
        sys.exit(0)

print("")
sys.exit(1)
PY
}

FREE_PORT="$(pick_free_port || true)"
if [[ -z "$FREE_PORT" ]]; then
  echo "No free port found in range ${PORT}..$((PORT + 199)) on host ${HOST}" >&2
  exit 1
fi

echo "Starting docs server at http://${HOST}:${FREE_PORT}"
echo "Tip: use 'PORT=18000 uv run bash run_dev.sh' to force a specific port."

exec sphinx-autobuild docs build --host "$HOST" --port "$FREE_PORT"
