SELECT '01-' || c.period_name Pstart,
       c.period_name,
       b.po_number,
       b.lc_number,
--       c.INVOICE_ID,
--       a.invoice_num,
  --     a.VOUCHER_NUM,
 --      DOC_SEQUENCE_ID,
       DOC_SEQUENCE_VALUE voucher_number,
--       INVOICE_LINE_NUMBER,
--       a.DESCRIPTION,
       c.amount amount,
       (SELECT segment1||'.'||segment2||'.'||segment3||'.'||segment4||'.'||segment5
                FROM gl.gl_code_combinations d
               WHERE     d.code_combination_id = c.dist_code_combination_id) distribution_account,
               (select user_name from applsys.fnd_user where user_id = a.Created_BY) created_by
  FROM apps.xxakg_lc_details b, ap.ap_invoice_distributions_all c,ap.AP_INVOICEs_all a
 WHERE c.attribute_category = 'LC No.' || ' &' || ' LC Charge Information'
       AND c.attribute1 = TO_CHAR (b.lc_id)
       and c.invoice_id = a.invoice_id
--       and b.po_number in ('I/COU/000019')
       AND EXISTS
             (SELECT 1
                FROM gl.gl_code_combinations d
               WHERE     d.code_combination_id = c.dist_code_combination_id
                     AND d.segment3 IN (2050107, 2050106)
                     AND d.segment1 in ('2110','2120','2200','2300','2400')
                     )
        and c.period_name = 'JUN-13'
        order by DOC_SEQUENCE_VALUE

