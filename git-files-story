#!/bin/bash
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit 1
fi

CARD_ID=$1

FILES=$(git log --pretty=%n --name-only --grep=$CARD_ID)

while IFS='' read -ra ADDR; do
    for file in "${ADDR[@]}"; do
        FILE_ARRAY+=($file)
    done
done <<< "$FILES"

IFS=$'\n' SORTED=($(sort -u <<<"${FILE_ARRAY[*]}"))
unset IFS

for file in "${SORTED[@]}"; do
    echo $file
done
