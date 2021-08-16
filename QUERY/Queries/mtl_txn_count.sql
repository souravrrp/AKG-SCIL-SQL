select * 
from
(


select
    mmt.organization_id,
    ood.organization_code,
    mmt.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
    msi.creation_date,
    count(mmt.transaction_id) txn_count,
    trunc(max(mmt.transaction_date)) last_txn_date,
    trunc(sysdate)-trunc(max(mmt.transaction_date)) last_txn_day--,
--    mmt.*
from
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood
where
    mmt.transaction_quantity<0
    and msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and mmt.organization_id=ood.organization_id
    and ood.operating_unit=:operating_unit
    and ood.organization_id=:organization_id
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('CALR.CALR.2203')
     and trunc(mmt.transaction_date) between trunc(sysdate)-180 and trunc(sysdate)
group by 
    mmt.organization_id,
    ood.organization_code,
    mmt.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    msi.creation_date


)   
having count(inventory_item_id)>2