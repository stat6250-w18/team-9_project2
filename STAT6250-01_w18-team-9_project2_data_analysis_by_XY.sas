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
See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


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
;

footnote2
;
footnote3
;

*
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
proc freq
		data=HL_SC_Analytic_file noprint;
		tables COUNTY_NAME / noprint out=county_freq;
run;
* use proc sort to create a temporary sorted table in descending by
county_freq;
proc sort
        data=county_freq
        out=county_freq_sort
    ;
    by descending count;
run;
* use proc print to print out top 10 results in the frequency count in facility numbers;
proc print
        data=county_freq_sort(obs=10)
    ;
run;



title1
'Research question: Can gross patient revenue (SC_16) be used to predict total operating revenue for special care facilities in 2016?'
;

title2
'Rationale: This should help us understand if the amount of public/private grants the specialty care facilities are receiving depends on the revenue from patients.'
;

*
Methodology: Use proc means to compute 5-number summaries of Gross_Patient_Rev 
and Total_Operating_Rev. Then use proc format to create formats that bin both 
columns with respect to the proc means output. Then use proc freq to create a 
two-way table of the two variables with respect to the created formats.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables. 

Followup Steps: A more rigorous way of testing the relationship can use an 
inferential statistical technique like linear regression.
;

proc format;
	value NET_PATIENT_REV_TOTL_bins
	low-<2959614="Q1 Patient"
        2959614-<4874814="Q2 Patient"
        4874814-<6477886="Q3 Patient"
        6477886-high="Q4 Patient"
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
Run;


title1
'Research Question: What is the top ten counties have highest special care total net patient revenue in 2016?'
;
title2
'Rationale: This helps identify the counties with significant revenue in healthcare industry. Will be a strong indicator for healthcare tech companies to focus on potential markets.'
;

*
Note: This compares the column COUNTY_CODE from SC_listing and column 
NET_PATIENT_REV_TOTL from SC_data16.

Methodology: When combining SC_data16 and SC_listing during data preparation, 
use PROC MEANS to get the mean value of net patient revenue in each county, 
and output the results to a temporary dataset, and use PROC SORT to extract
and sort just the means the temporary dateset. Finally, use proc print here 
to display the first 10 rows of the sorted dataset.

Limitations: This methodology does not account for hospitals/clinics with 
missing data, or facilities having suspend status (not in normal opening 
status). Some of the facilities belong to the same parent facility, so it is
double counted to some degree.

Followup Steps: Use Facility status variable as a filter to count opening
facilities only, and better handle missing data, e.g., by using a previous 
year's data or a rolling average of previous years' data as a proxy.
;

data SC_data_XY;
	retain 	
		OSHPD_ID
		FAC_NAME
		CITY
		COUNTY_CODE
		COUNTY_NAME
		GRO_REV_TOTL
		NET_PATIENT_REV_TOTL
;
	keep
		OSHPD_ID
		FAC_NAME
		CITY
		COUNTY_CODE
		COUNTY_NAME
		GRO_REV_TOTL
		NET_PATIENT_REV_TOTL
;
	merge 
		SC_listing_raw_sorted
		SC_data16_raw_sorted
;
	by
		OSHPD_ID
;
Run;



proc sort
        data=SC_data_XY
        out=SC_data_XY_temp
    ;
    	by 
		descending NET_PATIENT_REV_TOTL;
run;

proc print
        data=SC_data_XY_temp(obs=10)
    ;
    id
		FAC_NAME COUNTY_NAME
    ;
    var NET_PATIENT_REV_TOTL
        
    ;
run;

title;
footnote;
