#!/bin/bash

def="$1"

# totally gratuitous.  Discards stdout of command piped in for first
# 3-4 seconds.  Motivation: "samweb prestage-dataset" says nothing useful
# in that time.
outputafterfirstfewseconds()
{
  t=$(date +%s)
  while read line; do
    tnow=$(date +%s)
    if [ $((tnow - t)) -gt 3 ]; then
      echo "$line"
    fi
  done
}

# If there's only one file in the set, it says CACHED or NOT
# CACHED.  Otherwise it says "Cached:" and gives a percent.
cachedpercent=$(cache_state.py -d $def | tee /dev/stderr | \
  awk '/^CACHED$/  {print 100;}\
       /NOT CACHED/{print 0;}\
       /Cached:/   {split($3, n, "("); print n[2]*1;}')


doit()
{
  samweb prestage-dataset --socket-timeout=1800 --defname=$def \
    --parallel 4 2> /dev/stdout | outputafterfirstfewseconds
}

if ! [ $cachedpercent ]; then
  echo Could not see how many files were cached, trying to cache them
  doit
elif [ "$cachedpercent" -lt 100 ]; then
  echo Not all files are cached.  Caching...
  doit
fi
