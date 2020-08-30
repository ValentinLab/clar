#!/bin/dash

# Usage string
USAGE='USAGE: clar DIR'

# One argument is needed
if [ $# -ne 1 ] ; then
  echo "Error: One argument is needed.\n$USAGE"
  exit 1
fi

# The argument must be a directory
if [ "$1" = "." ] || [ "$1" = ".." ] ; then
  echo "Error: The directory can't be '.' or '..'.\n$USAGE"
  exit 1
fi
if ! [ -d "$1" ] ; then
  echo "Error: The directory must exists.\n$USAGE"
  exit 1
fi

# Remove git and .DS_Store
walk_dirs() {
  # .git* / .DS_Store
  rm -rf $1/.git*
  rm -rf $1/.DS_Store

  # recursive
  DIRS=$(ls $1)
  for DIR in $DIRS ; do
    if [ -d "$1/$DIR" ] ; then
      walk_dirs "$1/$DIR"
    fi
  done
}
walk_dirs $1

exit 0
