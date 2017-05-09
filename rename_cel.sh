#!/bin/bash
find . -maxdepth 1 -name 'GSM*.gz' | while read f; do 
    out=$(echo $f|tr 'a-z' 'A-Z'|sed 's/\(GSM[0-9]*\).*/\1.CEL.gz/')
    if [[ $f != $out ]]; then 
     	echo $f:$out 
	mv $f $out
    fi 
done