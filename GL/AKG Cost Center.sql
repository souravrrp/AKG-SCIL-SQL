SELECT
VAL_SET.FLEX_VALUE_SET_NAME,
FFV.FLEX_VALUE
,FFV.*
--,FFV.*
FROM
APPS.FND_FLEX_VALUE_SETS VAL_SET
,APPS.FND_FLEX_VALUES_vl FFV
WHERE 1=1
AND VAL_SET.FLEX_VALUE_SET_ID=FFV.FLEX_VALUE_SET_ID
AND VAL_SET.FLEX_VALUE_SET_NAME='AKG_CostCentre'
--AND VAL_SET.FLEX_VALUE_SET_ID='1014887'
AND FFV.FLEX_VALUE='GHAT27'