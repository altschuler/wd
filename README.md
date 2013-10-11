wd
====

wd lets you create bookmarks of directories in your shell, and quickly navigate to them by. For example typing `wd dev` could take you to `~/Documents/Work/Code`

Should work in most shells

### Requirements
`wd` depends on ruby


###Installation

Put `engine.rb` and `warp` in some directory. Then add an alias in your shell config to the `warp` file using dot space (so that the file will be executed in your current shell)

    alias wd='. /path/to/warp'

###Usage

    warp <name>
    
Warp to bookmark named `<name>`

    warp add <name>
    
Add cwd as warp bookmark with id `<name>`

    warp rm <name> [<name2> ...]

Remove bookmarks

    warp ls
    
List all bookmarks (stored in `~/.warps`):
