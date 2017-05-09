# convert Metric tab CXT output to the R version
BEGIN {
OFS="\t"
print "#TXT_VIA_R_MAS5"
print "NAME\tMAS5\tPCALL"

}

/^[0-9]/ {print $3,$6,$7}