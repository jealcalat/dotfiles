#!/bin/sh

name=$1

ffmpeg -f x11grab -i :0.0 -f alsa -ac 2 -i pulse -acodec aac -strict experimental $name.mkv
