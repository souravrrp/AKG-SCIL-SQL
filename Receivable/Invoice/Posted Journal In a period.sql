/* Formatted on 8/28/2019 11:51:26 AM (QP5 v5.287) */
SELECT DISTINCT gcck.concatenated_segments "Accounting Combinations",
                gjl.je_line_num,
                gjl.ledger_id,
                gjl.period_name
  --head.posted_date "Date Posted",
  --head.ledger_id,
  --head.je_category,
  --head.je_source,
  --head.period_name,
  --head.name,
  --head.currency_code,
  --head.status,
  --head.description,
  --head.running_total_dr,
  --head.running_total_cr,
  --head.doc_sequence_value
  --,gjb.description
  --,gjb.RUNNING_TOTAL_DR
  --,gjb.RUNNING_TOTAL_CR
  FROM apps.gl_code_combinations_kfv gcck,
       apps.gl_je_lines gjl,
       apps.gl_je_headers gjh,
       apps.gl_je_batches gjb
 WHERE     gcck.code_combination_id = gjl.code_combination_id
       AND gjl.je_header_id = gjh.je_header_id
       AND gjb.je_batch_id = gjh.je_batch_id
       AND gjh.ledger_id = 2025
       AND gjh.je_source = 'Receivables'
       --AND gjh.doc_sequence_value = 117021964
       --AND code.segment2 = ----(select appropriate segment# for CC)
       --AND code.segment3= ----(select appropriate segment# for Account)
       AND TRUNC (gjh.posted_date) BETWEEN '27-AUG-2019' AND '27-AUG-2019'
       AND gjh.posted_date IS NOT NULL;


--------------------------------------------------------------------------------

SELECT gjjlv.period_name "Period Name",
       gjb.name "Batch Name",
       gjjlv.header_name "Journal Entry For",
       gjjlv.je_source "Source",
       glcc.concatenated_segments "Accounts",
       NVL (gjjlv.line_entered_dr, 0) "Entered Debit",
       NVL (gjjlv.line_entered_cr, 0) "Entered Credit",
       NVL (gjjlv.line_accounted_dr, 0) "Accounted Debit",
       NVL (gjjlv.line_accounted_cr, 0) "Accounted Credit",
       gjjlv.currency_code "Currency",
       rctype.name "Trx type",
       rcta.trx_number "Trx Number",
       rcta.trx_date "Trx Date",
       RA.CUSTOMER_NAME "Trx Reference",
       gjh.STATUS "Posting Status",
       TRUNC (gjh.DATE_CREATED) "GL Transfer Dt",
       gjjlv.created_by "Transfer By"
  FROM apps.GL_JE_JOURNAL_LINES_V gjjlv,
       apps.gl_je_lines gje,
       apps.gl_je_headers gjh,
       apps.gl_je_batches gjb,
       apps.ra_customer_trx_all rcta,
       apps.ar_customers ra,
       apps.gl_code_combinations_kfv glcc,
       apps.ra_cust_trx_types_all rctype
 WHERE 1=1
       --AND gjh.period_name IN ('OCT-2008', 'NOV-2008')
       AND glcc.code_combination_id = gje.code_combination_id
       AND gjh.je_batch_id = gjb.je_batch_id
       AND gjh.je_header_id = gje.je_header_id
       AND gjh.period_name = gjb.default_period_name
       AND gjh.period_name = gje.period_name
       AND gjjlv.period_name = gjh.period_name
       AND gjjlv.je_batch_id = gjh.je_batch_id
       AND gjjlv.je_header_id = gjh.je_header_id
       AND gjjlv.line_je_line_num = gje.je_line_num
       AND gjjlv.line_code_combination_id = glcc.code_combination_id
       AND gjjlv.line_reference_4 = rcta.trx_number
       AND rcta.cust_trx_type_id = rctype.cust_trx_type_id
       AND rcta.org_id = rctype.org_id
       AND ra.customer_id = rcta.bill_to_customer_id
       and rcta.trx_number='418332946'
       --and       glcc.segment1 ='30D
       ;
       
       
--------------------------------------------------------------------------------

SELECT gjb.name GL_batch_name,
       gjh.name Journal_Name,
       gjl.period_name,
       gjh.JE_CATEGORY,
       gjh.JE_SOURCE,
       gjh.currency_code,
       DECODE (gjh.ACTUAL_FLAG, 'A', 'Actual','B', 'Budget','E', 'Encumbrance') Balance_Type,
       DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) Batch_Status,
       gjh.posted_date,
       rcta.trx_number,
       rcta.trx_date
  FROM apps.gl_je_lines gjl,
       apps.gl_je_headers gjh,
       apps.gl_je_batches gjb,     
       apps.gl_import_references gir,
       apps.xla_ae_lines xal,
       apps.xla_ae_headers xah,
       apps.xla_events xe,
       apps.xla_transaction_entities xte,
       apps.ra_customer_trx_all rcta
 WHERE gjb.je_batch_id  = gjh.je_batch_id
   and gjl.je_header_id = gjh.je_header_id
   and gjl.je_header_id = gir.je_header_id
   and gjl.je_line_num  = gir.je_line_num
   and gir.gl_sl_link_table = xal.gl_sl_link_table
   and gir.gl_sl_link_id    = xal.gl_sl_link_id
   and xal.application_id = xah.application_id
   and xal.ae_header_id   = xah.ae_header_id
   --and xal.ae_line_num = 1 /*If AR Transaction has multiple lines then xla_ae_lines table contains multiple lines*/
   and xah.application_id = xe.application_id
   and xah.event_id       = xe.event_id
   and xe.application_id = xte.application_id
   and xe.entity_id      = xte.entity_id
   and xte.application_id    = 222
   and xte.entity_code       = 'TRANSACTIONS'
   and xte.source_id_int_1   = rcta.customer_trx_id
   and trim(rcta.trx_number) = trim('&AR_trx_number');