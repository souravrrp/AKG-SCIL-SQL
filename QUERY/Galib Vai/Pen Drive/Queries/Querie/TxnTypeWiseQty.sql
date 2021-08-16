SELECT 
--    *
    application_id
FROM applsys.fnd_application
WHERE 
    application_short_name = 'INV'
--    application_id=555
    
    
SELECT 
--*
    set_of_books_id
FROM apps.gl_sets_of_books
WHERE NAME = 'Cement Ledger'

select * from INV.MTL_MATERIAL_TRANSACTIONS where TRANSACTION_ID=19770263 


select
    *
--    c.segment1||'.'||c.segment2||'.'||c.segment3 ItemCode,
--    GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5 AccountCode,
--    trunc(B.TRANSACTION_DATE) Txn_date,
--    sum(TRANSACTION_QUANTITY) Txn_Qty
FROM INV.MTL_MATERIAL_TRANSACTIONS b,
             INV.MTL_SYSTEM_ITEMS_B c,
            GL.gl_code_combinations gcc
where
    c.INVENTORY_ITEM_ID=B.INVENTORY_ITEM_ID
--    and B.TRANSACTION_DATE = to_date('16-JUN-2013','DD-MON-YYYY') 
    and B.TRANSACTION_ID=19770263
    and B.DISTRIBUTION_ACCOUNT_ID=GCC.CODE_COMBINATION_ID
--    and B.TRANSACTION_TYPE_ID=42    -- Misc. Receipt
--group by
--    c.segment1,c.segment2,c.segment3,
--    GCC.SEGMENT1,GCC.SEGMENT2,GCC.SEGMENT3,GCC.SEGMENT4,GCC.SEGMENT5,
--    trunc(B.TRANSACTION_DATE)                        