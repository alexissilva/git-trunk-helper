#!/bin/bash

# messages
NO_STORY_ID="No story id supplied"
NO_STORY_COMMITS="There are not any commits for this story"

# default options
NAME_ONLY=false
EXTENSION=*

for i in "$@"; do
    case $i in
        --name-only)
        NAME_ONLY=true
        shift
        ;;
        -e=*|--extension=*)
        EXTENSION="${i#*=}"
        shift
        ;;
        *)
        STORY_ID=$1
        ;;
    esac
done

if [ -z $STORY_ID ]; then
    echo $NO_STORY_ID
    exit 1
fi

COMMITS_CMD="git log --pretty=%h --grep=$STORY_ID"
COMMITS=$($COMMITS_CMD)
REVERSE_COMMITS=$($COMMITS_CMD --reverse)
read -r FIRST_COMMIT <<< "$REVERSE_COMMITS"
read -r LAST_COMMIT <<< "$COMMITS"

ALL_COMMITS=$(git log --pretty=%h --reverse)
read -r INITIAL_REPO_COMMIT <<< "$ALL_COMMITS"
if [ -z $FIRST_COMMIT ]; then
    echo $NO_STORY_COMMITS
    exit 1
fi

if [ $FIRST_COMMIT = $INITIAL_REPO_COMMIT ]; then
    START_COMMIT=$FIRST_COMMIT
else
    START_COMMIT=$FIRST_COMMIT~1
fi

DIFF_CMD="git diff $START_COMMIT $LAST_COMMIT"

MODIFIED_FILES_SCRIPT="./git-files-story.sh"
MODIFIED_FILES=$($MODIFIED_FILES_SCRIPT $STORY_ID)
while IFS='' read -ra ADDR; do
    for file in "${ADDR[@]}"; do
        if [[ $file == *$EXTENSION ]]; then
            DIFF_FILE="$DIFF_CMD -- $file"
            if [[ ! -z $($DIFF_FILE) ]]; then
                if $NAME_ONLY; then
                    echo $file
                else
                    $DIFF_FILE
                fi
            fi
        fi
    done
done <<< "$MODIFIED_FILES"
