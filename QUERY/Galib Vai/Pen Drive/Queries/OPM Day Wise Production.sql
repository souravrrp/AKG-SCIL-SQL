select
--    bh.*
--    md.*
--    mmt.*
    r.ROUTING_NO,
    trunc(to_date(bh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')) PROD_DATE,
    bh.ATTRIBUTE3 PROD_SHIFT,
    bh.batch_no,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    decode(md.line_type,
    -1,'Ingredient',
    1,'Product',
    2,'By Product') as Line_Type,
    MTT.TRANSACTION_TYPE_NAME,
--    sum(nvl(mmt.TRANSACTION_QUANTITY,0)) Txn_Qty,
    mmt.TRANSACTION_QUANTITY,
    mmt.transaction_uom
from
    gme.gme_batch_header bh,
    gme.gme_material_details md,
    gmd.gmd_routings_b r,
    inv.mtl_system_items_b msi,
    inv.mtl_material_transactions mmt,
    inv.mtl_transaction_types mtt
where
    bh.organization_id=99
    and bh.batch_id=md.batch_id
    and bh.organization_id=md.organization_id
    and bh.organization_id=mmt.organization_id
    and md.inventory_item_id=msi.inventory_item_id
    and md.inventory_item_id=mmt.inventory_item_id
    and bh.ROUTING_ID  =  r.ROUTING_ID
    and bh.batch_id=mmt.TRANSACTION_SOURCE_ID
    and mmt.transaction_source_type_id = 5
    and mmt.transaction_type_id =MTT.TRANSACTION_TYPE_ID
    and trunc(to_date(bh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')) between '01-OCT-2013' and '31-OCT-2013'
    and r.routing_no='DRYING'
    and bh.batch_no=132
    and bh.batch_status<>-1
--    and rownum<10
group by
    r.ROUTING_NO,
    trunc(to_date(bh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')),
    bh.ATTRIBUTE3,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    MTT.TRANSACTION_TYPE_NAME,
    mmt.TRANSACTION_QUANTITY,
    mmt.transaction_uom,
    md.line_type,
    bh.batch_no    
order by
    r.ROUTING_NO,
    trunc(to_date(bh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')),
    bh.batch_no,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3


    
select * from gmd.gmd_routings_b 
where 
    OWNER_ORGANIZATION_ID=99
    and rownum<10    
    
    
select * 
from 
--    gme.gme_material_details
    gme.gme_batch_header 
where rownum<10        