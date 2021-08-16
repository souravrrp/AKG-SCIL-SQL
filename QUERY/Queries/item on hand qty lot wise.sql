select
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    ood.organization_code,
    moq.subinventory_code,
    moq.lot_number,
    moq.transaction_quantity
from
    APPS.MTL_ONHAND_QUANTITIES moq,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood
where
--    msi.organization_id=99
    ood.operating_unit=99
    and msi.organization_id=ood.organization_id
    and msi.inventory_item_id=moq.inventory_item_id
    and msi.organization_id=moq.organization_id
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('RPAP.ORNI.0001')
--    and moq.lot_number='RPAP-14-AUG-2014-11'
--    and moq.SUBINVENTORY_CODE='CER-SP FLR'
--    and rownum<10
order by
    moq.lot_number             