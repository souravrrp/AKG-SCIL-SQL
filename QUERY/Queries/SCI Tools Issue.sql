select
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    mmt.ATTRIBUTE1 EMP_ID,
    pap.full_name,
    to_char(trunc(mmt.transaction_date),'MON-YY') TXN_PERIOD,
    mmt.SUBINVENTORY_CODE FROM_SUB_INV,
    mmt.TRANSFER_SUBINVENTORY,
    sum(case when nvl(mmt.transaction_quantity,0)<0 then abs(nvl(mmt.transaction_quantity,0)) else 0 end) ISS_QTY,
    sum(case when  nvl(mmt.transaction_quantity,0)>0 then abs(nvl(mmt.transaction_quantity,0)) else 0 end) RCV_QTY 
--    mmt.*
from 
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    hr.per_all_people_f pap
where
    mmt.organization_id=101
    and msi.organization_id=mmt.organization_id
    and msi.inventory_item_id=mmt.inventory_item_id
    and mmt.attribute1=pap.employee_number
    and mmt.transaction_type_id=103
--    and mmt.ATTRIBUTE1=8136
--    and mmt.SUBINVENTORY_CODE in ('SCI- STORE','SCI-TOOLS')
--    and mmt.TRANSFER_SUBINVENTORY='SCI-TOOLS'
--    and rownum<10
group by
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    mmt.ATTRIBUTE1,
    pap.full_name,
    to_char(trunc(mmt.transaction_date),'MON-YY'),
    mmt.SUBINVENTORY_CODE,
    mmt.TRANSFER_SUBINVENTORY
    
    
select 
    *
--    FULL_NAME 
from hr.per_all_people_f 
where 
    employee_number=3084
--    person_id=3084 
--    and rownum<10        
    
select * from inv.mtl_transaction_types --where rownum<10        