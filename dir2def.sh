#!/bin/bash

# Convert the output directory name, in my convention, to the SAM definition
# used for it (also my convention)

dir="$(basename "$1")"

# Repair timestamp, which couldn't have colons in it in the filesystem because of SAM
rfctime=$(echo $dir | cut -d- -f 1-5 | sed 's/\(....-..-..T..\)-\(..\)-/\1:\2:/')
fracsec=$(cut -d. -f 2 -s  <<< $rfctime | cut -dZ -f 1)
if [ $fracsec ]; then
  unixtime=$(TZ=UTC date +%s -d "$(echo $rfctime | sed -e 's/T/ /' -e 's/\..*//')").$fracsec
else
  unixtime=$(TZ=UTC date +%s -d "$(echo $rfctime | sed -e 's/T/ /' -e 's/\..*//')")
fi
stream=$(echo $dir | cut -d- -f 6-7)

echo strait-ligo-coincidence-artdaq-${unixtime}-${stream}
