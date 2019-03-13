#!/bin/bash

# messages
NO_STORY_ID="No story id supplied"
NO_STORY_COMMITS="There are not any commits for this story"
NO_VALID_START="The start commit does not belong to the story"

# default options
NAME_ONLY=false
STAT=false
PATTERN=.*
ONE_BY_ONE=true
CUSTOM_START=

# sets options
for i in "$@"; do
    case $i in
        -n|--name-only)
        NAME_ONLY=true
        shift
        ;;
        -s|--stat)
        STAT=true
        shift
        ;;
        -a|--all)
        ONE_BY_ONE=false
        shift
        ;;
        -p=*|--pattern=*)
        PATTERN="${i#*=}"
        shift
        ;;
        --start=*)
        CUSTOM_START="${i#*=}"
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

if $STAT || $NAME_ONLY; then
    ONE_BY_ONE=false
fi

# creates diff command
if [ ! -z $CUSTOM_START ]; then
    DATE_CUSTOM_START=$(git log --pretty=%aI -n 1 $CUSTOM_START)
    SINCE_CMD="--since=\"$DATE_CUSTOM_START\""
fi

COMMITS_CMD="git log --pretty=%h --grep=$STORY_ID $SINCE_CMD"
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

if [ ! -z $CUSTOM_START ] || [ $FIRST_COMMIT = $INITIAL_REPO_COMMIT ]; then
    START_COMMIT=$FIRST_COMMIT
else
    START_COMMIT=$FIRST_COMMIT~1
fi

DIFF_BASIC_CMD="git diff $START_COMMIT $LAST_COMMIT"
DIFF_CMD=$DIFF_BASIC_CMD
if $STAT; then
    DIFF_CMD="$DIFF_CMD --stat"
fi
if $NAME_ONLY; then
    DIFF_CMD="$DIFF_CMD --name-only"
fi

# filters files
MODIFIED_FILES_SCRIPT="./git-files-story.sh"
MODIFIED_FILES=$($MODIFIED_FILES_SCRIPT $STORY_ID)
FILTERED_FILES=()
while IFS='' read -ra FILES; do
    for file in "${FILES[@]}"; do
        if [[ $file =~ $PATTERN ]]; then
            DIFF_FILE="$DIFF_BASIC_CMD -- $file"
            if [[ ! -z $($DIFF_FILE) ]]; then
                FILTERED_FILES+=($file)
            fi
        fi
    done
done <<< "$MODIFIED_FILES"


# execute command
if $ONE_BY_ONE; then
    for file in "${FILTERED_FILES[@]}"; do
        DIFF_CMD_BY_FILE="$DIFF_CMD -- $file"
        $DIFF_CMD_BY_FILE
    done
else
    FILES_STRING=""
    for file in "${FILTERED_FILES[@]}"; do
        FILES_STRING+=" $file"
    done
    DIFF_CMD_ALL="$DIFF_CMD -- $FILES_STRING"
    $DIFF_CMD_ALL
fi
