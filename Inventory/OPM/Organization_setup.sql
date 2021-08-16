SELECT
*
FROM
APPS.FND_DESCRIPTIVE_FLEXS_VL
WHERE 1=1
--AND APPLICATION_TABLE_NAME='Inventory'
AND TITLE='Transfer Order Lines'

------------------------------------------------------------------------------------------------

SELECT
*
FROM
APPS.FND_DESCR_FLEX_CONTEXTS_VL 
WHERE 1=1
AND DESCRIPTIVE_FLEX_CONTEXT_CODE='OM Move/Trip Number'

------------------------------------------------------------------------------------------------

SELECT
*
FROM
APPS.FND_DESCR_FLEX_COL_USAGE_VL 
WHERE 1=1
AND DESCRIPTIVE_FLEX_CONTEXT_CODE='OM Move/Trip Number'

------------------------------------------------------------------------------------------------
SELECT
*
FROM
APPS.FND_FLEX_VALUE_SETS 
WHERE 1=1
AND FLEX_VALUE_SET_NAME='XXAKG_MOVE_ORDER_NO'


------------------------------------------------------------------------------------------------
SELECT
*
FROM
APPS.FND_FLEX_VALIDATION_TABLES 
WHERE 1=1
AND MEANING_COLUMN_NAME='MOV_ORDER_NO'