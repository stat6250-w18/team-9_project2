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
footnote1
'Most of counties has the similar number of hospitals and special clinic in CA except LOS ANGELES which has more than half number of SC.'
;
footnote2
'The LOS ANGELES has the most number of hospitals, which is 124, and special clinic, which is 189, and the number is such bigger than others.'
;
footnote3
'All the counties have at least one hospital, and about 15 counties do not have a special clinic in CA.'
;

*
Methodology: Use pro print to display the result.

Limitation: If there are duplicate values with respect to the columns specified, 
thenrows are typically moved around as little as possible, meaning that they 
willremain in the same order as in the original dataset.

Possible Follow-up Step: Try to use some data visualization skills to create a 
good chart to make the result more clearly.
;

proc print 
	data=distribution_LS;
run;
title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top 10 counties with the highest mean value of scale for Hosptials by using the "TOTAL_BEDS" column?'
;
title2
'Rationale: This would help research the reason of the number of hosptials in each county.'
;
footnote1
'The NAPA county has the highest mean value of hosptials scale which is 593 beds per hospital.'
;
footnote2
'Combining the result with the result of research question1, the LOS ANGELES has the biggest number of beds, which is 28024(226*124).'
;


*
Methodology:Using proc print to display the first 10 row of the sorted dataset 
and use WHERE statement to limiting the range. 

Limitation: This methodology does not account for total_bed with 
missing data, nor does it attempt to validate data in any way, like filtering 
for percentages between 0 and 1.

Possible Follow-up Step: Make sure the right file has been merge, and clean 
values in order to filter out any possible illegal values, and better handle 
missing data.
;

proc print
    noobs
    data=HL_listing_raw_sorted_temp_LS(obs=10)
    ;
    id
        COUNTY_NAME
    ;
    var
        TOTAL_BEDS
    ;
run;
title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the mean value of net patient revenue for special clinics?'
;
title2
'Rationale: This would help identify the which county have the higher demand of health servics.'
;
footnote1
'The MONTEREY county has the highest mean value of net patient revenue, which is 6,994,020.5 at 2016'
;
footnote2
'The SANTA CLARA has the highest range of net patient revenue, which is 43,554,183.0 at 2016. And this county also has the biggest number of net patient revenue, which is 43,692,512.0 at 2016'
;
*
Methodology: After merging SC_listing and SC_data, we get more information about
special care clinics. Then, use proc mean to get the mean, range, max and min 
value of the total net patient revenue for special clinic at 2016. 

Limitation: This methodology does not account for net patient revenue with 
missing data, nor does it attempt to validate data in any way, like filtering 
for percentages between 0 and 1.

Possible Follow-up Step: More carefully clean values in order to filter out any 
possible illegal values, and better handle missing data, e.g., by add more 
limitation for the row which may be sorted.
;
proc means
		mean
		range
		max
		min
		maxdex=1
		data=SC_data_XY1
    ;
    class
        COUNTY_NAME
    ;
    var
        NET_PATIENT_REV_TOTL
    ;
    output
        out=SC_data_LS
    ;
run;
title;
footnote;
