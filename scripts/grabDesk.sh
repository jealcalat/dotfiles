#!/bin/bash

# usage: grabDesk.sh [-o output_file] [--video_size video_size] [--crf video_quality]

# example: grabDesk.sh -o output.mkv --video_size 1920x1080 --crf 18

# Default values
output_file="output.mkv"
video_size="1920x1080"
video_quality=18

# Parse command-line options
while getopts ":o:-:" opt; do
  case ${opt} in
    o )
      output_file="$OPTARG"
      ;;
    - )
      case "${OPTARG}" in
        video_size )
          video_size="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
          ;;
        crf )
          video_quality="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
          ;;
        * )
          echo "Unknown option --${OPTARG}"
          echo "Usage: $0 [-o output_file] [--video_size video_size] [--crf video_quality]"
          exit 1
          ;;
      esac
      ;;
    \? )
      echo "Usage: $0 [-o output_file] [--video_size video_size] [--crf video_quality]"
      exit 1
      ;;
    : )
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Set the video codec, pixel format
video_codec="libx264"
video_pixel_format="yuv420p"

# Set the audio codec, input device number, and quality (bitrate)
audio_codec="aac"
audio_device_num=1
audio_bitrate="192k"

# Use ffmpeg to capture the desktop and audio input
ffmpeg -y \
    -f x11grab -framerate 60 -video_size ${video_size} -i $DISPLAY \
    -f pulse -i "default:${audio_device_num}" \
    -c:v ${video_codec} -pix_fmt ${video_pixel_format} -crf ${video_quality} \
    -c:a ${audio_codec} -b:a ${audio_bitrate} \
    ${output_file}


