#!/usr/bin/env bash
# Wipes the photo gallery on a connected Android device/emulator and injects
# a fixed set of 18 sample photos (12 portrait + 6 landscape), so the swipe
# screen always starts from a known, reproducible state.
#
# Each photo is stamped with a specific creation date (spread across the
# past ~2 years, with several photos sharing a month and several months
# having none) so the month/year date filter can be exercised: some months
# must appear in the picker with more than one photo, and months with zero
# photos must not appear at all.
#
# MediaStore's date_added/date_taken columns cannot be edited directly (Android
# silently ignores ContentProvider updates to those columns, even as root), so
# the only reliable way to backdate a photo is to set the device's system
# clock to the target date *before* pushing+scanning it, then move on. This
# requires a rootable system image (adb root) — a Google Play system image
# (the default when creating an AVD from Android Studio's device picker)
# refuses both `adb root` and clock changes. Use a "Google APIs" (non-Play
# Store) system image instead, e.g.:
#   sdkmanager "system-images;android-<api>;google_apis_ps16k;x86_64"
#   avdmanager create avd -n Pixel_9_dev -k "system-images;android-<api>;google_apis_ps16k;x86_64" -d pixel_9
#
# Usage: tool/seed_gallery/seed_gallery.sh [device_id]
#   device_id  optional adb device id (see `adb devices`). Defaults to the
#              only connected device, and fails if there is more than one.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHOTOS_DIR="$SCRIPT_DIR/photos"
DEVICE_DIR="/sdcard/Pictures/pic_swiper_samples"

# Months to subtract from the current month for each sample photo's creation
# date. Repeated values put several photos in the same month (to test
# multi-photo months); skipped values leave gaps (to test that empty months
# are hidden from the picker).
declare -A MONTHS_AGO=(
  [sample_01.png]=0
  [sample_02.png]=0
  [sample_03.png]=1
  [sample_04.png]=3
  [sample_05.png]=3
  [sample_06.png]=3
  [sample_07.png]=6
  [sample_08.png]=6
  [sample_09.png]=8
  [sample_10.png]=11
  [sample_11.png]=11
  [sample_12.png]=14
  [sample_13_landscape.png]=14
  [sample_14_landscape.png]=18
  [sample_15_landscape.png]=20
  [sample_16_landscape.png]=20
  [sample_17_landscape.png]=23
  [sample_18_landscape.png]=23
)

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
    echo "  QT_QPA_PLATFORM=xcb flutter emulators --launch Pixel_9_dev" >&2
    exit 1
  elif [ "$DEVICE_COUNT" -gt 1 ]; then
    echo "Multiple devices connected, pass one explicitly:" >&2
    "$ADB" devices >&2
    exit 1
  fi
  ADB_ARGS=()
fi

adb() { command "$ADB" "${ADB_ARGS[@]}" "$@"; }
# A single remote command string, so adb's re-quoting doesn't mangle nested
# quotes (passing several separate argv words to `adb shell` is unreliable).
adbsh() { adb shell "$1"; }

echo "Requesting root (needed to backdate photos via the system clock)..."
adb root >/dev/null 2>&1 || true
sleep 1
if [ "$(adbsh 'whoami' | tr -d '\r')" != "root" ]; then
  echo "This device/emulator does not support 'adb root'." >&2
  echo "Use a non-Play-Store \"Google APIs\" system image (Play Store images" >&2
  echo "block both adb root and system clock changes) — see the comment at" >&2
  echo "the top of this script." >&2
  exit 1
fi

# Always leave the device clock on real time, even on failure.
restore_time() {
  local now
  now=$(date -u +%Y-%m-%dT%H:%M:%S)
  adbsh "date -u -s '$now'" >/dev/null 2>&1 || true
}
trap restore_time EXIT

# UTC "YYYY-MM-DD HH:MM:SS" for the 10th of the month that is $1 months
# before the current month, at noon.
target_datetime_for_months_ago() {
  local months_ago="$1"
  local month_start
  month_start=$(date -u -d "$(date -u +%Y-%m-01) -${months_ago} month" +%Y-%m-10)
  echo "${month_start} 12:00:00"
}

PHOTO_COUNT=$(find "$PHOTOS_DIR" -type f -name '*.png' | wc -l | tr -d ' ')

echo "Wiping gallery..."
adb shell content delete --uri content://media/external/images/media >/dev/null 2>&1 || true
adb shell rm -rf /sdcard/DCIM/Camera /sdcard/Pictures >/dev/null
adb shell mkdir -p "$DEVICE_DIR"
# /sdcard is a symlink; MediaStore's _data column holds the resolved path, so
# querying by _data needs to match against that, not the /sdcard/... spelling.
DEVICE_DIR_REAL=$(adbsh "realpath $DEVICE_DIR" | tr -d '\r')

# Block until $1 is indexed in MediaStore. The scan broadcast is fire-and-
# forget, so without this the loop can change the clock for the *next* group
# before MediaProvider has actually written the previous group's row — which
# stamps date_added with whatever time the clock happens to be at by the time
# the async scan finally runs, not the time it was pushed at.
wait_until_indexed() {
  local f="$1"
  for _ in $(seq 1 30); do
    row_count=$(adbsh "content query --uri content://media/external/images/media --projection _id --where \"_data='$DEVICE_DIR_REAL/$f'\"" | grep -c '^Row:' || true)
    if [ "$row_count" -gt 0 ]; then
      return 0
    fi
    sleep 0.3
  done
  echo "  Warning: $f was not indexed in time; its date may be wrong" >&2
}

# Group sample files by their target month so the clock only needs to change
# once per distinct month instead of once per file.
declare -A FILES_FOR_MONTHS_AGO=()
for f in "${!MONTHS_AGO[@]}"; do
  months_ago="${MONTHS_AGO[$f]}"
  FILES_FOR_MONTHS_AGO[$months_ago]="${FILES_FOR_MONTHS_AGO[$months_ago]:-} $f"
done

DISTINCT_MONTHS=$(printf '%s\n' "${!FILES_FOR_MONTHS_AGO[@]}" | sort -n)

echo "Pushing $PHOTO_COUNT sample photos, backdated across $(echo "$DISTINCT_MONTHS" | wc -l | tr -d ' ') distinct months..."
for months_ago in $DISTINCT_MONTHS; do
  files=(${FILES_FOR_MONTHS_AGO[$months_ago]})
  target=$(target_datetime_for_months_ago "$months_ago")

  adbsh "date -u -s '$target'" >/dev/null

  sources=()
  for f in "${files[@]}"; do
    sources+=("$PHOTOS_DIR/$f")
  done
  adb push "${sources[@]}" "$DEVICE_DIR/" >/dev/null

  for f in "${files[@]}"; do
    adb shell am broadcast \
      -a android.intent.action.MEDIA_SCANNER_SCAN_FILE \
      -d "file://$DEVICE_DIR/$f" >/dev/null
  done

  # Wait for the scan to actually land before the clock moves again, so this
  # group's date_added isn't stamped with a later group's (or the restored
  # real) time by a scan that's still catching up.
  for f in "${files[@]}"; do
    wait_until_indexed "$f"
  done
done

echo "Done. Gallery now has $PHOTO_COUNT sample photos across $(echo "$DISTINCT_MONTHS" | wc -l | tr -d ' ') distinct months."
