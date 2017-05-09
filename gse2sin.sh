#!/bin/bash
# gse2sin Create tab-delimited report from GEO SERIES files
#
# 10 June 2010
# Rajiv Narayan [narayan@broadinstitute.org]

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:51 EDT


G2SCMD=$(dirname $0)/parse_gse.awk

if [ "$1xxx" != "xxx" ]; then

    if [ "$2x" == "x" ]; then
	echo "SOFT folder not specified"
	exit 1;
    else
	softFolder="$2"
    fi
    
    fn="Series_geo_accession\tSeries_title\tSeries_sample_organism\tSeries_platform_id\tSeries_sample_count\tSeries_pubmed_id\tSeries_submission_date\tSeries_last_update_date\tSeries_contributor\tSeries_type\tSeries_summary\tSeries_sample_id\tSeries_sample_taxid\tSeries_project\tSeries_overall_design\tSeries_citation\tSeries_gp_id\tSeries_relation\tSeries_platform_organism\tSeries_platform_taxid\tSeries_contact_name\tSeries_contact_institute\tSeries_contact_department\tSeries_contact_laboratory\tSeries_contact_address\tSeries_contact_city\tSeries_contact_state\tSeries_contact_country\tSeries_contact_zip/postal_code\tSeries_contact_email\tSeries_contact_fax\tSeries_contact_phone\tSeries_contact_web_link\tSeries_status\tSeries_supplementary_file\tSeries_web_link"

    echo -e "$fn"

    grep -v '#' $1 | while read line;
    do
      softFile=$softFolder/${line}
      if [ -f ${softFile}.SOFT.gz ]; then
	  zcat "${softFile}.SOFT.gz" | awk -v name=$(basename $softFile) -f $G2SCMD 
      elif [ -f ${softFile}.SOFT ]; then 
	  cat "${softFile}.SOFT" | awk -v name=$(basename $softFile) -f $G2SCMD 
      else 
	  echo -e "$line\t#FILE_NOT_FOUND"	
      fi
    done
    
else 
     echo "Usage: $0 <gse_soft_list> <softFolder>"
fi
