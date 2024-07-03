#!/bin/sh
SCRIPT="$(realpath "$0")"
SCRIPTPATH="$(dirname "$SCRIPT")"
add_before_cmd="$(echo "$1" | sed 's/QQQ/ /g')"
add_after_cmd="$(echo "$2" | sed 's/QQQ/ /g')"
if [ "$add_after_cmd" = "XXXXX" ]; then
    add_after_cmd=''
fi
allcmds="$*"
allcmds="$(echo "$allcmds" | sed -E 's/^[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+//g')"
setcfgfile="/data/user/0/com.termux/files/home/setcfg.sh"
envcfgfile="/data/user/0/com.termux/files/home/envcfg.sh"
package_install_script_path="/data/data/com.termux/files/usr/bin/packi"
termuxpackagename="com.termux"
termux_props_file="/data/user/0/com.termux/files/home/.termux/termux.properties"
termux_data_folder='/data/data/com.termux/files/home'
grand_permission_script="$SCRIPTPATH/termux_grant_permission.sh"
termux_su_file='/data/data/com.termux/files/usr/bin/su'
remountscript="$SCRIPTPATH/termux_remountscript.sh"

rm -f "$termux_su_file"
rm -f "$setcfgfile"
rm -f "$envcfgfile"
rm -f "$package_install_script_path"
if [ -f  "$package_install_script_path" ]; then
    sh "$remountscript"
    rm -f "$package_install_script_path"
fi
sh "$grand_permission_script" --grant 1 --package "$termuxpackagename"
sed -i 's/# allow-external-apps = true/allow-external-apps = true/g' "$termux_props_file"

for line in $(seq 1 $(echo -n -e "$allcmds\n" | wc -l)); do
  script2execute="$(echo -n -e "$allcmds" | sed -n "${line}p" | sed 's/^-e[[:space:]]*//g' )"
  echo -e "$add_before_cmd $script2execute $add_after_cmd" >>"$package_install_script_path"
done

echo -e 'set > setcfg.sh' >>"$package_install_script_path"
echo -e 'env > envcfg.sh' >>"$package_install_script_path"
sleep 1
sed -i 's/^-e[[:space:]]*//g' "$package_install_script_path"
sleep 1
chmod 755 "$package_install_script_path"
monkey -p  "$termuxpackagename" 1
sleep 1
monkey -p  "$termuxpackagename" 1
sleep 1
am startservice --user 0 -n com.termux/com.termux.app.RunCommandService -a com.termux.RUN_COMMAND --es com.termux.RUN_COMMAND_PATH "$package_install_script_path" --esa com.termux.RUN_COMMAND_ARGUMENTS '' --es com.termux.RUN_COMMAND_WORKDIR "$termux_data_folder" --ez com.termux.RUN_COMMAND_BACKGROUND 'false' --es com.termux.RUN_COMMAND_SESSION_ACTION '0'
while [ ! -f "$setcfgfile" ] || [ ! -f "$envcfgfile" ]; do
    sleep 1
done
