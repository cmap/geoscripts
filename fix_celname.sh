#!/bin/env bash
source /cmap/tools/sig_tools/bin/bashtk -q
#source /xchip/cogs/matlib/bin/bashtk -q
SCRIPT="${0##*/}"

# Edits: Arthur Liberzon [liberzon@broadinstitute.org]
# Change: 15.May.2017 renamed to 'fix_celname.sh'
# Change: 15.May.2017 updated path to bashtk 

USAGE_HELP="--------------------------------------------------
$SCRIPT: Standardize cel file names.
Author: Rajiv Narayan [narayan@broadinstitute.org]
--------------------------------------------------
Usage: $SCRIPT [cel file folder]
"

CELPATH="$1"
SANITIZE_BIN=$(dirname $0)'/fix_celname.awk'
if [[ -n $CELPATH ]]; then
    RPT="$CELPATH/$SCRIPT.rpt"
    echo -e "SAMPLE_ID\tORIG_NAME\tSTD_NAME\tSTATUS" > $RPT
    find $CELPATH -iname '*.CEL' -o -iname '*.CEL.gz'| while read f;
	do
 	# gzip if needed
	if [[ $(echo $f| tr '[:lower:]' '[:upper:]') =~ '.CEL$' ]]; then
	    print_hl "Gzipping $f"
	    gzip -9 "$f"
	    f=${f}.gz
	fi
	# file path
	p=${f%/*}
	if [[ $p == $f ]]; then 
	    p="$PWD"
	fi
	# filename
	fn="${f##*/}"	
	# sanitized name
	ofn=$(echo $fn | awk --re-interval -f $SANITIZE_BIN)
	dest=$p/$ofn
	status="UNCHANGED"
	status_busy "Renaming $fn to $ofn"
	
	if [[ -z $ofn ]]; then
		status_append "Zero length string"
		status_fail
		status="FAIL"
	else
		if [[ $f != $dest && ! -f $dest ]]; then
			mv "$f" "$dest"
			status_pass
			status="RENAMED"
	    elif [[ -f $dest && $f != $dest ]]; then
			status_append "EXISTS skipping"
			status="SKIPPED"
			status_fail
	    else
			status_append "UNCHANGED"
			status_pass
	    fi
	fi
	echo -e  "${ofn/.CEL.gz/}\t$fn\t$ofn\t$status" >> $RPT
    done
else
    msg_help
fi
