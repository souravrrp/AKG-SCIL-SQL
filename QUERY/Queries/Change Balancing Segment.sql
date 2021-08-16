select 
    mmt.* 
from 
    INV.MTL_MATERIAL_TRANSACTIONS mmt,
    gl.gl_code_combinations gcc
where 
    ORGANIZATION_ID=99
    and trunc(transaction_date)='23-OCT-2013'
    and transaction_id=22605317
    and mmt.distribution_account_id=gcc.code_combination_id
    and rownum<10



select DISTRIBUTION_ACCOUNT_ID from INV.MTL_MATERIAL_TRANSACTIONS where transaction_id=22605317


--update INV.MTL_MATERIAL_TRANSACTIONS
--set DISTRIBUTION_ACCOUNT_ID=141649
--where  transaction_id=22605317


select *
from gl.gl_code_combinations gcc
where
--    segment1||'.'||segment2||'.'||segment3||'.'||segment4||'.'||segment5='2200.ACFAC.4030706.9999.00'
    code_combination_id=141649
    
--159365    


--141649