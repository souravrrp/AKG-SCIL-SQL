SELECT msi.segment1,msi.segment2,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,msi.DESCRIPTION,msi.ITEM_TYPE,mc.segment1||'|'||mc.segment2 item_category
FROM
APPS.MTL_SYSTEM_ITEMS_FVL MSI,
inv.mtl_item_categories mic,
inv.mtl_categories_b mc
WHERE msi.ORGANIZATION_ID = 91
and msi.organization_id = mic.organization_id
and msi.INVENTORY_ITEM_ID = mic.INVENTORY_ITEM_ID
and mic.CATEGORY_ID = mc.CATEGORY_ID
order by msi.segment1||'.'||msi.segment2||'.'||msi.segment3 