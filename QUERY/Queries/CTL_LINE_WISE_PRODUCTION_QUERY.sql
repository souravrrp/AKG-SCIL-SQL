/* Formatted on 3/19/2015 5:45:55 PM (QP5 v5.136.908.31019) */
SELECT r.ROUTING_NO AS Process,
       h.ACTUAL_START_DATE,
       h.actual_cmplt_date,
       h.batch_close_date,
       h.attribute3 AS Shift,
       d.attribute1 CTL_LINE,
       TO_DATE (h.attribute4, 'RRRR/MM/DD HH24:MI:SS') AS Production_Date,
       t.transaction_id,
       TO_CHAR (t.transaction_date, 'DD-MON-YYYY HH24:MI:SS') AS trans_date,
       DECODE (h.batch_status,
               -1, 'Cancelled',
               1, 'Pending',
               2, 'WIP',
               3, 'Completed',
               4, 'Closed')
          AS batch_status,
       h.batch_id,
       h.batch_no AS batch_no,
       DECODE (d.line_type, -1, 'Ingredients', 1, 'Product', 2, 'By Product')
          AS Line_type,
       t.organization_id,
       t.subinventory_code,
       msi.concatenated_segments,
       msi.description,
       mtt.transaction_type_name,
       lt.lot_number AS lot_number,
       CASE
          WHEN lt.lot_number IS NOT NULL THEN lt.transaction_quantity
          ELSE t.transaction_quantity
       END
          AS trans_qty,
       apps.fnc_get_item_cost (
          msi.organization_id,
          msi.inventory_item_id,
          TO_CHAR (TRUNC (TO_DATE (h.attribute4, 'RRRR/MM/DD HH24:MI:SS')),
                   'MON-YY'))
          item_cost,
       t.transaction_uom AS trans_uom,
       NVL (lot.attribute1, 0) AS "Length",
       lot.grade_code AS "GRADE",
       t.secondary_transaction_quantity AS sec_qty,
       t.secondary_uom_code
  FROM apps.mtl_material_transactions t,
       apps.gme_material_details d,
       apps.gme_batch_header h,
       apps.mtl_transaction_lot_numbers lt,
       apps.mtl_lot_numbers lot,
       apps.gmd_routings_b r,
       apps.mtl_system_items_kfv msi,
       apps.mtl_transaction_types mtt
 WHERE     t.transaction_source_type_id = 5
       AND t.transaction_source_id = h.batch_id
       AND t.organization_id = h.organization_id
       AND d.batch_id = h.batch_id
       and h.batch_no in (176886,178880)
       AND d.material_detail_id = t.trx_source_line_id
       AND lt.transaction_id(+) = t.transaction_id
       AND lot.lot_number(+) = lt.lot_number
       AND lot.organization_id(+) = lt.organization_id
       AND lot.inventory_item_id(+) = lt.inventory_item_id
       AND r.routing_id = h.routing_id
       AND r.owner_organization_id = h.organization_id
       AND d.inventory_item_id = msi.inventory_item_id
       AND d.organization_id = msi.organization_id
       AND t.transaction_type_id = mtt.transaction_type_id
       AND H.organization_id IN (95)
       and r.ROUTING_NO='CTL'
--       AND d.attribute_category = 'WIP|GP SHEET'
       AND d.line_type = 1
--       AND TRUNC (t.transaction_date) BETWEEN :p_from_date AND :p_to_date