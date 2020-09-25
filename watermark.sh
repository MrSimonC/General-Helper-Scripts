#!/bin/bash

# example:
# watermark.sh filename.png QA
# watermark.sh ./ QA
# outputs: processed/filename.png with "QA" in the centre

# pre-requisites:
# install ImageMagicK

if ! command -v magick &> /dev/null
then
    echo "imagemagic (magick) could not be found"
    exit
fi

text="$2"

addwatermark(){
    input="$1"
    file_name="${input##*/}"
    file_extension="${file_name##*.}"
    file="${file_name%.*}"

    magick convert "$file_name"  \
    -fill white  \
    -font Arial -pointsize 120 \
    -undercolor '#00000080'  \
    -gravity Center \
    -annotate +5+5 "$text" \
    "$2""$file""$3"."$file_extension" # e.g. processed/myFile.png (or, myFile_out.png)
}

# file
if [[ -f $1 ]]; then
    echo "***Processing file***: $1"
    if [ ! -d "$(cd "$(dirname "$1")" && pwd -P)/processed" ]; then
        mkdir -p "$(cd "$(dirname "$1")" && pwd -P)/processed"
    fi
    addwatermark "$1" "processed/"
# directory
elif [ -d "$1" ]; then
    if [ ! -d "$1/processed" ]; then
        mkdir -p  "$1/processed"
    fi
    cd "$1" || exit
    for InputItem in *; do
        if [ -f "$InputItem" ]; then
            echo "***Processing***: $InputItem"
            addwatermark "$InputItem" "processed/"
        fi
    done
fi