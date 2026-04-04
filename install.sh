#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST="$SCRIPT_DIR/dist"
THEME_DIR="/boot/grub/themes/pixel-emerald"

if [[ ! -f "$DIST/background.png" ]]; then
  echo "FEHLER: dist/ leer — erst ./build.sh ausführen"
  exit 1
fi

echo "==> Installiere nach $THEME_DIR ..."
sudo mkdir -p "$THEME_DIR"
sudo cp "$DIST/background.png"          "$THEME_DIR/"
sudo cp "$DIST/pixel-emerald-16.pf2"    "$THEME_DIR/"
sudo cp "$DIST/pixel-emerald-22.pf2"    "$THEME_DIR/"
sudo cp "$DIST/select_c.png"            "$THEME_DIR/"
sudo cp "$DIST/select_e.png"            "$THEME_DIR/"
sudo cp "$DIST/select_w.png"            "$THEME_DIR/"
sudo cp "$SCRIPT_DIR/theme.txt"         "$THEME_DIR/"

echo "==> Installiert: $THEME_DIR"
ls "$THEME_DIR"
