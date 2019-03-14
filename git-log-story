#!/bin/bash

# messages
NO_STORY_ID="No story id supplied"

# sets options
for i in "$@"; do
    case $i in
        *)
        STORY_ID=$1
        ;;
    esac
done

if [ -z $STORY_ID ]; then
    echo $NO_STORY_ID
    exit 1
fi

# executs command
LOG_CMD="git log --grep=$STORY_ID"
$LOG_CMD