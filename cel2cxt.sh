#!/bin/bash
#
# make CXT files from .CEL files

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:48 EDT

#OVERWRITE existing TXT file
#overwrite=1

# $Author: Arthur Liberzon [liberzon@broadinstitute.org]
# Changed: 17.May.2017 CEL2TXTCMD
# call 'use CMAP-R-3.2' before calling this script
# TODO: find a way to circumvent this call

#RBIN=/xchip/cogs/holmes/tools/R-2.7.0/bin/R
RBIN=R
#CEL2TXTCMD=/xchip/cogs/matlib/extra/geoscripts/cel2txt.r
CEL2TXTCMD=/cmap/users/liberzon/bged_al/geoscripts/cel2cxt.r

get_filename(){
# check if cel file exists, returns valid file in $validfn
    p=$1
    fn=${2%.CEL*}
    validfn=""
    if [ -f $p/${fn}.CEL.gz ]; then
	validfn=${fn}.CEL.gz
    elif [ -f $p/${fn}.CEL ]; then
	validfn=${fn}.CEL
    fi
}

run_cel2txt() {
# calls R script to convert a single CEL file to TXT
    celFile=$1
    txtFile=$2    
    if [ -f $celFile -a ! -f ${txtFile}.gz ]; then
	echo "$celFile:extracting text"
	$RBIN CMD BATCH --slave "--args celfile=$celFile outfile=$txtFile" $CEL2TXTCMD 
	gzip $txtFile	
    elif [ -f $txtFile -o -f ${txtFile}.gz ]; then
	echo "$celFile:text exists"
    elif [ ! -f $txtFile -o ! -f $txtFile ]; then
	echo "$celFile:missing"	
    fi
}

if [ "$1xxx" != "xxx" ]; then
    startRow=1
    stopRow=1000000
    nr=0;

    if [ "$2x" == "x" ]; then
	echo "celFolder not specified"
	exit 1;
    else
	celFolder="$2"
    fi

    if [ "$3x" == "x" ]; then
	echo "outFolder not specified"
	exit 1;
    else
	outFolder="$3"
    fi

#start and stop idx
    if [ "$4x" != "x" ]; then
	startRow=$4
    fi
    
    if [ "$5x" != "x" ]; then
	stopRow=$5
    fi

    # get $validfn
    get_filename $celFolder $1

    if [[ $validfn =~ ".CEL*" ]]; then
	celFile=$celFolder/${1%.CEL*}.CEL.gz
	txtFile=$outFolder/${1%.CEL*}.CXT
	run_cel2txt $celFile $txtFile
    else
	grep -v '^#' $1 | while read line;
	do
	    # get validfn
	    get_filename $celFolder $line
	    echo "vfn:$validfn, $celFolder $line"
	    celFile=$celFolder/${validfn}
	    txtFile=$outFolder/${validfn/.CEL*/}.CXT
	    nr=$(expr $nr + 1)
	    if [ $nr -ge $startRow -a $nr -le $stopRow ]; then
		run_cel2txt $celFile $txtFile
	    elif [ $nr -ge $stopRow ]; then
		exit
	    fi
	done
    fi
else 
    echo "cel2txt.sh: Extract MAS5 summarized expression values from Affymetrix CEL files." 
    echo "Usage: $0 <cel_list> <celFolder> <outFolder> [startRow] [stopRow]"
fi
