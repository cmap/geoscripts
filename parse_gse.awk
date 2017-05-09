BEGIN{
	OFS="\t"
	init()
}
# print record after parsing each file
(NR!=1 && FNR==1){
	print_rec(arr)
}

#re-initialize at the beginning of each file
FNR==1{
	delete arr
}

#found GEO field, add to array
/^!/{
	ns=split($0, a, "=")
	# deal with cases when the string has a "="
	if (ns>2) {
	    a[2] = join(a, 2, ns, "=")
	}
	k=sanitize(a[1])
	#append values for multiple entries
	v=sanitize(a[2], arr[k])
	arr[k]=v
}

# Find number of sample in series
/^!Series_sample_id/{
	arr["Series_sample_count"]++
}

# join an array into a string
function join(array, start, end, sep,  result, i)
{
    if (sep == "")
	sep = " "
    else if (sep == SUBSEP) # magic value
	sep = ""
    result = array[start]
    for (i = start + 1; i <= end; i++)
	result = result sep array[i]
    return result
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
fn="Series_geo_accession,\
Series_title,\
Series_sample_organism,\
Series_platform_id,\
Series_sample_count,\
Series_pubmed_id,\
Series_submission_date,\
Series_last_update_date,\
Series_contributor,\
Series_type,\
Series_summary,\
Series_sample_id,\
Series_sample_taxid,\
Series_project,\
Series_overall_design,\
Series_citation,\
Series_gp_id,\
Series_relation,\
Series_platform_organism,\
Series_platform_taxid,\
Series_contact_name,\
Series_contact_institute,\
Series_contact_department,\
Series_contact_laboratory,\
Series_contact_address,\
Series_contact_city,\
Series_contact_state,\
Series_contact_country,\
Series_contact_zip/postal_code,\
Series_contact_email,\
Series_contact_fax,\
Series_contact_phone,\
Series_contact_web_link,\
Series_status,\
Series_supplementary_file,\
Series_web_link"
#create an array
N=split(fn, fields, ",")
#for (i=1;i<N;i++) {
#	printf "%s\t", fields[i]
#}
#printf "%s\n", fields[N]
}
# the last record
END {
	print_rec(arr)
}
