# termuxfree
Run any Termux package as root (real root!) in your ADB shell

![](https://github.com/hansalemaos/termuxfree/blob/main/pythonasroot.png?raw=true)

### 1. Download Termux from GitHub 
https://github.com/termux/termux-app/releases/download/v0.118.1/termux-app_v0.118.1+github-debug_x86_64.apk

### 2. Connect to the device, install termux-app_v0.118.1+github-debug_x86_64.apk and copy the scripts to the sdcard

```sh
adb connect 127.0.0.1:5595
adb -s 127.0.0.1:5595 install "C:\Users\hansc\Downloads\termux-app_v0.118.1+github-debug_x86_64.apk"
adb -s 127.0.0.1:5595 push C:\termuxfree /sdcard
```

### 3. open cmd.exe and start an ADB shell 

```sh
adb -s 127.0.0.1:5595 shell 
```

### 4. activate su and run the script termux_configure_termux.sh (do this only ONCE - takes about a minute to complete)
```sh
su 
sh /sdcard/termuxfree/termux_configure_termux.sh
```

### 5. activate the Termux env in your ADB shell and use any Termux package outside Termux 
```sh
# each time you open an adb shell, you have to execute 
source /sdcard/tenv.sh

# if you want to make changes to the Termux folder (rw remount), use
sh /sdcard/termuxfree/termux_remountscript.sh;source /sdcard/tenv.sh 

# execute /sdcard/oenv.sh to set the old env (usually not necessary, because adb resets the env automatically each time you start it)
source /sdcard/oenv.sh
```

### 6. after sourcing /sdcard/tenv.sh, you can install packages from the ADB shell like this:
```sh
# Note that all install commands will open the termux app to install packages.  
# If you install packages as root directly in your adb shell (pkg install), 
# you will mess up your termux installation due to user rights. 
# Termux (user u0_a136 in my case) has no rights to open files created by root (user 0) or shell (user 2000)
# So, if you don't want to run a lot of chmod/chgrp/chown commands to repair your Termux installation, install packages using these commands:
pkginstall python
pkgreinstall python
pkguninstall python
pkgup

#to (un)install python packages 
pipinstall cython
pipuninstall cython

```
### 7. run commands like you would in termux 
```sh
python
```