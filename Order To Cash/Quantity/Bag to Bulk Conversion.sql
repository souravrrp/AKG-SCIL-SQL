/* Formatted on 10/27/2019 10:05:14 AM (QP5 v5.287) */
---------------------------***MTN to BAG Conversion***--------------------------

SELECT (CASE
           WHEN '1024565' = :P_INVENTORY_ITEM_ID
           THEN
              (NVL ( :P_REQUIRED_QUANTITY, 0) * 1000) / 50
           ELSE
              DECODE (MSI.PRIMARY_UOM_CODE,
                      'MTN', NVL ( :P_REQUIRED_QUANTITY, 0) * 20,
                      NVL ( :P_REQUIRED_QUANTITY, 0))
        END)
          QTY
  FROM INV.MTL_SYSTEM_ITEMS_B MSI
 WHERE     1 = 1
       AND MSI.ORGANIZATION_ID = :P_ORGANIZATION_ID
       AND MSI.INVENTORY_ITEM_ID = :P_INVENTORY_ITEM_ID;


---------------------------***BAG to MTN Conversion***--------------------------

SELECT (CASE
           WHEN '1024565' = :P_INVENTORY_ITEM_ID
           THEN
              NVL ( :P_REQUIRED_QUANTITY, 0)
           ELSE
              DECODE (MSI.PRIMARY_UOM_CODE,
                      'MTN', NVL ( :P_REQUIRED_QUANTITY, 0),
                      (NVL ( :P_REQUIRED_QUANTITY, 0) / 20))
        END)
          QTY
  FROM INV.MTL_SYSTEM_ITEMS_B MSI
 WHERE     1 = 1
       AND MSI.ORGANIZATION_ID = :P_ORGANIZATION_ID
       AND MSI.INVENTORY_ITEM_ID = :P_INVENTORY_ITEM_ID;



--------------------------------------------------------------------------------

SELECT (CASE
           WHEN '1024565' = :P_INVENTORY_ITEM_ID
           THEN
              (NVL ( :P_REQUIRED_QUANTITY, 0) * 1000) / 50
           WHEN MSI.PRIMARY_UOM_CODE = 'MTN'
           THEN
              NVL ( :P_REQUIRED_QUANTITY, 0) * 20
           WHEN MSI.PRIMARY_UOM_CODE = 'BAG'
           THEN
              NVL ( :P_REQUIRED_QUANTITY, 0)
           ELSE 
              NVL ( :P_REQUIRED_QUANTITY, 0)||''||MSI.PRIMARY_UOM_CODE
        END)
          QTY
  FROM INV.MTL_SYSTEM_ITEMS_B MSI
 WHERE     1 = 1
       AND MSI.ORGANIZATION_ID = :P_ORGANIZATION_ID
       AND MSI.INVENTORY_ITEM_ID = :P_INVENTORY_ITEM_ID;