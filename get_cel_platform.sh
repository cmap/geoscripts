#!/bin/bash

if [ "$1"xxx != "xxx" -a -f "$1" ]; then
    f=$1
    if  [[ "$f" == *.gz ]]; then
	platform=$(zcat $f|strings|sed -n -e '/.1sq/{p;q;}'|sed  's/\(.*\) \(.*\).1sq/\U\2/')
    else
	platform=$(cat $f|strings|sed -n -e '/.1sq/{p;q;}'|sed  's/\(.*\) \(.*\).1sq/\U\2/')
    fi
    if [ -z "$platform" ]; then
	platform=$(Rscript /xchip/cogs/matlib/extra/geoscripts/get_cel_platform.r celfile=$f 2>/dev/null| sed -n 's/#PLATFORM:\(.*\)/\1/p')
    fi
    echo -e "$f\t$platform"
fi
