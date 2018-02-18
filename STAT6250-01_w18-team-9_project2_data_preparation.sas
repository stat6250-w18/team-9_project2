*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
* 
[Dataset 1 Name] HHA-Listing-Dec2017

[Dataset Description] Home Health Agencies and Hospice， Dec.2017

[Experimental Unit Description] California Home Health Agencies and Hospice 
Licensed as of December 31, 2017

[Number of Observations] 2,810  

[Number of Features] 13

[Data Source] The file https://www.oshpd.ca.gov/documents/HID/FacilityList/
HHA-Listing-Dec2017.xlsx was downloaded and edited to produce file.

[Data Dictionary] https://www.oshpd.ca.gov/documents/HID/FacilityList/
HHA-Listing-Dec2017.xlsx

[Unique ID Schema] The columns OSHPD_ID is the unique id in HHA-Listing-Dec2017.
--

[Dataset 2 Name] Hospital-Listing-Dec2017

[Dataset Description] Hospitals in California as Dec.2017

[Experimental Unit Description] Hospitals licensed as of December 31, 2017 

[Number of Observations] 533

[Number of Features] 15

[Data Source] The file https://www.oshpd.ca.gov/documents/HID/FacilityList/
Hospital-Listing-Dec2017.xlsx was downloaded and edited to produce file.

[Data Dictionary] https://www.oshpd.ca.gov/documents/HID/FacilityList/
Hospital-Listing-Dec2017.xlsx

[Unique ID Schema] The columns OSHPD_ID is the unique id in 
Hospital-Listing-Dec2017.
--

[Dataset 3 Name] SC-Listing-Dec2017

[Dataset Description] Specialty Care Clinics in California as DEC.2017

[Experimental Unit Description] California Specialty Care Clinics licensed 
as of December 31, 2017 

[Number of Observations] 660

[Number of Features] 12

[Data Source] The file
https://www.oshpd.ca.gov/documents/HID/FacilityList/SC-Listing-Dec2017.xlsx
was downloaded and edited to produce file.

[Data Dictionary] https://www.oshpd.ca.gov/documents/HID/FacilityList/
SC-Listing-Dec2017.xlsx

[Unique ID Schema] The column OSHPD_ID is a unique id.
--

[Dataset 4 Name] SpCl16_util_data_FINAL

[Dataset Description] Specialty Care Clinics Annual Utilization Data

[Experimental Unit Description] California Specialty Care Clinics Annual Utilization 
Data(Complete Data Set).

[Number of Observations] 617

[Number of Features] 33

[Data Source]  The file https://www.oshpd.ca.gov/documents/HID/Utilization/
SpCl16_util_data_FINAL.xlsx was downloaded and edited to produce file 
SpCl16_util_data_FINAL.xls by deleting the column 34 to the end.

[Data Dictionary] https://www.oshpd.ca.gov/documents/HID/Utilization/
SpCl16_util_data_FINAL.xlsx

[Unique ID Schema] The column OSHPD_ID is a unique id.
;

* environmental setup;

* create output formats;
