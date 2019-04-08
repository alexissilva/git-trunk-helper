# How to use

1. Clone project 
> git clone https://github.com/alexissilva/git-trunk-helper.git

2. Add repository folder to your $PATH. If you are using zsh, edit your `~/.zshrc` file and add:  
> export PATH=$PATH:*{your-git-projects-folder}*/git-trunk-helper

3. Run! For example for seeing changes added in story 117:
> git diff-story 117


# Options

`--name-only`, `-n`

Shows only names of the modified files


`--stat`, `-s`

Shows a histogram of the modified files


`--all`, `-a`

By default the changes are showing file by file. This shows all changes together.


`--pattern=<pattern>`, `-p=<pattern>`

Filters files using a pattern.

`--start=<commit>`

Shows changes since a specific commit

`--test=skip`, `-t=skip`, `-t=s` 

Skip test files

`--test=only`, `-t=only`, `-t=o`

Shows only test files