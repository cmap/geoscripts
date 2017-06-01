#!/bin/bash
# QCRPT.SH generate qcreport from TXT file
# This is a wrapper for qcrpt.r script 
# Usage: ./qcrpt.sh <cxt_list> <cxtFolder> <outFile>

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:51 EDT

# $Author: Arthur Liberzon [liberzon@broadinstitute.org]
# Changed: 17.May.2017 added workdir to support full path info
# Changed: 17.May.2017 changed all 'txt' to 'cxt'
# Changed: 17.May.2017 updated QCRTCMD
# to make R work, call 'CMAP-R-3.2' first, then the script
# TODO: find a way to circumvent it

#RBIN=/xchip/cogs/holmes/tools/R-2.7.0/bin/R
RBIN=R
#QCRPTCMD=/xchip/cogs/matlib/extra/geoscripts/qcrpt.r
QCRPTCMD="/cmap/users/liberzon/bged_al/geoscripts/qcrpt.r"

workdir="/cmap/obelix/bged/staging/alwork"

if [ "$1xxx" != "xxx" ]; then

    cxtFiles="${workdir}/${1}"

    if [ "$2x" == "x" ]; then
	echo "cxtPath not specified"
	exit 1;
    else
	cxtPath="$2"
    fi

    if [ "$3x" == "x" ]; then
	echo "outFile not specified"
	exit 1;
    else
	outFile="$3"
    fi

    echo "Generating QC report..."
    echo $RBIN CMD BATCH --slave "--args  cxtpath=$cxtPath cxtfiles=$cxtFiles outfile=$outFile" $QCRPTCMD
    $RBIN CMD BATCH --slave "--args  cxtpath=$cxtPath cxtfiles=$cxtFiles outfile=$outFile" $QCRPTCMD	
    
else 
     echo "Usage: $0 <cxt_list> <cxtFolder> <outFile>"
fi
