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
grub-mkfont -s 28 -n "PixelifySans" -o "$DIST/pixel-emerald-28.pf2" "$SRC_FONT"
grub-mkfont -s 16 -n "PixelifySans" -o "$DIST/pixel-emerald-16.pf2" "$SRC_FONT"
echo "==> Fertig: pixel-emerald-16.pf2, pixel-emerald-28.pf2"

echo "==> Selection-Sprites (9-part)..."
# GRUB boot_menu verwendet 9-part pixmap style: c/n/s/e/w/ne/nw/se/sw
# Strategie: n/ne/nw/c/w/e transparent; s/sw/se = Emerald-Underline (L px hoch)
L=3   # Liniendicke (Höhe des _s-Streifens = sichtbare Underline)
SW=4  # Breite der Seitenteile (w/e/sw/se)

# Transparente Teile: PNG32: erzwingt RGBA (color_type=6), GRUB-kompatibel
convert -size 1x1     xc:none PNG32:"$DIST/select_c.png"
convert -size 1x1     xc:none PNG32:"$DIST/select_n.png"
convert -size 1x1     xc:none PNG32:"$DIST/select_ne.png"
convert -size 1x1     xc:none PNG32:"$DIST/select_nw.png"
convert -size ${SW}x1 xc:none PNG32:"$DIST/select_w.png"
convert -size ${SW}x1 xc:none PNG32:"$DIST/select_e.png"

# Unterline-Teile: volle Emerald-Farbe, RGBA
convert -size 1x${L}     xc:'#1fce8c' PNG32:"$DIST/select_s.png"
convert -size ${SW}x${L} xc:'#1fce8c' PNG32:"$DIST/select_sw.png"
convert -size ${SW}x${L} xc:'#1fce8c' PNG32:"$DIST/select_se.png"

echo "==> Fertig: select_*.png (9-part, ${L}px Emerald-Underline via _s/_sw/_se)"

echo "==> Icons generieren..."
ICONS="$DIST/icons"
mkdir -p "$ICONS"

E='#1fce8c'  # Emerald
M='#60e8b6'  # Mint
W='#c0c0c0'  # Dim White
T='none'     # Transparent

# Linux-Pinguin (32x32, Pixel-Art)
convert -size 32x32 xc:$T \
  -fill "$E" \
  -draw "rectangle 11,2 20,6"   \
  -draw "rectangle 9,6 22,18"   \
  -draw "rectangle 7,16 24,28"  \
  -draw "rectangle 7,26 12,31"  \
  -draw "rectangle 19,26 24,31" \
  -fill "$M" \
  -draw "rectangle 12,8 19,17"  \
  -draw "rectangle 11,18 20,27" \
  -fill "$W" \
  -draw "rectangle 12,4 14,7"   \
  -draw "rectangle 17,4 19,7"   \
  PNG32:"$ICONS/linux.png"

# GRUB-Klassen für Linux-Einträge (erste Klasse bestimmt das Icon)
cp "$ICONS/linux.png" "$ICONS/cachyos.png"
cp "$ICONS/linux.png" "$ICONS/gnulinux.png"
cp "$ICONS/linux.png" "$ICONS/gnu-linux.png"
cp "$ICONS/linux.png" "$ICONS/gnu.png"

# Windows-Logo (4 Quadrate)
convert -size 32x32 xc:$T \
  -fill "$W" \
  -draw "rectangle 3,3 14,14"   \
  -draw "rectangle 17,3 28,14"  \
  -draw "rectangle 3,17 14,28"  \
  -draw "rectangle 17,17 28,28" \
  PNG32:"$ICONS/windows.png"
cp "$ICONS/windows.png" "$ICONS/windows8.png"
cp "$ICONS/windows.png" "$ICONS/windows10.png"
cp "$ICONS/windows.png" "$ICONS/windows11.png"

# UEFI-Firmware (einfaches Zahnrad-ähnliches Symbol)
convert -size 32x32 xc:$T \
  -fill "$M" \
  -draw "ellipse 16,16 8,8 0,360" \
  -draw "rectangle 13,1 18,7"  \
  -draw "rectangle 13,24 18,30" \
  -draw "rectangle 1,13 7,18"  \
  -draw "rectangle 24,13 30,18" \
  -draw "rectangle 4,4 9,9"    \
  -draw "rectangle 22,4 27,9"  \
  -draw "rectangle 4,22 9,27"  \
  -draw "rectangle 22,22 27,27" \
  -fill "$T" \
  -draw "ellipse 16,16 4,4 0,360" \
  PNG32:"$ICONS/uefi-firmware.png"
cp "$ICONS/uefi-firmware.png" "$ICONS/efi.png"

# Memtest
convert -size 32x32 xc:$T \
  -fill "$E" \
  -draw "rectangle 4,4 27,27" \
  -fill "$T" \
  -draw "rectangle 7,7 24,24" \
  -fill "$E" \
  -draw "rectangle 10,13 21,14" \
  -draw "rectangle 10,17 21,18" \
  -draw "rectangle 15,10 16,21" \
  PNG32:"$ICONS/memtest86+.png"
cp "$ICONS/memtest86+.png" "$ICONS/memtest.png"

# Submenu (Ordner-Symbol)
convert -size 32x32 xc:$T \
  -fill "$W" \
  -draw "rectangle 3,8 13,11"   \
  -draw "rectangle 3,11 28,26"  \
  -fill "$T" \
  -draw "rectangle 5,13 26,24"  \
  PNG32:"$ICONS/submenu.png"

# Shutdown / Halt
convert -size 32x32 xc:$T \
  -fill "$W" \
  -draw "arc 6,6 25,25 -60,240" \
  -fill "$T" \
  -draw "arc 9,9 22,22 -60,240" \
  -fill "$W" \
  -draw "rectangle 14,3 17,16" \
  PNG32:"$ICONS/shutdown.png"
cp "$ICONS/shutdown.png" "$ICONS/halt.png"
cp "$ICONS/shutdown.png" "$ICONS/reboot.png"

echo "==> Fertig: icons/ (linux, windows, uefi-firmware, memtest, shutdown)"

echo "==> Fertig"
