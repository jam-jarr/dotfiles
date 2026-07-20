#!/bin/sh

# Run the app before connecting to the VPN, to speed things up
(
  nordvpn connect >/dev/null
  while curl -s torrentio.strem.fun | rg -q block; do
    nordvpn connect >/dev/null
  done
) &

/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=stremio --file-forwarding com.stremio.Stremio @@u %U @@

# nordvpn disconnect
