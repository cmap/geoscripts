#!/bin/bash
# get information on all current geo platforms 
# creates a tab delimited text file: geo_platforms.txt

source /xchip/cogs/tools/bashtk/bashtk -q

rec_limit=5000
outfile="geo_platforms.txt"
total_platforms=$(curl -s 'http://www.ncbi.nlm.nih.gov/geo/browse/?view=platforms'|sed -n 's/.*"total_count">\(.*\)<.*/\1/p')
n_vol=$(ceil $(calc 11021 / $rec_limit))
echo "Total platforms: $total_platforms"
echo "Saving to $outfile"
for i in $(seq 1 $n_vol); do 
    st=$(calc "($i-1)*$rec_limit + 1")
    stp=$(min $(calc "$st + $rec_limit - 1 ") $total_platforms)
    #url="http://www.ncbi.nlm.nih.gov/geo/browse?view=platforms&zsort=date&amount=all_results&page=$i&mode=tsv&display=$rec_limit"
    url="http://www.ncbi.nlm.nih.gov/geo/browse/?view=platforms&amp;zsort=date&amp;amount=all_results&amp;page=$i&amp;mode=tsv&amp;display=$rec_limit"
    if [[ $i == 1 ]]; then
	curl -s $url > $outfile
    else
	curl -s $url |sed 1d >> $outfile
    fi
done
echo "done."
