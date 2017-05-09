# gse2sin.awk Extract annotation from GSE SOFT files

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:53 EDT

# CHANGES: 
# 6/19/2010: Sanitize inputs
# 6/21/2010: Multiple series, keyword extraction

#TODO:
# Capture additional fields
# See: http://bioinformatics.tgen.org/brunit/software/bioparser/docs/enc_bio_parser_soft_record_pm.shtml

BEGIN{
IGNORECASE=1
OFS="\t"
SOFT_FILE=name
SERIES_FOLDER="/xchip/bged/Samples/"
GSE_NAME = ""
SERIES_TITLE = ""
SERIES_PUBMED_ID = ""
ORGANISM = ""
SERIES_SUMMARY = ""
CHIP_NAME = ""
SERIES_SAMPLE_NAME = ""
SERIES_KEYWORDS = ""
SOURCE_OF_DATA = "GEO"
SUBMISSION_DATE = ""
UPDATE_DATE = ""
STATUS = ""
}

/^!Series_geo_accession/{ GSE_NAME = getval($0) }
/^!Series_title/ { SERIES_TITLE = getval($0) }
/^!Series_pubmed_id/ {SERIES_PUBMED_ID = getval($0, SERIES_PUBMED_ID,",") }
/^!Series_sample_organism/ { ORGANISM = getval($0, ORGANISM, ",") }
/^!Series_summary/ { SERIES_SUMMARY = getval($0, SERIES_SUMMARY, " ") }
/^!Series_platform_id/ { CHIP_NAME = getval($0, CHIP_NAME, ",") }
# note: can belong to more than one series
/^!Series_sample_id/ { SERIES_SAMPLE_NAME = getval($0, SERIES_SAMPLE_NAME,",") }
/^!Series_submission_date/ { SUBMISSION_DATE = getval($0) }
/^!Series_last_update_date/ { UPDATE_DATE = getval($0) }
/^!Series_status/ { STATUS = getval($0) }
tolower($0) ~/keywords[ :=]/ { sub(/keywords[ :=]/,"keywords="); SERIES_KEYWORDS = getkeywords($0, SERIES_KEYWORDS) }

function getval(line, old, dlm) {
    if (!dlm)
	dlm="|"
    split(line,a,"=");
    # sanitize input
    sub(/^[ \r\n]+/, "",a[2])
    sub(/[ \r\n]+$/, "",a[2])
    sub(/\t+/, " ",a[2])
    sub(dlm, " ", a[2])
    if (old)
	return old dlm a[2]
    else
	return a[2]
}

function getkeywords(s, old) {
    split(s,a,"=");
    sub(/^[ \t\r\n]+/, "",a[3])
    sub(/[ \t\r\n]+$/, "",a[3])
    sub(/|/, "",a[3])
    if (old)
	return old "|" a[3]
    else
	return a[3]
}
 
END {
# test if data exists in local cache
#    if(! system("test -f " SERIES_FOLDER "/gse/" GSE_NAME ".SOFT")) 
#	HAS_SOFT="Y"

    if (GSE_NAME =="") {
	GSE_NAME = SOFT_FILE
	SERIES_TITLE = "ANNOTATION_NOT_FOUND"
    }

    print GSE_NAME, SERIES_TITLE, SERIES_SUMMARY, SERIES_PUBMED_ID, ORGANISM, CHIP_NAME, SERIES_KEYWORDS, SOURCE_OF_DATA, SERIES_SAMPLE_NAME, SUBMISSION_DATE, UPDATE_DATE, STATUS
}
