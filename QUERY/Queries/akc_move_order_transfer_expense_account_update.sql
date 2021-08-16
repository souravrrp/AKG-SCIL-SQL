/* Formatted on 3/15/2015 9:59:08 AM (QP5 v5.136.908.31019) */
  SELECT mtrl.request_number move_order_number,
         TRUNC ( (mtrl.line_number - 1) / 5) + 1 hpage_no,
         mtrl.line_id,
         mtrl.header_id,
         mtrl.organization_id,
         mtrl.inventory_item_id,
         (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3) item_code,
         msi.attribute30,
         msi.description,
         mtrl.from_locator_id,
         mtrl.to_account_id,
         mtrl.transaction_header_id,
         mtrl.line_number,
         mtrl.revision,
         mtrl.transaction_type_name transaction_type,
         mtrl.date_required,
         mtrl.uom_code,
         mtrl.quantity quantity_required,
         mtrl.quantity_delivered,
         uses.use_of_area,
         uses.used_dept,
         mtrl.grade_code,
         mtrl.from_subinventory_code,
         mtrl.lpn_number,
         mtrl.from_cost_group_id,
         mtrl.lot_number,
         mtrl.unit_number,
         mtrl.serial_number_start,
         mtrl.serial_number_end,
         mtrl.to_subinventory_code,
         mtrl.to_locator_id locatorr,
         mtrl.to_cost_group_id,
         mtrl.transaction_type_id,
         mtrl.REFERENCE || ' [' || mtrl.lot_number || '] ' REFERENCE,
         mtrl.txn_source_id,
         mthl.header_status_name,
         mtrl.status_date,
         mtrl.line_status,
         ml.meaning status,
         mtrl.transaction_source_type_id,
         mtrl.txn_source_line_id,
         mtrl.txn_source_line_detail_id,
         mtrl.to_organization_id,
         mtrl.ship_to_location_id,
         xx.subinventory_code,
         xx.locator_id,
         xx.transaction_date,
         xx.qty_issued,
         xx.reason_id,
         mthl.created_by prepared_by,
         xx.created_by issued_by,
         xx.taken_by,
            APPS.XXAKG_OPMINV_PKG.personid_to_empid (xx.taken_by)
         || '-'
         || APPS.XXAKG_OPMINV_PKG.empnm_from_personid (xx.taken_by)
            TAKEN_BY_NAME,
         apps.xxakg_opminv_pkg.LAST_MO (mtrl.organization_id,
                                        mtrl.status_date,
                                        uses.used_dept,
                                        mtrl.inventory_item_id)
            last_mo,
         apps.xxakg_opminv_pkg.LAST_MO_issue_qty (
            mtrl.organization_id,
            mtrl.status_date,
            uses.used_dept,
            mtrl.inventory_item_id,
            apps.xxakg_opminv_pkg.LAST_MO (mtrl.organization_id,
                                           mtrl.status_date,
                                           uses.used_dept,
                                           mtrl.inventory_item_id))
            last_mo_issue_qty,
         TRUNC (apps.xxakg_opminv_pkg.LAST_MO_dt (mtrl.organization_id,
                                                  mtrl.status_date,
                                                  uses.used_dept,
                                                  mtrl.inventory_item_id))
            last_mo_dt,
      /*--------------  Expense account and cost center-------------------*/
         CASE
            WHEN mthl.transaction_type_id = 64
                 AND mtrl.from_subinventory_code = 'AKC-GEN ST'
            THEN
               (SELECT    gcc.segment1
                       || '.'
                       || gcc.segment2
                       || '.'
                       || gcc.segment3
                  FROM xla.xla_seg_rule_details xsrd,
                       xla.xla_conditions xc,
                       inv.mtl_transaction_reasons mtr,
                       gl.gl_code_combinations gcc
                 WHERE xsrd.segment_rule_code = 'CEM_EXP_TRANS_TO'
                       AND xc.segment_rule_detail_id =
                             xsrd.segment_rule_detail_id
                       AND xc.source_code = 'REASON_ID'
                       AND xc.VALUE_CONSTANT = mtrl.reason_id
                       AND mtrl.reason_id = mtr.reason_id
                       AND xsrd.value_code_combination_id =
                             gcc.code_combination_id)
            ELSE
               (SELECT segment1 || '.' || segment2 || '.' || segment3
                  FROM gl.gl_code_combinations
                 WHERE code_combination_id = mtrl.TO_ACCOUNT_ID)
         END
            expanse_account,
         CASE
            WHEN mthl.transaction_type_id = 64
                 AND mtrl.from_subinventory_code = 'AKC-GEN ST'
            THEN
               (SELECT gcc.segment3
                  FROM xla.xla_seg_rule_details xsrd,
                       xla.xla_conditions xc,
                       inv.mtl_transaction_reasons mtr,
                       gl.gl_code_combinations gcc
                 WHERE xsrd.segment_rule_code = 'CEM_EXP_TRANS_TO'
                       AND xc.segment_rule_detail_id =
                             xsrd.segment_rule_detail_id
                       AND xc.source_code = 'REASON_ID'
                       AND xc.VALUE_CONSTANT = mtrl.reason_id
                       AND mtrl.reason_id = mtr.reason_id
                       AND xsrd.value_code_combination_id =
                             gcc.code_combination_id)
            ELSE
               (SELECT segment3
                  FROM gl.gl_code_combinations
                 WHERE code_combination_id = mtrl.TO_ACCOUNT_ID)
         END
            natural_account,
         CASE
            WHEN mthl.transaction_type_id = 64
                 AND mtrl.from_subinventory_code = 'AKC-GEN ST'
            THEN
               (SELECT gcc.segment2
                  FROM xla.xla_seg_rule_details xsrd,
                       xla.xla_conditions xc,
                       inv.mtl_transaction_reasons mtr,
                       gl.gl_code_combinations gcc
                 WHERE xsrd.segment_rule_code = 'CEM_EXP_TRANS_TO'
                       AND xc.segment_rule_detail_id =
                             xsrd.segment_rule_detail_id
                       AND xc.source_code = 'REASON_ID'
                       AND xc.VALUE_CONSTANT = mtrl.reason_id
                       AND mtrl.reason_id = mtr.reason_id
                       AND xsrd.value_code_combination_id =
                             gcc.code_combination_id)
            ELSE
               (SELECT segment2
                  FROM gl.gl_code_combinations
                 WHERE code_combination_id = mtrl.TO_ACCOUNT_ID)
         END
            cost_center
      /*--------------  Expense account and cost center-------------------*/
    FROM apps.mtl_txn_request_headers_v mthl,
         apps.mtl_txn_request_lines_v mtrl,
         apps.mtl_system_items_b msi,
         apps.mfg_lookups ml,
         (  SELECT mmt.organization_id,
                   mmt.inventory_item_id,
                   mmt.transaction_type_id,
                   mmt.move_order_line_id,
                   mmt.subinventory_code,
                   mmt.locator_id,
                   mmt.attribute1 taken_by,
                   mmt.transaction_source_id,
                   mmt.reason_id,
                   MAX (mmt.created_by) created_by,
                   (mmt.transaction_date) transaction_date,
                   SUM (ABS (mmt.primary_quantity)) qty_issued
              FROM apps.mtl_material_transactions mmt
             WHERE     mmt.primary_quantity < 0
                   AND mmt.organization_id = :P_ORG
                   AND mmt.transaction_source_type_id = 4
                   AND mmt.transaction_id IN (47281000)
          GROUP BY mmt.organization_id,
                   mmt.inventory_item_id,
                   mmt.transaction_type_id,
                   mmt.attribute1,
                   mmt.move_order_line_id,
                   mmt.subinventory_code,
                   mmt.locator_id,
                   mmt.transaction_source_id,
                   mmt.reason_id,
                   (mmt.transaction_date)) xx,
         (SELECT request_number,
                 attribute3 used_dept,
                 attribute4
                 || NVL (
                       apps.XXAKG_OPMINV_PKG.contractor (ATTRIBUTE_CATEGORY,
                                                         attribute1),
                       attribute1)
                    use_of_area
            FROM apps.mtl_txn_request_headers_v --where upper(attribute_category)='USE OF AREA'
                                               ) uses
   WHERE     mtrl.request_number = mthl.request_number
         AND mtrl.header_id = mthl.header_id
         AND mtrl.organization_id = mthl.organization_id
         AND mtrl.line_status = ml.lookup_code
         AND ml.lookup_type = 'MTL_TXN_REQUEST_STATUS'
         --AND UPPER(MTRL.TRANSACTION_TYPE_NAME)='MOVE ORDER ISSUE'
         AND mtrl.organization_id = NVL (:P_ORG, mtrl.organization_id)
         AND mtrl.request_number BETWEEN NVL (:P_MO, mtrl.request_number)
                                     AND  NVL (:p_lmo, mtrl.request_number)
         AND mtrl.transaction_source_type_id = 4
         AND mtrl.organization_id = xx.organization_id(+)
         AND mtrl.organization_id = msi.organization_id
         AND mtrl.inventory_item_id = xx.inventory_item_id(+)
         AND mtrl.inventory_item_id = msi.inventory_item_id
         --AND mtrl.inventory_item_id=24397
         AND mtrl.line_id = xx.move_order_line_id(+)
         AND mtrl.header_id = xx.transaction_source_id(+)
         AND mtrl.transaction_type_id = xx.transaction_type_id(+)
         AND mthl.request_number = uses.request_number(+)
ORDER BY xx.taken_by, mtrl.request_number, mtrl.line_number ASC