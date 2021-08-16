select 
    grc.recipe_id,
    grc.recipe_no,
    grc.recipe_version,
    grv.RECIPE_VALIDITY_RULE_ID,
--    grv.RECIPE_ID,
    ood.operating_unit,
    grv.ORGANIZATION_ID,
    ood.organization_code,
    grv.INVENTORY_ITEM_ID,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    grv.DETAIL_UOM,
    grv.START_DATE,
    grv.MIN_QTY,
    grv.MAX_QTY,
    grv.STD_QTY
from
    apps.gmd_recipes grc,
    apps.GMD_RECIPE_VALIDITY_RULES grv,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood
where
    grc.recipe_id=grv.recipe_id
    and grv.inventory_item_id=msi.inventory_item_id
    and grv.organization_id=msi.organization_id
    and grv.organization_id=ood.organization_id
    and ood.legal_entity=23279
    and ood.operating_unit=605
    and grc.recipe_no like 'SPLT%'
--    rownum<10     