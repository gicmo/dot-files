dotfiles
========

Collection various small dot-files and other config files.
Uses [homeshick](https://github.com/andsens/homeshick) for management.

Quick start
-----------

```sh
# install myrepos via homebrew
brew install myrepos

# clone all repos to ~/.homesick/repos
mr --trust-all bootstrap https://raw.githubusercontent.com/gicmo/dot-files/master/mrconfig  ~/.homesick/repos

# load homeshick
source ~/.homesick/repos/homeshick/homeshick.sh

# link all dotfiles
homeshick link
```
