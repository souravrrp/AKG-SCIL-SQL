SELECT 
    ood.organization_code
    ,moqd.subinventory_code
    ,msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3 item_code
    ,NVL(SUM (moqd.primary_transaction_quantity),0) AS ON_HAND_QTY
 from
    inv.mtl_system_items_b msi,
    inv.mtl_onhand_quantities_detail moqd,
    INV.MTL_SECONDARY_INVENTORIES si,
    apps.org_organization_definitions ood
where 1=1
    and msi.organization_id = moqd.organization_id
    and msi.organization_id = ood.organization_id
    and ood.organization_id = moqd.organization_id
    and moqd.subinventory_code = si.SECONDARY_INVENTORY_NAME
    and si.asset_inventory<>2
    and si.SECONDARY_INVENTORY_NAME not like '%TOOLS%'
    and moqd.inventory_item_id = msi.inventory_item_id
--    and msi.organization_id = :DESTINATION_ORGANIZATION_ID
--    and msi.inventory_item_id=:ITEM_ID
    and msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3 = 'GBIN.BMSA.0001'
    and ood.organization_code = 'MRB'
group by 
    ood.organization_code
    ,moqd.subinventory_code
    ,msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3
    

SELECT * FROM APPS.mtl_onhand_quantities_detail


select *
from inv.mtl_system_items_b msi
where 1=1
and msi.segment1||'.'||msi.segment2||'.'||msi.segment3='BRND.GIFT.0008'


------------------------------------------Item Cost------------------------------------


select 
        mmt.transaction_id,
        msi.inventory_item_id,
        msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
        msi.description,
        msi.organization_id,
        mmt.subinventory_code,
        mmt.transaction_quantity,
        mmt.transaction_date,
        mmt.actual_cost,
        mmt.transaction_cost,
        mmt.prior_cost,
        mmt.new_cost,
        mmt.rcv_transaction_id,
        mmt.source_code,
        mmt.source_line_id,
        mmt.shipment_number,
        mmt.prior_costed_quantity        
from 
        apps.mtl_material_transactions mmt
        ,apps.mtl_system_items msi
where 1=1
        and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('BRND.FSTN.0001')
        and msi.inventory_item_id=mmt.inventory_item_id
        and msi.organization_id=mmt.organization_id
        and msi.organization_id in (1345)
order by mmt.transaction_id


---------------------------------------------------------------------------------------------------

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