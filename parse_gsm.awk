BEGIN{
	OFS="\t"
	init()
}
# print record after parsing each file
(NR!=1 && (FNR==1 || /^\^SAMPLE/)){
    if ("Sample_geo_accession" in arr)
	print_rec(arr)
}

#re-initialize at the beginning of each file
(FNR==1 || /^\^SAMPLE/){
	delete arr
}

#found GEO field, add to array
/^!/{
	split($0, a, "=");
	k=sanitize(a[1])
	#append values for multiple entries
	v=sanitize(a[2], arr[k])
	arr[k]=v
#	print k,v
}

# Find number of series
/^!Sample_series_id/{
	arr["Sample_series_count"]++
}

# Clean input
function sanitize(s, old){
    # sanitize input
    sub(/^[! \r\n]+/, "",s)
    sub(/[ \r\n]+$/, "",s)
    sub(/[\|\t]+/, " ",s)
    if (old)
	return old "|" s
    else
    	return s
}

# print a record
function print_rec(arr) {
for (i=1;i<N;i++) {
	printf "%s\t", arr[fields[i]]
}
printf "%s\n", arr[fields[N]]
}

function init(){
#Print order of fields
fn="Sample_geo_accession,\
Sample_title,\
Sample_type,\
Sample_channel_count,\
Sample_source_name_ch1,\
Sample_biomaterial_provider_ch1,\
Sample_organism_ch1,\
Sample_taxid_ch1,\
Sample_characteristics_ch1,\
Sample_description,\
Sample_platform_id,\
Sample_series_count,\
Sample_series_id,\
Sample_status,\
Sample_treatment_protocol_ch1,\
Sample_growth_protocol_ch1,\
Sample_molecule_ch1,\
Sample_extract_protocol_ch1,\
Sample_label_ch1,\
Sample_label_protocol_ch1,\
Sample_hyb_protocol,\
Sample_scan_protocol,\
Sample_data_processing,\
Sample_submission_date,\
Sample_last_update_date,\
Sample_contact_name,\
Sample_contact_email,\
Sample_contact_phone,\
Sample_contact_fax,\
Sample_contact_institute,\
Sample_contact_department,\
Sample_contact_laboratory,\
Sample_contact_address,\
Sample_contact_city,\
Sample_contact_state,\
Sample_contact_zip/postal_code,\
Sample_contact_country,\
Sample_contact_web_link,\
Sample_source_name_ch2,\
Sample_biomaterial_provider_ch2,\
Sample_organism_ch2,\
Sample_taxid_ch2,\
Sample_characteristics_ch2,\
Sample_treatment_protocol_ch2,\
Sample_growth_protocol_ch2,\
Sample_molecule_ch2,\
Sample_extract_protocol_ch2,\
Sample_label_ch2,\
Sample_label_protocol_ch2,\
Sample_data_row_count,\
Sample_supplementary_file,\
Sample_tag_count,\
Sample_tag_length,\
Sample_row_count,\
Sample_anchor"
#create an array
N=split(fn, fields, ",")
#for (i=1;i<N;i++) {
#	printf "%s\t", fields[i]
#}
#printf "%s\n", fields[N]
}
# the last record
END {
    if ("Sample_geo_accession" in arr)
	print_rec(arr)
}
