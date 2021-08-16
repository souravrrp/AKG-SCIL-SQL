select
    ood.organization_code,
    trunc(mmt.transaction_date) txn_date,
    sum(case when mmt.transaction_quantity<0 then nvl(mmt.primary_quantity,0) else 0 end) issue_qty,
    sum(case when mmt.transaction_quantity>0 then nvl(mmt.primary_quantity,0) else 0 end) rcv_qty
from
    inv.mtl_system_items_b msi,
    inv.mtl_material_transactions mmt,
    apps.org_organization_definitions ood
where  
    msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and msi.organization_id=ood.organization_id
    and ood.operating_unit=85
--    and ood.organization_code='SCI'
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('DRCT.CLNK.0001')
    and trunc(mmt.transaction_date) between '01-FEB-2015' and '10-FEB-2015'
group by 
    organization_code,
    trunc(mmt.transaction_date)
order by 
    organization_code,trunc(mmt.transaction_date)          