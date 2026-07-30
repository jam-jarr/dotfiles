#!/bin/bash

set -euo pipefail

if [ -f /etc/keyd/default.conf.bak ]; then
  echo "Resoring backup file"
  # if there is a backup, restore it
  sudo cp /etc/keyd/default.conf{.bak,}
  sudo rm /etc/keyd/default.conf.bak
else
  # else use the swap file
  if [[ ! -f /etc/keyd/default.conf.swp ]]; then
    echo "No backup file found, exiting"
    exit 1
  fi
  echo "Switching to alt config"
  sudo cp /etc/keyd/default.conf{,.bak}
  sudo cp /etc/keyd/default.conf{.swp,}
fi
echo "-----------------------"
sudo keyd reload && keyd check
