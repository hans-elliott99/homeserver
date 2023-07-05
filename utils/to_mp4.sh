#!/usr/bin/env bash

# Convert video file formats to MP4
# Supported conversions: mts, wmv, avi
# Dependency: ffmpeg
#
input=$1

# ========== helpers ==========
get_mp4_name () { # pass filename
    local name=$(echo "$1" | rev | cut -d"." -f2- | rev)
    echo "$name.mp4"
}

get_ext () { # pass filename
    echo "$1" | rev | cut -d"." -f1 | rev
}

# ========== ffmpeg converters ==========
# args: input_filepath output_filepath
convert_mts () {
    echo "[mts] Converting $1 to $2..."
    ffmpeg -hide_banner -loglevel error -i "$1" -c:v copy -c:a aac -strict experimental -b:a 128k "$2"
}

convert_wmv () {
    echo "[wmv] Converting $1 to $2..."
    ffmpeg -hide_banner -loglevel error -i "$1" -c:v libx264 -crf 23 -c:a aac -q:a 100 "$2" 
}

convert_avi () {
    echo "[avi] Converting $1 to $2..."
    ffmpeg -hide_banner -loglevel error -i "$1" -c:v libx264 "$2"
}

convert_mpg () {
    echo "[mpg] Converting $1 to $2..."
    ffmpeg -hide_banner -loglevel error -i "$1" -c:v libx264 -f mp4 "$2"
}

# ========== conversion engine ==========
convert_file () { # pass filename
    infile=$1
    outfile="$(get_mp4_name "$infile")"
    ext="$(get_ext "$infile")"
    if [ "${ext,,}" = "mts" ]; then
        convert_mts "$infile" "$outfile"
    elif [ "${ext,,}" = "wmv" ]; then
        convert_wmv "$infile" "$outfile"
    elif [ "${ext,,}" = "avi" ]; then
        convert_avi "$infile" "$outfile"
    elif [ "${ext,,}" = "mpg" ] || [ "${ext,,}" = "mpeg" ]; then
        convert_mpg "$infile" "$outfile"
    else
        echo "Extension '$ext' not supported. Skipping '$infile'."
    fi
}

# ========== main ==========
# if directory, loop through files and convert
if [ -d "${input}" ] ; then
    for filename in "$input"/*; do
        [ -e "$filename" ] || continue
        convert_file "$filename"
    done
# otherwise, check if file and try to convert
else
    if [ -f "${input}" ]; then
        convert_file "$input"
    else
        echo "'$input' is not a valid input."
        exit 1
    fi
fi
