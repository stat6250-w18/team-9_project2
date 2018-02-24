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


* combine HL_listing data and SC_listing data vertically
;

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


* build analytic dataset from raw datasets with the least number of columns
;

data SC_data_analytic_file;
    retain
		OSHPD_ID
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
		PHONE
		ADMIN_NAME
		OPER_CURRYR
		BEG_DATE
		END_DATE
		GRO_REV_TOTL
		WRITE_OFF_CHARITY_TOTL
		WRITE_OFF_CONTR_ADJUST_TOTL
		WRITE_OFF_BAD_DEBTS_TOTL
		WRITE_OFF_OTHR_ADJUST_TOTL
		WRITE_OFF_ADJUSTS
		NET_PATIENT_REV_TOTL
		REV_OTHR_OPER_GRANTS_PUBL_TOTL
		REV_OTHR_OPER_GRANTS_PVT_TOTL
		REV_OTHR_OPER_DONATIONS_TOTL
		REV_OTHER_OPER_OTHR_TOTL
		REV_OTHER_OPER_TOTL
		REV_OPER_TOTL
		EXP_OPER_SAL_WAGES
		EXP_OPER_CONTR_PROF
		EXP_OPER_SUP
		EXP_OPER_RENT_DEPRC
		EXP_OPER_UTIL
		EXP_OPER_LIAB_PROF_INS
		EXP_OPER_OTHR_INS
		EXP_OPER_ALL_OTHR
		EXP_OPER_TOTL
		NET_FRM_OPER
    ;
    keep
        OSHPD_ID
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
		PHONE
		ADMIN_NAME
		OPER_CURRYR
		BEG_DATE
		END_DATE
		GRO_REV_TOTL
		WRITE_OFF_CHARITY_TOTL
		WRITE_OFF_CONTR_ADJUST_TOTL
		WRITE_OFF_BAD_DEBTS_TOTL
		WRITE_OFF_OTHR_ADJUST_TOTL
		WRITE_OFF_ADJUSTS
		NET_PATIENT_REV_TOTL
		REV_OTHR_OPER_GRANTS_PUBL_TOTL
		REV_OTHR_OPER_GRANTS_PVT_TOTL
		REV_OTHR_OPER_DONATIONS_TOTL
		REV_OTHER_OPER_OTHR_TOTL
		REV_OTHER_OPER_TOTL
		REV_OPER_TOTL
		EXP_OPER_SAL_WAGES
		EXP_OPER_CONTR_PROF
		EXP_OPER_SUP
		EXP_OPER_RENT_DEPRC
		EXP_OPER_UTIL
		EXP_OPER_LIAB_PROF_INS
		EXP_OPER_OTHR_INS
		EXP_OPER_ALL_OTHR
		EXP_OPER_TOTL
		NET_FRM_OPER
    ;
    merge
        HL_SC_Analytic_file
      	SC_data16 
    ;
    by
        OSHPD_ID
	;
run;


* combine SC_data15_raw and SC_data16_raw vertically - TT
;

data SC_data_analytic_file_v2;
    set
        SC_data15_raw(in=ay2015_data_row)
        SC_data16_raw(in=ay2016_data_row)
    ;
    if
        ay2015_data_row=1
    then
        do;
            data_source="15";
        end;
    else
        do;
            data_source="16";
        end;
run;
