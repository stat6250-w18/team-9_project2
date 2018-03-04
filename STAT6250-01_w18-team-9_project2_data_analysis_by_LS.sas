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
'Research Question: What is the distribution of hospitail and special care clinics for each county in California?'
;

title2
'Rationale: This should help identify the specific distribution of the health services.'
;

*
Methodology: When combining the HL_listing and SC_listing, we can clear see the 
information of hosptials and special care clinics in the one table. Then use proc
mean and proc print to carry out the distribution of the hospital and SC clinics
in the county column.

Limitation: If there are duplicate values with respect to the columns specified, 
thenrows are typically moved around as little as possible, meaning that they 
willremain in the same order as in the original dataset.

Possible Follow-up Step: Try to use some data visualization skills to create a 
good chart to make the result more clearly.
;

proc sort data=HL_Listing_raw_sorted;
	by COUNTY_NAME;
run;
data work1;
	set HL_Listing_raw_sorted(drop=OSHPD_ID FACILITY_NAME
		LICENSE_NUM
		FACILITY_LEVEL
		ADDRESS
		CITY
		ZIP_CODE
		COUNTY_CODE
		ER_SERVICE
		TOTAL_BEDS
		FACILITY_STATUS_DESC
		FACILITY_STATUS_DATE
		LICENSE_TYPE
		LICENSE_CATEGORY);
	by COUNTY_NAME;
	if first.COUNTY_NAME then 
		NUMBER_HL=0;
		NUMBER_HL+1;
	if last.COUNTY_NAME then output;
run;
proc sort data=SC_listing_raw_sorted;
	by COUNTY_NAME;
run;
data work2;
	set SC_listing_raw_sorted(drop=OSHPD_ID FACILITY_NAME
		LICENSE_NUM
		ADDRESS
		CITY
		ZIP_CODE
		COUNTY_CODE
		FACILITY_STATUS_DESC
		FACILITY_STATUS_DATE
		LICENSE_TYPE
		LICENSE_CATEGORY);
	by COUNTY_NAME;
	if first.COUNTY_NAME then 
		NUMBER_SC=0;
		NUMBER_SC+1;
	if last.COUNTY_NAME then output;
run;
data distribution_LS;
	retain
		COUNTY_NAME
		NUMBER_HL
		NUMBER_SC
	;
	keep
		COUNTY_NAME
		NUMBER_HL
		NUMBER_SC
	;
	merge
		work1
		work2
	;
	by
		COUNTY_NAME
	;
run;

proc print data=distribution_LS;
run;
title;
footnote;
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top 10 counties with the highest mean value of scale for Hosptials by using the "TOTAL_BEDS" column? And it's there any relationship between the scale and the distribution in each county'
;

title2
'Rationale: This would help research the reason of the number of hosptials in each county'
;
footnote1
'
;

*
Methodology: Using proc sort to create a temporary sorted table in 
descending by HL_SC_Analytic. Then, use proc print to display the first
10 row of the sorted dataset and use WHERE statement to limiting the range.
And merge the table about the distribution and the table about the hosptials
scale. Final, use proc print to display them.

Limitation: This methodology does not account for total_bed with 
missing data, nor does it attempt to validate data in any way, like filtering 
for percentages between 0 and 1.

Possible Follow-up Step: Make sure the right file has been merge, and clean 
values in order to filter out any possible illegal values, and better handle 
missing data.
;

proc means
        MEAN
        noprint
        data=HL_listing_raw_sorted
    ;
    class
        COUNTY_NAME
    ;
    var
        TOTAL_BEDS
    ;
    output
        out=HL_listing_raw_sorted_temp_LS
    ;
run;

proc sort
        data=HL_listing_raw_sorted_temp_LS(WHERE=(_STAT_="MEAN"))
    ;
    by
        descending TOTAL_BEDS
    ;
run;
proc print
        noobs
        data=HL_listing_raw_sorted_temp_LS
		out= HL_SCALE
    ;
    id
        COUNTY_NAME
    ;
    var
        TOTAL_BEDS(RENAME=(TOTAL_BEDS=HL_BEDS))
    ;
run;
title;
footnote;
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top 10 counties with the highest mean value of net patient revenue for SC clinics?'
;

title2
'Rationale: This would help identify the which county have the higher demand of health servics.'
;

*
Methodology: After merging SC_listing and SC_data, we get more information about
special care clinics. Then, use proc sort to create a temporary sorted table in 
descending by SC_data_analytic_file. Finally, use proc print to display the first
10 row of the sorted dataset and use IF statement to limiting the range.

Limitation: This methodology does not account for net patient revenue with 
missing data, nor does it attempt to validate data in any way, like filtering 
for percentages between 0 and 1.

Possible Follow-up Step: More carefully clean values in order to filter out any 
possible illegal values, and better handle missing data, e.g., by add more limitation
for the row which may be sorted.
;
DATA SC_data_LS;
	retain 	
		OSHPD_ID
		COUNTY_NAME
		GRO_REV_TOTL
		NET_PATIENT_REV_TOTL
;
	keep
		OSHPD_ID
		FAC_NAME
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
        data=SC_data_LS
        out=SC_data_LS_temp
    ;
    	by 
		descending NET_PATIENT_REV_TOTL;
run;
proc print
        data=SC_data_LS_temp
		out=SC_LS
    ;
    id
		COUNTY_NAME
    ;
    var NET_PATIENT_REV_TOTL
        
    ;
run;
data Camparing;
	retain
		COUNTY_NAME
		NUMBER_HL
		NUMBER_SC
		HL_BEDS
		NET_PATIENT_REV_TOTL
	;
	keep
		COUNTY_NAME
		NUMBER_HL
		NUMBER_SC
		HL_BEDS
		NET_PATIENT_REV_TOTL
	;
	merge
		distribution
		HL_SCALE
		SC_LS
	;
run;
proc print
	data=Camparing
;
run;
title;
footnote;
