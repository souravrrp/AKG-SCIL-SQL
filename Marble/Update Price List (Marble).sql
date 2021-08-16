SELECT 'Without Advance Pricing' Item_Type,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE,
TO_CHAR(OPLL.END_DATE_ACTIVE,'DD-MON-RR') END_DATE,
OPLL.METHOD_CODE APPLICATION_METHOD
--,OPLL.*
FROM
APPS.OE_PRICE_LISTS OPL,
APPS.OE_PRICE_LIST_LINES OPLL
,APPS.MTL_SYSTEM_ITEMS_B MSI
where 1=1
and OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
and OPLL.END_DATE_ACTIVE IS NULL
AND OPL.ATTRIBUTE1 IS NULL
AND OPLL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
--    AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.ELAB.0020')
--AND OPLL.CONCATENATED_SEGMENTS=:P_CONCATENATED_SEGMENTS
AND OPLL.CONCATENATED_SEGMENTS=:P_Item_Code
AND OPL.NAME='AKG Marble Price List'
AND MSI.ORGANIZATION_ID=606
--and substr(msi.segment1,0,1) NOT IN ('G','M')
--AND OPLL.METHOD_CODE='UNIT_PRICE'
--and OPLL.ITEM_DESCRIPTION like '%Wastage%'
UNION ALL
SELECT 'Polish Item' Item_Type,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE,
TO_CHAR(OPLL.END_DATE_ACTIVE,'DD-MON-RR') END_DATE,
OPLL.METHOD_CODE APPLICATION_METHOD
--,OPLL.*
FROM
APPS.OE_PRICE_LISTS OPL,
APPS.OE_PRICE_LIST_LINES OPLL
,APPS.MTL_SYSTEM_ITEMS_B MSI
where 1=1
and OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
and OPLL.END_DATE_ACTIVE IS NULL
AND OPL.ATTRIBUTE1 IS NULL
AND OPLL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
--    AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.ELAB.0020')
--AND OPLL.CONCATENATED_SEGMENTS=:P_CONCATENATED_SEGMENTS
AND OPLL.CONCATENATED_SEGMENTS=:P_Item_Code
AND OPL.NAME='AKG Marble Polish Price List'
AND MSI.ORGANIZATION_ID=606
--and substr(msi.segment1,0,1) NOT IN ('G','M')
--AND OPLL.METHOD_CODE='UNIT_PRICE'
--and OPLL.ITEM_DESCRIPTION like '%Wastage%'
UNION ALL
SELECT 'Unpolish Item' Item_Type,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE,
TO_CHAR(OPLL.END_DATE_ACTIVE,'DD-MON-RR') END_DATE,
OPLL.METHOD_CODE APPLICATION_METHOD
--,OPLL.*
FROM
APPS.OE_PRICE_LISTS OPL,
APPS.OE_PRICE_LIST_LINES OPLL
,APPS.MTL_SYSTEM_ITEMS_B MSI
where 1=1
and OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
and OPLL.END_DATE_ACTIVE IS NULL
AND OPL.ATTRIBUTE1 IS NULL
AND OPLL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
--    AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.ELAB.0020')
--AND OPLL.CONCATENATED_SEGMENTS=:P_CONCATENATED_SEGMENTS
AND OPLL.CONCATENATED_SEGMENTS=:P_Item_Code
AND OPL.NAME='AKG Marble Unpolish Price List'
AND MSI.ORGANIZATION_ID=606
--and substr(msi.segment1,0,1) NOT IN ('G','M')
--AND OPLL.METHOD_CODE='UNIT_PRICE'
--and OPLL.ITEM_DESCRIPTION like '%Wastage%'


------------------------------------------------------------------------------------------------

SELECT
*
FROM
APPS.MTL_SYSTEM_ITEMS_B MSIB
WHERE 1=1
AND MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3=:P_ITEM_CODE-- IN ('CMNT.BAG.0001')
--AND MSIB.SEGMENT2='CANO'