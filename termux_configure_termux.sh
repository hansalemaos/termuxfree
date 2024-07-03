SCRIPT="$(realpath "$0")"
SCRIPTPATH="$(dirname "$SCRIPT")"
remountscript="$SCRIPTPATH/termux_remountscript.sh"
pkginstallscript="$SCRIPTPATH/termux_pkg_install.sh"
makeenvscript="$SCRIPTPATH/termux_makeenv.sh"
pkupscript="$SCRIPTPATH/termux_pkg_up.sh"
sh "$remountscript"
monkey -p com.termux 1
sleep 5
input text 'yes | termux-change-repo'
startvar=0
while [ "$startvar" -le 20 ]; do
    input keyevent KEYCODE_ENTER
    startvar=$((startvar + 1))
    sleep 0.1
done
input keyevent KEYCODE_ENTER
input keyevent KEYCODE_ENTER
pkill com.termux
sleep 5
monkey -p com.termux 1
sleep 1
monkey -p com.termux 1
sleep 1
eval "sh $pkupscript"
eval "sh $pkginstallscript root-repo"
eval "sh $makeenvscript"

