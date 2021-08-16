select
    mmt.*
--    mmt.transaction_id,
--    mtt.transaction_type_name,
--    mc.segment1 item_catg,
--    mc.segment2 item_type,
--    mmt.inventory_item_id,
--    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
--    msi.description,
--    ood1.organization_code,
--    ood2.organization_code transfer_organization,
--    mmt.subinventory_code,
--    to_char(trunc(mmt.transaction_date),'MON-YY') Txn_period,
----    mmt.transaction_quantity,
--    mmt.primary_quantity,
--    apps.fnc_get_item_cost(mmt.organization_id,mmt.inventory_item_id,to_char(trunc(mmt.transaction_date),'MON-YY')) item_cost
----    mmt.transaction_cost
from
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    inv.mtl_transaction_types mtt,
    apps.org_organization_definitions ood1,
    apps.org_organization_definitions ood2
where
--    mmt.transaction_id in ()
--    and 
    ood1.operating_unit=85
    and msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and ood1.organization_id=mmt.organization_id
    and mmt.transaction_type_id=mtt.transaction_type_id
    and mmt.transfer_organization_id=ood2.organization_id(+)
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('WTNA.IMHI.0005')
--    and to_char(trunc(mmt.transaction_date),'MON-YY')='OCT-14'
--    and TRANSACTION_TYPE_NAME<>'Direct Org Transfer'
    and mmt.transaction_type_id=103
--    transaction_set_id=2278720
--    and mmt.transaction_id in ()
    and rownum<10
