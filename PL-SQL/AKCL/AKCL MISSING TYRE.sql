------------------------------**AKCL TYRE BRAND**--------------------------------------
SELECT
FLEX_VALUE_SET_NAME
,FFV.FLEX_VALUE
--,FFV.*
--,VAL_SET.*
FROM
APPS.FND_FLEX_VALUE_SETS VAL_SET
,APPS.FND_FLEX_VALUES FFV
WHERE 1=1
AND VAL_SET.FLEX_VALUE_SET_ID=FFV.FLEX_VALUE_SET_ID
AND VAL_SET.FLEX_VALUE_SET_NAME='XXAKG_TYRE_BRAND_DTL'
--AND FFV.FLEX_VALUE='MRF'

----------------------------------------**COUNTRY**--------------------------------------
SELECT
LOOKUP_TYPE,
LOOKUP_CODE,
MEANING,
DESCRIPTION
--,FLV.*
FROM
APPS.FND_LOOKUP_VALUES FLV
WHERE 1=1
--AND DESCRIPTION LIKE '%IND%'
AND LOOKUP_TYPE='JEDE_COUNTRY_SHORT_NAME'
--AND LOOKUP_CODE like '%IND%'
--AND MEANING='Vietnam'


----------------------------------------**TYRE SIZE**-------------------------------------
SELECT
FLEX_VALUE_SET_NAME
,FFV.FLEX_VALUE
--,FFV.*
--,VAL_SET.*
FROM
APPS.FND_FLEX_VALUE_SETS VAL_SET
,APPS.FND_FLEX_VALUES FFV
WHERE 1=1
AND VAL_SET.FLEX_VALUE_SET_ID=FFV.FLEX_VALUE_SET_ID
AND VAL_SET.FLEX_VALUE_SET_NAME='XXAKG_TYRE_SIZE_DTL'
AND VAL_SET.FLEX_VALUE_SET_ID='1017603'
--AND FFV.FLEX_VALUE='10-00-20'
