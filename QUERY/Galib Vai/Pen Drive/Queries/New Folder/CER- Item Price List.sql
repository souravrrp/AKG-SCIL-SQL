
select
    ph.name,
--    pl.*
--    mc.segment1||'|'||mc.segment2 Category_code,
    pl.PRODUCT_ATTR_VAL_DISP,
    pl.list_price_uom_code,
    pl.OPERAND unit_price,
    pl.list_price,
    pl.START_DATE_ACTIVE,
    pl.END_DATE_ACTIVE
from
    apps.qp_secu_list_headers_v ph,
    apps.qp_list_lines_v pl,
    inv.mtl_categories_b mc
where
    ph.NAME  =:price_list_name ----like '%SCI%Transfer%Pricelist%'--'AKG Ceramic Price List'
    and ph.list_header_id=pl.list_header_id
    and pl.product_attr_value=mc.category_id
    and pl.END_DATE_ACTIVE is null
--    and pl.INVENTORY_ITEM_ID is not null
--    and mc.segment1||'|'||mc.segment2 in ()
--    and mc.segment2 in ('WATER CLOSET MARCELLA-P TRAP-B')
--    and rownum<10
    
    
                 