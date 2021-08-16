select 
    *
--    distinct cost_cmpntcls_id 
from GMF.CM_ADJS_DTL
where 
--    period_id=6
--    and adjustment_date=to_date('01/06/2013','DD/MM/YYYY')
--    and 
    ORGANIZATION_ID=99
--    rownum<100 


select * from INV.MTL_SYSTEM_ITEMS_B
where 
--VALV.SOLV.3035
       segment1='VALV'
       and segment2='SOLV'
       and segment3='3035' 
--    rownum<100

-- Cost Cmpnt Cls
--1
--57
--2