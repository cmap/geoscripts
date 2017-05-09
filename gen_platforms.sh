#!/bin/env bash
GEOBIN=/xchip/cogs/narayan/code/geoscripts
TGT_PLATFORM=${GEOBIN}/target_platforms.txt
OUTFILE=new_platform.txt
NEW_SAMPLE=new_samples.txt
NEW_SERIES=new_series.txt
OUTDIR=$PWD

#download SOFT files
$GEOBIN/geodl_soft.sh $TGT_PLATFORM $OUTDIR

#find alternate GPL ids [target platform but different id]
grep '!Platform_relation = ' $OUTDIR/GPL*.SOFT|grep -o 'GPL[0-9]*'|sort -n -k2 -t'L'|uniq > $OUTDIR/$OUTFILE

#download SOFT files for new GPL ids
$GEOBIN/geodl_soft.sh $OUTDIR/$OUTFILE $OUTDIR

# list of GSM ids across all platforms
cat $OUTDIR/$OUTFILE |while read g; do grep '!Platform_sample_id = ' $OUTDIR/$g.SOFT|grep -o 'GSM[0-9]*'; done |sort | uniq >$OUTDIR/$NEW_SAMPLE

cat $OUTDIR/$OUTFILE |while read g; do grep '!Platform_series_id = ' $OUTDIR/$g.SOFT|grep -o 'GSE[0-9]*'; done |sort | uniq >$OUTDIR/$NEW_SERIES
