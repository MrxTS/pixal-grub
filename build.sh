#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST="$SCRIPT_DIR/dist"
SRC_VIDEO="$HOME/qylock/themes/pixel-emerald/bg.mp4"
SRC_FONT="$HOME/qylock/themes/pixel-emerald/font/PixelifySans-Bold.ttf"

mkdir -p "$DIST"

echo "==> Hintergrundbild..."
ffmpeg -y -ss 2.0 \
  -i "$SRC_VIDEO" \
  -vframes 1 \
  -vf "scale=2560:1440:flags=lanczos" \
  -update 1 \
  "$DIST/background.png"

echo "==> Fertig: $DIST/background.png"

echo "==> Fonts konvertieren..."
grub-mkfont -s 22 -n "PixelifySans Bold" -o "$DIST/pixel-emerald-22.pf2" "$SRC_FONT"
grub-mkfont -s 16 -n "PixelifySans Bold" -o "$DIST/pixel-emerald-16.pf2" "$SRC_FONT"
echo "==> Fertig: pixel-emerald-16.pf2, pixel-emerald-22.pf2"
