SELECT
(SELECT ORGANIZATION_CODE FROM APPS.MTL_PARAMETERS WHERE ORGANIZATION_ID=MSI.ORGANIZATION_ID) ORG_CODE,
MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
MSI.DESCRIPTION ITEM_DESCRIPTION,
MSI.PRIMARY_UOM_CODE UOM,
MC.SEGMENT1 BUSINESS,
MC.SEGMENT2 PRODUCT_CLASS,
MC.SEGMENT3 PRODUCT_CATEGORY,
MC.SEGMENT4 PRODUCT_TYPE,
MC.SEGMENT5 "PRODUCT_SUB_TYPE/NAME",
MC.SEGMENT6 PRODUCT_BRAND,
MC.SEGMENT7 PRODUCT_WIDTH,
MC.SEGMENT8 THICKNESS,
MC.SEGMENT9 LENGTH,
MC.SEGMENT10 WEIGHT,
MC.SEGMENT11 COLOR,
MC.SEGMENT12 SHAPE,
MC.SEGMENT13 WAVE,
MC.SEGMENT14 GRADE,
MC.SEGMENT15 SHADE,
MC.SEGMENT16 "COUNTRY OF ORIGIN"
--,MC.*
--MSI.*
--MIC.*
FROM
INV.MTL_SYSTEM_ITEMS_B MSI
,INV.MTL_ITEM_CATEGORIES MIC
,INV.MTL_CATEGORIES_B MC
,APPS.MTL_CATEGORY_SETS MCS
WHERE 1=1
AND MIC.CATEGORY_SET_ID=MCS.CATEGORY_SET_ID
AND MIC.CATEGORY_ID=MC.CATEGORY_ID
AND MSI.INVENTORY_ITEM_ID=MIC.INVENTORY_ITEM_ID
AND MSI.ORGANIZATION_ID=MIC.ORGANIZATION_ID
AND MSI.ORGANIZATION_ID=99
AND MCS.CATEGORY_SET_NAME='Product Categories'
AND MC.SEGMENT1='CERAMIC'
--AND MIC.SEGMENT2='FINISH GOODS'
AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.SFII.0001')

------------------------------------------------------------------------------------------------

SELECT
(SELECT ORGANIZATION_CODE FROM APPS.MTL_PARAMETERS WHERE ORGANIZATION_ID=MSI.ORGANIZATION_ID) ORG_CODE,
MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
MSI.DESCRIPTION ITEM_DESCRIPTION,
MSI.PRIMARY_UOM_CODE UOM,
NVL(MC.SEGMENT1,'NA') BUSINESS,
NVL(MC.SEGMENT2,'NA') PRODUCT_CLASS,
NVL(MC.SEGMENT3,'NA') PRODUCT_CATEGORY,
NVL(MC.SEGMENT4,'NA') PRODUCT_TYPE,
NVL(MC.SEGMENT5,'NA') "PRODUCT_SUB_TYPE/NAME",
NVL(MC.SEGMENT6,'NA') PRODUCT_BRAND,
NVL(MC.SEGMENT7,'NA') PRODUCT_WIDTH,
NVL(MC.SEGMENT8,'NA') THICKNESS,
NVL(MC.SEGMENT9,'NA') LENGTH,
NVL(MC.SEGMENT10,'NA') WEIGHT,
NVL(MC.SEGMENT11,'NA') COLOR,
NVL(MC.SEGMENT12,'NA') SHAPE,
NVL(MC.SEGMENT13,'NA') WAVE,
NVL(MC.SEGMENT14,'NA') GRADE,
NVL(MC.SEGMENT15,'NA') SHADE,
NVL(MC.SEGMENT16,'NA') "COUNTRY OF ORIGIN"
--,MC.*
--MSI.*
--MIC.*
FROM
INV.MTL_SYSTEM_ITEMS_B MSI
,INV.MTL_ITEM_CATEGORIES MIC
,INV.MTL_CATEGORIES_B MC
,APPS.MTL_CATEGORY_SETS MCS
,APPS.XXAKG_DEL_ORD_DO_LINES DODL
,APPS.XXAKG_DEL_ORD_HDR DOH
,APPS.OE_ORDER_HEADERS_ALL OOH
WHERE 1=1
AND DOH.DO_HDR_ID = DODL.DO_HDR_ID
AND DODL.ORDER_HEADER_ID = OOH.HEADER_ID
--AND OOH.ORDER_NUMBER IN ('99071339')
AND DOH.DO_NUMBER IN ('DO/COU/92307')
AND DODL.ORDERED_ITEM_ID = MSI.INVENTORY_ITEM_ID
AND DODL.WAREHOUSE_ORG_ID = MSI.ORGANIZATION_ID
AND MIC.CATEGORY_SET_ID=MCS.CATEGORY_SET_ID
AND MIC.CATEGORY_ID=MC.CATEGORY_ID
AND MSI.INVENTORY_ITEM_ID=MIC.INVENTORY_ITEM_ID
AND MSI.ORGANIZATION_ID=MIC.ORGANIZATION_ID
AND MSI.ORGANIZATION_ID=99
AND MCS.CATEGORY_SET_NAME='Product Categories'
AND MC.SEGMENT1='CERAMIC'
--AND MIC.SEGMENT2='FINISH GOODS'
--AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.SFII.0001')


------------------------------------------------------------------------------------------------

SELECT
MIC.CATEGORY_ID,
MIC.ORGANIZATION_ID,
MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
MSI.DESCRIPTION,
MSI.PRIMARY_UOM_CODE,
MC.SEGMENT1 ITEM_CATEGORY,
MC.SEGMENT2 ITEM_TYPE
,MIC.CATEGORY_SET_NAME
,MIC.*
FROM
APPS.MTL_SYSTEM_ITEMS_B MSI,
APPS.MTL_ITEM_CATEGORIES_V MIC,
APPS.MTL_CATEGORIES MC
WHERE 1=1
AND MIC.CATEGORY_ID=MC.CATEGORY_ID
AND MSI.INVENTORY_ITEM_ID=MIC.INVENTORY_ITEM_ID
AND MSI.ORGANIZATION_ID=MIC.ORGANIZATION_ID
--AND MC.SEGMENT2 IS NOT NULL
AND MSI.ORGANIZATION_ID=91
AND MIC.CATEGORY_SET_NAME='Product Categories'
--AND MC.SEGMENT1='NA'
--AND MC.SEGMENT2 IN ('FLUSING MECHANISM FOR STELLA')
AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.SFII.0001')

--------------------------------------------------------------------------------
SELECT
(SELECT ORGANIZATION_CODE FROM APPS.MTL_PARAMETERS WHERE ORGANIZATION_ID=MSI.ORGANIZATION_ID) ORG_CODE,
MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
MSI.DESCRIPTION ITEM_DESCRIPTION,
MSI.PRIMARY_UOM_CODE UOM,
NVL(MC.SEGMENT1,'NA') BUSINESS,
NVL(MC.SEGMENT2,'NA') PRODUCT_CLASS,
NVL(MC.SEGMENT3,'NA') PRODUCT_CATEGORY,
NVL(MC.SEGMENT4,'NA') PRODUCT_TYPE,
NVL(MC.SEGMENT5,'NA') "PRODUCT_SUB_TYPE/NAME",
NVL(MC.SEGMENT6,'NA') PRODUCT_BRAND,
NVL(MC.SEGMENT7,'NA') PRODUCT_WIDTH,
NVL(MC.SEGMENT8,'NA') THICKNESS,
NVL(MC.SEGMENT9,'NA') LENGTH,
NVL(MC.SEGMENT10,'NA') WEIGHT,
NVL(MC.SEGMENT11,'NA') COLOR,
NVL(MC.SEGMENT12,'NA') SHAPE,
NVL(MC.SEGMENT13,'NA') WAVE,
NVL(MC.SEGMENT14,'NA') GRADE,
NVL(MC.SEGMENT15,'NA') SHADE,
NVL(MC.SEGMENT16,'NA') "COUNTRY OF ORIGIN"
--,MC.*
--MSI.*
--MIC.*
FROM
INV.MTL_SYSTEM_ITEMS_B MSI
,INV.MTL_ITEM_CATEGORIES MIC
,INV.MTL_CATEGORIES_B MC
,APPS.MTL_CATEGORY_SETS MCS
,APPS.OE_ORDER_LINES_ALL OOL
WHERE 1=1
AND OOL.SHIPMENT_PRIORITY_CODE IN ('DO/COU/92307')
AND OOL.ORDERED_ITEM_ID = MSI.INVENTORY_ITEM_ID
AND OOL.SHIP_FROM_ORG_ID = MSI.ORGANIZATION_ID
AND MIC.CATEGORY_SET_ID=MCS.CATEGORY_SET_ID
AND MIC.CATEGORY_ID=MC.CATEGORY_ID
AND MSI.INVENTORY_ITEM_ID=MIC.INVENTORY_ITEM_ID
AND MSI.ORGANIZATION_ID=MIC.ORGANIZATION_ID
AND MSI.ORGANIZATION_ID=99
AND MCS.CATEGORY_SET_NAME='Product Categories'
AND MC.SEGMENT1='CERAMIC'
--AND MIC.SEGMENT2='FINISH GOODS'
--AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.SFII.0001')