#!/usr/bin/env bash

set -euo pipefail
set -x
cd /app
GOOS="linux" go build  -buildvcs=false  -ldflags='-s -w' -o /app/bin/main github.com/paketo-buildpacks/native-image/v5/cmd/main

if [ "${STRIP:-false}" != "false" ]; then
  strip bin/main
fi

if [ "${COMPRESS:-none}" != "none" ]; then
  $COMPRESS bin/main
fi

ln -fs main bin/build
ln -fs main bin/detect
