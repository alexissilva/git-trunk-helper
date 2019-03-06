# How to use

1. Copy script files in your repository root folder
2. Add it execution permissions (*chmod*)
3. Run!


To see the changes made in the story `STORY_ID` 
> ./git-diff-story.sh STORY_ID


To see only modified files names, use `--name-only` or `-n`
> ./git-diff-story.sh STORY_ID --name-only

To filter files, you can use option `--pattern` or `-p`
> ./git-diff-story.sh STORY_ID -p=test.js
./git-diff-story.sh STORY_ID -p=/controllers

...

**Work in progress**