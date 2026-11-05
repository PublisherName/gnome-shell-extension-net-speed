#!/bin/bash
set -euo pipefail

if (( $EUID == 0 )); then
        INSTALL_DIR="/usr/share/gnome-shell/extensions"
else
        INSTALL_DIR="$HOME/.local/share/gnome-shell/extensions"
fi
mkdir -p "$INSTALL_DIR"

SRC_DIR="$(dirname "$0")/netspeedindicator@subashghimire.info.np"
DEST_DIR="$INSTALL_DIR/netspeedindicator@subashghimire.info.np"

echo "Installing extension files in $DEST_DIR"
rm -rf "$DEST_DIR"
cp -r "$SRC_DIR" "$DEST_DIR"

echo "Done."
echo "Restart GNOME Shell (Alt+F2, then 'r' + Enter on X11, or log out/in on Wayland) and enable 'Net Speed Indicator' in GNOME Extensions."
