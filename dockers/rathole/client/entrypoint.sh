#!/bin/sh
set -eu

template_path=${1:?missing rathole config template}
: "${RATHOLE_TOKEN:?RATHOLE_TOKEN must be set}"

case "${RATHOLE_TOKEN}" in
    *[!A-Za-z0-9_-]*)
        echo "RATHOLE_TOKEN may contain only letters, numbers, '_' and '-'" >&2
        exit 1
        ;;
esac

sed "s/__RATHOLE_TOKEN__/${RATHOLE_TOKEN}/g" "${template_path}" > /tmp/rathole.toml
exec /usr/bin/rathole /tmp/rathole.toml
