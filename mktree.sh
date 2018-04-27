#!/usr/bin/env bash

# Default to current folder
# Necessary in the event that a path begins with a "/"
BASE_DIR="./"

# Default template file
DEFAULT_TEMPLATE="$HOME/.mktree"
if [[ -e $DEFAULT_TEMPLATE ]]; then
  TEMPLATE=$DEFAULT_TEMPLATE
fi

# Template enviromental variable
if [[ -n "$MKTREE_TEMPLATE" ]]; then
  TEMPLATE="$MKTREE_TEMPLATE"
fi

# Print usage information
function usage()
{
cat <<EOF
Usage:     $0 [OPTIONS]
Version:   1.0.0

Create a directory tree

OPTIONS:
    -C directory  Change to a directory before creating the directory tree,
                  this directory will be created if it does not already exist
    -t file       The template file to use to create the directory tree

EOF
}

# Send errors to stderr, and optionally exit
function error()
{
  echo -e "Error: $1" >&2
  [[ ! "$2" == "noexit" ]] && exit 1
}

# Parse options
while getopts ":C:t:" OPTION; do
  case $OPTION in
    C)
      BASE_DIR="$OPTARG"
      ;;
    t)
      TEMPLATE="$OPTARG"
      ;;
    :)
      error "-${OPTARG} requires an argument" noexit
      usage
      exit 1
      ;;
    \?)
      error "Invalid option: -${OPTARG}" noexit
      usage
      exit 1
      ;;
  esac
done

if [[ -e "$TEMPLATE" ]]; then
  # Read template
  IFS=$'\n' DIRS=( $(sed '/^[[:blank:]]*#/d;s/#.*//' "$TEMPLATE") )
fi

if [[ -n "$BASE_DIR" ]]; then
  # Store directories in here
  TMP_DIRS=()

  # Set basedir
  # BASE_DIR=$(basename "$BASE_DIR")
  TMP_DIRS+=("$BASE_DIR")

  # Build directory list
  for dir in "${DIRS[@]}"; do
    TMP_DIRS+=("${BASE_DIR}/${dir}")
  done

  # Reset directory structure
  DIRS=("${TMP_DIRS[@]}")
fi

if [ ${#DIRS[@]} -gt 0 ]; then
  # Create directories
  mkdir -p "${DIRS[@]}"
fi
