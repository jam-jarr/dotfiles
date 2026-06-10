#!/bin/sh

nordvpn connect >/dev/null
while curl -s torrentio.strem.fun | rg -q block; do
  nordvpn connect >/dev/null
done
echo "Time to steal 😻"
