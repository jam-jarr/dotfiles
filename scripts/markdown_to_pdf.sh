#!/bin/bash

# Convert markdown to pdf

filename="$1"

if [ -z "$filename" ]; then
  echo "Usage: $0 filename.md"
  exit 1
fi

output=$(echo "$filename" | sed 's/\.md/\.pdf/')

pandoc "$filename" -o "$output"

echo "Converted $filename to $output"
