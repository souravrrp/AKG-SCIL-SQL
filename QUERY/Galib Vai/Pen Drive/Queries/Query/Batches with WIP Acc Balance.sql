/* Formatted on 7/15/2013 1:40:30 PM (QP5 v5.163.1008.3004) */
  SELECT geh.source_document_id batch_id,
         bh.batch_no,
         bh.organization_id,
         gcc.segment1|| '.'|| gcc.segment2|| '.'|| gcc.segment3|| '.'|| gcc.segment4|| '.'|| gcc.segment5 AS Account,
         SUM (NVL (al.accounted_dr, 0)) dr,
         SUM (NVL (al.accounted_cr, 0)) cr,
         SUM (NVL (al.accounted_dr, 0) - NVL (al.accounted_cr, 0)) AS Balance
    FROM 
         apps.xla_ae_headers ah,
         apps.xla_ae_lines al,
         apps.gmf_xla_extract_headers geh,
         apps.gme_batch_header bh,
         apps.gl_code_combinations gcc
   WHERE     
         ah.event_id = geh.event_id
         AND ah.application_id = 555
         AND al.ae_header_id = ah.ae_header_id
         AND al.accounting_class_code = 'WIP_VALUATION'
         AND al.code_combination_id = gcc.code_combination_id
         AND geh.entity_code = 'PRODUCTION'
         AND geh.source_document_id = bh.batch_id
         AND ah.period_name = :P_NAME
         AND gcc.segment3 = 2050103
--         AND trunc(batch_close_date) between to_date('01-JUL-2013') and to_date('31-JUL-2013')
         AND geh.legal_entity_id = :L_ID
--AND bh.batch_no=:b_no
--AND bh.organization_id =:org -- <>
GROUP BY geh.source_document_id,
         bh.batch_no,
         bh.organization_id,
         gcc.segment1|| '.'|| gcc.segment2|| '.'|| gcc.segment3|| '.'|| gcc.segment4|| '.'|| gcc.segment5
  HAVING ABS (SUM (NVL (al.accounted_dr, 0) - NVL (al.accounted_cr, 0))) > 1
  
  
  
--- For Details  
SELECT 
    geh.source_document_id batch_id,bh.batch_no,msi.concatenated_segments,sum(d.actual_qty),
bh.organization_id,al.accounting_class_code,geh.valuation_cost_type,geh.valuation_cost_type_id,bh.attribute4,
--(nvl(al.accounted_dr, 0)),(nvl (al.accounted_cr, 0)),(nvl(al.accounted_dr, 0) - nvl(al.accounted_cr, 0)) remaining_wip_amt
SUM(nvl(al.accounted_dr, 0)),SUM(nvl (al.accounted_cr, 0)),SUM(nvl(al.accounted_dr, 0) - nvl(al.accounted_cr, 0)) remaining_wip_amt
FROM apps.xla_ae_headers ah,
apps.xla_ae_lines al ,
apps.gmf_xla_extract_headers geh,
apps.gmf_fiscal_policies gfp,
apps.gme_batch_header bh,
apps.gme_material_details d ,
apps.mtl_system_items_kfv msi
WHERE ah.event_id = geh.event_id
--AND ah.application_id = 555
AND al.ae_header_id = ah.ae_header_id
AND al.accounting_class_code = 'WIP_VALUATION'
AND gfp.legal_entity_id = geh.legal_entity_id
AND geh.valuation_cost_type_id = gfp.cost_type_id
AND geh.entity_code= 'PRODUCTION'
AND geh.source_document_id = bh.batch_id
AND bh.batch_id =d.batch_id
AND d.organization_id =msi.organization_id
AND d.inventory_item_id =msi.inventory_item_id
AND ah.period_name=:P_NAME
--AND d.line_type=1
--AND trunc(batch_close_date) >=to_date('01-JUN-2012')
AND geh.legal_entity_id = &legal_entity_id
--AND bh.organization_id =97 -- in (93,321,94,95,96,97,98,188,125,124,123,464)
--and bh.batch_no=35541
GROUP BY geh.source_document_id,al.accounting_class_code,geh.valuation_cost_type,geh.valuation_cost_type_id,bh.batch_no,bh.organization_id,bh.attribute4,msi.concatenated_segments
HAVING abs(SUM(nvl(al.accounted_dr, 0) - nvl(al.accounted_cr, 0))) > 1 and sum(d.actual_qty)<>0
order by 2,3;
  