SELECT mmt.TRANSACTION_ID TXN_ID,
          TRUNC (mmt.TRANSACTION_DATE),
          MP.ORGANIZATION_CODE SOURCE_ORG,
          mmt.ATTRIBUTE3 SO_MOVE_NO,
          mmt.ATTRIBUTE4 TC_NUM,
          MOVH.VEHICLE_NO,
          MOVH.TRANSPORT_MODE,
          MOVH.TRANSPORTER_NAME,
          OOD.OPERATING_UNIT,
          mtt.TRANSACTION_TYPE_NAME,
          CASE
             WHEN mmt.TRANSACTION_QUANTITY < 0 THEN 'Issue'
             ELSE 'Receipt'
          END
             TXN_TYPE,
          msi.CONCATENATED_SEGMENTS ITEM_CODE,
          msi.DESCRIPTION,
          (SELECT SEGMENT1
             FROM APPS.MTL_ITEM_CATEGORIES_V
            WHERE     INVENTORY_ITEM_ID = mmt.INVENTORY_ITEM_ID
                  AND ORGANIZATION_ID = mmt.ORGANIZATION_ID
                  AND CATEGORY_SET_NAME = 'Inventory')
             ITEM_CATEGORY,
          (SELECT SEGMENT2
             FROM APPS.MTL_ITEM_CATEGORIES_V
            WHERE     INVENTORY_ITEM_ID = mmt.INVENTORY_ITEM_ID
                  AND ORGANIZATION_ID = mmt.ORGANIZATION_ID
                  AND CATEGORY_SET_NAME = 'Inventory')
             ITEM_TYPE,
          mmt.SUBINVENTORY_CODE,
          CASE
             WHEN LOT.TRANSACTION_QUANTITY IS NOT NULL
             THEN
                LOT.TRANSACTION_QUANTITY
             ELSE
                mmt.TRANSACTION_QUANTITY
          END
             TRANSACTION_QUANTITY,
          case when PROCESS_ENABLED_FLAG='N'
             THEN mmt.TRANSACTION_COST
             ELSE APPS.fnc_get_item_cost(mmt.organization_id,mmt.inventory_item_id,TO_CHAR (mmt.TRANSACTION_DATE,'MON-YY')) END
              ITEM_COST,
          CASE
             WHEN LOTN.ATTRIBUTE_CATEGORY = 'WIP|REWINDING COIL'
             THEN
                LOTN.ATTRIBUTE10
             WHEN LOTN.ATTRIBUTE_CATEGORY = 'WIP|RE REWINDING COIL'
             THEN
                LOTN.ATTRIBUTE10
             WHEN LOTN.ATTRIBUTE_CATEGORY = 'WIP|RE RE REWINDING COIL'
             THEN
                LOTN.ATTRIBUTE10
             WHEN LOTN.ATTRIBUTE_CATEGORY = 'WIP|GP COIL'
             THEN
                LOTN.ATTRIBUTE10
             WHEN LOTN.ATTRIBUTE_CATEGORY = 'WIP|REWINDED BUILD UP COIL'
             THEN
                LOTN.ATTRIBUTE2
             ELSE
                '0'
          END
             COIL_WIDTH,
          mmt.TRANSACTION_UOM,
          LOT.LOT_NUMBER,
          LOTN.GRADE_CODE LOT_GRADE,
          DECODE (LOTN.STATUS_ID,
                  1, 'Active',
                  40, 'Prime',
                  41, 'R1',
                  42, 'R2',
                  20, 'Hold')
             LOT_STATUS,
          NVL (
             CASE
                WHEN LOT.LOT_NUMBER IS NOT NULL
                THEN
                   LOT.SECONDARY_TRANSACTION_QUANTITY
                ELSE
                   mmt.SECONDARY_TRANSACTION_QUANTITY
             END,
             0)
             SECONDARY_TXN_QUANTITY,
          mmt.SECONDARY_UOM_CODE,
          (SELECT ORGANIZATION_CODE
             FROM INV.MTL_PARAMETERS
            WHERE ORGANIZATION_ID = mmt1.ORGANIZATION_ID)
             DEST_ORG_CODE,
          mmt1.SUBINVENTORY_CODE DEST_SUB_INV_CODE,
          mmt.CREATION_DATE,
          apps.xxakg_com_pkg.GET_EMP_NAME_FROM_USER_ID (mmt.CREATED_BY)
             CREATED_BY
     FROM INV.MTL_MATERIAL_TRANSACTIONS mmt,
          INV.MTL_MATERIAL_TRANSACTIONS mmt1,
          INV.MTL_PARAMETERS MP,
          APPS.MTL_SYSTEM_ITEMS_B_KFV msi,
          INV.MTL_TRANSACTION_TYPES mtt,
          INV.MTL_TRANSACTION_LOT_NUMBERS LOT,
          INV.MTL_LOT_NUMBERS LOTN,
          APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
          apps.xxakg_mov_ord_hdr MOVH
    WHERE     mmt.TRANSACTION_ID = mmt1.TRANSFER_TRANSACTION_ID
          AND mmt.ORGANIZATION_ID = MP.ORGANIZATION_ID
          AND MP.ORGANIZATION_ID = OOD.ORGANIZATION_ID
          AND mmt.TRANSACTION_TYPE_ID = mtt.TRANSACTION_TYPE_ID
          AND mmt.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID
          AND mmt.ORGANIZATION_ID = msi.ORGANIZATION_ID
          AND mmt.TRANSACTION_ID = LOT.TRANSACTION_ID(+)
          AND mmt.ORGANIZATION_ID = LOT.ORGANIZATION_ID(+)
          AND LOT.INVENTORY_ITEM_ID = LOTN.INVENTORY_ITEM_ID(+)
          AND LOT.LOT_NUMBER = LOTN.LOT_NUMBER(+)
          AND LOT.ORGANIZATION_ID = LOTN.ORGANIZATION_ID(+)
          AND MOVH.MOV_ORDER_NO(+) = mmt.ATTRIBUTE3
          AND mmt.TRANSACTION_TYPE_ID = 3
        and rownum<10