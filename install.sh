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
sudo cp "$DIST/pixel-emerald-28.pf2"    "$THEME_DIR/"
sudo cp "$DIST"/select_*.png            "$THEME_DIR/"
sudo cp -r "$DIST/icons"               "$THEME_DIR/"
sudo cp "$SCRIPT_DIR/theme.txt"         "$THEME_DIR/"

echo "==> Installiert: $THEME_DIR"
ls "$THEME_DIR"

GRUB_DEFAULT="/etc/default/grub"
THEME_PATH="$THEME_DIR/theme.txt"

echo "==> Setze GRUB_THEME in $GRUB_DEFAULT ..."
# GRUB_THEME setzen oder ersetzen
if grep -q "^GRUB_THEME=" "$GRUB_DEFAULT"; then
  sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$THEME_PATH\"|" "$GRUB_DEFAULT"
else
  echo "GRUB_THEME=\"$THEME_PATH\"" | sudo tee -a "$GRUB_DEFAULT" > /dev/null
fi

# GRUB_BACKGROUND auskommentieren falls vorhanden (würde theme überschreiben)
if grep -q "^GRUB_BACKGROUND=" "$GRUB_DEFAULT"; then
  sudo sed -i "s|^GRUB_BACKGROUND=|# GRUB_BACKGROUND=|" "$GRUB_DEFAULT"
  echo "==> GRUB_BACKGROUND auskommentiert (würde Theme überschreiben)"
fi

echo "==> Generiere grub.cfg ..."
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "==> Fertig. Beim nächsten Boot ist das Theme aktiv."
