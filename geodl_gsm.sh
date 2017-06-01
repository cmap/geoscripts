#!/bin/bash -
# GEODL_GSM.SH Download GEO GSM CEL files
# Usage: geodl_gsm.sh <filelist> [outdir] [Platform ID]
# filelist: GEO Accession numbers, one per line
# outdir: Output folder, default is PWD
# Platform ID: optional parameter that specifies the GEO platform ID.
#              Options are GPL96, GPL570 (default).
# Will attempt to ftp the CEL file from GEO:
# for GPL96 (This was the old layout, should use GPL570 layout now):
# ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/samples
#/$gsmFile/$gsmFile.CEL.gz
# for GPL570, GPL571 
# ftp://ftp.ncbi.nih.gov/pub/geo/DATA/supplementary/samples
#/${gsmFile:0:6}nnn/$gsmFile/$gsmFile.CEL.gz

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:49 EDT
# Changes: Jun.21.2010 Added Aspera support

# $EditsBy: Arthur Liberzon [liberzon@broadinstitute.org]
# Changes: May.11.2017 imposed bash strict mode
# Changes: May.11.2017 disabled Aspera support
# Changes: May.11.2017 updated path to Aspera client
# Changes: May.12.2017 added input parameter declarations
# Changes: May.15.2017 updated FTP url syntax

set -euo pipefail

#                              $1        $2          $3
usage="Usage: geodl_gsm.sh <filelist> [outdir] [GEO Platform ID]"

# filelist - required argument, list of GEO IDs, one per line
idlist="${1:-}"

if [[ -z $idlist ]]; then
	echo "${usage}"
	exit 1
fi

# output directory
workdir="/cmap/obelix/bged/staging/alworks"
celdir="${workdir}/cel"
outdir="${2:-${celdir}}"

# GEO Platform ID
gpl="${3:-"GPL570"}"

# Use the faster aspera client
# May 11, 2017: aspera doesn't work, change the setting to disable it
use_aspera=0
aspera_path="/cmap/tools/bin/aspera-connect/"
asperarg_1="bin/ascp -o Overwrite=never -QT -q -l 100M -i"
asperarg_2="${aspera_path}etc/asperaweb_id_dsa.putty"
asperarg_3="anonftp@ftp-private."
#ncbi_ftp="ncbi.nlm.nih.gov:/pub/geo/DATA/supplementary/samples"
ncbi_ftp="ncbi.nlm.nih.gov/geo/samples"

# downloads parent GSM folder instead of cel file. Should download CEL
# files that were named using a non standard scheme
use_wildcard=1

if [ "${use_aspera}" -eq 1 ]; then
#using aspera
	ftpurl="${aspera_path}${asperarg_1}${asperarg_2}${asperarg_3}${ncbi_ftp}"
    else
#for wget
	ftpurl="ftp://ftp.${ncbi_ftp}"
fi

##output folder
#if [ "${2}xxx" != "xxx" ]; then
#    outdir="${2}"
#else
#    outdir="${PWD}"
#fi
#
##check optional Platform ID (default to GPL96)
#if [ "${3}xxx" != "xxx" ]; then
#    gpl="${3}"
#else
#    gpl="GPL570"
#fi

url=""

if [ "${1}xxx" != "xxx" ]; then
	cat "${1}" | while read gsmFile;
	do
	gsmFile="${gsmFile%%\.}"

	# compose url
	urlBase="${ftpurl}/${gsmFile:0:$(expr ${#gsmFile} - 3)}nnn/${gsmFile}/"
	if [ ! -f "${outdir}/${gsmFile}.CEL" ]; then
#		if [ $gpl == "GPL570" -o $gpl == "GPL571" ]; then
		echo "make url for ${gpl}"
		if [ $use_aspera -eq 1 -a $use_wildcard -eq 1 ]; then
			url="${urlBase}"
		else
			url="${urlBase}suppl/$gsmFile"
		fi
#		elif [ $gpl == "GPL96" ]; then
#			url="${ftpurl}/${gsmFile}/${gsmFile}"
#		else
#			echo "Invalid platform ID ${gpl}"
#			exit 1;
#		fi

		echo "Downloading: ${url}"
		
		# download CEL
		if [ $use_aspera -eq 1 ]; then
			if [ $use_wildcard -eq 1 ]; then
				$url "${outdir}" && echo "${gsmFile}:ok Unzipping.."
		    	# handle non-standard names
				if [ $? -eq 0 ]; then
					# rename all files to uppercase
					find "${outdir}/${gsmFile}/" -type f | while read f;
					do
						bn=$(basename $f);
						of=$(echo $bn | tr '[a-z]' '[A-Z]')
						mv $f ${f/$bn/$of}
					done
					# if cel file exists rename and move to parent folder
					if [ -f "${outdir}/${gsmFile}/${gsmFile}*.CEL.GZ" ]; then
						gunzip -cf "${outdir}/${gsmFile}/${gsmFile}*.CEL.GZ" \
							> "${outdir}/${gsmFile}.CEL" \
							&& rm -rf "${outdir}/${gsmFile}" \
							|| echo "Error unzipping!"
					fi
				else
					echo "${gsmFile}:Error!"; 
				fi
			else
				"${url}.CEL.gz ${outdir}/${gsmFile}.CEL.gz" \
					&& echo "${gsmFile}:ok Unzipping.." \
					&& gunzip -f "${outdir}/${gsmFile}.CEL.gz" \
					|| echo "${gsmFile}:Error!"
			fi
	    else
			echo "${url}"
			wget "${url}*.CEL.gz" -o wget.log -nv -nc -P "${outdir}" \
				&& echo "${gsmFile}:ok Unzipping.." \
				&& gunzip -f ${outdir}/$gsmFile*.CEL.gz \
				|| echo "${gsmFile}:Error!"
		fi
		echo "Done."
	else
		echo "${gsmFile}:ok Exists"
	fi
	done
fi
