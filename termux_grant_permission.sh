#!/bin/sh
SCRIPT="$(realpath "$0")"
SCRIPTPATH="$(dirname "$SCRIPT")"
# sh /sdcard/shellauto/u_grant_permission.sh --grant 1 --package com.tremux

grant=1
package=''
while [ $# -gt 0 ]; do
    case "$1" in
        --grant)
            shift
            grant=$1
            ;;
        --package)
            shift
            package=$1
            ;;
    esac
    shift
done
givepermission() {
    cmdxx=$(dumpsys package "$package" | grep permission | tr -d " " | awk 'BEGIN{FS=":"} {print $1}' | grep -oE '^.*[A-Z_0-9]+$' | uniq)
    while IFS= read -r permission; do
        pm "$1" "$package" "$permission" 2>/dev/null
    done <<<"$cmdxx"
}
if [ -z "$package" ]; then
    return 1
fi
if [ "$grant" -eq 0 ]; then
    givepermission revoke
else
    givepermission grant
fi
