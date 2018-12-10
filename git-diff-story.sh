#!/bin/bash

# default options
NAME_ONLY=false

for i in "$@"; do
    case $i in
        --name-only)
        NAME_ONLY=true
        shift
        ;;
        *)
        CARD_ID=$1
        ;;
    esac
done

if [ -z $CARD_ID ]; then
    echo "No card id supplied"
    exit 1
fi

COMMITS_CMD="git log --pretty=%h --grep=$CARD_ID"
COMMITS=$($COMMITS_CMD)
REVERSE_COMMITS=$($COMMITS_CMD --reverse)
read -r FIRST_COMMIT <<< "$REVERSE_COMMITS"
read -r LAST_COMMIT <<< "$COMMITS"

ALL_COMMITS=$(git log --pretty=%h --reverse)
read -r INITIAL_REPO_COMMIT <<< "$ALL_COMMITS"
if [ $FIRST_COMMIT = $INITIAL_REPO_COMMIT ]; then
    START_COMMIT=$FIRST_COMMIT
else
    START_COMMIT=$FIRST_COMMIT~1
fi

DIFF_CMD="git diff $START_COMMIT $LAST_COMMIT"

MODIFIED_FILES_SCRIPT="./git-files-story.sh"
MODIFIED_FILES=$($MODIFIED_FILES_SCRIPT $CARD_ID)
while IFS='' read -ra ADDR; do
    for file in "${ADDR[@]}"; do
        DIFF_FILE="$DIFF_CMD -- $file"
        if [[ ! -z $($DIFF_FILE) ]]; then
            if $NAME_ONLY; then
                echo $file
            else
                $DIFF_FILE
            fi
        fi
    done
done <<< "$MODIFIED_FILES"
