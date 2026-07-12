#!/bin/bash
movie=$1
sub=$2
offset=$3

ffmpeg -i "$movie" -itsoffset -${offset}s -i "$sub" -map 0:v -map 0:a -map 1:s -c copy -c:s srt output.mkv
