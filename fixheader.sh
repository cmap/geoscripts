#!/bin/bash

for f in *.CEL
do
  chip=$(/xchip/cogs/matlib/extra/geoscripts/get_cel_platform.sh $f|cut -f2|sed 's/ //')
  cat ${chip}.hdr > fixed/$f
  awk 'BEGIN{ok=0}/^\[INTENSITY\]/{ok=1;} {if (ok==1) print;}' $f >> fixed/$f
done
