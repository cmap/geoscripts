# Proper names for BGED CEL files
# Usage:
# awk --re-interval -f fix_celname.awk files.txt

{
    o=sanitize($0)
    print o
}

function sanitize(s){
# uppercase
    s=toupper(s)
# Fix gzip extension
    sub(/.GZ$/, ".gz", s)
# Remove special characters
    gsub(/\(/, "_", s)
    gsub(/[^[:alnum:]_\-\.]/, "", s)
    gsub(/!/,"", s)
# Replace spaces with underscores
    gsub(/ +/, "_",s)
    if (s ~ /^GSM/) {
# Fix GSM names, should be GSM[0-9]*.CEL.gz
	match(s, "^GSM[0-9]*")
	if (RSTART>0) 
	    s=substr(s, RSTART, RLENGTH)".CEL.gz"
    }
    else if (s !~ /^BSM_/) {
# add BSM prefix for non-GEO names
	s="BSM_"s
    }
# replace repeats with a single underscore
# NOTE: requires awk to be called using --re-interval
    gsub(/[_-]{2,}/, "_", s)
# cant begin or end with a special char
    gsub(/^[-_.]{1,}/,"",s)
    gsub(/[-_.]{1,}$/,"",s)
    return s
}

