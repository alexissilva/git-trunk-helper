# How to use

1. Copy script files in your repository root folder
2. Add it execution permissions (*chmod*)
3. Run!


To see the changes made in the story `STORY_ID` 
> ./git-diff-story.sh STORY_ID


To see only the names of modified files
> ./git-diff-story.sh STORY_ID --name-only

To filter per extension file use option `--extension` or `-e`
> ./git-diff-story.sh STORY_ID -e=.test.js

...

**Work in progress**