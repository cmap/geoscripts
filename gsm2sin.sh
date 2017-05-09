#!/bin/bash
# gsm2sin Create tab-delimited report from GEO SOFT files
#
# 10 June 2010
# Rajiv Narayan [narayan@broadinstitute.org]

# $Author: Rajiv Narayan [narayan@broadinstitute.org]
# $Version: 142
# $Date: Jun.15.2010 19:08:51 EDT


G2SCMD=$(dirname $0)/parse_gsm.awk

if [ "$1xxx" != "xxx" ]; then

    if [ "$2x" == "x" ]; then
	echo "SOFT folder not specified"
	exit 1;
    else
	softFolder="$2"
    fi
fn="Sample_geo_accession\tSample_title\tSample_type\tSample_channel_count\tSample_source_name_ch1\tSample_biomaterial_provider_ch1\tSample_organism_ch1\tSample_taxid_ch1\tSample_characteristics_ch1\tSample_description\tSample_platform_id\tSample_series_count\tSample_series_id\tSample_status\tSample_treatment_protocol_ch1\tSample_growth_protocol_ch1\tSample_molecule_ch1\tSample_extract_protocol_ch1\tSample_label_ch1\tSample_label_protocol_ch1\tSample_hyb_protocol\tSample_scan_protocol\tSample_data_processing\tSample_submission_date\tSample_last_update_date\tSample_contact_name\tSample_contact_email\tSample_contact_phone\tSample_contact_fax\tSample_contact_institute\tSample_contact_department\tSample_contact_laboratory\tSample_contact_address\tSample_contact_city\tSample_contact_state\tSample_contact_zip/postal_code\tSample_contact_country\tSample_contact_web_link\tSample_source_name_ch2\tSample_biomaterial_provider_ch2\tSample_organism_ch2\tSample_taxid_ch2\tSample_characteristics_ch2\tSample_treatment_protocol_ch2\tSample_growth_protocol_ch2\tSample_molecule_ch2\tSample_extract_protocol_ch2\tSample_label_ch2\tSample_label_protocol_ch2\tSample_data_row_count\tSample_supplementary_file\tSample_tag_count\tSample_tag_length\tSample_row_count\tSample_anchor"
    echo -e "$fn"

    grep -v '#' $1 | while read line;
    do
      softFile=$softFolder/${line}
      if [ -f ${softFile}.SOFT.gz ]; then
	  zcat "${softFile}.SOFT.gz" | awk -v name=$(basename $softFile) -f $G2SCMD 
      elif [ -f ${softFile}.SOFT ]; then 
	  cat "${softFile}.SOFT" | awk -v name=$(basename $softFile) -f $G2SCMD 
      else 
	  echo -e "#FILE_NOT_FOUND:$line"	
      fi
    done
    
else 
     echo "Usage: $0 <gsm_soft_list> <softFolder>"
fi
