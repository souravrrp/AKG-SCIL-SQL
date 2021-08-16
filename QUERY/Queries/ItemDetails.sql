select 
--*
     decode(a.ORGANIZATION_ID,99,'CER') ORGANIZATION,
    a.SEGMENT1||'.'||a.SEGMENT2||'.'||a.SEGMENT3 ItemCode,
    a.DESCRIPTION,
    b.segment1 ItemCategory,
    a.PRIMARY_UOM_CODE,
    a.INVENTORY_ITEM_STATUS_CODE
from 
    INV.MTL_SYSTEM_ITEMS_B a, 
    APPS.MTL_ITEM_CATEGORIES_V b
where 
    a.ORGANIZATION_ID=99
    and a.INVENTORY_ITEM_ID=b.INVENTORY_ITEM_ID
--    and a.DESCRIPTION like ''
group by
    a.ORGANIZATION_ID,
    a.SEGMENT1||'.'||a.SEGMENT2||'.'||a.SEGMENT3,
    a.DESCRIPTION,
    b.segment1,
    a.PRIMARY_UOM_CODE,
    a.INVENTORY_ITEM_STATUS_CODE
order by
      a.SEGMENT1||'.'||a.SEGMENT2||'.'||a.SEGMENT3  
      