---------- INV Source ---------------
SELECT mtl.TRANSACTION_ID,
       gcc.code_combination_id combination_id,
       itm.organization_id,
       'INV' TYPE,
       xlh.accounting_date,
       gcc.code_combination_id,
       gcc.segment1 company,
       gcc.segment2 cost_center,
       gcc.segment3 account,
       prj.project_id project_id,
       pjt.task_number || ' (' || pjt.task_name || ' )' task,
       mtl.expenditure_type,
       DECODE (NVL (mtl.pm_cost_collected, 'Y'), 'Y', 'YES', 'N', 'NO', 'NA'),
       mta.base_transaction_value amount,
       TO_CHAR (NVL (moh.request_number, mtl.transaction_source_id))
          txn_src_num,
       typ.transaction_type_name txn_type,
       NULL,
       sup.vendor_id,
       NULL,
       NULL,
       itm.organization_id,
       itm.inventory_item_id,
       TO_CHAR (mtl.primary_quantity),
       NULL,
       TO_CHAR (mta.transaction_id),
       TO_CHAR (mta.inv_sub_ledger_id),
       NULL,
       mtl.last_updated_by,
       mtl.last_update_date,
       mtl.creation_date,
       mtl.created_by
  FROM gl.gl_ledgers led,
       xla.xla_ae_headers xlh,
       xla.xla_ae_lines xll,
       xla.xla_transaction_entities xte,
       xla.xla_distribution_links xdl,
       apps.fnd_application pn,
       apps.fnd_application_tl pn1,
       apps.fnd_application_tl pnl,
       inv.mtl_transaction_accounts mta,
       inv.mtl_material_transactions mtl,
       inv.mtl_txn_request_headers moh,
       apps.ap_suppliers sup,
       apps.gl_code_combinations_kfv gcc,
       apps.mtl_system_items_b_kfv itm,
       inv.mtl_parameters mp,
       inv.mtl_txn_source_types styp,
       inv.mtl_transaction_types typ,
       pa.pa_projects_all prj,
       pa.pa_tasks pjt,
       (SELECT 'CONTRACTOR' TYPE FROM DUAL
        UNION
        SELECT 'WORKSHOP' FROM DUAL
        UNION
        SELECT 'CONSTRUCTION MATERIAL' FROM DUAL
        UNION
        SELECT 'SUB-CONTRACTORS' FROM DUAL
        UNION
        SELECT 'OTHERS' FROM DUAL) tp,
       apps.hr_operating_units hou
 WHERE     1 = 1
       AND xlh.ledger_id = led.ledger_id
       AND xlh.entity_id = xte.entity_id
       AND xte.source_application_id = pn.application_id
       AND xlh.application_id = pn1.application_id
       AND xlh.ae_header_id = xll.ae_header_id
       AND xll.ae_header_id = xdl.ae_header_id
       AND xll.ae_line_num = xdl.ae_line_num
       AND xlh.event_id = xdl.event_id
       AND pn.application_id = pnl.application_id
       AND xll.code_combination_id = gcc.code_combination_id
       AND mta.transaction_id = mtl.transaction_id
       AND mtl.organization_id = itm.organization_id
       AND mtl.inventory_item_id = itm.inventory_item_id
       AND mtl.organization_id = mp.organization_id
       AND mtl.transaction_source_type_id = styp.transaction_source_type_id
       AND mtl.transaction_type_id = typ.transaction_type_id
       AND DECODE (mtl.transaction_source_type_id,
                   4, mtl.transaction_source_id,
                   -99999) = moh.header_id(+)
       AND DECODE (
             moh.attribute_category,
             'Contractor List',
             CASE
                WHEN UPPER (moh.attribute1) = LOWER (moh.attribute1)
                THEN
                   TO_NUMBER (moh.attribute1)
                ELSE
                   0
             END,
             'Project Contractor List',
             moh.attribute1) = sup.vendor_id(+)
       AND sup.vendor_type_lookup_code = tp.TYPE(+)
       AND mtl.source_project_id = pjt.project_id
       AND mtl.source_task_id = pjt.task_id
       AND pjt.project_id = prj.project_id
       AND prj.org_id = hou.organization_id
       AND mta.accounting_line_type = 2
       AND mtl.source_project_id IS NOT NULL
       AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
       AND xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id(+)
       AND xlh.gl_transfer_status_code = 'Y'
       AND xlh.balance_type_code = 'A'

    

----------- INV1 Source ------------------------
    
SELECT mtl.transaction_id,
       gcc.code_combination_id,
       itm.organization_id,
       'INV1' TYPE,
       xlh.accounting_date,
       gcc.code_combination_id,
       gcc.segment1 company,
       gcc.segment2 cost_center,
       gcc.segment3 account,
       NULL project_id,
       NULL task,
       mtl.expenditure_type,
       'NA',
       mta.base_transaction_value amount,
       TO_CHAR (NVL (moh.request_number, mtl.transaction_source_id))
          txn_src_num,
       typ.transaction_type_name txn_type,
       NULL,
       sup.vendor_id,
       NULL,
       NULL,
       itm.organization_id,
       itm.inventory_item_id,
       TO_CHAR (mtl.primary_quantity),
       NULL,
       TO_CHAR (mta.transaction_id),
       TO_CHAR (mta.inv_sub_ledger_id),
       NULL,
       mtl.last_updated_by,
       mtl.last_update_date,
       mtl.creation_date,
       mtl.created_by
  FROM gl.gl_ledgers led,
       xla.xla_ae_headers xlh,
       xla.xla_ae_lines xll,
       xla.xla_transaction_entities xte,
       xla.xla_distribution_links xdl,
       apps.fnd_application pn,
       apps.fnd_application_tl pn1,
       apps.fnd_application_tl pnl,
       inv.mtl_transaction_accounts mta,
       inv.mtl_material_transactions mtl,
       inv.mtl_txn_request_headers moh,
       apps.ap_suppliers sup,
       apps.gl_code_combinations_kfv gcc,
       apps.mtl_system_items_b_kfv itm,
       inv.mtl_parameters mp,
       inv.mtl_txn_source_types styp,
       inv.mtl_transaction_types typ,
       (SELECT 'CONTRACTOR' TYPE FROM DUAL
        UNION
        SELECT 'WORKSHOP' FROM DUAL
        UNION
        SELECT 'CONSTRUCTION MATERIAL' FROM DUAL
        UNION
        SELECT 'SUB-CONTRACTORS' FROM DUAL
        UNION
        SELECT 'OTHERS' FROM DUAL) tp
 WHERE     1 = 1
       AND xlh.ledger_id = led.ledger_id
       AND xlh.entity_id = xte.entity_id
       AND xte.source_application_id = pn.application_id
       AND xlh.application_id = pn1.application_id
       AND xlh.ae_header_id = xll.ae_header_id
       AND xll.ae_header_id = xdl.ae_header_id
       AND xll.ae_line_num = xdl.ae_line_num
       AND xlh.event_id = xdl.event_id
       AND pn.application_id = pnl.application_id
       AND xll.code_combination_id = gcc.code_combination_id
       AND mta.transaction_id = mtl.transaction_id
       AND mtl.organization_id = itm.organization_id
       AND mtl.inventory_item_id = itm.inventory_item_id
       AND mtl.organization_id = mp.organization_id
       AND mtl.transaction_source_type_id = styp.transaction_source_type_id
       AND mtl.transaction_type_id = typ.transaction_type_id
       AND DECODE (mtl.transaction_source_type_id,
                   4, mtl.transaction_source_id,
                   -99999) = moh.header_id(+)
       AND DECODE (
             moh.attribute_category,
             'Contractor List',
             CASE
                WHEN UPPER (moh.attribute1) = LOWER (moh.attribute1)
                THEN
                   TO_NUMBER (moh.attribute1)
                ELSE
                   0
             END,
             'Project Contractor List',
             moh.attribute1) = sup.vendor_id(+)
       AND sup.vendor_type_lookup_code = tp.TYPE(+)
       AND mtl.source_project_id IS NULL
       AND mta.accounting_line_type = 2
       AND xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
       AND xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id(+)
       AND xlh.gl_transfer_status_code = 'Y'
       AND xlh.balance_type_code = 'A'
       AND gcc.segment3 IN (2030101, 2030102, 2030103)
       and gcc.segment1 in ('1220')
--       and rownum<10    