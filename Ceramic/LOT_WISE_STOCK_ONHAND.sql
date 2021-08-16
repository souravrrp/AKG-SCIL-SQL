SELECT 
    MC.SEGMENT2 PRODUCT_DESCRIPTION,
    MC.SEGMENT1||'|'||MC.SEGMENT2 CATEGORY_CODE,
    MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3 ITEM_CODE,
    MSIB.DESCRIPTION,
    SUM(MOQD.PRIMARY_TRANSACTION_QUANTITY) ON_HAND_QUANTITY,
----    MSIB.INVENTORY_ITEM_ID,
    MOQD.LOT_NUMBER,
    MOQD.SUBINVENTORY_CODE,
    MSI.DESCRIPTION SUBINVENTORY_NAME,
    OOD.ORGANIZATION_NAME,
    OOD.ORGANIZATION_CODE,
    OOD.ORGANIZATION_ID,
    OOD.OPERATING_UNIT
--    ,MC.*
FROM
    APPS.MTL_CATEGORIES MC
    ,APPS.MTL_ITEM_CATEGORIES MIC
    ,APPS.MTL_SYSTEM_ITEMS_B MSIB
    ,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
    ,APPS.MTL_ONHAND_QUANTITIES_DETAIL MOQD
    ,APPS.MTL_SECONDARY_INVENTORIES MSI
--    ,APPS.MTL_LOT_NUMBERS MLN
WHERE 1=1
--    MC.CATEGORY_ID
    AND MIC.CATEGORY_ID=MC.CATEGORY_ID
    AND MIC.INVENTORY_ITEM_ID=MSIB.INVENTORY_ITEM_ID
    AND MSIB.ORGANIZATION_ID=MIC.ORGANIZATION_ID
    AND MSIB.ORGANIZATION_ID=OOD.ORGANIZATION_ID
    AND MSI.ORGANIZATION_ID=OOD.ORGANIZATION_ID
    AND MOQD.INVENTORY_ITEM_ID=MSIB.INVENTORY_ITEM_ID
    AND MOQD.ORGANIZATION_ID=MSIB.ORGANIZATION_ID
    AND MSI.SECONDARY_INVENTORY_NAME=MOQD.SUBINVENTORY_CODE
--    AND MLN.LOT_NUMBER=MOQD.LOT_NUMBER
--    AND MLN.INVENTORY_ITEM_ID =MOQD.INVENTORY_ITEM_ID
--    AND MLN.ORGANIZATION_ID =MOQD.ORGANIZATION_ID
    AND MSIB.ORGANIZATION_ID=99
    AND MC.SEGMENT1 IN ('INGREDIENT','FINISH GOODS','INDIRECT MATERIAL')--'FINISH GOODS'--'INDIRECT MATERIAL'--'INGREDIENT'
    AND MC.SEGMENT1!='NA'
    AND MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3 IN ('BSNA.ISBW.0001')
--    AND MSI.DISABLE_DATE IS NULL
--    AND MSI.DESCRIPTION IN ('Water Closet Marcella-P Trap-Rose Pink-B')
--    AND MC.SEGMENT2 in ('COMODE(WC)-IMOLA P-B(WOP)')
    GROUP BY
    MC.SEGMENT2,
    MC.SEGMENT1||'|'||MC.SEGMENT2,
    MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3,
    MSIB.DESCRIPTION,
--    MSIB.INVENTORY_ITEM_ID,
    MOQD.SUBINVENTORY_CODE,
    MOQD.LOT_NUMBER,
    MSI.DESCRIPTION,
    OOD.ORGANIZATION_NAME,
    OOD.ORGANIZATION_CODE,
    OOD.ORGANIZATION_ID,
    OOD.OPERATING_UNIT
    
    SELECT * FROM APPS.MTL_LOT_NUMBERS