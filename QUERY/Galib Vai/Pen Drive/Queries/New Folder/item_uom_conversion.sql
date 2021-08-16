select 
    mc.segment1 item_category,
    mc.segment2 item_type,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
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
    and ood.operating_unit=83
    and ood.organization_code='CER'
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('WTNA.VERW.0001',
'WTNA.VERI.0001',
'WTNA.VERP.0001',
'WTNA.VERB.0001',
'WTNA.VERG.0001',
'WTNA.VERD.0001',
'WTNA.VERR.0001',
'WTNA.VERY.0001',
'MWTA.VERB.0001',
'MWTA.VERG.0001',
'MWTA.VERI.0001',
'MWTA.VERP.0001',
'MWTA.VERW.0001',
'WTNB.VERY.0001')
    