SELECT   mthl.request_number ,mthl.request_number move_order_number, trunc((mtrl.line_number-1)/7)+1 hpage_no,mtrl.line_id, mtrl.header_id,
         mtrl.organization_id, mtrl.inventory_item_id,
         (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3
         ) item_code,msi.attribute30,
         msi.description, mtrl.from_locator_id, mtrl.to_account_id,
         mtrl.transaction_header_id, mtrl.line_number, mtrl.revision,
         uses.transaction_type_name transaction_type, 
         mtrl.date_required,
         mtrl.uom_code, mtrl.quantity quantity_required,
         mtrl.quantity_delivered,uses.use_of_area, 
         (SELECT TO_CHAR(VM.EFFECTIVE_START_DATE) START_DATE FROM APPS.PQP_VEHICLE_REPOSITORY_F VM
         WHERE  VM.VEHICLE_STATUS = 'A'
          AND VM.VRE_ATTRIBUTE2 = 82
          AND TRUNC (SYSDATE) BETWEEN VM.EFFECTIVE_START_DATE          
          AND NVL (VM.EFFECTIVE_END_DATE, TRUNC (SYSDATE))
          AND VM.REGISTRATION_NUMBER= uses.use_of_area) START_DATE,
         (SELECT PAPF.EMPLOYEE_NUMBER||'-'||PAPF.FULL_NAME FROM APPS.PQP_VEHICLE_REPOSITORY_F VM,APPS.PER_ALL_PEOPLE_F PAPF
         WHERE  VM.VEHICLE_STATUS = 'A'
          AND VM.VRE_ATTRIBUTE2 = 82
          AND TRUNC (SYSDATE) BETWEEN VM.EFFECTIVE_START_DATE          
          AND NVL (VM.EFFECTIVE_END_DATE, TRUNC (SYSDATE))
          AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
          AND PAPF.PERSON_ID=VM.VRE_ATTRIBUTE19
          AND VM.REGISTRATION_NUMBER=uses.use_of_area) Driver_name,
         uses.used_dept, mtrl.grade_code,
         mtrl.from_subinventory_code, 
--         mtrl.lpn_number,
         mtrl.from_cost_group_id, mtrl.lot_number, mtrl.unit_number,
         mtrl.serial_number_start, mtrl.serial_number_end,
         mtrl.to_subinventory_code, mtrl.to_locator_id locatorr,
         mtrl.to_cost_group_id, mtrl.transaction_type_id, mtrl.REFERENCE||' ['||mtrl.lot_number||'] ' REFERENCE,
         mtrl.txn_source_id,
--         mthl.header_status_name, 
         mtrl.status_date, mtrl.line_status,
         ml.meaning status, mtrl.transaction_source_type_id,
         mtrl.txn_source_line_id, mtrl.txn_source_line_detail_id,
         mtrl.to_organization_id, mtrl.ship_to_location_id,xx.subinventory_code,xx.locator_id,
         xx.transaction_date, xx.qty_issued,xx.reason_id,mthl.created_by prepared_by,xx.created_by issued_by,xx.taken_by,
         APPS.XXAKG_OPMINV_PKG.personid_to_empid(xx.taken_by)||'-'||APPS.XXAKG_OPMINV_PKG.empnm_from_personid(xx.taken_by)TAKEN_BY_NAME,
         apps.xxakg_opminv_pkg.LAST_MO(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id)last_mo,
         apps.xxakg_opminv_pkg.LAST_MO_issue_qty(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id,
         apps.xxakg_opminv_pkg.LAST_MO(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id))last_mo_issue_qty,
         trunc(apps.xxakg_opminv_pkg.LAST_MO_dt(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id))last_mo_dt,
 CASE
            WHEN mthl.transaction_type_id = 64 and mtrl.from_subinventory_code=mthl.FROM_SUBINVENTORY_CODE
            THEN
               (SELECT distinct gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3
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
                       and xsrd.value_code_combination_id=gcc.code_combination_id
               )
            ELSE
              (select segment1||'.'||segment2||'.'||segment3
                 from gl.gl_code_combinations
                 where code_combination_id=mtrl.TO_ACCOUNT_ID) 
         END expanse_account,
 CASE
            WHEN mthl.transaction_type_id = 64 and mtrl.from_subinventory_code=mthl.FROM_SUBINVENTORY_CODE
            THEN
               (SELECT distinct  gcc.segment3
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
                       and xsrd.value_code_combination_id=gcc.code_combination_id)
            ELSE
                  (select segment3
               from gl.gl_code_combinations
                where code_combination_id=mtrl.TO_ACCOUNT_ID) 
         END  natural_account,
         mthl.ATTRIBUTE2 Expense_head
    FROM apps.mtl_txn_request_headers mthl,apps.mtl_txn_request_lines mtrl,
         apps.mtl_system_items_b msi,
         apps.mfg_lookups ml,
         (SELECT   mmt.organization_id, mmt.inventory_item_id,
                   mmt.transaction_type_id, mmt.move_order_line_id,mmt.subinventory_code,mmt.locator_id,mmt.attribute1 taken_by,
                   mmt.transaction_source_id, mmt.reason_id,max(mmt.created_by) created_by,
                   (mmt.transaction_date) transaction_date,
                   SUM (ABS (mmt.primary_quantity)) qty_issued
              FROM apps.mtl_material_transactions mmt
             WHERE mmt.primary_quantity < 0
               AND mmt.organization_id = :P_ORG
               AND mmt.transaction_source_type_id = 4
          GROUP BY mmt.organization_id,
                   mmt.inventory_item_id,
                   mmt.transaction_type_id,mmt.attribute1,
                   mmt.move_order_line_id,mmt.subinventory_code,mmt.locator_id,
                   mmt.transaction_source_id,
                   mmt.reason_id,
                  (mmt.transaction_date)) xx,
                   (select request_number,attribute3 used_dept,attribute4||nvl(apps.XXAKG_OPMINV_PKG.contractor(ATTRIBUTE_CATEGORY,attribute1),attribute1) use_of_area, transaction_type_name
from apps.mtl_txn_request_headers_v
--where upper(attribute_category)='USE OF AREA'
) uses
   WHERE  mtrl.header_id = mthl.header_id
     AND mtrl.organization_id = mthl.organization_id
     and mtrl.line_status = ml.lookup_code
     AND ml.lookup_type = 'MTL_TXN_REQUEST_STATUS'
     --AND UPPER(MTRL.TRANSACTION_TYPE_NAME)='MOVE ORDER ISSUE'
     AND mtrl.organization_id = NVL(:P_ORG,mtrl.organization_id)
     AND mthl.request_number between nvl(:P_MO,mthl.request_number) and nvl(:p_lmo,mthl.request_number)
     AND mtrl.transaction_source_type_id = 4
     AND mtrl.organization_id = xx.organization_id(+)
     AND mtrl.organization_id = msi.organization_id
     AND mtrl.inventory_item_id = xx.inventory_item_id(+)
     AND mtrl.inventory_item_id = msi.inventory_item_id
     --AND mtrl.inventory_item_id=24397
     AND mtrl.line_id = xx.move_order_line_id(+)
     AND mtrl.header_id = xx.transaction_source_id(+)
     AND mtrl.transaction_type_id = xx.transaction_type_id(+)
     and mthl.request_number=uses.request_number(+)
    ORDER BY xx.taken_by ,mthl.request_number,mtrl.line_number asc

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT   mthl.request_number ,mthl.request_number move_order_number, trunc((mtrl.line_number-1)/7)+1 hpage_no,mtrl.line_id, mtrl.header_id,
         mtrl.organization_id, mtrl.inventory_item_id,
         (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3
         ) item_code,msi.attribute30,
         msi.description, mtrl.from_locator_id, mtrl.to_account_id,
         mtrl.transaction_header_id, mtrl.line_number, mtrl.revision,
         uses.transaction_type_name transaction_type, 
         mtrl.date_required,
         mtrl.uom_code, mtrl.quantity quantity_required,
         mtrl.quantity_delivered,uses.use_of_area, 
         (SELECT PAPF.EMPLOYEE_NUMBER||'-'||PAPF.FULL_NAME FROM APPS.PQP_VEHICLE_REPOSITORY_F VM,APPS.PER_ALL_PEOPLE_F PAPF
         WHERE  VM.VEHICLE_STATUS = 'A'
          AND VM.VRE_ATTRIBUTE2 = 82
          AND TRUNC (SYSDATE) BETWEEN VM.EFFECTIVE_START_DATE          
          AND NVL (VM.EFFECTIVE_END_DATE, TRUNC (SYSDATE))
          AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
          AND PAPF.PERSON_ID=VM.VRE_ATTRIBUTE19
          AND VM.REGISTRATION_NUMBER=uses.use_of_area) Driver_name,
         uses.used_dept, mtrl.grade_code,
         mtrl.from_subinventory_code, 
--         mtrl.lpn_number,
         mtrl.from_cost_group_id, mtrl.lot_number, mtrl.unit_number,
         mtrl.serial_number_start, mtrl.serial_number_end,
         mtrl.to_subinventory_code, mtrl.to_locator_id locatorr,
         mtrl.to_cost_group_id, mtrl.transaction_type_id, mtrl.REFERENCE||' ['||mtrl.lot_number||'] ' REFERENCE,
         mtrl.txn_source_id,
--         mthl.header_status_name, 
         mtrl.status_date, mtrl.line_status,
         ml.meaning status, mtrl.transaction_source_type_id,
         mtrl.txn_source_line_id, mtrl.txn_source_line_detail_id,
         mtrl.to_organization_id, mtrl.ship_to_location_id,xx.subinventory_code,xx.locator_id,
         xx.transaction_date, xx.qty_issued,xx.reason_id,mthl.created_by prepared_by,xx.created_by issued_by,xx.taken_by,
         APPS.XXAKG_OPMINV_PKG.personid_to_empid(xx.taken_by)||'-'||APPS.XXAKG_OPMINV_PKG.empnm_from_personid(xx.taken_by)TAKEN_BY_NAME,
         apps.xxakg_opminv_pkg.LAST_MO(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id)last_mo,
         apps.xxakg_opminv_pkg.LAST_MO_issue_qty(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id,
         apps.xxakg_opminv_pkg.LAST_MO(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id))last_mo_issue_qty,
         trunc(apps.xxakg_opminv_pkg.LAST_MO_dt(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id))last_mo_dt,
 CASE
            WHEN mthl.transaction_type_id = 64 and mtrl.from_subinventory_code=mthl.FROM_SUBINVENTORY_CODE
            THEN
               (SELECT distinct gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3
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
                       and xsrd.value_code_combination_id=gcc.code_combination_id
               )
            ELSE
              (select segment1||'.'||segment2||'.'||segment3
                 from gl.gl_code_combinations
                 where code_combination_id=mtrl.TO_ACCOUNT_ID) 
         END expanse_account,
 CASE
            WHEN mthl.transaction_type_id = 64 and mtrl.from_subinventory_code=mthl.FROM_SUBINVENTORY_CODE
            THEN
               (SELECT distinct  gcc.segment3
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
                       and xsrd.value_code_combination_id=gcc.code_combination_id)
            ELSE
                  (select segment3
               from gl.gl_code_combinations
                where code_combination_id=mtrl.TO_ACCOUNT_ID) 
         END  natural_account,
         mthl.ATTRIBUTE2 Expense_head
    FROM apps.mtl_txn_request_headers mthl,apps.mtl_txn_request_lines mtrl,
         apps.mtl_system_items_b msi,
         apps.mfg_lookups ml,
         (SELECT   mmt.organization_id, mmt.inventory_item_id,
                   mmt.transaction_type_id, mmt.move_order_line_id,mmt.subinventory_code,mmt.locator_id,mmt.attribute1 taken_by,
                   mmt.transaction_source_id, mmt.reason_id,max(mmt.created_by) created_by,
                   (mmt.transaction_date) transaction_date,
                   SUM (ABS (mmt.primary_quantity)) qty_issued
              FROM apps.mtl_material_transactions mmt
             WHERE mmt.primary_quantity < 0
               AND mmt.organization_id = :P_ORG
               AND mmt.transaction_source_type_id = 4
          GROUP BY mmt.organization_id,
                   mmt.inventory_item_id,
                   mmt.transaction_type_id,mmt.attribute1,
                   mmt.move_order_line_id,mmt.subinventory_code,mmt.locator_id,
                   mmt.transaction_source_id,
                   mmt.reason_id,
                  (mmt.transaction_date)) xx,
                   (select request_number,attribute3 used_dept,attribute4||nvl(apps.XXAKG_OPMINV_PKG.contractor(ATTRIBUTE_CATEGORY,attribute1),attribute1) use_of_area, transaction_type_name
from apps.mtl_txn_request_headers_v
--where upper(attribute_category)='USE OF AREA'
) uses
   WHERE  mtrl.header_id = mthl.header_id
     AND mtrl.organization_id = mthl.organization_id
     and mtrl.line_status = ml.lookup_code
     AND ml.lookup_type = 'MTL_TXN_REQUEST_STATUS'
     --AND UPPER(MTRL.TRANSACTION_TYPE_NAME)='MOVE ORDER ISSUE'
     AND mtrl.organization_id = NVL(:P_ORG,mtrl.organization_id)
     AND mthl.request_number between nvl(:P_MO,mthl.request_number) and nvl(:p_lmo,mthl.request_number)
     AND mtrl.transaction_source_type_id = 4
     AND mtrl.organization_id = xx.organization_id(+)
     AND mtrl.organization_id = msi.organization_id
     AND mtrl.inventory_item_id = xx.inventory_item_id(+)
     AND mtrl.inventory_item_id = msi.inventory_item_id
     --AND mtrl.inventory_item_id=24397
     AND mtrl.line_id = xx.move_order_line_id(+)
     AND mtrl.header_id = xx.transaction_source_id(+)
     AND mtrl.transaction_type_id = xx.transaction_type_id(+)
     and mthl.request_number=uses.request_number(+)
    ORDER BY xx.taken_by ,mthl.request_number,mtrl.line_number asc

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT   mthl.request_number ,mthl.request_number move_order_number, trunc((mtrl.line_number-1)/7)+1 hpage_no,mtrl.line_id, mtrl.header_id,
         mtrl.organization_id, mtrl.inventory_item_id,
         (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3
         ) item_code,msi.attribute30,
         msi.description, mtrl.from_locator_id, mtrl.to_account_id,
         mtrl.transaction_header_id, mtrl.line_number, mtrl.revision,
         uses.transaction_type_name transaction_type, 
         mtrl.date_required,
         mtrl.uom_code, mtrl.quantity quantity_required,
         mtrl.quantity_delivered,uses.use_of_area, (select DRIVER_EMP_NUM||' - '||DRIVER_NAME   from  apps.XXAKG_DRIVER_DETAILS  where END_DATE is null and rownum=1 and REG_NUMBER=uses.use_of_area) Driver_name,
         uses.used_dept, mtrl.grade_code,
         mtrl.from_subinventory_code, 
--         mtrl.lpn_number,
         mtrl.from_cost_group_id, mtrl.lot_number, mtrl.unit_number,
         mtrl.serial_number_start, mtrl.serial_number_end,
         mtrl.to_subinventory_code, mtrl.to_locator_id locatorr,
         mtrl.to_cost_group_id, mtrl.transaction_type_id, mtrl.REFERENCE||' ['||mtrl.lot_number||'] ' REFERENCE,
         mtrl.txn_source_id,
--         mthl.header_status_name, 
         mtrl.status_date, mtrl.line_status,
         ml.meaning status, mtrl.transaction_source_type_id,
         mtrl.txn_source_line_id, mtrl.txn_source_line_detail_id,
         mtrl.to_organization_id, mtrl.ship_to_location_id,xx.subinventory_code,xx.locator_id,
         xx.transaction_date, xx.qty_issued,xx.reason_id,mthl.created_by prepared_by,xx.created_by issued_by,xx.taken_by,
         APPS.XXAKG_OPMINV_PKG.personid_to_empid(xx.taken_by)||'-'||APPS.XXAKG_OPMINV_PKG.empnm_from_personid(xx.taken_by)TAKEN_BY_NAME,
         apps.xxakg_opminv_pkg.LAST_MO(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id)last_mo,
         apps.xxakg_opminv_pkg.LAST_MO_issue_qty(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id,
         apps.xxakg_opminv_pkg.LAST_MO(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id))last_mo_issue_qty,
         trunc(apps.xxakg_opminv_pkg.LAST_MO_dt(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id))last_mo_dt,
 CASE
            WHEN mthl.transaction_type_id = 64 and mtrl.from_subinventory_code=mthl.FROM_SUBINVENTORY_CODE
            THEN
               (SELECT distinct gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3
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
                       and xsrd.value_code_combination_id=gcc.code_combination_id
               )
            ELSE
              (select segment1||'.'||segment2||'.'||segment3
                 from gl.gl_code_combinations
                 where code_combination_id=mtrl.TO_ACCOUNT_ID) 
         END expanse_account,
 CASE
            WHEN mthl.transaction_type_id = 64 and mtrl.from_subinventory_code=mthl.FROM_SUBINVENTORY_CODE
            THEN
               (SELECT distinct  gcc.segment3
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
                       and xsrd.value_code_combination_id=gcc.code_combination_id)
            ELSE
                  (select segment3
               from gl.gl_code_combinations
                where code_combination_id=mtrl.TO_ACCOUNT_ID) 
         END  natural_account,
         mthl.ATTRIBUTE2 Expense_head
    FROM apps.mtl_txn_request_headers mthl,apps.mtl_txn_request_lines mtrl,
         apps.mtl_system_items_b msi,
         apps.mfg_lookups ml,
         (SELECT   mmt.organization_id, mmt.inventory_item_id,
                   mmt.transaction_type_id, mmt.move_order_line_id,mmt.subinventory_code,mmt.locator_id,mmt.attribute1 taken_by,
                   mmt.transaction_source_id, mmt.reason_id,max(mmt.created_by) created_by,
                   (mmt.transaction_date) transaction_date,
                   SUM (ABS (mmt.primary_quantity)) qty_issued
              FROM apps.mtl_material_transactions mmt
             WHERE mmt.primary_quantity < 0
               AND mmt.organization_id = :P_ORG
               AND mmt.transaction_source_type_id = 4
          GROUP BY mmt.organization_id,
                   mmt.inventory_item_id,
                   mmt.transaction_type_id,mmt.attribute1,
                   mmt.move_order_line_id,mmt.subinventory_code,mmt.locator_id,
                   mmt.transaction_source_id,
                   mmt.reason_id,
                  (mmt.transaction_date)) xx,
                   (select request_number,attribute3 used_dept,attribute4||nvl(apps.XXAKG_OPMINV_PKG.contractor(ATTRIBUTE_CATEGORY,attribute1),attribute1) use_of_area, transaction_type_name
from apps.mtl_txn_request_headers_v
--where upper(attribute_category)='USE OF AREA'
) uses
   WHERE  mtrl.header_id = mthl.header_id
     AND mtrl.organization_id = mthl.organization_id
     and mtrl.line_status = ml.lookup_code
     AND ml.lookup_type = 'MTL_TXN_REQUEST_STATUS'
     --AND UPPER(MTRL.TRANSACTION_TYPE_NAME)='MOVE ORDER ISSUE'
     AND mtrl.organization_id = NVL(:P_ORG,mtrl.organization_id)
     AND mthl.request_number between nvl(:P_MO,mthl.request_number) and nvl(:p_lmo,mthl.request_number)
     AND mtrl.transaction_source_type_id = 4
     AND mtrl.organization_id = xx.organization_id(+)
     AND mtrl.organization_id = msi.organization_id
     AND mtrl.inventory_item_id = xx.inventory_item_id(+)
     AND mtrl.inventory_item_id = msi.inventory_item_id
     --AND mtrl.inventory_item_id=24397
     AND mtrl.line_id = xx.move_order_line_id(+)
     AND mtrl.header_id = xx.transaction_source_id(+)
     AND mtrl.transaction_type_id = xx.transaction_type_id(+)
     and mthl.request_number=uses.request_number(+)
    ORDER BY xx.taken_by ,mthl.request_number,mtrl.line_number asc
    
    
    
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------move_order_type_name--uses

SELECT   mthl.request_number ,mthl.request_number move_order_number, trunc((mtrl.line_number-1)/7)+1 hpage_no,mtrl.line_id, mtrl.header_id,
         mtrl.organization_id, mtrl.inventory_item_id,
         (msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3
         ) item_code,msi.attribute30,
         msi.description, mtrl.from_locator_id, mtrl.to_account_id,
         mtrl.transaction_header_id, mtrl.line_number, mtrl.revision,
--         mtrl.transaction_type_name transaction_type, 
         mtrl.date_required,
         mtrl.uom_code, mtrl.quantity quantity_required,
         mtrl.quantity_delivered,uses.use_of_area, (select DRIVER_EMP_NUM||' - '||DRIVER_NAME   from  apps.XXAKG_DRIVER_DETAILS  where END_DATE is null and rownum=1 and REG_NUMBER=uses.use_of_area) Driver_name,
         uses.used_dept, mtrl.grade_code,
         mtrl.from_subinventory_code, 
--         mtrl.lpn_number,
         mtrl.from_cost_group_id, mtrl.lot_number, mtrl.unit_number,
         mtrl.serial_number_start, mtrl.serial_number_end,
         mtrl.to_subinventory_code, mtrl.to_locator_id locatorr,
         mtrl.to_cost_group_id, mtrl.transaction_type_id, mtrl.REFERENCE||' ['||mtrl.lot_number||'] ' REFERENCE,
         mtrl.txn_source_id,
--         mthl.header_status_name, 
         mtrl.status_date, mtrl.line_status,
         ml.meaning status, mtrl.transaction_source_type_id,
         mtrl.txn_source_line_id, mtrl.txn_source_line_detail_id,
         mtrl.to_organization_id, mtrl.ship_to_location_id,xx.subinventory_code,xx.locator_id,
         xx.transaction_date, xx.qty_issued,xx.reason_id,mthl.created_by prepared_by,xx.created_by issued_by,xx.taken_by,
         APPS.XXAKG_OPMINV_PKG.personid_to_empid(xx.taken_by)||'-'||APPS.XXAKG_OPMINV_PKG.empnm_from_personid(xx.taken_by)TAKEN_BY_NAME,
         apps.xxakg_opminv_pkg.LAST_MO(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id)last_mo,
         apps.xxakg_opminv_pkg.LAST_MO_issue_qty(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id,
         apps.xxakg_opminv_pkg.LAST_MO(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id))last_mo_issue_qty,
         trunc(apps.xxakg_opminv_pkg.LAST_MO_dt(mtrl.organization_id,mtrl.status_date,uses.used_dept,mtrl.inventory_item_id))last_mo_dt,
 CASE
            WHEN mthl.transaction_type_id = 64 and mtrl.from_subinventory_code=mthl.FROM_SUBINVENTORY_CODE
            THEN
               (SELECT distinct gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3
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
                       and xsrd.value_code_combination_id=gcc.code_combination_id
               )
            ELSE
              (select segment1||'.'||segment2||'.'||segment3
                 from gl.gl_code_combinations
                 where code_combination_id=mtrl.TO_ACCOUNT_ID) 
         END expanse_account,
 CASE
            WHEN mthl.transaction_type_id = 64 and mtrl.from_subinventory_code=mthl.FROM_SUBINVENTORY_CODE
            THEN
               (SELECT distinct  gcc.segment3
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
                       and xsrd.value_code_combination_id=gcc.code_combination_id)
            ELSE
                  (select segment3
               from gl.gl_code_combinations
                where code_combination_id=mtrl.TO_ACCOUNT_ID) 
         END  natural_account,
         mthl.ATTRIBUTE2 Expense_head
    FROM apps.mtl_txn_request_headers mthl,apps.mtl_txn_request_lines mtrl,
         apps.mtl_system_items_b msi,
         apps.mfg_lookups ml,
         (SELECT   mmt.organization_id, mmt.inventory_item_id,
                   mmt.transaction_type_id, mmt.move_order_line_id,mmt.subinventory_code,mmt.locator_id,mmt.attribute1 taken_by,
                   mmt.transaction_source_id, mmt.reason_id,max(mmt.created_by) created_by,
                   (mmt.transaction_date) transaction_date,
                   SUM (ABS (mmt.primary_quantity)) qty_issued
              FROM apps.mtl_material_transactions mmt
             WHERE mmt.primary_quantity < 0
               AND mmt.organization_id = :P_ORG
               AND mmt.transaction_source_type_id = 4
          GROUP BY mmt.organization_id,
                   mmt.inventory_item_id,
                   mmt.transaction_type_id,mmt.attribute1,
                   mmt.move_order_line_id,mmt.subinventory_code,mmt.locator_id,
                   mmt.transaction_source_id,
                   mmt.reason_id,
                  (mmt.transaction_date)) xx,
                   (select request_number,attribute3 used_dept,attribute4||nvl(apps.XXAKG_OPMINV_PKG.contractor(ATTRIBUTE_CATEGORY,attribute1),attribute1) use_of_area
from apps.mtl_txn_request_headers_v
--where upper(attribute_category)='USE OF AREA'
) uses
   WHERE  mtrl.header_id = mthl.header_id
     AND mtrl.organization_id = mthl.organization_id
     and mtrl.line_status = ml.lookup_code
     AND ml.lookup_type = 'MTL_TXN_REQUEST_STATUS'
     --AND UPPER(MTRL.TRANSACTION_TYPE_NAME)='MOVE ORDER ISSUE'
     AND mtrl.organization_id = NVL(:P_ORG,mtrl.organization_id)
     AND mthl.request_number between nvl(:P_MO,mthl.request_number) and nvl(:p_lmo,mthl.request_number)
     AND mtrl.transaction_source_type_id = 4
     AND mtrl.organization_id = xx.organization_id(+)
     AND mtrl.organization_id = msi.organization_id
     AND mtrl.inventory_item_id = xx.inventory_item_id(+)
     AND mtrl.inventory_item_id = msi.inventory_item_id
     --AND mtrl.inventory_item_id=24397
     AND mtrl.line_id = xx.move_order_line_id(+)
     AND mtrl.header_id = xx.transaction_source_id(+)
     AND mtrl.transaction_type_id = xx.transaction_type_id(+)
     and mthl.request_number=uses.request_number(+)
    ORDER BY xx.taken_by ,mthl.request_number,mtrl.line_number asc