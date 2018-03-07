*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
* 

[Dataset 1 Name] HL_listing

[Dataset Description] Hospitals listing in California until Dec.2017

[Experimental Unit Description] California Hospitals licensed December 31,2017 

[Number of Observations] 533

[Number of Features] 15

[Data Source] The file https://www.oshpd.ca.gov/documents/HID/FacilityList/
Hospital-Listing-Dec2017.xlsx was downloaded and edited to produce 
HL_listing.xlsx by fixing the column name which make it more clear and creating
the variable description for the data set.

[Data Dictionary] https://www.oshpd.ca.gov/documents/HID/FacilityList/
Hospital-Listing-Dec2017.xlsx

[Unique ID Schema] The columns OSHPD_ID is the unique id.
--

[Dataset 2 Name] SC_listing

[Dataset Description] Specialty Care Clinics in California until DEC.2017

[Experimental Unit Description] California Specialty Care Clinics licensed 
at December 31, 2017 

[Number of Observations] 660

[Number of Features] 12

[Data Source] The file
https://www.oshpd.ca.gov/documents/HID/FacilityList/SC-Listing-Dec2017.xlsx
was downloaded and edited to produce SC_listing.xlsx by fixing the column 
name which make it more clear and creating the variable description for the 
data set.

[Data Dictionary] https://www.oshpd.ca.gov/documents/HID/FacilityList/
SC-Listing-Dec2017.xlsx

[Unique ID Schema] The column OSHPD_ID is the unique id.
--

[Dataset 3 Name] SC_data15

[Dataset Description] Specialty Care Clinics Annual Utilization Data in 2016

[Experimental Unit Description] California Specialty Care Clinics Annual 
Utilization Data(Complete Data Set).

[Number of Observations] 617

[Number of Features] 33

[Data Source]  The file https://www.oshpd.ca.gov/documents/HID/Utilization/
SpCl16_util_data_FINAL.xlsx was downloaded and edited to produce file 
SC_data16.xlsx by deleting the column 34 to the end, fixing the column name 
which make it more clear and creating the variable description for the 
data set.

[Data Dictionary] https://www.oshpd.ca.gov/documents/HID/Utilization/
SpCl16_util_data_FINAL.xlsx

[Unique ID Schema] The column OSHPD_ID is the unique id.
--

[Dataset 4 Name] SC_data15

[Dataset Description] Specialty Care Clinics Annual Utilization Data in 2015

[Experimental Unit Description] California Specialty Care Clinics Annual 
Utilization Data(Complete Data Set).

[Number of Observations] 617

[Number of Features] 33

[Data Source]  The file https://www.oshpd.ca.gov/documents/HID/Utilization/
SpCl15_util_data_FINAL.xlsx was downloaded and edited to produce file 
SC_data15.xlsx by deleting the column 34 to the end, fixing the column name 
which make it more clear and creating the variable description for the 
data set.

[Data Dictionary] https://www.oshpd.ca.gov/documents/HID/Utilization/
SpCl15_util_data_FINAL.xlsx

[Unique ID Schema] The column OSHPD_ID is the unique id.
;

* environmental setup;

*create ouput format
Use proc format to create formats that bin both columns with respect to the 
output for Research Question 2 - TT;
proc format;
    value GRO_REV_TOTL_bins
        low-<6662674="Q1 GRO_REV_TOTL"
        6662674-<40383657="Q2 GRO_REV_TOTL"
        40383657-<97329204="Q3 GRO_REV_TOTL"
        97329204-high="Q4 GRO_REV_TOTL"
    ;
    value NET_FRM_OPER_bins
        low-100170="Q1 NET_FRM_OPER"
        100170-<690879="Q2 NET_FRM_OPER"
        690879-<1369635="Q3 NET_FRM_OPER"
        1369635-high="Q4 NET_FRM_OPER"
    ;
	value NET_PATIENT_REV_TOTL_bins
	low-<2959614="Q1 Patient"
        2959614-<4874814="Q2 Patient"
        4874814-<6477886="Q3 Patient"
        6477886-high="Q4 Patient"
    ;
run;

* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-9_project2/blob/master/data/HL_listing.xlsx?raw=true
;
%let inputDataset1Type = XLSX;
%let inputDataset1DSN = HL_listing_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-9_project2/blob/master/data/SC_listing.xlsx?raw=true
;
%let inputDataset2Type = XLSX;
%let inputDataset2DSN = SC_listing_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-9_project2/blob/master/data/SC_data16.xlsx?raw=true
;
%let inputDataset3Type = XLSX;
%let inputDataset3DSN = SC_data16_raw;

%let inputDataset4URL =
https://github.com/stat6250/team-9_project2/blob/master/data/SC_data15.xlsx?raw=true
;
%let inputDataset4Type = XLSX;
%let inputDataset4DSN = SC_data15_raw;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset4DSN.,
    &inputDataset4URL.,
    &inputDataset4Type.
)

* sort and check raw datasets for duplicates with respect to their unique ids,
  removing blank rows, if needed;

proc sort
        nodupkey
        data=HL_listing_raw
        dupout=HL_listing_raw_dups
        out=HL_listing_raw_sorted(where=(not(missing(OSHPD_ID))))
    ;
    by
        OSHPD_ID
    ;
run;
proc sort
        nodupkey
        data=SC_listing_raw
        dupout=SC_listing_raw_dups
        out=SC_listing_raw_sorted
    ;
    by
        OSHPD_ID
    ;
run;
proc sort
        nodupkey
        data=SC_data16_raw
        dupout=SC_data16_raw_dups
        out=SC_data16_raw_sorted
    ;
    by
        OSHPD_ID
    ;
run;
proc sort
        nodupkey
        data=SC_data15_raw
        dupout=SC_data15_raw_dups
        out=SC_data15_raw_sorted
    ;
    by
        OSHPD_ID
    ;
run;


* combine HL_listing data and SC_listing data vertically;

data HL_SC_Analytic_file;
	set
		HL_listing_raw_sorted(in=HL_row)
    	SC_listing_raw_sorted(in=SC_row)
    ;
	retain
		FACILITY_NAME
		LICENSE_NUM
		FACILITY_LEVEL
		ADDRESS
		CITY
		ZIP_CODE
		COUNTY_CODE
		COUNTY_NAME
		ER_SERVICE
		TOTAL_BEDS
		FACILITY_STATUS_DESC
		FACILITY_STATUS_DATE
		LICENSE_TYPE
		LICENSE_CATEGORY
	;
	by
		OSHPD_ID
	;
    if
        HL_row=1
    then
        do;
            data_source=HL_listing_raw_sorted;
        end;
    else
        do;
            data_source=SC_listing_raw_sorted;
        end;
run;


* create SC16_analytic_file for further analysis - TT;

data SC16_analytic_file;
	retain
		OSHPD_ID
		FAC_NAME
		FAC_CITY
		GRO_REV_TOTL
		REV_OPER_TOTL
		EXP_OPER_TOTL
		NET_FRM_OPER		
	;
	keep
		OSHPD_ID
		FAC_NAME
		FAC_CITY
		GRO_REV_TOTL
		REV_OPER_TOTL
		EXP_OPER_TOTL
		NET_FRM_OPER
	;
	set
		SC_data16_raw_sorted
	;
run;


* combine SC_data15_raw_sorted and SC_data16_raw_sorted,
and compute PROFIT_DIFFERENCES_1516;

data SC_analytic_file_TT1;
    retain
        OSHPD_ID
        FAC_NAME
        FAC_CITY
        REV_OPER_TOTL
        EXP_OPER_TOTL
        NET_FRM_OPER
        PROFIT_DIFFERENCES_1516
    ;
    keep
        OSHPD_ID
        FAC_NAME
        FAC_CITY
        NET_FRM_OPER
        PROFIT_DIFFERENCES_1516
    ;
    merge
        SC_data15_raw_sorted(rename=(NET_FRM_OPER=PROFIT15))
        SC_data16_raw_sorted(rename=(NET_FRM_OPER=PROFIT16))
    ;
    by
		OSHPD_ID
    ;
    PROFIT_DIFFERENCES_1516=
        input(PROFIT16,best12.)
        -
        input(PROFIT15,best12.)
    ;
run;


* combine SC_data15_raw_sorted and SC_data16_raw_sorted, 
and compute Gross_Patient_Revenue_Diff_1516;

data SC_analytic_file_TT2;
    retain
        OSHPD_ID
        FAC_NAME
        FAC_CITY
        GRO_REV_TOTL
        Gross_Patient_Revenue_Diff_1516
    ;
    keep
        OSHPD_ID
        FAC_NAME
        FAC_CITY
        GRO_REV_TOTL
        Gross_Patient_Revenue_Diff_1516 
    ;
    merge
        SC_data15_raw_sorted(rename=(GRO_REV_TOTL=REVENUE15))
        SC_data16_raw_sorted(rename=(GRO_REV_TOTL=REVENUE16))
    ;
    by
		OSHPD_ID
    ;
    Gross_Patient_Revenue_Diff_1516=
        input(REVENUE16,best12.)
        -
        input(REVENUE15,best12.)
    ;
run;


*use proc sort to create a temporary sorted table 
in descending by SC_analytic_file_TT1_print and
SC_analytic_file_TT2_print;

proc sort
        data=SC_analytic_file_TT1
        out=SC_analytic_file_TT1_print
    ;
    by descending PROFIT_DIFFERENCES_1516;
run;

proc sort
        data=SC_analytic_file_TT2
        out=SC_analytic_file_TT2_print
    ;
    by descending Gross_Patient_Revenue_Diff_1516;
run;


*Data preperation part by XY:
* use proc sort to create a temporary sorted table in descending by
county_freq;
proc freq
	data=HL_SC_Analytic_file noprint;
	tables COUNTY_NAME / noprint 
	out=county_freq
	;
run;

proc sort
    data=county_freq
    out=county_freq_sort
    ;
    by descending count;
run;

data SC_data_XY1;
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
run;

proc sort
	data=SC_data_XY1
	out=SC_data_XY1_temp;
	by descending NET_PATIENT_REV_TOTL;
run;

*
First, use DATA to create two temp dataset and use IF statemetn to
make the temp dataset show the count number for hospitals and special clinic. 
Then merging the two temp dataset to create the new dataset which called 
distribution by using COUNTY_NAME by LS.
; 
proc sort 
	data=HL_Listing_raw_sorted;
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
	if last.COUNTY_NAME then 
		output;
run;

proc sort 
	data=SC_listing_raw_sorted;
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
	if last.COUNTY_NAME then 
		output;
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

*
Using proc sort to create a temporary sorted table in 
descending by HL_SC_Analytic by LS.
;

proc means
        mean
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
