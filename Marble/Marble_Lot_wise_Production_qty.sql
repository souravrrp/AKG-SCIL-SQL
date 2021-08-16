SELECT DISTINCT 'Only Block Lot number' Lot_type,
                sysb.segment1||'.'||sysb.segment2||'.'||sysb.segment3 "Ingredient Item Number",
                mtt.transaction_type_name Ingred_Qty,
                mtln.transaction_quantity,
                mtln1.transaction_quantity,
                mmt.transaction_date,
                mmt.transaction_set_id,
                sysb1.segment1||'.'||sysb1.segment2||'.'||sysb1.segment3 "Prod_Item",
                 mtt1.transaction_type_name Prod_Qty,
                gg.object_id "Ingredient Object ID",
                gg.object_type "Ingredient Object Type",
                mtln.transaction_id,
                mtln.transaction_source_id,
                gg.parent_object_id "Ingredient Parent Object ID",
                mtln.lot_number "Ingredient Lot Number",
                mtln1.lot_number "Prod_Lot",
                batch1.batch_no "Product Batch Number"
  FROM inv.mtl_object_genealogy gg,
       inv.mtl_object_genealogy gg1,
       inv.mtl_transaction_lot_numbers mtln,
       inv.mtl_transaction_lot_numbers mtln1,
       inv.mtl_system_items_b sysb,
       inv.mtl_system_items_b sysb1,
       gme.gme_batch_header batch,
       gme.gme_batch_header batch1,
       apps.mtl_material_transactions mmt,
       apps.mtl_material_transactions mmt1,
       inv.mtl_transaction_types mtt,
       inv.mtl_transaction_types mtt1
WHERE     1 = 1
       AND gg.origin_txn_id(+) = mtln.transaction_id
       AND mtln.inventory_item_id = sysb.inventory_item_id
       AND mtln.transaction_source_id = batch.batch_id
       AND gg1.origin_txn_id = mtln1.transaction_id
       AND mtln1.inventory_item_id = sysb1.inventory_item_id
       AND mtln1.transaction_source_id = batch1.batch_id
       AND NVL (gg1.object_id, gg.object_id) = gg.parent_object_id
       AND mmt.transaction_type_id = mtt.transaction_type_id
       AND mmt1.transaction_type_id = mtt1.transaction_type_id
       --and gg.object_id = gg1.parent_object_id
       AND sysb.organization_id = :organization_id
       AND batch.organization_id = :organization_id
       AND mtln.organization_id = :organization_id
       AND mtln.lot_number in ('M.ALYB.71/4')
--       AND mtln.lot_number = :i_lotnumber   ----only block lot number
        --and mtln1.lot_number=:p_lotnumber       ----without block lot 
       AND mtln.lot_number != mtln1.lot_number
       AND mmt.TRANSACTION_ID = mtln.transaction_id
       AND mmt1.TRANSACTION_ID = mtln1.transaction_id
       UNION ALL
       SELECT DISTINCT 'Without Block Lot number' Lot_type,
                sysb.segment1||'.'||sysb.segment2||'.'||sysb.segment3 "Ingredient Item Number",
                mtt.transaction_type_name Ingred_Qty,
                mtln.transaction_quantity,
                mtln1.transaction_quantity,
                mmt.transaction_date,
                mmt.transaction_set_id,
                sysb1.segment1||'.'||sysb1.segment2||'.'||sysb1.segment3 "Prod_Item",
                mtt1.transaction_type_name Prod_Qty,
                gg.object_id "Ingredient Object ID",
                gg.object_type "Ingredient Object Type",
                mtln.transaction_id,
                mtln.transaction_source_id,
                gg.parent_object_id "Ingredient Parent Object ID",
                mtln.lot_number "Ingredient Lot Number",
                mtln1.lot_number "Prod_Lot",
                batch1.batch_no "Product Batch Number"
  FROM inv.mtl_object_genealogy gg,
       inv.mtl_object_genealogy gg1,
       inv.mtl_transaction_lot_numbers mtln,
       inv.mtl_transaction_lot_numbers mtln1,
       inv.mtl_system_items_b sysb,
       inv.mtl_system_items_b sysb1,
       gme.gme_batch_header batch,
       gme.gme_batch_header batch1,
       apps.mtl_material_transactions mmt,
       apps.mtl_material_transactions mmt1,
       inv.mtl_transaction_types mtt,
       inv.mtl_transaction_types mtt1
WHERE     1 = 1
       AND gg.origin_txn_id(+) = mtln.transaction_id
       AND mtln.inventory_item_id = sysb.inventory_item_id
       AND mtln.transaction_source_id = batch.batch_id
       AND gg1.origin_txn_id = mtln1.transaction_id
       AND mtln1.inventory_item_id = sysb1.inventory_item_id
       AND mtln1.transaction_source_id = batch1.batch_id
       AND NVL (gg1.object_id, gg.object_id) = gg.parent_object_id
       AND mmt.transaction_type_id = mtt.transaction_type_id
       AND mmt1.transaction_type_id = mtt1.transaction_type_id
       --and gg.object_id = gg1.parent_object_id
       AND sysb.organization_id = :organization_id
       AND batch.organization_id = :organization_id
       AND mtln.organization_id = :organization_id
       AND mtln1.lot_number in ('M.ALYB.71/4')
--       AND mtln.lot_number = :i_lotnumber   ----only block lot number
        --and mtln1.lot_number=:p_lotnumber       ----without block lot 
       AND mtln.lot_number != mtln1.lot_number
       AND mmt.TRANSACTION_ID = mtln.transaction_id
       AND mmt1.TRANSACTION_ID = mtln1.transaction_id
       
       



------------------------------------------------------------------------------------------------

SELECT DISTINCT sysb.segment1||'.'||sysb.segment2||'.'||sysb.segment3 "Ingredient Item Number",
                mtt.transaction_type_name Ingred_Qty,
                mtln.transaction_quantity,
                mtln1.transaction_quantity,
                mmt.transaction_date,
                mmt.transaction_set_id,
                sysb1.segment1||'.'||sysb1.segment2||'.'||sysb1.segment3 "Prod_Item",
                 mtt1.transaction_type_name Prod_Qty,
                gg.object_id "Ingredient Object ID",
                gg.object_type "Ingredient Object Type",
                mtln.transaction_id,
                mtln.transaction_source_id,
                gg.parent_object_id "Ingredient Parent Object ID",
                mtln.lot_number "Ingredient Lot Number",
                mtln1.lot_number "Prod_Lot",
                batch1.batch_no "Product Batch Number"
  FROM inv.mtl_object_genealogy gg,
       inv.mtl_object_genealogy gg1,
       inv.mtl_transaction_lot_numbers mtln,
       inv.mtl_transaction_lot_numbers mtln1,
       inv.mtl_system_items_b sysb,
       inv.mtl_system_items_b sysb1,
       gme.gme_batch_header batch,
       gme.gme_batch_header batch1,
       apps.mtl_material_transactions mmt,
       apps.mtl_material_transactions mmt1,
       inv.mtl_transaction_types mtt,
       inv.mtl_transaction_types mtt1
WHERE     1 = 1
       AND gg.origin_txn_id(+) = mtln.transaction_id
       AND mtln.inventory_item_id = sysb.inventory_item_id
       AND mtln.transaction_source_id = batch.batch_id
       AND gg1.origin_txn_id = mtln1.transaction_id
       AND mtln1.inventory_item_id = sysb1.inventory_item_id
       AND mtln1.transaction_source_id = batch1.batch_id
       AND NVL (gg1.object_id, gg.object_id) = gg.parent_object_id
       AND mmt.transaction_type_id = mtt.transaction_type_id
       AND mmt1.transaction_type_id = mtt1.transaction_type_id
       --and gg.object_id = gg1.parent_object_id
       AND sysb.organization_id = :organization_id
       AND batch.organization_id = :organization_id
       AND mtln.organization_id = :organization_id
--       AND mtln.lot_number in ('M.ALYB.71/4')
       AND mtln.lot_number = :i_lotnumber   ----only block lot number
--        and mtln1.lot_number=:p_lotnumber       ----without block lot 
       AND mtln.lot_number != mtln1.lot_number
       AND mmt.TRANSACTION_ID = mtln.transaction_id
       AND mmt1.TRANSACTION_ID = mtln1.transaction_id