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
*
'Research Question 1: What are Specialty Care Clinics experienced decrease (negative revenue) in "NET_FRM_OPERù" between 2015 and 2016?'
;

title2
'Rationale: This would help identify Specialty Care Clinics experienced decrease in Net from Operting for further reimbursements and/or Medical aid assistance from Cal State.'
;

footnote1
'Profit dropped and/or a negative gross profit occurs with these SC clinics because costs exceed patient revenues.'  
;

footnote2
'Probably these clinics received reimbursements from the Hospital Fee Program which decreased its total Medical and community benefit investment'
;

footnote3
'Also patients payments covered by Medical do not cover the full costs of providing care'
;
*
Note: This compares the column "NET_FRM_OPER" from SC_data15 to the column of 
the same name from SC_data16.

Methodology: After combining SC_data15 with SC_data16 during data preparation,
I'm going to take the difference of values of "NET_FRM_OPER" for each
facilities and create a new variable called PROFIT_DIFFERENCES_1516. 
Then, use proc sort to create a temporary sorted table in descending by
PROFIT_DIFFERENCES_1516. Finally, use proc print here to display the
bottom 100 rows of the sorted dataset.

Limitations: This methodology does not account for clinics with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean values in order to filter out 
any possible illegal values, and better handle missing data, e.g., by using 
a previous year's data or a rolling average of previous years' data as a proxy.
;

*
List all clinics experienced decrease (negative profit) from 15-16
;
proc print 
    data=SC_analytic_file_TT1_print
   ;
   id
       FAC_NAME
       FAC_CITY
   ;
   var
       PROFIT_DIFFERENCES_1516
   ;
   where
        PROFIT_DIFFERENCES_1516 lt 0
    ;
run;

*
Shows a histogram combined with two density plots. 
;
proc sgplot 
    data=SC_analytic_file_TT1;
    histogram PROFIT_DIFFERENCES_1516;
    density PROFIT_DIFFERENCES_1516;
    density PROFIT_DIFFERENCES_1516 / type=kernel;
    keylegend / location=inside position=topright;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question 2: What are the top ten Specialty Care clinics experienced the biggest decrease in "GRO_REV_TOTL"ù between 2015 and 2016?'
;

title2
'Rationale: This would help identify Specialty Care clinics experienced increase in Gross Patient Revenue to see what type of diseases increase in California.'
;

footnote1
'Based on the output, the top 10 clinics experienced increase in Gross Patient Revenue are Dialysis Facility which pretty much tells that dialysis demand strong as kidney disease grows'
;

footnote2
'Also Dialysis centers performed well in term of patient revenue, due to the inelastic demand for their services'
; 

footnote3
'In addition, 9 out of top 10 facilities (except EL SOBRANTE) are located in Southern California that pretty much tells the location of dialysis centers largely reflects the distribution of the population and geographic.'
;

*
Note: This compares the column "GRO_REV_TOTL" from SC_data15 to the column of 
the same name from SC_data16.

Methodology: After combining SC_data15 with SC_data16 during data preparation,
I'm going to take the difference of values of "GRO_REV_TOTL" for each
facilities and create a new variable called Gross_Patient_Revenue_Diff_1516. 
Then, use proc sort to create a temporary sorted table in descending by
Total_Gross_Patient_Revenue_1516. Finally, use proc print here to display the
first ten rows of the sorted dataset.

Limitations: This methodology does not account for clinics with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean values in order to filter out 
any possible illegal values, and better handle missing data, e.g., by using 
a previous year's data or a rolling average of previous years' data as a proxy.
;

proc sql;
    create table SC_analytic_file_TT2_print AS
        select
            OSHPD_ID,
            FAC_NAME,
            FAC_CITY,
            Gross_Patient_Revenue_Diff_1516
        from 
            SC_analytic_file_TT2
        order by
            Gross_Patient_Revenue_Diff_1516 descending
	;
quit;

*
List top 10 clinics experience increase in profit from 15-16
;
proc print 
    data=SC_analytic_file_TT2_print(obs=10)
   ;
   id
       FAC_NAME
       FAC_CITY
   ;
   var
       Gross_Patient_Revenue_Diff_1516
   ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question 3: Is it possible to use "GRO_REV_TOTL" (revenue) to predict the decrease or loss of Net From Operation (profit)?'
;

'Rationale: This would help identify whether revenue is associated with Net From Operation (profit) to consider for further financial aid assistant from Cal State.'
;

footnote1
'Based on the table output, there is no clear pattern to predict the decrease or loss of profit from revenue'
;

footnote2
'A possible follow-up to this approach like linear regression finds useful correlations'
; 

footnote3
'Based on the Pearson correlation coefficient output, we see this is a positive linear relationship (0.23226) and p-value is 0.0001'
;

footnote4
'In this case, p-value is smaller than alpha of 0.05 or 5% so revenue and profit show significant correlation.'
;

*
Note: This compares the column "GRO_REV_TOTL" from SC_data to the column 
NET_FRM_OPER from SC16_analytic_file.

Methodology: Use proc univariate to identiy  quantiles of "GRO_REV_TOTL" 
and NET_FRM_OPER. Then use proc format to create formats that bin both columns 
with respect to the output. Then use proc freq to create a cross-tab of the two 
variables with respect to the created formats.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.

Possible Follow-up Steps: A possible follow-up to this approach could use an 
inferential statistical technique like linear regression.
;

proc univariate 
    data=SC16_analytic_file;
    histogram GRO_REV_TOTL;
run;

proc freq
	data=SC16_analytic_file
    ;
    table
		GRO_REV_TOTL
		*NET_FRM_OPER
		/ missing norow nocol nopercent
    ;
    title
        'Patient Revenue vs. Profit'
    ;
    where
        not(missing(NET_FRM_OPER))
    ;
    format
        GRO_REV_TOTL GRO_REV_TOTL_bins.
        NET_FRM_OPER NET_FRM_OPER_bins.
    ;
    label
        GRO_REV_TOTL="Gross Patient Revenue - REVENUE"
        NET_FRM_OPER="Net From Operation - PROFIT"
    ;
run;

proc corr 
	data = SC16_analytic_file;
	var GRO_REV_TOTL;
	with NET_FRM_OPER;
run; 

title;
footnote;



