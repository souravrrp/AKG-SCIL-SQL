SELECT 
*
FROM
APPS.SO_LOOKUPS
WHERE 1=1
AND LOOKUP_TYPE='AKG_HIRE_RATE_CHARGE_CEMENT'
--AND MEANING like '%Sariatpur%'
AND END_DATE_ACTIVE IS NULL