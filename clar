#!/bin/dash

# ----- Usage string -----
USAGE='USAGE: clar [-v] DIR'

# ----- One argument is needed -----
if [ $# -lt 1 ] || [ $# -gt 2 ] ; then
  echo "Error: One argument is needed.\n$USAGE"
  exit 1
fi

# ----- Check if the verbose option is present -----
if [ "$1" = "-v" ] ; then
  VERBOSE=1
  shift
else
  VERBOSE=0
fi

# ----- The argument must be a directory -----
if [ "$1" = '.' ] || [ "$1" = '..' ] ; then
  echo "Error: The directory can't be '.' or '..'.\n$USAGE"
  exit 1
fi
if ! [ -d "$1" ] ; then
  echo "Error: The directory must exists.\n$USAGE"
  exit 1
fi

# ----- Remove files -----
FOLDERS=".git"
FILES=".gitignore .DS_Store"
EXT=".tmp .class .aux .log .toc"
walk_dirs() {
  # Verbose
  if [ $VERBOSE -eq 1 ] ; then
    echo "[  ] $1"
    # folders
    for FLD in $FOLDERS ; do
      if [ -d $1/$FLD ] ; then
        echo "  $FLD"
      fi
    done
    #files
    for FIL in $FILES ; do
      if [ -f $1/$FIL ] ; then
        echo "  $FIL"
      fi
    done
    # extensions
    for ETN in $EXT ; do
      if ls $1/*$ETN 2> /dev/null >&2 ; then
        echo "  $ETN"
      fi
    done  
    echo "[OK] $1\n"
  fi

  # Remove
  # folders
  for FLD in $FOLDERS ; do
    rm -rf "$1/$FLD"
  done
  # files
  for FIL in $FILES ; do
    rm -f "$1/$FIL"
  done
  # extentions
  for ETN in $EXT ; do
    rm -f "$1"/*$ETN
  done

  # Recursive
  DIRS=$(ls "$1")
  for DIR in $DIRS ; do
    if [ -d "$1/$DIR" ] ; then
      walk_dirs "$1/$DIR"
    fi
  done
}
walk_dirs "$1"

# ----- Create tar.gz -----
tar czf "$1.tar.gz" "$1"

# ----- Verbose option -----
if [ $VERBOSE -eq 1 ] ; then
  echo " -> $1.tar.gz created.\n"
  echo "It's done!"
fi

exit 0
