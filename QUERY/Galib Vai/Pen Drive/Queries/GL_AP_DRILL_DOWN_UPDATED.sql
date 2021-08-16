select
--    *
    ap.period_name,
    lc.lc_number,
    lc.po_number,
    ap.VOUCHER_NUMBER,
    ap.GRN_NUMBER,
    sum(ap.amount) amount
from apps.xxakg_lc_details lc,
(select
--    aia.*
    aid.PERIOD_NAME,
    aid.ATTRIBUTE1 LC_ID,
    aia.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
    aid.ATTRIBUTE5 GRN_NUMBER,
--    glmv.Total
    SUM(NVL(aid.AMOUNT,aid.base_amount)) AMOUNT
from    
    ap.ap_invoices_all aia,
    ap.ap_invoice_distributions_all aid,
    gl.gl_code_combinations gcc,
    (select
        distinct VOUCHER_NUMBER ,
        SUM(NVL(DEBITS,0)) Dr,
        SUM(NVL(CREDITS,0)) Cr,
        SUM(NVL(DEBITS,0))-SUM(NVL(CREDITS,0)) Total
    from
        apps.xxakg_gl_details_statement_mv
    where
        JE_SOURCE='AP'
        and LEDGER_ID=2025
        and account='2050107'
        and company='2110'
        and trunc(voucher_date) < '01-AUG-13'
--    and trunc(voucher_date) between '01-JAN-13' and '31-JUL-13'
    group by
        VOUCHER_NUMBER) glmv
where
    aia.doc_sequence_value = glmv.voucher_number
    and aia.invoice_id=aid.invoice_id
--    and aid.ATTRIBUTE_CATEGORY = 'LC No.' || ' &' || ' LC Charge Information'
    and aid.dist_code_combination_id=gcc.code_combination_id
    and gcc.segment1='2110'
    and gcc.segment3='2050107'
    and aia.SET_OF_BOOKS_ID=2025
group by
    aid.PERIOD_NAME,
    aid.ATTRIBUTE1,
    aia.DOC_SEQUENCE_VALUE,
    aid.attribute5
order by
        aia.DOC_SEQUENCE_VALUE
) ap
where
    ap.lc_id=lc.lc_id
--    and lc.po_number in ()
group by
    ap.period_name,
    lc.lc_number,
    lc.po_number,
    ap.VOUCHER_NUMBER,
    ap.GRN_NUMBER
    
    
-----------------------------
select
    VOUCHER_NUMBER--,
--    SUM(NVL(DEBITS,0)) Dr,
--    SUM(NVL(CREDITS,0)) Cr,
    SUM(NVL(DEBITS,0))-SUM(NVL(CREDITS,0)) Total
from
    apps.xxakg_gl_details_statement_mv
where
    JE_SOURCE='AP'
    and LEDGER_ID=2025
    and account='2050107'
    and company='2110'
    and trunc(voucher_date) < '01-JAN-13'
--    and rownum=1 
group by
    VOUCHER_NUMBER
)       
group by
    