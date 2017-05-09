#!/bin/bash
# GEODL_SERIES.SH Download GEO CEL files associated with a series
# Usage: geodl_series.sh <filelist> [outdir]
# filelist: GEO Series Accession numbers, one per line
# outdir: Output folder, default is PWD
# Will attempt to download files from
# ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/series/${gseFile}_RAW.tar

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:49 EDT

USE_ASPERA=${USE_ASPERA:-0}
DELETE_TAR=${DELETE_TAR:-1}

if [ $USE_ASPERA -eq 1 ]; then
#using aspera
    ftpurl="/xchip/cogs/tools/bin/aspera-connect/bin/ascp -o Overwrite=never -QT -q -i /xchip/cogs/tools/bin/aspera-connect/etc/asperaweb_id_dsa.putty -l 300M anonftp@ftp-private.ncbi.nlm.nih.gov:/pub/geo/DATA/supplementary/series"
else
#for wget
    ftpurl="ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/series"
fi

#output folder
if [ "$2xxx" != "xxx" ]; then
    outdir=$2
else
    outdir="$PWD"
fi

if [ "$1xxx" != "xxx" ]; then

    grep -v '#' $1 | while read gseFile;
    do
	if [ ! -f "$outdir/${gseFile}_RAW.tar" ]; then
	    
	    url="$ftpurl/$gseFile/${gseFile}_RAW.tar"
	    echo "Downloading: $url"
	    if [ $USE_ASPERA -eq 1 ]; then
		$url $outdir
	    else
		wget $url -o wget.log -nv -nc -P $outdir 
	    fi
	    # Extract CEL files
	    if [[ -f "$outdir/${gseFile}_RAW.tar" ]]; then
		echo "$gseFile:ok Unzipping.."
		tar xvf "$outdir/${gseFile}_RAW.tar" -C "$outdir" --ignore-case '*.cel.*'
		[[ $? && $DELETE_TAR==1 ]] && rm $outdir/${gseFile}_RAW.tar 
	    else 
		echo "$gseFile:Error!"
	    fi

	    echo "Done."
	else
	    echo "$gseFile:ok Exists"
	fi
	
    done
else
    echo "Usage: geodl_series.sh <filelist> [outdir]"
fi
