#!/bin/bash -

# GEODL_SOFT.SH Download GEO SOFT annotation files.
# Usage: geodl_soft.sh <filelist> [outdir]
# filelist: GEO Accession numbers (GSE or GSM), one per line
# outdir: output folder [default=$PWD]
#       : if filelist has gse_ids, use gsepath as outdir
#       : if filelist has gsm_ids, use gsmpath as outdir
# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $EditsBy: Arthur Liberzon [liberzon@broadinstute.org]
# $Version: 143
# $Date: Jun.15.2010 19:08:50 EDT
# Changes: Nov.5.2015 imposed bash strict mode
# Changes: May.10.2017 updated gsepath and gsmpath values
# Changes: May.10.2017 updated GEO URL
# Changes: May.11.2017 declared new workdir

set -euo pipefail

# IFS = internal field separator
IFS=$'\n\t'

#                              $1                 $2
usage="Usage: geodl_soft.sh gse_or_gsm_ids.grp soft_folder"

# output folder
workdir="/cmap/obelix/bged/staging/alworks"
gsepath="${workdir}/gse"
gsmpath="${workdir}/gsm"

#check_bged=${check_bged:-1}

idlist="${1:-}"
outdir="${2:-${PWD}}"
baseurl="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc="
endurl="&amp;targ=self&form=text&view=quick"

if [[ -z $idlist ]]; then
	echo "${usage}"
	exit 1
fi

echo "Writing SOFT file annotations to ${outdir}"

function check() {
    f="${1}"
    outdir="${2}"
    exists=0
    for p in $outdir $gsepath $gsmpath;
    do
	if [[ -f "${p}/${f}.SOFT" || -f "${p}/${f}.SOFT.gz" ]]; then
	    exists=1
	    break
	fi
    done
    [[ $exists == 1 ]]
}

if [ "${1}xxx" != "xxx" ]; then
    grep -v "#" $1 | while read i
    do
		outfile="${outdir}/${i}.SOFT"
		echo "${i}"
	if (! check $i $outdir ); then
		forcurl="${baseurl}${i}${endurl}"
		curl --progress-bar "${forcurl}" -o "${outfile}"
	else
	    if [[ ! -f $outfile ]]; then
			echo "File exists in BGED, skipping"
	    	else
			echo "Exists skipping"
	    fi
	fi
    done
else
    echo "Usage: geodl_soft.sh <filelist> [outdir]"
fi

exit 0 # all is well
