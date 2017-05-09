# gsm2sin.awk Extract annotation from GSM SOFT files

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:53 EDT

# CHANGES: 
# 6/19/2010: Sanitize inputs
# 6/21/2010: Multiple series, keyword extraction

BEGIN{
OFS="\t"
SOFT_FILE=name
SAMPLE_FOLDER="/xchip/bged/Samples/"
CEL_FILE_NAME = ""
SAMPLE_TITLE = ""
SAMPLE_DESC = ""
SAMPLE_SOURCE = ""
ORGANISM = ""
SAMPLE_CHARACTERISTICS = ""
CHIP_NAME = ""
SERIES_NAME = ""
SAMPLE_KEYWORDS = ""
SCHEMA = "generic"
SOURCE_OF_DATA = "GEO"
GOOD_QUALITY = "NA"
COMMENT = "NA"
BATCH_NAME = "NA"
CELL_LINE = "NA"
ORDER = "NA"
P_CALL = "NA"
SAMPLE_NAME = "NA"
SAMPLE_TYPE = "NA"
SUBMISSION_DATE = ""
UPDATE_DATE = ""
STATUS = ""
HAS_CEL ="N"
HAS_CXT = "N"
HAS_TXT = "N"
HAS_SOFT = "N"
}

/^!Sample_geo_accession/{ CEL_FILE_NAME = getval($0) }
/^!Sample_title/ { SAMPLE_TITLE = getval($0) }
/^!Sample_description/ { SAMPLE_DESC = getval($0, SAMPLE_DESC) }
/^!Sample_source_name_ch1/ {SAMPLE_SOURCES = getval($0) }
/^!Sample_organism_ch1/ { ORGANISM = getval($0) }
/^!Sample_characteristics_ch1/ { SAMPLE_CHARACTERISTICS = getval($0, SAMPLE_CHARACTERISTICS) }
/^!Sample_platform_id/ { CHIP_NAME = getval($0) }
# note: can belong to more than one series
/^!Sample_series_id/ { SERIES_NAME = getval($0, SERIES_NAME) }
/^!Sample_submission_date/ { SUBMISSION_DATE = getval($0) }
/^!Sample_last_update_date/ { UPDATE_DATE = getval($0) }
/^!Sample_status/ { STATUS = getval($0) }
tolower($0) ~/keywords =/ { SAMPLE_KEYWORDS = getkeywords($0, SAMPLE_KEYWORDS) }

function getval(line, old, dlm) {
    if (!dlm)
	dlm="|"
    split(line,a,"=");
    # sanitize input
    sub(/^[ \t\r\n]+/, "",a[2])
    sub(/[ \t\r\n]+$/, "",a[2])
    sub(/[|\t]+/, " ",a[2])
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
    if(! system("test -f " SAMPLE_FOLDER "/CEL/" CEL_FILE_NAME ".CEL.gz")) 
	HAS_CEL="Y"

    if(! system("test -f " SAMPLE_FOLDER "/CXT/" CEL_FILE_NAME ".CXT.gz"))
	HAS_CXT="Y"

    if(! system("test -f " SAMPLE_FOLDER "/SOFT_GSM/" CEL_FILE_NAME ".SOFT.gz")) 
	HAS_SOFT="Y"

    if(! system("test -f " SAMPLE_FOLDER "/TXT_GSM/" CEL_FILE_NAME ".TXT.gz"))
	HAS_TXT="Y"
    
    if (CEL_FILE_NAME =="") {
	CEL_FILE_NAME = SOFT_FILE
	SAMPLE_TITLE = "ANNOTATION_NOT_FOUND"
    }

    print CEL_FILE_NAME, SAMPLE_TITLE , SAMPLE_DESC, SAMPLE_SOURCE, ORGANISM, SAMPLE_CHARACTERISTICS, CHIP_NAME, SERIES_NAME, SAMPLE_KEYWORDS, SCHEMA, SOURCE_OF_DATA, GOOD_QUALITY, COMMENT, BATCH_NAME, CELL_LINE, ORDER, P_CALL, SAMPLE_NAME, SAMPLE_TYPE, SUBMISSION_DATE, UPDATE_DATE, STATUS, HAS_CEL, HAS_CXT, HAS_TXT, HAS_SOFT
}
