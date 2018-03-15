*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
*
This file uses the following analytic dataset to address several research
questions regarding information and specific data at CA Hospitials and 
specialty Care clinics.

Dataset Name: SC_data analytic_file and HL_SC_Analytic_file created in external
file STAT6250-01_w18-team-9_project2_data_preparation.sas, which is assumed to 
be in the same directory as this file.

See included file for dataset properties.
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))
-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets SC_data_analytic_file,
  SC_data_analytic_file_sort, and HL_SC_analytic_file_sort;
%include '.\STAT6250-01_w18-team-9_project2_data_preparation.sas';

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top ten counties that have largest amount for Special Care and hospitals? (consider the two category together)'
;

title2
'Rationale: This should identify counties that have most healthcare facilities in California.'
;

footnote1
'From the ten counties of most special care facilities and hospital numbers, we can see top five counties are all in southern California.'
;

footnote2
'Los Angeles County has the most healthcare facility amount, which accounts for 26.4% of the state total.'
;

footnote3
'Alameda County is covers most special care and hospital facilities in Northern California, but it is only 1/6 of the amount in Los Angeles County.'
;

*
Note: This calculates the total count from the column COUNTY_NAME from SC_listing 
and column COUNTY_NAME from HL_listing.

Methodology: First, combine SC_listing  and HL_listing in data prep file and use
proc Freq to summarize the frequency of each county and output table as 
countyfreq. Then, use proc sort to create a temporary sorted table in descending 
by county frequency. Finally, use proc print here to display the first 10 rows 
of the sorted dataset.

Limitations: This methodology does not account for hospitals/clinics with 
missing data, or facilities having suspend status (not in normal opening status).
Some of the facilities belong to the same parent facility, so it is double 
counted to some degree.

Followup Steps: Use Facility status variable as a filter to count opening 
facilities only, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

* use proc print to print out top 10 results in the frequency count in facility 
numbers;

proc print
    data=county_freq_sort(obs=10)
    ;
run;
title;
footnote;


title1
'Research question: Can net patient revenue (SC_16) be used to gross total revenue for special care facilities in 2016?'
;

title2
'Rationale: This should help us understand if the amount of public/private grants from patient service of the specialty care facilities will determine the gross revenue of the facility.'
;

footnote1
"As shown in the two way table, there was an extremely high correlation between gross total revenue and net patient revenue, that facilities with higher net patient grants tend to have higher gross revenue(including operation revenue)."
;

footnote2
"Possible explanations for this correlation include hospitals with larger operation size tend to receive more patient amount, and more credibility in reputation, so grants from public and organizations will be higher."
;

footnote3
"Given this apparent correlation based on descriptive methodology, further investigation should be performed using inferential methodology to determine the level of statistical significance of the result."
;

footnote1
"As shown in the two way table, there was an extremely high correlation between gross total revenue and net patient revenue, that facilities with higher net patient grants tend to have higher gross revenue(including operation revenue)."
;

footnote2
"Possible explanations for this correlation include hospitals with larger operation size tend to receive more patient amount, and more credibility in reputation, so grants from public and organizations will be higher."
;

footnote3
"Given this apparent correlation based on descriptive methodology, further investigation should be performed using inferential methodology to determine the level of statistical significance of the result."
;

*

Note: This compares bins in NET_PATIENT_REV_TOTL column from SC_data16 table 
and bins in GRO_REV_TOTL column in the same table.

Methodology: Use proc means to compute 5-number summaries of Gross_Patient_Rev 
and Total_Operating_Rev. Then use proc format to create formats that bin both 
columns with respect to the proc means output. Then use proc freq to create a 
two-way table of the two variables with respect to the created formats.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations in quartile division, which could be lack of 
statistical proof for a correlation test. 

Followup Steps: A more rigorous way of testing the relationship can use an 
inferential statistical technique like linear regression.
;

proc freq
	data= SC_data16_raw_sorted;
	table 
		NET_PATIENT_REV_TOTL
		*GRO_REV_TOTL
		/missing norow nocol nopercent
	;
	format
		GRO_REV_TOTL GRO_REV_TOTL_bins.
		NET_PATIENT_REV_TOTL NET_PATIENT_REV_TOTL_bins.
;
run;
title;
footnote;

title1
'Research Question: What is the top ten counties have highest special care total net patient revenue in 2016?'
;

title2
'Rationale: This helps identify the counties with significant revenue in healthcare industry. Will be a strong indicator for healthcare tech companies to focus on potential markets.'
;

footnote1
'After using a proc means method to get an average of 2016 net patient revenue for all the counties, we have the state-wide mean net patient revenue of 5047746.68'
;

footnote2
'In the 10 counties listed, their annual net patient revenue is 2-8 times of the state-wide average.'
;

footnote3
'We can infer that there is a huge gap in healthcare facilities anual income among different areas in california.'
; 

*

Note: This compares the column COUNTY_CODE from SC_listing and column 
NET_PATIENT_REV_TOTL from SC_data16.

Methodology: First, combine SC_data16 and SC_listing with desired variables 
into a temp data set, then  use PROC SORT to extract and sort just the means
the temporary dateset. Finally, use proc print here to display the first 10 
rows of the sorted dataset.

Limitations: This methodology does not account for hospitals/clinics with 
missing data, or facilities having suspend status (not in normal opening 
status). Some of the facilities belong to the same parent facility, so it is
double counted to some degree.

Followup Steps: Use Facility status variable as a filter to count opening
facilities only, and better handle missing data, e.g., by using a previous 
year's data or a rolling average of previous years' data as a proxy.
;

proc means
	data=SC_data_analytic_file;
	var NET_PATIENT_REV_TOTL;
run;

proc print
    data=SC_data_XY1_temp(obs=10)
    ;
    id
		COUNTY_NAME
    ;
    var 
		NET_PATIENT_REV_TOTL
    ;
run;
title;
footnote;
