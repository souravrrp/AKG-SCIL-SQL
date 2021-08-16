select
    *
from ap.ap_invoices_all
where
--    DOC_SEQUENCE_VALUE=213079148
    rownum<10
--CANCELLED_DATE

select 
--    distinct EVENT_TYPE_CODE
    * 
from GMF.GMF_TRANSACTION_VALUATION
where
    trunc(TRANSACTION_DATE) between '01-MAY-2013' and '31-MAY-2013'
    rownum<10     
    
select
    *
from ap.ap_invoice_distributions_all
where
    ATTRIBUTE_CATEGORY = 'LC No.' || ' &' || ' LC Charge Information'
    and SET_OF_BOOKS_ID=2025
    and ACCOUNTING_EVENT_ID=
--    and PERIOD_NAME='MAY-13'
    and rownum<10           
    
    
    
select 
    *
from GMF.GMF_TRANSACTION_VALUATION
where
    ledger_id=2025
    and ORG_ID=85
    and JOURNAL_LINE_TYPE='INV'
    and rownum<10         
    
    
    
------------------    
select 
--    *
    ITEM_CODE_SEGMENT1||'.'||ITEM_CODE_SEGMENT2||'.'||ITEM_CODE_SEGMENT3 ItemCode,
    sum(case when GOODS_RECEIPT_NUM is null then (nvl(DEBITS,0)-nvl(CREDITS,0)) else 0 end) WITHOUT_GRN,
    sum(case when GOODS_RECEIPT_NUM is not null then (nvl(DEBITS,0)-nvl(CREDITS,0)) else 0 end) WITH_GRN
from apps.xxakg_gl_details_statement_mv
where
    LEDGER_ID=2025
    and company='2110'
    and account in ('2050107')
    and JE_SOURCE='INV'
    and trunc(voucher_date) between '01-JAN-2013' and '31-JUL-2013'
--    and rownum<10
group by
    ITEM_CODE_SEGMENT1,ITEM_CODE_SEGMENT2,ITEM_CODE_SEGMENT3  
-----------------------------
                  