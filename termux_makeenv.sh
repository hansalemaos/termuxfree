#!/bin/sh
SCRIPT="$(realpath "$0")"
SCRIPTPATH="$(dirname "$SCRIPT")"
remountscript="$SCRIPTPATH/termux_remountscript.sh"
sh "$remountscript"
setcfgfile="/data/user/0/com.termux/files/home/setcfg.sh"
envcfgfile="/data/user/0/com.termux/files/home/envcfg.sh"
package_install_script_path="/data/data/com.termux/files/usr/bin/packienv"
termuxpackagename="com.termux"
termux_props_file="/data/user/0/com.termux/files/home/.termux/termux.properties"
termux_data_folder='/data/data/com.termux/files/home'
grand_permission_script="$SCRIPTPATH/termux_grant_permission.sh"
termux_su_file='/data/data/com.termux/files/usr/bin/su'
termux_awk_parser="$SCRIPTPATH/termux_awkcfg.awk"
termux_merged_env="/sdcard/tenv.sh"
termux_old_env="/sdcard/oenv.sh"
pip_install_script="$SCRIPTPATH/termux_pip_install.sh"
pip_uninstall_script="$SCRIPTPATH/termux_pip_uninstall.sh"
pkg_install_script="$SCRIPTPATH/termux_pkg_install.sh"
pkg_uninstall_script="$SCRIPTPATH/termux_pkg_uninstall.sh"
pkg_reinstall_script="$SCRIPTPATH/termux_pkg_reinstall.sh"
pkg_up_script="$SCRIPTPATH/termux_pkg_up.sh"
if [ ! -f "$termux_old_env" ]; then
    set > "$termux_old_env"
    env >> "$termux_old_env"
fi
rm -f "$termux_su_file"
rm -f "$setcfgfile"
rm -f "$envcfgfile"
rm -f "$package_install_script_path"
sh "$grand_permission_script" --grant 1 --package "$termuxpackagename"
sed -i 's/# allow-external-apps = true/allow-external-apps = true/g' "$termux_props_file"
echo -e 'set > setcfg.sh' >>"$package_install_script_path"
echo -e 'env > envcfg.sh' >>"$package_install_script_path"
sed -i 's/^-e[[:space:]]*//g' "$package_install_script_path"
chmod 755 "$package_install_script_path"
monkey -p "$termuxpackagename" 1
sleep 1
monkey -p "$termuxpackagename" 1
sleep 1
am startservice --user 0 -n com.termux/com.termux.app.RunCommandService -a com.termux.RUN_COMMAND --es com.termux.RUN_COMMAND_PATH "$package_install_script_path" --esa com.termux.RUN_COMMAND_ARGUMENTS '' --es com.termux.RUN_COMMAND_WORKDIR "$termux_data_folder" --ez com.termux.RUN_COMMAND_BACKGROUND 'false' --es com.termux.RUN_COMMAND_SESSION_ACTION '0'

while [ ! -f "$setcfgfile" ] || [ ! -f "$envcfgfile" ]; do
    sleep 1
done
envcfgtermux="$(cat "$envcfgfile" | grep -v 'IFS=' | grep "=")"
setcfgtermux="$(cat "$setcfgfile" | grep -v 'IFS=' | grep "=")"
envcfg="$(eval "env" | grep -v 'IFS=' | grep "=")"

echo -e "$envcfgtermux\n$setcfgtermux\n$envcfg" | awk -f "$termux_awk_parser" | grep -vE "=[[:space:]]*$" | grep -vE "^PS[[:digit:]]" | grep -v "PID" | grep -v "^HOME" >"$termux_merged_env"
echo -e 'HOME=/' >>"$termux_merged_env"
sed -i 's/^-e[[:space:]]*//g' "$termux_merged_env"
echo "alias pkginstall='sh $pkg_install_script'" >>"$termux_merged_env"
echo "alias pkguninstall='sh $pkg_uninstall_script'" >>"$termux_merged_env"
echo "alias pkgreinstall='sh $pkg_reinstall_script'" >>"$termux_merged_env"
echo "alias pkgup='sh $pkg_up_script'" >>"$termux_merged_env"
echo "alias pipinstall='sh $pip_install_script'" >>"$termux_merged_env"
echo "alias pipuninstall='sh $pip_uninstall_script'" >>"$termux_merged_env"
echo "alias rwmount='sh $remountscript'" >>"$termux_merged_env"