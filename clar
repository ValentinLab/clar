#!/bin/dash

# Usage string
USAGE='USAGE: clar [-v] DIR'

# One argument is needed
if [ $# -lt 1 ] || [ $# -gt 2 ] ; then
  echo "Error: One argument is needed.\n$USAGE"
  exit 1
fi

# Check if the verbose option is present
if [ "$1" = "-v" ] ; then
  VERBOSE=1
  shift
else
  VERBOSE=0
fi

# The argument must be a directory
if [ "$1" = '.' ] || [ "$1" = '..' ] ; then
  echo "Error: The directory can't be '.' or '..'.\n$USAGE"
  exit 1
fi
if ! [ -d "$1" ] ; then
  echo "Error: The directory must exists.\n$USAGE"
  exit 1
fi

# Remove .git* / .DS_Store
walk_dirs() {
  # .git* / .DS_Store
  if [ $VERBOSE -eq 1 ] ; then
    echo "[  ] $1"
    if [ -d "$1/.git" ] ; then
      echo "  .git"
    fi
    if [ -f "$1/.DS_Store" ] ; then
      echo "  .DS_Store"
    fi
    echo "[OK] $1\n"
  fi
  rm -rf "$1/.git*"
  rm -rf "$1/.DS_Store"

  # recursive
  DIRS=$(ls "$1")
  for DIR in $DIRS ; do
    if [ -d "$1/$DIR" ] ; then
      walk_dirs "$1/$DIR"
    fi
  done
}
walk_dirs "$1"

# Create tar.gz
tar czf "$1.tar.gz" "$1"

# Verbose option
if [ $VERBOSE -eq 1 ] ; then
  echo " -> $1.tar.gz created.\n"
  echo "It's done!"
fi

exit 0
