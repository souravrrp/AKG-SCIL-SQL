/* Formatted on 10/30/2019 9:55:32 AM (QP5 v5.287) */
SELECT MSI.INVENTORY_ITEM_ID,
       MSI.ORGANIZATION_ID,
       OOD.ORGANIZATION_CODE,
       OOD.ORGANIZATION_NAME,
       MSI.SEGMENT1 || '.' || MSI.SEGMENT2 || '.' || MSI.SEGMENT3 ITEM_CODE,
       MSI.DESCRIPTION,
       MSI.INVENTORY_ITEM_FLAG,
       MSI.CUSTOMER_ORDER_FLAG,
       MSI.CUSTOMER_ORDER_ENABLED_FLAG,
       MSI.INVOICE_ENABLED_FLAG,
       MSI.PURCHASING_ITEM_FLAG,
       MSI.SERVICE_ITEM_FLAG,
       MSI.PURCHASING_ENABLED_FLAG,
       MSI.STOCK_ENABLED_FLAG,
       MSI.LIST_PRICE_PER_UNIT,
       MSI.PRIMARY_UOM_CODE,
       INVENTORY_ASSET_FLAG
  --,MSI.*
  --,OOD.*
  FROM APPS.MTL_SYSTEM_ITEMS_B MSI, APPS.ORG_ORGANIZATION_DEFINITIONS OOD
 WHERE     1 = 1
       AND MSI.ORGANIZATION_ID = OOD.ORGANIZATION_ID
       AND (   :P_OPERATING_UNIT IS NULL
            OR (OOD.OPERATING_UNIT = :P_OPERATING_UNIT))
       AND (   :P_ORGANIZATION_CODE IS NULL
            OR (OOD.ORGANIZATION_CODE = :P_ORGANIZATION_CODE))
       AND (   :P_ITEM_CODE IS NULL
            OR (MSI.SEGMENT1 || '.' || MSI.SEGMENT2 || '.' || MSI.SEGMENT3 =
                   :P_ITEM_CODE))
       --AND OOD.ORGANIZATION_ID=:P_ORGANIZATION_ID--101
       --AND ORGANIZATION_CODE in ('SCI','CIM')
       --AND OPERATING_UNIT=85
       --AND MSI.ORGANIZATION_ID=101
       --AND MSI.SEGMENT1='BRND'
       --AND MSI.SEGMENT2='GIFT'
       --AND MSI.INVENTORY_ITEM_ID='24408'
       --AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('SCRP.MISC.0059','SCRP.MISC.0105')
       --AND UPPER(MSI.DESCRIPTION) LIKE UPPER('%'||:P_ITEM_DESC||'%')
       --AND MSI.PRIMARY_UOM_CODE='PCS'
       --AND MSI.DESCRIPTION LIKE 'Tea%'
       AND MSI.ENABLED_FLAG = 'Y';