SELECT '01-' || c.period_name Pstart,
       c.period_name,
       b.po_number,
       b.lc_number,
       B.LC_STATUS,
       a.INVOICE_ID,
      a.invoice_num,
  --     a.VOUCHER_NUM,
     -- DOC_SEQUENCE_ID,
    a.DOC_SEQUENCE_VALUE voucher_number,
--       INVOICE_LINE_NUMBER,
--       a.DESCRIPTION,
C.ATTRIBUTE2 LC_PARENT_CHARGE,
C.ATTRIBUTE3 CHILD_CHARGE,
a.ATTRIBUTE10,b.CURRENCY_CODE,b.LC_VALUE,a.EXCHANGE_RATE,c.amount amount,
--b.FUNCTIONAL_AMOUNT,
DECODE (A.INVOICE_CURRENCY_CODE, 'USD', (c.amount*a.EXCHANGE_RATE),
                                        'BDT', c.amount
                               ) "FUNCTIONAL_AMOUNT",
a.INVOICE_AMOUNT,
       (SELECT segment1||'.'||segment2||'.'||segment3||'.'||segment4||'.'||segment5
                FROM gl.gl_code_combinations d
               WHERE     d.code_combination_id = c.dist_code_combination_id) distribution_account,
               (select user_name from applsys.fnd_user where user_id = a.Created_BY) created_by
  FROM apps.xxakg_lc_details b, ap.ap_invoice_distributions_all c,ap.AP_INVOICEs_all a
WHERE c.attribute_category = 'LC No.' || ' &' || ' LC Charge Information'
and b.lc_number = '120314010353'
       AND c.attribute1 = TO_CHAR (b.lc_id)
       and c.invoice_id = a.invoice_id
--       and a.VENDOR_ID=b.VENDOR_ID--added line
       and a.SET_OF_BOOKS_ID=b.LEDGER_ID--added line
        and a.SET_OF_BOOKS_ID=c.SET_OF_BOOKS_ID--added line
--        AND A.INVOICE_CURRENCY_CODE=B.CURRENCY_CODE--added line
--        and b.PO_HEADER_ID=a.QUICK_PO_HEADER_ID--added line
--       and b.po_number in ('I/COU/000019')
       AND EXISTS
             (SELECT 1
                FROM gl.gl_code_combinations d
               WHERE     d.code_combination_id = c.dist_code_combination_id
                    -- AND d.segment3 IN (2050107, 2050106,2010501,2050108)
                     AND d.segment1 in ('2200')
                     )
        --and c.period_name = 'NOV-17'
        --AND A.INVOICE_DATE BETWEEN '01-JAN-2016' AND '19-DEC-2017'
         order by DOC_SEQUENCE_VALUE

