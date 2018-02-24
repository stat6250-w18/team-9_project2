*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding information and specific data for Hospitials and 
Specialty Care clinics in California.

Dataset Name: SC_data analytic_file, SC_data analytic_file_v2 and 
HL_SC_Analytic_file created in external file 
STAT6250-01_w18-team-9_project2_data_preparation.sas, which is assumed to be in
the same directory as this file.

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets SC_data_analytic_file,
 SC_data_analytic_file_v2, SC_data_analytic_file_sort, 
 and HL_SC_analytic_file_sort;
%include '.\STAT6250-01_w18-team-9_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question 1: What is a total number of license types per hospital and clinic?'
;

title2
'Rationale: This would help provide a quick comparison between a number of active hospitals and clinic in 2016.'
;

footnote1
;

footnote2
;

*
Note: This compares the columns "License_Type" from SC_listing to the same 
column from HL_listing.

Methodology: After combining all datasets during data preparation, use sum in
proc print to produce the totals of license types for hospitals and clinics.

Limitations: This methodology does not account for any schools with missing
data, nor does it attempt to validate data in any ways.

Possible Follow-up Steps: Need to bring the table in bar graph to be
more presentable.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question 2: What are the top ten medical center or facilities experienced the biggest decrease in “GRO_REV_TOTL” between 2015 and 2016?'
;

title2
'Rationale: This would help identify hospitals and/or clinics experienced decrease in Gross patient revenue to consider for further financial aid assistant from Cal State.'
;

footnote1
;

footnote2
;

*
Note: This compares the column "GRO_REV_TOTL" from SC_data15
to the column of the same name from SC_listing16.

Methodology: When combining SC_data15 with SC_data16 during data preparation,
I'm going to calculate the difference of values of "NET_FRM_OPER" for each
facilities and create a new variable called SC_data_change_2015_to_2016. Then,
use proc sort to create a temporary sorted table in descending by
SC_listing_rate_change_2015_to_2016. Finally, use proc print here to display 
the first ten rows of the sorted dataset.

Limitation: This methodology does not account for total_bed with 
missing data, nor does it attempt to validate data in any way, like filtering 
for percentages between 0 and 1.

Possible Follow-up Step: Make sure the right file has been merge, and clean 
values in order to filter out any possible illegal values, and better handle 
missing data.
;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question 3: Can “GRO_REV_TOTL” be used to predict the decrease or loss from Net From Operation?'
;

title2
'Rationale: This would help identify whether the Total Gross Revenue is associated with Net From Operation (Net Revenue) to consider for further financial aid assistant from Cal State.'
;

footnote1
;

footnote2
;

*
Note: This compares the column "GRO_REV_TOTL" from SC_data15 to the column 
NET_FRM_OPER from SC_data16.

Methodology: Use proc means to compute 5-number summaries of "GRO_REV_TOTL" and 
NET_FRM_OPER. Then use proc format to create formats that bin both columns with 
respect to the proc means output. Then use proc freq to create a cross-tab of 
the two variables with respect to the created formats.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.

Possible Follow-up Steps: A possible follow-up to this approach could use an 
inferential statistical technique like linear regression.
;
