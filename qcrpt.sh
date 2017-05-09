#!/bin/bash
# QCRPT.SH generate qcreport from TXT file
# This is a wrapper for qcrpt.r script 
# Usage: ./qcrpt.sh <txt_list> <txtFolder> <outFile>

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:51 EDT

#RBIN=/xchip/cogs/holmes/tools/R-2.7.0/bin/R
RBIN=R
QCRPTCMD=/xchip/cogs/matlib/extra/geoscripts/qcrpt.r

if [ "$1xxx" != "xxx" ]; then

    txtFiles="$1"

    if [ "$2x" == "x" ]; then
	echo "txtPath not specified"
	exit 1;
    else
	txtPath="$2"
    fi

    if [ "$3x" == "x" ]; then
	echo "outFile not specified"
	exit 1;
    else
	outFile="$3"
    fi

    echo "Generating QC report..."
    echo $RBIN CMD BATCH --slave "--args  txtpath=$txtPath txtfiles=$txtFiles outfile=$outFile" $QCRPTCMD
    $RBIN CMD BATCH --slave "--args  txtpath=$txtPath txtfiles=$txtFiles outfile=$outFile" $QCRPTCMD	
    
else 
     echo "Usage: $0 <txt_list> <txtFolder> <outFile>"
fi
