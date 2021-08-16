SELECT 
HOU.NAME ORGANIZATION,
A.CUSTOMER_NUMBER,
A.CUSTOMER_NAME,
        (SELECT DISTINCT NVL (HOC.PHONE_NUMBER, 0)
             FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
            WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                  AND ARC.CUSTOMER_ID = A.CUSTOMER_ID
                  AND HOC.STATUS = 'A'
                  AND HOC.CONTACT_STATUS = 'A'
                  AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                  AND HOC.CONTACT_POINT_TYPE = 'PHONE'
                  AND ARC.JOB_TITLE = 'Owner')
             Owner_PHONE_NO,
          (SELECT DISTINCT NVL (HOC.EMAIL_ADDRESS, 0)
             FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
            WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                  AND ARC.CUSTOMER_ID = A.CUSTOMER_ID
                  AND HOC.STATUS = 'A'
                  AND HOC.CONTACT_STATUS = 'A'
                  AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                  AND HOC.CONTACT_POINT_TYPE = 'EMAIL'
                  AND ARC.JOB_TITLE = 'Owner')
             Owner_EMAIL,
          (SELECT DISTINCT NVL (HOC.PHONE_NUMBER, 0)
             FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
            WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                  AND ARC.CUSTOMER_ID = A.CUSTOMER_ID
                  AND HOC.STATUS = 'A'
                  AND HOC.CONTACT_STATUS = 'A'
                  AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                  AND HOC.CONTACT_POINT_TYPE = 'PHONE'
                  AND ARC.JOB_TITLE = 'Manager')
             Manager_PHONE_NO,
          (SELECT DISTINCT NVL (HOC.EMAIL_ADDRESS, 0)
             FROM APPS.AR_CONTACTS_V ARC, APPS.HZ_ORG_CONTACTS_V HOC
            WHERE     ARC.CONTACT_NUMBER = HOC.CONTACT_NUMBER
                  AND ARC.CUSTOMER_ID = A.CUSTOMER_ID
                  AND HOC.STATUS = 'A'
                  AND HOC.CONTACT_STATUS = 'A'
                  AND HOC.CONTACT_PRIMARY_FLAG = 'Y'
                  AND HOC.CONTACT_POINT_TYPE = 'EMAIL'
                  AND ARC.JOB_TITLE = 'Manager')
             Manager_EMAIL
--,A.* 
FROM
APPS.XXAKG_AR_CUSTOMER_SITE_V A,
APPS.HR_OPERATING_UNITS HOU
WHERE 1=1
--AND A.ORG_ID=85
AND HOU.ORGANIZATION_ID=A.ORG_ID
AND SITE_USE_CODE = 'BILL_TO'
--AND SITE_USE_CODE = 'SHIP_TO'
--AND A.SHIP_TO_ORG_ID='34777'
AND PRIMARY_FLAG='Y'
--AND STATUS = 'A'
AND A.CUSTOMER_NUMBER IN ('20058','33530','20061','20059','20062')
--AND A.CUSTOMER_NAME LIKE '%International%Institute%of%Maritime%Technology%'
--AND UPPER(A.CUSTOMER_NAME) LIKE UPPER('%'||:P_CUST_NAME||'%') 
ORDER BY 2 DESC