SELECT
*
FROM
APPS.SO_LOOKUPS
WHERE 1=1
AND LOOKUP_TYPE='AKG_TO_FINAL_DESTINATION'
--AND END_DATE_ACTIVE IS NULL
--and MEANING like '%Modren%'

SELECT
--*
Meaning Location
FROM
APPS.FND_LOOKUP_VALUES
WHERE 1=1
AND LOOKUP_TYPE='AKG_TO_FINAL_DESTINATION'
--AND MEANING like 'Modern%'\
AND MEANING NOT LIKE 'AKCL%'
AND MEANING NOT LIKE 'Abul%'
AND ENABLED_FLAG='Y'
AND END_DATE_ACTIVE IS NULL



SELECT 
--*
Meaning Location
FROM
APPS.FND_LOOKUP_VALUES
WHERE 1=1
AND LOOKUP_TYPE='AKG_HIRE_RATE_CHARGE_CEMENT'
AND MEANING NOT LIKE 'AKCL%'
AND ENABLED_FLAG='Y'
AND END_DATE_ACTIVE IS NULL
--AND MEANING LIKE 'Bangla Bazar'
ORDER BY CREATION_DATE DESC



SELECT
*
FROM
APPS.XXAKG_ONT_REG_BLK_FINAL_DEST_M 
WHERE 1=1
AND ORG_ID=85


SELECT
*
FROM
APPS.XXAKG_REGION_BLK_FINAL_DEST_V
