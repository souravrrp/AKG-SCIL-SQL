/* Formatted on 8/28/2019 11:36:59 AM (QP5 v5.287) */
SELECT AIA.ORG_ID,
       AIA.INVOICE_NUM,
       AIA.INVOICE_AMOUNT,
       AIA.INVOICE_DATE,
       AIA.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
       TO_CHAR (AIA.GL_DATE) GL_DATE,
       AIDA.PERIOD_NAME,
       AIA.DESCRIPTION INVOICE_DESCRIPTION,
       AIDA.AMOUNT PROVISION_AMOUNT,
       AIDA.DESCRIPTION PROVISION_DESCRIPTION,
       AIDA.ATTRIBUTE_CATEGORY,
       AIDA.ATTRIBUTE1,
       AIDA.ATTRIBUTE2,
       GCC.SEGMENT2 "Cost Centre",
          GCC.SEGMENT1
       || '-'
       || GCC.SEGMENT2
       || '-'
       || GCC.SEGMENT3
       || '-'
       || GCC.SEGMENT4
          "Account",
       GCC.SEGMENT3 "Natural Account",
       FFVV.DESCRIPTION "Natural Account Name"
  --,AIA.*
  --,AILA.*
  --,AIDA.*
  --,GCC.*
  FROM APPS.AP_INVOICES_ALL AIA,
       APPS.AP_INVOICE_LINES_ALL AILA,
       APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA,
       APPS.GL_CODE_COMBINATIONS GCC,
       APPS.FND_FLEX_VALUES_VL FFVV
 WHERE     1 = 1
       AND AIA.INVOICE_ID = AILA.INVOICE_ID
       AND AIA.INVOICE_ID = AIDA.INVOICE_ID
       AND AIDA.DIST_CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
       AND FFVV.FLEX_VALUE = GCC.SEGMENT3
       AND TO_CHAR (AIA.CREATION_DATE, 'DD-MON-RR') = '27-AUG-19'
       AND AIA.INVOICE_NUM = '218261306'
       AND AIA.ORG_ID = 85
       
--------------------------------------------------------------------------------

select 
    hou.name ou_name
    ,ai.doc_sequence_value
    ,ai.invoice_type_lookup_code
    ,aps.segment1 supplier_no
    ,aps.vendor_name
--    ,ai.invoice_num
--    ,ai.invoice_currency_code currency
--    ,ai.exchange_rate
--    ,ai.invoice_amount
--    ,ai.base_amount
--    ,ai.payment_status_flag
--    ,ai.amount_paid
--    ,ail.line_number inv_line
--    ,ail.line_type_lookup_code line_type
--    ,ail.amount line_amt
--    ,ail.base_amount line_base_amt
    ,aid.distribution_line_number dist_line
--    ,aid.line_type_lookup_code dist_type
--    ,aid.dist_match_type
    ,aid.accounting_date dist_gl_date
    ,aid.amount dist_amt
--    ,aid.base_amount dist_base_amt
    ,decode(aid.base_amount, null, aid.amount, aid.base_amount) functional_amount
    ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account
    ,flex.description Account_description
    ,aid.attribute_category dff_context
    ,aid.attribute1 program_name
    ,aid.attribute2 head_of_expenditure
from
    apps.ap_invoices_all ai
    ,apps.hr_operating_units hou
    ,apps.ap_suppliers aps
    ,apps.ap_supplier_sites_all apss
    ,apps.ap_invoice_lines_all ail
    ,apps.ap_invoice_distributions_all aid
    ,apps.gl_code_combinations gcc
    ,apps.fnd_flex_values_vl flex
where 1=1
    and ai.doc_sequence_value in (218261306)
--    and ai.org_id in (85)
    and ai.org_id =  hou.organization_id
    and ai.vendor_id = aps.vendor_id
    and ai.vendor_site_id = apss.vendor_site_id
    and ai.invoice_id = ail.invoice_id
    and ai.org_id = ail.org_id
    and ai.invoice_id = aid.invoice_id
    and ai.org_id = aid.org_id
    and ail.line_number = aid.invoice_line_number
    and aid.dist_code_combination_id=gcc.code_combination_id
    AND gcc.segment3=flex.flex_value_meaning
    and (ail.discarded_flag='N' or ail.discarded_flag is null)
    and (ail.cancelled_flag='N' or ail.cancelled_flag is null)
    and (aid.reversal_flag='N' or aid.reversal_flag is null)
    and ai.cancelled_date is null
order by 
    ai.doc_sequence_value
    ,ail.line_number
    ,aid.distribution_line_number
