/* Formatted on 4/26/2015 11:43:06 AM (QP5 v5.136.908.31019) */
SELECT glh.je_header_id je_header_id,
       gll.je_line_num je_line_num,
       1 organization_id,
       'GL' source,
       gll.effective_date accounting_date,
       gcc.code_combination_id,
       gcc.segment1 company,
       gcc.segment2 cost_center,
       gcc.segment3 account,
       NULL project_id,
       NULL task,
       NULL expenditure_type,
       'NA' transfer_to_project,
       NVL (gll.accounted_dr, accounted_cr * -1) amount,
       NULL voucher_number,
       NULL GRN_number,
       NULL Distribution_line_number,
       NULL vendor_id,
       NULL invoice_number,
       NULL accounting_class_code,
       NULL inventory_organization_id,
       NULL inventory_item_id,
       NULL primary_quantity,
       NULL destination_type_code,
       NULL rcv_sub_ledger_id,
       gll.description transaction_description,
       NULL vendor_site_id,
       glh.last_updated_by,
       glh.last_update_date,
       glh.creation_date,
       glh.created_by
  FROM gl.gl_ledgers led,
       gl.gl_je_headers glh,
       gl.gl_je_lines gll,
       apps.gl_code_combinations_kfv gcc
 WHERE     1 = 1
       AND glh.ledger_id = led.ledger_id
       AND glh.je_header_id = gll.je_header_id
       AND gll.code_combination_id = gcc.code_combination_id
       AND glh.je_from_sla_flag IS NULL
       AND glh.actual_flag = 'A'
       AND gcc.segment3 IN (2030101, 2030102, 2030103)
UNION ALL
SELECT aid.invoice_id,
       aid.invoice_distribution_id,
       hou.ORGANIZATION_ID,
       'AP' source,
       xlh.accounting_date,
       gcc.code_combination_id,
       gcc.segment1 company,
       gcc.segment2 cost_center,
       gcc.segment3 account,
       prj.PROJECT_ID project_id,
       pjt.task_number || ' (' || pjt.task_name || ' )' task,
       aid.expenditure_type,
       DECODE (aid.pa_addition_flag, 'Y', 'YES', 'N', 'NO', 'NA'),
       NVL (xdl.unrounded_accounted_dr, xdl.unrounded_accounted_cr * -1)
          amount,
       TO_CHAR (ai.doc_sequence_value),
       TO_CHAR (aid.invoice_line_number),
       TO_CHAR (aid.distribution_line_number),
       ai.VENDOR_ID,
       ai.invoice_num,
       xll.accounting_class_code,
       NULL ref7,
       NULL ref8,
       NULL ref9,
       NULL ref10,
       NULL ref11,
       NULL,
       ai.vendor_site_id,
       ai.last_updated_by,
       ai.last_update_date,
       ai.creation_date,
       ai.created_by
  FROM gl.gl_ledgers led,
       xla.xla_ae_headers xlh,
       xla.xla_ae_lines xll,
       xla.xla_transaction_entities xte,
       xla.xla_distribution_links xdl,
       apps.fnd_application pn,
       apps.fnd_application_tl pn1,
       apps.fnd_application_tl pnl,
       ap.ap_invoices_all ai,
       ap.ap_invoice_lines_all ail,
       ap.ap_invoice_distributions_all aid,
       pa.pa_projects_all prj,
       pa.pa_tasks pjt,
       apps.gl_code_combinations_kfv gcc,
       ar.hz_parties hzp,
       ar.hz_party_sites hzps,
       ap.ap_suppliers as1,
       apps.ap_lookup_codes alc,
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
       AND ai.invoice_id = ail.invoice_id
       AND ail.invoice_id = aid.invoice_id
       AND ail.line_number = aid.invoice_line_number
       AND ai.vendor_id = as1.vendor_id(+)
       AND ai.party_id = hzp.party_id
       AND ai.party_site_id = hzps.party_site_id(+)
       AND ( (as1.employee_id IS NULL AND hzps.party_site_id IS NOT NULL)
            OR (as1.employee_id IS NOT NULL))
       AND alc.lookup_type(+) = 'INVOICE PAYMENT STATUS'
       AND alc.lookup_code(+) = ai.payment_status_flag
       AND aid.project_id = pjt.project_id
       AND aid.task_id = pjt.task_id
       AND pjt.project_id = prj.project_id
       AND prj.org_id = hou.organization_id
       AND aid.project_id IS NOT NULL
       AND xdl.source_distribution_type = 'AP_INV_DIST'
       AND xdl.source_distribution_id_num_1 = aid.invoice_distribution_id
       --          AND xdl.accounting_line_code != 'AP_LIAB_INV_AOS_BS'
       AND xll.accounting_class_code != 'LIABILITY'
       AND xlh.gl_transfer_status_code = 'Y'
       AND xlh.balance_type_code = 'A'
UNION ALL
SELECT aid.invoice_id,
       aid.invoice_distribution_id,
       aid.org_id,
       'AP1' source,
       xlh.accounting_date,
       gcc.code_combination_id,
       gcc.segment1 company,
       gcc.segment2 cost_center,
       gcc.segment3 account,
       aid.PROJECT_ID project_id,
       NULL task,
       aid.expenditure_type,
       'NA',
       NVL (xdl.unrounded_accounted_dr, xdl.unrounded_accounted_cr * -1)
          amount,
       TO_CHAR (ai.doc_sequence_value),
       TO_CHAR (aid.invoice_line_number),
       TO_CHAR (aid.distribution_line_number),
       ai.vendor_id,
       ai.invoice_num,
       xll.accounting_class_code,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       ai.vendor_site_id,
       ai.last_updated_by,
       ai.last_update_date,
       ai.creation_date,
       ai.created_by
  FROM gl.gl_ledgers led,
       xla.xla_ae_headers xlh,
       xla.xla_ae_lines xll,
       xla.xla_transaction_entities xte,
       xla.xla_distribution_links xdl,
       apps.fnd_application pn,
       apps.fnd_application_tl pn1,
       apps.fnd_application_tl pnl,
       ap.ap_invoices_all ai,
       ap.ap_invoice_lines_all ail,
       ap.ap_invoice_distributions_all aid,
       apps.gl_code_combinations_kfv gcc,
       ar.hz_parties hzp,
       ar.hz_party_sites hzps,
       ap.ap_suppliers as1,
       apps.ap_lookup_codes alc
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
       AND ai.invoice_id = ail.invoice_id
       AND ail.invoice_id = aid.invoice_id
       AND ail.line_number = aid.invoice_line_number
       AND ai.vendor_id = as1.vendor_id(+)
       AND ai.party_id = hzp.party_id
       AND ai.party_site_id = hzps.party_site_id(+)
       AND ( (as1.employee_id IS NULL AND hzps.party_site_id IS NOT NULL)
            OR (as1.employee_id IS NOT NULL))
       AND alc.lookup_type(+) = 'INVOICE PAYMENT STATUS'
       AND alc.lookup_code(+) = ai.payment_status_flag
       AND aid.project_id IS NULL
       AND xdl.source_distribution_type = 'AP_INV_DIST'
       AND xdl.source_distribution_id_num_1 = aid.invoice_distribution_id
       AND xlh.gl_transfer_status_code = 'Y'
       AND xlh.balance_type_code = 'A'
       AND gcc.segment3 IN (2030101, 2030102, 2030103)
UNION ALL
SELECT a2.transaction_id,
       GCC.code_combination_id,
       a4.SHIP_TO_ORG_ID,
       'RCV' TYPE,
       TRUNC (xlh.accounting_date) txn_date,
       gcc.code_combination_id,
       gcc.segment1,
       gcc.segment2,
       gcc.segment3,
       prj.project_id project_id,
       pjt.task_number || ' (' || pjt.task_name || ' )' task,
       pod.expenditure_type,
       DECODE (a1.pa_addition_flag, 'Y', 'YES', 'N', 'NO', 'NA'),
       NVL (xdl.unrounded_accounted_dr, xdl.unrounded_accounted_cr * -1)
          amount,
       a4.receipt_num grn_num,
       a1.reference4 po_num,
       NULL,
       a4.vendor_id,
       NULL,
       NULL,
       itm.organization_id,
       itm.inventory_item_id,
       TO_CHAR (a2.primary_quantity),
       a2.destination_type_code,
       TO_CHAR (a1.rcv_sub_ledger_id),
       TO_CHAR (a2.transaction_id),
       a4.vendor_site_id,
       a4.last_updated_by,
       a4.last_update_date,
       a4.creation_date,
       a4.created_by
  FROM gl.gl_ledgers led,
       xla.xla_ae_headers xlh,
       xla.xla_ae_lines xll,
       xla.xla_transaction_entities xte,
       xla.xla_distribution_links xdl,
       apps.fnd_application pn,
       apps.fnd_application_tl pn1,
       apps.fnd_application_tl pnl,
       po.rcv_receiving_sub_ledger a1,
       po.rcv_transactions a2,
       po.po_distributions_all pod,
       po.rcv_shipment_lines a3,
       po.rcv_shipment_headers a4,
       apps.mtl_system_items_b_kfv itm,
       apps.gl_code_combinations_kfv gcc,
       pa.pa_projects_all prj,
       pa.pa_tasks pjt,
       inv.mtl_parameters mp,
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
       AND a1.rcv_transaction_id = a2.transaction_id
       AND a1.reference3 = pod.po_distribution_id
       AND a2.shipment_header_id = a3.shipment_header_id
       AND a2.shipment_line_id = a3.shipment_line_id
       AND a3.shipment_header_id = a4.shipment_header_id
       AND a3.item_id = itm.inventory_item_id(+)
       AND a3.to_organization_id = itm.organization_id(+)
       AND itm.organization_id = mp.organization_id(+)
       AND pod.project_id = pjt.project_id
       AND pod.task_id = pjt.task_id
       AND pjt.project_id = prj.project_id
       AND prj.org_id = hou.organization_id
       AND pod.project_id IS NOT NULL
       AND a2.transaction_type != 'TRANSFER'
       AND xdl.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
       AND xdl.source_distribution_id_num_1 = a1.rcv_sub_ledger_id
       AND xlh.gl_transfer_status_code = 'Y'
       AND xlh.balance_type_code = 'A'
UNION ALL
SELECT a2.transaction_id,
       GCC.code_combination_id,
       a4.SHIP_TO_ORG_ID,
       'RCV1' TYPE,
       TRUNC (xlh.accounting_date) txn_date,
       gcc.code_combination_id,
       gcc.segment1,
       gcc.segment2,
       gcc.segment3,
       NULL project_id,
       NULL task,
       pod.expenditure_type,
       'NA',
       NVL (xdl.unrounded_accounted_dr, xdl.unrounded_accounted_cr * -1)
          amount,
       a4.receipt_num grn_num,
       a1.reference4 po_num,
       NULL,
       a4.vendor_id,
       NULL,
       NULL,
       itm.organization_id,
       itm.inventory_item_id,
       TO_CHAR (a2.primary_quantity),
       a2.destination_type_code,
       TO_CHAR (a1.rcv_sub_ledger_id),
       TO_CHAR (a2.transaction_id),
       a4.vendor_site_id,
       a4.last_updated_by,
       a4.last_update_date,
       a4.creation_date,
       a4.created_by
  FROM gl.gl_ledgers led,
       xla.xla_ae_headers xlh,
       xla.xla_ae_lines xll,
       xla.xla_transaction_entities xte,
       xla.xla_distribution_links xdl,
       apps.fnd_application pn,
       apps.fnd_application_tl pn1,
       apps.fnd_application_tl pnl,
       po.rcv_receiving_sub_ledger a1,
       po.rcv_transactions a2,
       po.po_distributions_all pod,
       po.rcv_shipment_lines a3,
       po.rcv_shipment_headers a4,
       apps.mtl_system_items_b_kfv itm,
       apps.gl_code_combinations_kfv gcc,
       inv.mtl_parameters mp
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
       AND a1.rcv_transaction_id = a2.transaction_id
       AND a1.reference3 = pod.po_distribution_id
       AND a2.shipment_header_id = a3.shipment_header_id
       AND a2.shipment_line_id = a3.shipment_line_id
       AND a3.shipment_header_id = a4.shipment_header_id
       AND a3.item_id = itm.inventory_item_id(+)
       AND a3.to_organization_id = itm.organization_id(+)
       AND itm.organization_id = mp.organization_id(+)
       AND pod.project_id IS NULL
       AND a2.transaction_type != 'TRANSFER'
       AND xdl.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
       AND xdl.source_distribution_id_num_1 = a1.rcv_sub_ledger_id
       AND xlh.gl_transfer_status_code = 'Y'
       AND xlh.balance_type_code = 'A'
       AND gcc.segment3 IN (2030101, 2030102, 2030103)
UNION ALL
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
UNION ALL
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
UNION ALL
  SELECT mmt.transaction_id,
         gcc.code_combination_id combination_id,
         item.organization_id organization_id,
         'OPM' source,
         xlh.accounting_date,
         gcc.code_combination_id,
         gcc.segment1 company,
         gcc.segment2 cost_center,
         gcc.segment3 account,
         NULL project_id,
         NULL task,
         mmt.expenditure_type,
         'NA',
         SUM (NVL (xll.accounted_dr, accounted_cr * -1)) amount,
         TO_CHAR (NVL (moh.request_number, mmt.transaction_source_id))
            txn_src_num,
         typ.transaction_type_name txn_type,
         TO_CHAR (mmt.transaction_id),
         sup.vendor_id,
         NULL,
         NULL,
         item.organization_id,
         item.inventory_item_id,
         TO_CHAR (mmt.primary_quantity),
         NULL,
         NULL,
         NULL,
         NULL,
         mmt.last_updated_by,
         mmt.last_update_date,
         mmt.creation_date,
         mmt.created_by
    FROM xla.xla_ae_headers xlh,
         xla.xla_ae_lines xll,
         xla.xla_transaction_entities xte,
         apps.fnd_application pn,
         apps.fnd_application_tl pn1,
         apps.fnd_application_tl pnl,
         inv.mtl_parameters mp,
         apps.mtl_system_items_b_kfv item,
         inv.mtl_transaction_types mtt,
         inv.mtl_txn_request_headers moh,
         apps.ap_suppliers sup,
         inv.mtl_txn_source_types styp,
         inv.mtl_transaction_types typ,
         inv.mtl_transaction_reasons mtr,
         inv.mtl_material_transactions mmt,
         gmf.gmf_xla_extract_headers eh,
         gl.gl_ledgers led,
         apps.gl_code_combinations_kfv gcc,
         (  SELECT 'CONTRACTOR' TYPE FROM DUAL
          UNION
            SELECT 'WORKSHOP' FROM DUAL
          UNION
            SELECT 'CONSTRUCTION MATERIAL' FROM DUAL
          UNION
            SELECT 'SUB-CONTRACTORS' FROM DUAL
          UNION
            SELECT 'OTHERS' FROM DUAL) tp
   WHERE     1 = 1
         AND xlh.entity_id = xte.entity_id
         AND xte.source_application_id = pn.application_id
         AND xlh.application_id = pn1.application_id
         AND xlh.ae_header_id = xll.ae_header_id
         AND pn.application_id = pnl.application_id
         AND xll.code_combination_id = gcc.code_combination_id
         AND mmt.reason_id = mtr.reason_id(+)
         AND mmt.transaction_type_id = mtt.transaction_type_id
         AND mmt.transaction_source_type_id = styp.transaction_source_type_id
         AND mmt.transaction_type_id = typ.transaction_type_id
         AND eh.organization_id = item.organization_id
         AND eh.inventory_item_id = item.inventory_item_id
         AND eh.organization_id = mp.organization_id
         AND eh.transaction_id = mmt.transaction_id
         AND led.ledger_id = eh.ledger_id
         AND DECODE (mmt.transaction_source_type_id,
                     4, mmt.transaction_source_id,
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
         AND mmt.source_project_id IS NULL
         AND xte.entity_code = 'INVENTORY'
         AND xte.source_id_int_1 = mmt.transaction_id
         AND xlh.gl_transfer_status_code = 'Y'
         AND xlh.balance_type_code = 'A'
         AND gcc.segment3 IN (2030101, 2030102, 2030103)
GROUP BY mmt.transaction_id,
         gcc.code_combination_id,
         item.organization_id,
         'OPM',
         xlh.accounting_date,
         gcc.code_combination_id,
         gcc.segment1,
         gcc.segment2,
         gcc.segment3,
         mmt.expenditure_type,
         'NA',
         TO_CHAR (NVL (moh.request_number, mmt.transaction_source_id)),
         typ.transaction_type_name,
         TO_CHAR (mmt.transaction_id),
         sup.vendor_id,
         item.organization_id,
         item.inventory_item_id,
         TO_CHAR (mmt.primary_quantity),
         mmt.last_updated_by,
         mmt.last_update_date,
         mmt.creation_date,
         mmt.created_by
UNION ALL
SELECT fav.TRANSACTION_HEADER_ID transaction_id,
       gcc.code_combination_id combination_id,
       3 organization_id,
       'FA' source,
       TRUNC (xll.accounting_date) accounting_date,
       gcc.code_combination_id,
       gcc.segment1 company,
       gcc.segment2 cost_center,
       gcc.segment3 account,
       prj.project_id project_id,
       NULL task,
       NULL expenditure_type,
       'YES',
       NVL (xll.accounted_dr, accounted_cr * -1) amount,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       fad.description,
       NULL,
       fiv.last_updated_by,
       fiv.last_update_date,
       fiv.creation_date,
       fiv.created_by
  FROM xla.xla_ae_headers xlh,
       xla.xla_ae_lines xll,
       xla.xla_distribution_links xdl,
       xla.xla_transaction_entities xte,
       xla.xla_events xev,
       gl.gl_ledgers led,
       apps.fnd_application pn,
       apps.fnd_application_tl pn1,
       apps.fnd_application_tl pnl,
       apps.gl_code_combinations_kfv gcc,
       fa.fa_transaction_headers fav,
       fa.fa_additions_tl fad,
       fa.fa_asset_invoices fiv,
       pa.pa_projects_all prj,
       pa.pa_project_asset_lines_all prjs,
       apps.hr_operating_units hou
 WHERE     1 = 1
       AND xlh.ledger_id = led.ledger_id
       AND xlh.entity_id = xte.entity_id
       AND xte.entity_id = xev.entity_id
       AND xlh.application_id = xev.application_id
       AND xte.source_application_id = pn.application_id
       AND xlh.application_id = pn1.application_id
       AND xlh.ae_header_id = xll.ae_header_id
       AND xll.ae_header_id = xdl.ae_header_id
       AND xll.ae_line_num = xdl.ae_line_num
       AND xlh.event_id = xdl.event_id
       AND pn.application_id = pnl.application_id
       AND xll.code_combination_id = gcc.code_combination_id
       AND xlh.gl_transfer_status_code = 'Y'
       AND xlh.balance_type_code = 'A'
       AND xte.source_id_int_1 = fav.transaction_header_id
       AND xte.source_id_char_1 = fav.book_type_code
       AND fav.asset_id = fad.asset_id
       AND fav.invoice_transaction_id = fiv.invoice_transaction_id_in
       AND fiv.project_id = prjs.project_id
       AND fiv.project_asset_line_id = prjs.project_asset_line_id
       AND prjs.project_id = prj.project_id
       AND prj.org_id = hou.organization_id
       AND pnl.application_name = 'Assets'
       AND fav.transaction_type_code = 'ADDITION'
       AND fiv.split_merged_code = 'MP'
UNION ALL
SELECT fav.TRANSACTION_HEADER_ID transaction_id,
       gcc.code_combination_id combination_id,
       4 organization_id,
       'FA1' source,
       TRUNC (xll.accounting_date) accounting_date,
       gcc.code_combination_id,
       gcc.segment1 company,
       gcc.segment2 cost_center,
       gcc.segment3 account,
       NULL project_id,
       NULL task,
       NULL expenditure_type,
       'NA',
       NVL (xll.accounted_dr, accounted_cr * -1) amount,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       fad.description,
       NULL,
       fiv.last_updated_by,
       fiv.last_update_date,
       fiv.creation_date,
       fiv.created_by
  FROM xla.xla_ae_headers xlh,
       xla.xla_ae_lines xll,
       xla.xla_distribution_links xdl,
       xla.xla_transaction_entities xte,
       xla.xla_events xev,
       gl.gl_ledgers led,
       apps.fnd_application pn,
       apps.fnd_application_tl pn1,
       apps.fnd_application_tl pnl,
       apps.gl_code_combinations_kfv gcc,
       fa.fa_transaction_headers fav,
       fa.fa_additions_tl fad,
       fa.fa_asset_invoices fiv
 WHERE     1 = 1
       AND xlh.ledger_id = led.ledger_id
       AND xlh.entity_id = xte.entity_id
       AND xte.entity_id = xev.entity_id
       AND xlh.application_id = xev.application_id
       AND xte.source_application_id = pn.application_id
       AND xlh.application_id = pn1.application_id
       AND xlh.ae_header_id = xll.ae_header_id
       AND xll.ae_header_id = xdl.ae_header_id
       AND xll.ae_line_num = xdl.ae_line_num
       AND xlh.event_id = xdl.event_id
       AND pn.application_id = pnl.application_id
       AND xll.code_combination_id = gcc.code_combination_id
       AND xlh.gl_transfer_status_code = 'Y'
       AND xlh.balance_type_code = 'A'
       AND xte.source_id_int_1 = fav.transaction_header_id
       AND xte.source_id_char_1 = fav.book_type_code
       AND fav.asset_id = fad.asset_id
       AND fav.invoice_transaction_id = fiv.invoice_transaction_id_in
       AND fiv.project_id IS NULL
       AND gcc.segment3 IN (2030101, 2030102, 2030103)
       AND pnl.application_name = 'Assets'
       AND fav.transaction_type_code = 'ADDITION'