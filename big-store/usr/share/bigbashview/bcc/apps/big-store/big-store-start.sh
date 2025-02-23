#!/bin/bash
#
# BigLinux Store 
# www.biglinux.com.br
# By Bruno Gonçalves
# 07/09/2020
# License: GPL v2 or greater 

#Translation
export TEXTDOMAINDIR="/usr/share/locale"
export TEXTDOMAIN=big-store


if [[ $(ps -aux | grep Big-Store | grep bigbashview) ]]; then

    kdialog --passivepopup $"A Big-Store já está em uso."
    exit
fi

cd /usr/share/bigbashview/bcc/apps/big-store/

HOME_FOLDER="$HOME/.bigstore"
TMP_FOLDER="/tmp/bigstore"


if [[ $(find "$HOME/.bigstore/snap.cache" -mtime +1 -print) ]] || [ ! -e "$HOME/.bigstore/snap.cache" ] ; then
  ./update_cache_snap &
fi

if [[ $(find "$HOME/.bigstore/flatpak.cache" -mtime +1 -print) ]] || [ ! -e "$HOME/.bigstore/flatpak.cache" ] ; then
  ./update_cache_flatpak &
fi


TITLE=$"Big-Store"

mkdir -p "$TMP_FOLDER"

# Save dynamic screenshot resolution
echo "$(xrandr | grep primary | sed 's|.*primary ||g;s|+.*||g;s|.*x||g') / 2" | bc > ${TMP_FOLDER}/screenshot-resolution.txt

/usr/share/bigbashview/bcc/apps/big-store/update_cache_flatpak &

if [ "$1" != "" ]; then
    QT_QPA_PLATFORM=xcb SDL_VIDEODRIVER=x11 WINIT_UNIX_BACKEND=x11 GDK_BACKEND=x11 bigbashview  -n "$TITLE" -w maximized index.sh.htm?search="$1" -i icon.svg
else
    QT_QPA_PLATFORM=xcb SDL_VIDEODRIVER=x11 WINIT_UNIX_BACKEND=x11 GDK_BACKEND=x11 bigbashview  -n "$TITLE" -w maximized index.sh.htm -i icon.svg
fi
