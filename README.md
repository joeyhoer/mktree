# mktree

Create a directory tree

## Create a template

Create a template file from an existing directory:

```
dir="./"; find "$dir" -type d | sed "s|$dir/||" > template.txt
```

## Usage

```
Usage: mktree [OPTIONS]

Create a directory tree

OPTIONS:
    -C directory  Change to a directory before creating the directory tree,
                  this directory will be created if it does not already exist
    -t file       The template file to use to create the directory tree
```

### Default template

The `~/.mktree` file will be used as the default template if it exists.

If the `MKTREE_TEMPLATE` environmental variable is defined, that file will be used as the default template instead.
