SELECT glcc.segment1 company, glcc.segment2 LOCATION,
       glcc.segment3 cost_center, glcc.segment4 ACCOUNT,
       glcc.segment5 product_line, glcc.segment6 channel,
       glcc.segment7 project,
       (SELECT flex_value || ' ' || fvt.description
          FROM apps.gl_code_combinations glc,
               apps.fnd_flex_values fv,
               apps.fnd_flex_values_tl fvt
         WHERE glc.code_combination_id = gjl.code_combination_id
           AND glc.segment4 = fv.flex_value
           AND fv.flex_value_set_id = 1002653
           AND fv.flex_value_id = fvt.flex_value_id) code_combo_desc,
       gjh.posted_date posted_on_dt, gjh.je_source, gjh.je_category,
       gjb.NAME je_batch_name, gjh.NAME document_name, '' je_seq_name,
       '' je_seq_num, gjl.je_line_num, gjl.description je_line_desc,
       xal.entered_cr global_cr, xal.entered_dr global_dr,
       xal.currency_code global_cur, ac.customer_name vendor_customer,
       rcta.trx_number transaction_number, rcta.trx_date transaction_date,
       xal.accounting_class_code transaction_type, xal.accounted_cr local_cr,
       xal.accounted_dr local_dr, gl.currency_code local_cur,
       (NVL (xal.accounted_dr, 0) - NVL (xal.accounted_cr, 0)
       ) transaction_amount,
       gl.currency_code transaction_curr_code, gjh.period_name fiscal_period,
       (gb.begin_balance_dr - gb.begin_balance_cr) begin_balance,
       (  gb.period_net_dr
        - gb.period_net_cr
        + gb.project_to_date_dr
        - gb.project_to_date_cr
       ) end_balance,
       gl.NAME ledger_name
  FROM apps.gl_je_headers gjh,
       apps.gl_je_lines gjl,
       apps.gl_import_references gir,
       xla.xla_ae_lines xal,
       xla.xla_ae_headers xah,
       apps.gl_code_combinations glcc,
       xla.xla_transaction_entities xte,
--apps.ar_adjustments_all ada,
       apps.ra_customer_trx_all rcta,
       apps.gl_ledgers gl,
       apps.gl_balances gb,
       apps.ar_customers ac,
       apps.gl_je_batches gjb
 WHERE 1 = 1
 AND rcta.ORG_ID=85
   AND gjh.je_header_id = gjl.je_header_id
   AND gjl.je_header_id = gir.je_header_id
   AND gjl.je_line_num = gir.je_line_num
   AND gir.gl_sl_link_id = xal.gl_sl_link_id
   AND gir.gl_sl_link_table = xal.gl_sl_link_table
   AND xal.ae_header_id = xah.ae_header_id
   AND xal.application_id = xah.application_id
   AND xal.code_combination_id = glcc.code_combination_id
   AND xte.entity_id = xah.entity_id
   --AND xte.entity_code = 'ADJUSTMENTS'
   AND xte.ledger_id = gl.ledger_id
   --AND xte.application_id = 222
   --AND NVL (xte.source_id_int_1, -99) = ada.adjustment_id
   --AND ada.customer_trx_id = rcta.customer_trx_id
   AND gjh.ledger_id = gl.ledger_id
   AND gb.code_combination_id = glcc.code_combination_id
   AND gb.period_name = gjh.period_name
   AND gb.currency_code = gl.currency_code
   AND gb.ledger_id = gl.ledger_id
   AND gjh.je_batch_id = gjb.je_batch_id
   AND rcta.bill_to_customer_id = ac.customer_id(+)
   AND gjh.period_name IN ('JUL-19')
   --AND glcc.segment4 = '20331'
   AND gjh.je_source = 'Receivables'
   AND ROWNUM<=3;
   
---------------------------------------------------------------------------------