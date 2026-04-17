#!/bin/sh

# Toggle sleep state using a flag file for persistence
FLAG_FILE="/tmp/sleep_disabled"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

if [ -f "$FLAG_FILE" ]; then
  # Sleep is currently disabled, so enable it
  rm -f "$FLAG_FILE"
  sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
  echo "${GREEN}Sleep enabled${NC}"
else
  # Sleep is currently enabled, so disable it
  touch "$FLAG_FILE"
  sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
  echo "${RED}Sleep disabled${NC}"
fi

