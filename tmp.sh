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

# Use the faster aspera client
USE_ASPERA=1
# downloads parent GSM folder instead of cel file. Should download CEL files that were named using a non standard scheme
USE_WILDCARD=1

sampdir='/xchip/bged/Update_GEO_Samples_June2010/gsm_not_in_bgedJune2010/Rajiv_CEL_files/'

if [ $USE_ASPERA -eq 1 ]; then
#using aspera
    ftpurl="/xchip/cogs/holmes/tools/bin/aspera-connect/bin/ascp -o Overwrite=never -QT -q -l 100M -i /xchip/cogs/holmes/tools/bin/aspera-connect/etc/asperaweb_id_dsa.putty anonftp@ftp-private.ncbi.nlm.nih.gov:/pub/geo/DATA/supplementary/samples"
    else
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

#check optional Platform ID (default to GPL96)
if [ "$3xxx" != "xxx" ]; then
    GPLID=$3
else
    GPLID="GPL570"
fi

if [ "$1xxx" != "xxx" ]; then

    cat $1 | while read gsmFile;
    do
	gsmFile=${gsmFile%%\.}
	if [ ! -f "$sampdir/$gsmFile.CEL"  ]; then

	    if [ $GPLID == "GPL570" -o $GPLID == "GPL571" ]; then
		if [ $USE_ASPERA -eq 1 -a $USE_WILDCARD -eq 1 ]; then
		    url="$ftpurl/${gsmFile:0:$(expr ${#gsmFile} - 3)}nnn/$gsmFile/"
		else
		    url="$ftpurl/${gsmFile:0:$(expr ${#gsmFile} - 3)}nnn/$gsmFile/$gsmFile"		    
		fi
	    elif [ $GPLID == "GPL96" ]; then
		url="$ftpurl/$gsmFile/$gsmFile"
	    else
		echo "Invalid platform ID $GPLID"
		exit 1;
	    fi

	    echo "Downloading: $url"
	    if [ $USE_ASPERA -eq 1 ]; then
		if [ $USE_WILDCARD -eq 1 ]; then
		    ${url} "$outdir" && echo "$gsmFile:ok Unzipping.."
		    # handle non-standard names
		    if [ $? -eq 0 ]; then
			# rename all files to uppercase
			find $outdir/$gsmFile/ -type f| while read f; do
			    bn=$(basename $f);
			    of=$(echo $bn | tr '[a-z]' '[A-Z]')
			    mv $f ${f/$bn/$of}
			done
			# if cel file exists rename and move to parent folder
			if [ -f $outdir/$gsmFile/${gsmFile}*.CEL.GZ ]; then
			    gunzip -cf $outdir/$gsmFile/${gsmFile}*.CEL.GZ > $outdir/${gsmFile}.CEL && rm -rf $outdir/$gsmFile || echo "Error unzipping!"
			fi
			
		    else
			echo "$gsmFile:Error!"; 
		    fi

		else
		    ${url}.CEL.gz $outdir/${gsmFile}.CEL.gz && echo "$gsmFile:ok Unzipping.." && gunzip -f "$outdir/${gsmFile}.CEL.gz" || echo "$gsmFile:Error!";
		fi
	    else
		wget ${url}.CEL.gz -o wget.log -nv -nc   -P $outdir && echo "$gsmFile:ok Unzipping.." && gunzip -f "$outdir/${gsmFile}.CEL.gz" || echo "$gsmFile:Error!"
	    fi
	    
	    echo "Done."
	else
	    echo "$gsmFile:ok Exists"
	fi
	
    done
else
    echo "Usage: geodl_gsm.sh <filelist> [outdir] [GEO Platform ID]"
fi
