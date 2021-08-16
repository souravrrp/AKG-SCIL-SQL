SELECT
*
FROM
APPS.AKG_BIEE_INTER_ORG_TRANSFER
WHERE 1=1
AND OPERATING_UNIT=85


SELECT
*
FROM
APPS.AKG_BI_SUBINV_TRANSACTIONS
WHERE 1=1
AND TO_CHAR (TRANSACTION_DATE, 'MON-RR') =:P_PERIOD_NAME
AND OPERATING_UNIT=85
AND SUBINVENTORY_CODE='DUMMY FG'


SELECT
*
FROM
APPS.AKG_BI_MISC_TRANSACTIONS
WHERE 1=1


-------------------------------------SUBINVENTORY_TRANSFER---------------------------

SELECT 
          ood.operating_unit,
          a.organization_id,
          ood.ORGANIZATION_CODE,
          a.SUBINVENTORY_CODE,
          a.TRANSFER_SUBINVENTORY,
          BB.TRANSACTION_TYPE_NAME,
          a.TRANSACTION_DATE,
          (SELECT segment1
             FROM apps.mtl_item_categories_v
            WHERE     INVENTORY_ITEM_ID = a.INVENTORY_ITEM_ID
                  AND ORGANIZATION_ID = a.ORGANIZATION_ID
                  AND CATEGORY_SET_NAME = 'Inventory')
             ITEM_CATEGORY,
          (SELECT segment2
             FROM apps.mtl_item_categories_v
            WHERE     INVENTORY_ITEM_ID = a.INVENTORY_ITEM_ID
                  AND ORGANIZATION_ID = a.ORGANIZATION_ID
                  AND CATEGORY_SET_NAME = 'Inventory')
             ITEM_TYPE,
          c.concatenated_segments AS item_code,
          c.description AS item_description,
          mlt.lot_number,
          a.primary_quantity,
          a.TRANSACTION_UOM
          ,A.TRANSACTION_REFERENCE
          ,apps.get_ename_frm_enum (b.created_by) "REQUEST_BY"
          ,apps.get_ename_frm_enum (a.created_by) "TRANSACT_BY"
     FROM apps.mtl_material_transactions a,
          apps.mtl_transaction_lot_numbers mlt,
          apps.mtl_txn_request_headers b,
          INV.MTL_TRANSACTION_TYPES BB,
          APPS.MTL_SYSTEM_ITEMS_B_KFV C,
          apps.org_organization_definitions ood
    WHERE     a.organization_id = ood.organization_id
          AND a.inventory_item_id = c.inventory_item_id
          AND a.organization_id = c.organization_id
          AND A.TRANSACTION_TYPE_ID = BB.TRANSACTION_TYPE_ID
--          AND a.transaction_type_id IN (104, 2, 64)
          AND a.transaction_source_id = b.header_id(+)
          AND a.transaction_id = mlt.transaction_id(+)
          AND TO_CHAR (A.TRANSACTION_DATE, 'MON-RR') ='MAY-18'--:P_PERIOD_NAME
          AND OPERATING_UNIT=85
--          AND SUBINVENTORY_CODE='DUMMY FG'
--          AND TRANSFER_SUBINVENTORY='DUMMY FG'
          AND A.TRANSACTION_REFERENCE LIKE '%1171530%'