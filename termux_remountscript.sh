#!/bin/sh
check_if_mounted() {
    mountcheckervalue=0
    mountchecker="$(mount -v | grep -v 'rw' | grep 'ro' | awk 'BEGIN{FS="[\\(]+";}{print $2}' | awk 'BEGIN{FS="[\\),]+";}{if ($1 ~ /^ro$/){ print 1;exit}}')"
    echo -e "$mountchecker"
    mountcheckervalue=$((mountcheckervalue + mountchecker))
    return "$mountcheckervalue"
}

modr() {

    if ! check_if_mounted; then
        mount -o remount,rw /
    else
        return 0
    fi
    if ! check_if_mounted; then
        su -c "mount -o remount,rw /"
    else
        return 0
    fi

    if ! check_if_mounted; then
        su -c "mount --all -o remount,rw -t vfat1"
    else
        return 0
    fi

    if ! check_if_mounted; then
        su -c 'mount --all -o remount,rw -t ext4'
    else
        return 0
    fi

    if ! check_if_mounted; then
        su -c 'mount -o remount,rw'
    else
        return 0
    fi

    if ! check_if_mounted; then
        su -c "mount -o remount,rw /;"
    else
        return 0
    fi

    if ! check_if_mounted; then
        mount -o remount,rw /
    else
        return 0
    fi
    if ! check_if_mounted; then
        su -c "mount -o remount,rw /"
    else
        return 0
    fi

    if ! check_if_mounted; then
        su -c 'mount -o rw&&remount /'
    else
        return 0
    fi

    if ! check_if_mounted; then
        su -c 'mount -o rw;remount /'
    else
        return 0
    fi

    if ! check_if_mounted; then
        mount --all -o remount,rw -t vfat
    else
        return 0
    fi
    if ! check_if_mounted; then
        su -c "mount --all -o remount,rw -t vfat"
    else
        return 0
    fi

    if ! check_if_mounted; then
        mount -o remount,rw /
    else
        return 0
    fi
    if ! check_if_mounted; then
        su -c "mount -o remount,rw /"
    else
        return 0
    fi
    if ! check_if_mounted; then
        mount --all -o remount,rw -t vfat
    else
        return 0
    fi
    if ! check_if_mounted; then
        su -c "mount --all -o remount,rw -t vfat"
    else
        return 0
    fi
    if ! check_if_mounted; then
        getprop --help >/dev/null;su -c 'mount -o remount,rw /;'
    else
        return 0
    fi
    if ! check_if_mounted; then
        su -c 'mount -o remount,rw /;'
    else
        return 0
    fi

    if ! check_if_mounted; then
        mount -v | grep "^/" | grep -v '\\(rw,' | grep '\\(ro' | awk '{print "mount -o rw,remount " $1 " " $3}' | tr '\n' '\0' | xargs -0 -n1 su -c
    else
        return 0
    fi

    if ! check_if_mounted; then
        mount -v | grep "^/" | grep -v '\\(rw,' | grep '\\(ro' | awk '{print "mount -o rw,remount " $1 " " $3}' | su -c sh
    else
        return 0
    fi

    if ! check_if_mounted; then
        mount -v | grep "^/" | grep -v '\\(rw,' | grep '\\(ro' | awk '{system("mount -o rw,remount " $1 " " $3)}'
    else
        return 0
    fi

    if ! check_if_mounted; then
        su -c 'mount -v | grep -E "^/" | awk '\''{print "mount -o rw,remount " $1 " " $3}'\''' | tr '\n' '\0' | xargs -0 -n1 su -c
    else
        return 0
    fi

    if ! check_if_mounted; then
        mount -Ev | grep -Ev 'nodev' | grep -Ev '/proc' | grep -v '\\(rw,' | awk 'BEGIN{FS="([[:space:]]+(on|type)[[:space:]]+)|([[:space:]]+\\()"}{print "mount -o rw,remount " $1 " " $2}' | xargs -n5 | su -c
    else
        return 0
    fi

    if ! check_if_mounted; then
        su -c 'mount -v | grep -E "^/" | awk '\''{print "mount -o rw,remount " $1 " " $3}'\''' | sh su -c
    else
        return 0
    fi

    if ! check_if_mounted; then
        getprop --help >/dev/null;su -c 'mount -v | grep -E "^/" | awk '\''{print "mount -o rw,remount " $1 " " $3}'\''' | tr '\n' '\0' | xargs -0 -n1 | su -c sh
    else
        return 0
    fi
return 1
}
modr 2>/dev/null
