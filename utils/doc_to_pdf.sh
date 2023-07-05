#!/usr/bin/env bash

# Convert doc(x) files to pdf
# dependencies: libreoffice

input=$1

get_ext () { # pass filename
    # get the extension for the input file
    echo "$1" | rev | cut -d"." -f1 | rev
}

get_out_dir () { # pass filepath
    # get the path to the input file's directory since libreofiice
    # takes an output dir argument.
    echo "$1" | rev | cut -d"/" -f2- | rev
}

convert_doc_to_pdf () { # pass input file, outdir
    echo ""
    libreoffice --headless --convert-to pdf "$1" --outdir "$2"
}

convert_file () { # pass filename
    infile=$1
    outdir="$(get_out_dir "$infile")"
    ext="$(get_ext "$infile")"
    if [ "${ext,,}" = "doc" ]; then
        convert_doc_to_pdf "$infile" "$outdir"
    elif [ "${ext,,}" = "docx" ]; then
        convert_doc_to_pdf "$infile" "$outdir"
    else
        echo "Extension '$ext' not supported. Skipping '$infile'."
    fi
}


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
