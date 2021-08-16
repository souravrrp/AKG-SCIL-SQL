select 
--    *
    COMPANY||'.'||COST_CENTER||'.'||ACCOUNT||'.'||INTER_PROJECT||'.'||FUTURE CodeCombination,
    ACCTDESC,
    ITEM_CODE_SEGMENT1||'.'||ITEM_CODE_SEGMENT2||'.'||ITEM_CODE_SEGMENT3 ItemCode,
    ORGANIZATION_CODE,
    VOUCHER_NUMBER,
    VOUCHER_DATE,
    NVL(DEBITS,0) DEBITS,
    NVL(CREDITS,0) CREDITS,
    SUM(NVL(DEBITS,0))-SUM(NVL(CREDITS,0)) balance
from 
    APPS.XXAKG_GL_DETAILS_STATEMENT_DMV 
where 
    application_id=555 
    and ledger_id=2025 
--    and voucher_date <'01-SEP-2013'--
    and voucher_date between '01-SEP-2013' and '30-SEP-2013'
--    and ACCOUNT='2050103'   --WIP
--    and ACCOUNT='2050110'   --RcvInv
--    and ACCOUNT='2050106'   --InTransit-RawMaterial LC
--    and ACCOUNT='2050107'
    and account='2050104'
    and company='2400'
--    and voucher_number in ()
group by
    COMPANY,COST_CENTER,ACCOUNT,INTER_PROJECT,FUTURE,ACCTDESC,ORGANIZATION_CODE,
    ITEM_CODE_SEGMENT1,ITEM_CODE_SEGMENT2,ITEM_CODE_SEGMENT3,
    VOUCHER_NUMBER,
    VOUCHER_DATE,
    DEBITS,
    CREDITS
having
    SUM(NVL(DEBITS,0))-SUM(NVL(CREDITS,0))<>0        