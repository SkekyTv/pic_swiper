#!/usr/bin/env bash
# Wipes the photo gallery on a connected Android device/emulator and injects
# a fixed set of 12 sample photos, so the swipe screen always starts from a
# known, reproducible state.
#
# Usage: tool/seed_gallery/seed_gallery.sh [device_id]
#   device_id  optional adb device id (see `adb devices`). Defaults to the
#              only connected device, and fails if there is more than one.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHOTOS_DIR="$SCRIPT_DIR/photos"
DEVICE_DIR="/sdcard/Pictures/pic_swiper_samples"

ADB="${ANDROID_HOME:-$HOME/Android/Sdk}/platform-tools/adb"
if ! command -v "$ADB" >/dev/null 2>&1; then
  ADB="adb"
fi

if [ "${1:-}" != "" ]; then
  ADB_ARGS=(-s "$1")
else
  DEVICE_COUNT=$("$ADB" devices | grep -c $'\tdevice$' || true)
  if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo "No device/emulator detected. Start one first, e.g.:" >&2
    echo "  QT_QPA_PLATFORM=xcb flutter emulators --launch Pixel_9" >&2
    exit 1
  elif [ "$DEVICE_COUNT" -gt 1 ]; then
    echo "Multiple devices connected, pass one explicitly:" >&2
    "$ADB" devices >&2
    exit 1
  fi
  ADB_ARGS=()
fi

adb() { command "$ADB" "${ADB_ARGS[@]}" "$@"; }

echo "Wiping gallery..."
adb shell content delete --uri content://media/external/images/media >/dev/null 2>&1 || true
adb shell rm -rf /sdcard/DCIM/Camera /sdcard/Pictures >/dev/null
adb shell mkdir -p "$DEVICE_DIR"

echo "Pushing 12 sample photos..."
adb push "$PHOTOS_DIR"/. "$DEVICE_DIR"/ >/dev/null

echo "Scanning media..."
for f in $(adb shell ls "$DEVICE_DIR" | tr -d '\r'); do
  adb shell am broadcast \
    -a android.intent.action.MEDIA_SCANNER_SCAN_FILE \
    -d "file://$DEVICE_DIR/$f" >/dev/null
done

echo "Done. Gallery now has 12 sample photos."
