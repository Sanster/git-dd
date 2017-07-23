# git-dd

![Gem Version](https://badge.fury.io/rb/git-dd.svg)

> git command to delete branches interactively

## Install
Install git-dd with [gem](https://rubygems.org/):
```
gem install git-dd
```

## How to use
- Run `git dd` to select branches to delete. Use arrow keys, press Space to select and Enter to finish.

![git-dd](git-dd.gif)

The **merged/unmerge** status show whether the branch has been merged into current branch.

* Run `git dd --merged` to delete all branches have been merged into current branch.

Press `Ctrl + c` to return.
