select 
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    ood.organization_code,
    moqd.subinventory_code,
    mil.segment1||'.'||mil.segment2||'.'||mil.segment3 Line_No,
    moqd.lot_number,
    moqd.primary_transaction_quantity onhand_qty
from
    inv.mtl_onhand_quantities_detail moqd,
    inv.mtl_system_items_b msi,
    inv.mtl_item_locations mil,
    apps.org_organization_definitions ood
where
    moqd.organization_id=msi.organization_id
    and moqd.inventory_item_id=msi.inventory_item_id
    and msi.organization_id=ood.organization_id
    and ood.legal_entity=23279
    and ood.operating_unit=85
    and ood.organization_code='SCS'
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('BRND.GIFT.0079')
--    and msi.description like '%LID%'
    and moqd.locator_id=mil.inventory_location_id(+)
    and regexp_like(mil.subinventory_code,'BLOCK|REGION')
    
    --------------------------------------------------

select 
ood.organization_code
,moqd.subinventory_code
,msi.inventory_item_id
,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code
,msi.description
,sum(nvl(moqd.primary_transaction_quantity,0)) onhand_qty
from
inv.mtl_onhand_quantities_detail moqd
,inv.mtl_system_items_b msi
,apps.mtl_item_categories mic
--,apps.mtl_categories mc
,apps.org_organization_definitions ood
where 1=1
and msi.organization_id=moqd.organization_id
and msi.organization_id=mic.organization_id
and ood.organization_id=moqd.organization_id
and moqd.inventory_item_id=msi.inventory_item_id
and mic.inventory_item_id=msi.inventory_item_id
and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 IN ('BRND.GIFT.0048')
--and moqd.inventory_item_id=850261
--and moqd.subinventory_code='SCS-BRAND'
group by 
ood.organization_code
,moqd.organization_id
,msi.inventory_item_id
,moqd.subinventory_code
,msi.segment1||'.'||msi.segment2||'.'||msi.segment3
,msi.description

SELECT * FROM APPS.mtl_onhand_quantities_detail


select *
from inv.mtl_system_items_b msi
where 1=1
and msi.segment1||'.'||msi.segment2||'.'||msi.segment3='BRND.GIFT.0008'


------------------------------------------------------------------------------------------------------



SELECT m.organization_id 
    ,m.transaction_quantity
  FROM apps.mtl_material_transactions m
 WHERE 1=1
--   AND m.organization_id = :destination_organization_id
   AND m.inventory_item_id = 866155
--   AND M.TRANSACTION_DATE <=to_date(sysdate)


select * 
from 
apps.mtl_item_categories
where inventory_item_id = 866155

select * 
from 
apps.mtl_categories
where category_id=604905