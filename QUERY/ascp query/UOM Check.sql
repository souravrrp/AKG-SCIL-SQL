select 
    mc.segment1 item_category,
    mc.segment2 item_type,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    msi.inventory_item_status_code Status,
    mucc.from_uom_code,
    mucc.to_uom_code,
    mucc.conversion_rate
from
    inv.mtl_system_items_b msi,
    inv.mtl_uom_class_conversions mucc,
    apps.org_organization_definitions ood,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc
where
    msi.inventory_item_id=mucc.inventory_item_id
    and msi.organization_id=ood.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_set_id=1
    and mic.category_id=mc.category_id
--    and ood.operating_unit=83
    and ood.organization_code='CER'
--    and mc.segment1 = 'WIP'
--    and msi.segment1 = 'RPWB'
--    and msi.description like '%READY PIECS%'
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('WMLD.VRWT.0004',
'CMLD.VRWT.0004',
'WMLD.JUPD.0001',
'CMLD.JUPD.0001',
'WMLD.JUWT.0001',
'CMLD.JUWT.0001',
'WMLD.JUWT.0002',
'CMLD.JUWT.0002',
'WMLD.WAPD.0001',
'CMLD.WAPD.0001',
'WMLD.WAWB.0001',
'CMLD.WAWB.0001')