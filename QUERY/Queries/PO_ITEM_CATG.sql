select
--    *
    pha.segment1 PO_NUMBER,
    pha.CLOSED_CODE,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    msi.description,
    mc.segment1 ITEM_CATG,mc.segment2 Item_type,
    pla.quantity
--    decode(msi.item_type,
--        'FG', 'Finished Good',
--        'P', 'Purchased Item',
--        'NS','Non Stockable Item') ITEM_TYPE
from 
    PO.PO_HEADERS_ALL pha,
    PO.PO_LINES_ALL pla,
    po.po_distributions_all pda,
    INV.MTL_SYSTEM_ITEMS_B msi,
    INV.MTL_ITEM_CATEGORIES mic,
    INV.MTL_CATEGORIES_B mc
where
    pha.po_header_id=pla.po_header_id
    and pda.po_header_id=pha.po_header_id
    and pda.po_line_id=pda.po_line_id
    and pda.DESTINATION_ORGANIZATION_ID=msi.organization_id
    and pla.item_id=msi.inventory_item_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and pha.segment1 in ('I/SCOU/000867')
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('MECH.FLUX.0001')
group by
    pha.segment1,
    pha.CLOSED_CODE,
    msi.segment1,msi.segment2,msi.segment3,
    msi.description,
    mc.segment1,mc.segment2,
    msi.item_type,
    pla.quantity
order by
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3





select * from PO.PO_HEADERS_ALL where rownum<10

select * from PO.PO_lines_ALL where rownum<10

select * from INV.MTL_CATEGORIES_B where rownum<10

select * from INV.MTL_SYSTEM_ITEMS_B msi
where 
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3='MACH.MCHN.0031'
--    rownum<10