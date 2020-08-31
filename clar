#!/bin/sh

# ----- Usage string -----
USAGE='usage: clar [-v -r -h] source_directory'

# ----- One argument is needed -----
if [ $# -eq 0 ] ; then
  echo "Error: At least one argument needed.\n$USAGE"
  exit 1
fi

# ----- Check the options -----
# Options :
#   -v : verbose
#   -r : remove the source directory
#   -h : help!
VERBOSE=0
REMOVE=0
SOURCE=""
for OPT in $@ ; do
  if [ "$OPT" = '-v' ] ; then
    # Verbose
    VERBOSE=1
  elif [ "$OPT" = '-r' ] ; then
    # Remove
    REMOVE=1
  elif [ "$OPT" = '-h' ] ; then
    # Help
    echo "clar -- create a clean tar archive compressed with gzip\n$USAGE"
    echo '\nABOUT:'
    echo 'Files such as .DS_Store, .git, *.class, etc. are deleted and a tar archive is created.'
    echo 'The archive name is "source_directory.tar.gz".'
    echo '\nOPTIONS:'
    echo '\t-v : verbose\n\t-r : delete source directory'
    exit 0
  elif echo "$OPT" | grep -E '\-.*' 2> /dev/null >&2 ; then
    echo "Error: Unknown option '$OPT'.\n$USAGE"
    exit 1
  else
    if ! [ -z "$SOURCE" ] ; then
      echo "Error: Only one path to the directory is needed\n$USAGE"
      exit 1
    fi
    SOURCE=$OPT
  fi
done

# ----- The argument must be a directory -----
if [ "$SOURCE" = '.' ] || [ "$SOURCE" = '..' ] ; then
  echo "Error: The directory can't be '.' or '..'.\n$USAGE"
  exit 1
fi
if ! [ -d "$SOURCE" ] ; then
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
    printf "[  ] \e[1m$1\e[0m\n"
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
    printf "[\e[32mOK\e[0m] \e[1m$1\e[0m\n\n"
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
CP_SOURCE="/tmp/$SOURCE"
cp -R "$SOURCE" $CP_SOURCE
walk_dirs $SOURCE

# ----- Create tar.gz -----
tar czfP "$SOURCE.tar.gz" $SOURCE

# ----- Verbose option -----
if [ $VERBOSE -eq 1 ] ; then
  printf " -> \e[1m$SOURCE.tar.gz\e[0m created.\n\n"
  echo "It's done!"
fi

# ----- Remove tmp and source -----
rm -rf "$SOURCE"
if [ $REMOVE -eq 0 ] ; then
  cp -r "$CP_SOURCE" "$SOURCE"
fi
rm -rf "$CP_SOURCE"

exit 0
