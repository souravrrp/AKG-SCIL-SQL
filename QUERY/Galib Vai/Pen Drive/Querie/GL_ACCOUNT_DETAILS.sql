select 
    to_char(voucher_date,'MON-YY') Period,
    COMPANY,
    COST_CENTER,
    ACCOUNT,
    ACCTDESC,
    ORGANIZATION_CODE,
    JE_SOURCE,
    SUM(NVL(DEBITS,0)) DEBIT,
    SUM(NVL(CREDITS,0)) CREDIT,
    SUM(NVL(DEBITS,0))-SUM(NVL(CREDITS,0)) BALANCE
from apps.xxakg_gl_details_statement_dmv 
where 
    Ledger_id=2025
    AND COMPANY='2400'
--    and account='2050107'
--    and ACCOUNT in ('2050101','2050105','2050104')   --Spare
--    and  ITEM_CATEGORY_SEGMENT1='FINISH GOODS' --and account not in (205010) 
--    and voucher_date between to_date('01-JUN-2013','DD-MON-YYYY') and to_date('30-JUN-2013','DD-MON-YYYY')
    and trunc(voucher_date) between '01-SEP-2013' and '30-SEP-2013'--<= '30-JUN-2013' 
--    and je_source in ('CST','INV')
group by
    voucher_date,
    COMPANY,
    COST_CENTER,
    JE_SOURCE,
   ORGANIZATION_CODE,
    ACCOUNT,
    ACCTDESC    
order by
        to_char(voucher_date,'MON-YYY'),
        COMPANY,
        ACCOUNT,
    ACCTDESC

