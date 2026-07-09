#!/bin/bash
set -eu

TARGET_PATH="$1"
shift
BUILD_CMD=("$@")

# 1. Get the directory and the filename
# If it's a file, we watch the directory and filter for the filename
if [ -f "$TARGET_PATH" ]; then
  WATCH_DIR=$(dirname "$TARGET_PATH")
  FILENAME=$(basename "$TARGET_PATH")
  WATCH_FILE_ONLY=true
else
  WATCH_DIR="$TARGET_PATH"
  WATCH_FILE_ONLY=false
fi

echo "Watching: $TARGET_PATH"
echo "Build command: ${BUILD_CMD[*]}"

# 2. Monitor the directory
# -m: monitor
# -e: listen for these specific events (modify + moved_to covers most save methods)
inotifywait -m -e modify,moved_to "$WATCH_DIR" --format '%f' | while read -r file; do

  # 3. If we are watching a specific file, check if this event matches that file
  if [ "$WATCH_FILE_ONLY" = true ]; then
    if [ "$file" != "$FILENAME" ]; then
      continue
    fi
  fi

  echo "--- Changes detected in $file! ---"
  "${BUILD_CMD[@]}"
  echo "--- Done! ---"
done
