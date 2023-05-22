#!/bin/sh

ffmpeg -f v4l2 -i /dev/video2 -vf "format=yuv420p" -f sdl "Webcam Preview"
