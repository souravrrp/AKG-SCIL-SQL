/* Formatted on 5/21/2019 3:18:47 PM (QP5 v5.287) */
  SELECT HOU.NAME ORGANIZATION,
         A.CUSTOMER_NUMBER,
         A.CUSTOMER_NAME,
         HCA.ACCOUNT_NAME "Account Description",
         A.ADDRESS1 "Address Line 1",
         A.ADDRESS2 "Address Line 2",
         A.ADDRESS3 "Address Line 3",
         A.ADDRESS4 "Address Line 4",
         A.LOCATION "Ship/Bill to Location",
         A.SITE_USE_CODE,
         A.STATUS,
         A.SITE_USE_STATUS,
         A.ACCT_USE_STATUS,
         A.PRIMARY_FLAG,
         A.REAILER RETAILER
    --A.*
    FROM APPS.XXAKG_AR_CUSTOMER_SITE_V A,
         APPS.HZ_CUST_ACCOUNTS HCA,
         APPS.HR_OPERATING_UNITS HOU
   WHERE     1 = 1
         AND A.ORG_ID = 84
         AND HOU.ORGANIZATION_ID = A.ORG_ID
         AND A.CUSTOMER_ID = HCA.CUST_ACCOUNT_ID
         --AND SITE_USE_CODE = 'BILL_TO'
         --AND SITE_USE_CODE = 'SHIP_TO'
         --AND PRIMARY_FLAG='Y'
         --AND STATUS = 'A'
         --AND CUSTOMER_NUMBER IN ('21456')
         --AND A.CUSTOMER_NAME LIKE '%International%Institute%of%Maritime%Technology%'
         AND UPPER (A.CUSTOMER_NAME) LIKE UPPER ('%' || :P_CUST_NAME || '%')
ORDER BY 2 DESC