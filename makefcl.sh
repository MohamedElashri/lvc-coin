#!/bin/bash

if [ $# -ne 3 ] && [ $# -ne 2 ]; then
  echo Syntax: $(basename $0) analysis_type timestamp {skymap}
  echo "Where analysis_type is the XXX in ligojob_XXX.fcl" 
  echo "      timestamp is the time of the GW event" 
  echo "      skymap is the FITS file, optional, will use a dummy" 
  echo "        if you do not specify one" 
  exit 1
fi

type=$1
unixtime=$2
skymap=/pnfs/nova/users/mstrait/ligo/LALInference_skymap-GW170817.fits
if [ $3 ]; then
  skymap=$3
fi

rfctime=$(TZ=UTC date "+%Y-%m-%dT%H:%M:%S" -d @$unixtime).${fracsec}Z
fcl=ligojob_$type.$rfctime.fcl

if ! [ -e $SRT_PRIVATE_CONTEXT/job/ligojob_$type.fcl ]; then
  echo Analysis type $type not supported
  exit 1
fi

# NOTE NeedBGEventTime -- set to a test value now, but will need to be set to
# real GW event time, and should be scripted up better for that.

cat $SRT_PRIVATE_CONTEXT/job/ligojob_$type.fcl | \
  sed "/this_here_ligoanalysis: @local/a this_here_ligoanalysis.GWEventTime: \"$rfctime\"\
      \nthis_here_ligoanalysis.NeedBGEventTime: \"2019-03-24T13:29:01.Z\"\
      \nthis_here_ligofilter.GWEventTime: \"$rfctime\"\
      \nthis_here_ligoanalysis.SkyMap: \"$skymap\"" > $SRT_PRIVATE_CONTEXT/job/$fcl

echo $SRT_PRIVATE_CONTEXT/job/$fcl created
