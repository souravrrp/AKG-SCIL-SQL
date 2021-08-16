/* Formatted on 7/22/2014 1:24:45 PM (QP5 v5.136.908.31019) */
  SELECT geh.source_document_id batch_id,
         bh.batch_no,
         bh.organization_id,
         al.accounting_class_code,
         geh.valuation_cost_type,
         geh.valuation_cost_type_id,
         SUM (NVL (al.accounted_dr, 0)),
         SUM (NVL (al.accounted_cr, 0)),
         SUM (NVL (al.accounted_dr, 0) - NVL (al.accounted_cr, 0))
            remaining_wip_amt
    FROM apps.xla_ae_headers ah,
         apps.xla_ae_lines al,
         apps.gmf_xla_extract_headers geh,
         apps.gmf_fiscal_policies gfp,
         apps.gme_batch_header bh
   WHERE     ah.event_id = geh.event_id
         AND ah.application_id = 555
         AND al.ae_header_id = ah.ae_header_id
         AND al.accounting_class_code = 'CLS'
         AND gfp.legal_entity_id = geh.legal_entity_id
         AND geh.valuation_cost_type_id = gfp.cost_type_id
         AND geh.entity_code = 'PRODUCTION'
         AND geh.source_document_id = bh.batch_id
         AND ah.period_name LIKE 'JAN%15'
         AND geh.legal_entity_id = 24273
--AND bh.organization_id = 93
GROUP BY geh.source_document_id,
         al.accounting_class_code,
         geh.valuation_cost_type_id,
         bh.batch_no,
         bh.organization_id,
         geh.valuation_cost_type
--HAVING ABS (SUM (NVL (al.accounted_dr, 0))) - abs(sum(NVL (al.accounted_cr, 0))) > 5
ORDER BY 1
