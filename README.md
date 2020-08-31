# CLAR

Create a clean tar archive compressed with gzip.

## How to use

**Usage:** `clar [-v -r -h] source_directory`

**Options:**
 * `-v`: verbose
 * `-r`: delete the source folder
 * `-h`: dislay help

## About

**Deleted folders:** (`$FOLDERS`)
 * .git/
 * .vscode/

**Deleted files:** (`$FILES`)
 * .gitignore
 * .DS_Store

**Deleted files with extension** (`$EXT`)
 * *.tmp
 * *.class
 * *.aux
 * *.log
 * *.toc
 * *.o