#!/usr/bin/env bash

# Spider through all sub-directories and convert documents to pdf
# ./convert_all_pdf.sh /path/to/directory


IFS=$'\n'; set -f
for f in $(find "$1" -name '*.docx' -or -name '*.doc'); do
    ~/utils/doc_to_pdf.sh "$f"
done
unset IFS; set +f
