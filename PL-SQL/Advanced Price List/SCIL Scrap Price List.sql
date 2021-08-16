SELECT
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE,
TO_CHAR(OPLL.END_DATE_ACTIVE,'DD-MON-RR') END_DATE,
OPLL.METHOD_CODE APPLICATION_METHOD
--,OPL.*
--,OPLL.*
FROM
APPS.OE_PRICE_LISTS OPL
,APPS.OE_PRICE_LIST_LINES OPLL
WHERE 1=1
AND OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
--AND OPLL.END_DATE_ACTIVE IS NULL
--AND OPL.ATTRIBUTE1 IS NULL
AND OPL.NAME='SCIL Scrap Price List'
AND OPLL.CONCATENATED_SEGMENTS=:P_SCRAP_ITEM
--AND TO_CHAR(OPLL.START_DATE_ACTIVE,'RRRR')=:P_PERIOD
ORDER BY CONCATENATED_SEGMENTS, OPLL.START_DATE_ACTIVE


------------------------------------------------------------------------------------------------

SELECT
MSI.INVENTORY_ITEM_ID,
MSI.ORGANIZATION_ID,
OOD.ORGANIZATION_CODE,
OOD.ORGANIZATION_NAME,
MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
MSI.DESCRIPTION,
MSI.INVENTORY_ITEM_FLAG,
MSI.CUSTOMER_ORDER_FLAG,
MSI.CUSTOMER_ORDER_ENABLED_FLAG,
MSI.INVOICE_ENABLED_FLAG,
MSI.STOCK_ENABLED_FLAG,
MSI.PRIMARY_UOM_CODE
--,MSI.*
--,OOD.*
FROM
APPS.MTL_SYSTEM_ITEMS_B MSI
,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE 1=1
AND MSI.ORGANIZATION_ID=OOD.ORGANIZATION_ID
--AND OOD.ORGANIZATION_ID=:P_ORGANIZATION_ID--101
AND ORGANIZATION_CODE in ('SCI')
AND OPERATING_UNIT=85
--AND MSI.ORGANIZATION_ID=101
--AND MSI.SEGMENT1='BRND'
--AND MSI.SEGMENT2='GIFT'
--AND MSI.INVENTORY_ITEM_ID='24408'
AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('SCRP.MISC.0106',
'SCRP.DRUM.0018',
'SCRP.LNGT.0001',
'SCRP.TYRE.0001',
'SCRP.TYRE.0002',
'SCRP.MISC.0110',
'SCRP.BAGW.0001')
--AND UPPER(MSI.DESCRIPTION) LIKE UPPER('%'||:P_ITEM_DESC||'%') 
--AND MSI.PRIMARY_UOM_CODE='PCS'
--AND MSI.DESCRIPTION LIKE 'Tea%'
AND MSI.ENABLED_FLAG='Y'

------------------------------------------------------------------------------------------------
SELECT
(SELECT OOD.ORGANIZATION_CODE FROM APPS.ORG_ORGANIZATION_DEFINITIONS OOD WHERE MSIB.ORGANIZATION_ID=OOD.ORGANIZATION_ID) ORGANIZATION_CODE,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.UNIT_CODE "UOM",
MSIB.CUSTOMER_ORDER_ENABLED_FLAG,
MSIB.SHIPPABLE_ITEM_FLAG,
MSIB.INVOICE_ENABLED_FLAG
FROM
APPS.MTL_SYSTEM_ITEMS_B MSIB
,APPS.OE_PRICE_LISTS OPL
,APPS.OE_PRICE_LIST_LINES OPLL
WHERE 1=1
AND OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
AND OPLL.END_DATE_ACTIVE IS NULL
--AND OPL.ATTRIBUTE1 IS NULL
AND OPL.NAME='SCIL Scrap Price List'
AND MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3=OPLL.CONCATENATED_SEGMENTS
AND OPLL.CONCATENATED_SEGMENTS IN ('SCRP.MISC.0106',
'SCRP.DRUM.0018',
'SCRP.LNGT.0001',
'SCRP.TYRE.0001',
'SCRP.TYRE.0002',
'SCRP.MISC.0110',
'SCRP.BAGW.0001')
AND MSIB.ORGANIZATION_ID IN ('101','1345')