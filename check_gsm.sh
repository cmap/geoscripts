#!/bin/bash
GSM_DIR='/xchip/bged/downloads/gsm'
cat $1 |while read f; do 
    isbad=$(zcat ${GSM_DIR}/${f}.SOFT.gz|grep -c 'DOCTYPE'); 
    if [[ $isbad -gt 0 ]]; then echo $f; fi; 
done 