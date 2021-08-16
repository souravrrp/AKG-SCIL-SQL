select 
    to_char(voucher_date,'MON-YY') Period,
    COMPANY,
    COST_CENTER,
    ACCOUNT,
    ACCTDESC,
    ORGANIZATION_CODE,
    JE_SOURCE,
    item_category_segment1,
    item_category_segment2,
    item_code_segment1||'.'||item_code_segment2||'.'||item_code_segment3 item_code,
    inventory_item_name,
    SUM(NVL(DEBITS,0)) DEBIT,
    SUM(NVL(CREDITS,0)) CREDIT,
    SUM(NVL(DEBITS,0))-SUM(NVL(CREDITS,0)) BALANCE
from 
    apps.xxakg_gl_details_statement_mv
--    apps.xxakg_gl_details_statement_dmv
--    apps.xxakg_gl_details_statement_mv
--    apps.xxakg_gl_dtl_dmv_2025
where 
    Ledger_id=2025
--    and organization_code='CER'
    AND COMPANY='2300'
    and cost_center='OPTRK'
--    and account='2050107'
    and ACCOUNT in ('4030806')   --Spare
--    and  ITEM_CATEGORY_SEGMENT1='MECHANICAL' --and account not in (205010)
--    and item_code_segment1||'.'||item_code_segment2||'.'||item_code_segment3 in ('0NUT.00MS.0002') 
--    and voucher_date between to_date('01-JUN-2013','DD-MON-YYYY') and to_date('30-JUN-2013','DD-MON-YYYY')
    and trunc(voucher_date) between '01-APR-2015' and '30-APR-2015'--<= '30-JUN-2013' 
--    and je_source in ('CST','INV')
group by
    voucher_date,
    COMPANY,
    COST_CENTER,
    JE_SOURCE,
   ORGANIZATION_CODE,
    ACCOUNT,
    ACCTDESC,
        item_category_segment1,
    item_category_segment2,
    item_code_segment1||'.'||item_code_segment2||'.'||item_code_segment3,
    inventory_item_name    
order by
        to_char(voucher_date,'MON-YYY'),
        COMPANY,
        ACCOUNT,
    ACCTDESC--,
--    category_code_segment1,
--    category_code_segment2,
--    item_code_segment1||'.'||item_code_segment2||'.'||item_code_segment3 ,
--    inventory_item_name