#!/bin/bash
# GEODL_GSM.SH Download GEO GSM CEL files
# Usage: geodl_gsm.sh <filelist> [outdir] [Platform ID]
# filelist: GEO Accession numbers, one per line
# outdir: Output folder, default is PWD
# Platform ID: optional parameter that specifies the GEO platform ID.
#              Options are GPL96, GPL570 (default).
# Will attempt to ftp the CEL file from GEO:
# for GPL96 (This was the old layout, should use GPL570 layout now):
# ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/samples/$gsmFile/$gsmFile.CEL.gz
# for GPL570, GPL571 
# ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/samples/${gsmFile:0:6}nnn/$gsmFile/$gsmFile.CEL.gz

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:49 EDT
# Changes Jun.21.2010 Added Aspera support

USE_ASPERA=${USE_ASPERA:-0}

if [ $USE_ASPERA -eq 1 ]; then
#using aspera
    echo 'Using aspera to download files.'
    ftpurl="/xchip/cogs/tools/bin/aspera-connect/bin/ascp -o Overwrite=never -QT -q -l 300M -i /xchip/cogs/tools/bin/aspera-connect/etc/asperaweb_id_dsa.openssh anonftp@ftp-private.ncbi.nlm.nih.gov:/pub/geo/DATA/supplementary/samples"
    else
    echo 'Using wget to download files.'
#for wget
    ftpurl="ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/samples"
fi

#output folder
if [ "$2xxx" != "xxx" ]; then
    outdir=$2
else
    outdir="$PWD"
fi
#outdir="/xchip/bged/xprocess/samples"

#check optional Platform ID (default to GPL570)
if [ "$3xxx" != "xxx" ]; then
    GPLID=$3
else
    GPLID="GPL570"
fi

if [ "$1xxx" != "xxx" ]; then

    cat $1 | while read gsmFile;
    do
	gsmFile=${gsmFile%*.CEL}
	if [ ! -f "$outdir/$gsmFile.CEL" ]; then

	    if [ $GPLID == "GPL570" -o $GPLID == "GPL571" ]; then
		#url="$ftpurl/${gsmFile:0:6}nnn/$gsmFile/$gsmFile.CEL.gz"
		url="$ftpurl/${gsmFile:0:$(expr ${#gsmFile} - 3)}nnn/$gsmFile/$gsmFile.CEL.gz"
	    elif [ $GPLID == "GPL96" ]; then
		url="$ftpurl/$gsmFile/$gsmFile.CEL.gz"
	    else
		echo "Invalid platform ID $GPLID"
		exit 1;
	    fi

	    echo "Downloading: $url"
	    if [ $USE_ASPERA -eq 1 ]; then
		$url $outdir && echo "$gsmFile:ok Unzipping.." && gunzip -f "$outdir/$gsmFile.CEL.gz" || echo "$gsmFile:Error!"		
	    else
		wget $url -o wget.log -nv -N -P $outdir && echo "$gsmFile:ok Unzipping.." && gunzip -f "$outdir/$gsmFile.CEL.gz" || echo "$gsmFile:Error!"
	    fi
	    
	    echo "Done."
	else
	    echo "$gsmFile:ok Exists"
	fi
	
    done
else
    echo "Usage: geodl_gsm.sh <filelist> [outdir] [GEO Platform ID]"
fi
