#!/bin/bash

if [ $1 ]; then
  GWNAME=$1
fi

. $SRT_PRIVATE_CONTEXT/ligo/env.sh

markcomplete.sh

mkdir -p $outhistdir
cd $outhistdir

for f in */complete; do
  $SRT_PRIVATE_CONTEXT/ligo/combine.sh $(dirname $f)
done
