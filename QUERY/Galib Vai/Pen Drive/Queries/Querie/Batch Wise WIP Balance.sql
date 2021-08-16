/* Formatted on 8/21/2013 5:06:38 PM (QP5 v5.163.1008.3004) */
  SELECT bh.batch_no,
            ITEM_CODE_SEGMENT1
         || '.'
         || ITEM_CODE_SEGMENT2
         || '.'
         || ITEM_CODE_SEGMENT3
            Item_code,
         SUM (NVL (debits, 0)) debits,
         SUM (NVL (credits, 0)) credits,
         SUM (NVL (debits, 0)) - SUM (NVL (credits, 0)) Net
    FROM apps.xxakg_gl_details_statement_dmv a,
         gmf.gmf_xla_extract_headers b,
         gme.gme_batch_header bh
   WHERE     company = '2110'
         AND cost_center = 'PACKR'
         AND account = 2050103
         AND INTER_PROJECT = 9999
         AND future = '00'
         AND VOUCHER_DATE BETWEEN '01-JUL-2013' AND '31-JUL-2013'
         AND a.voucher_number = b.transaction_id
         AND b.source_document_id = bh.batch_id
GROUP BY bh.batch_no,
            ITEM_CODE_SEGMENT1
         || '.'
         || ITEM_CODE_SEGMENT2
         || '.'
         || ITEM_CODE_SEGMENT3