#!/bin/sh
SCRIPT="$(realpath "$0")"
SCRIPTPATH="$(dirname "$SCRIPT")"
termuxbasic="$SCRIPTPATH/termux_basic.sh"
allfiles="$*"
echo  "$allfiles"
eval "sh $termuxbasic pkgQQQreinstall -y $allfiles"

# yes | python -m pip install