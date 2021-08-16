select
    gr.ROUTING_NO,
    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')) PROD_DATE,
    gbh.batch_no,
         DECODE(gbh.BATCH_STATUS,
         -1,'CANCELED',
          1,'PENDING',
          2,'WIP',
          3,'COMPLETED',
          4,'CLOSED') BATCH_STATUS,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    msi.description,
    decode(gmd.line_type,
        -1,'Ingredient',
        1,'Product',
        2,'By Product') as Line_Type,
    mtt.transaction_type_name,
    mmt.transaction_date,
    sum(mmt.TRANSACTION_QUANTITY) Txn_Qty--,
from
    gme.gme_batch_header gbh,
    gme.gme_material_details gmd,
    gmd.gmd_routings_b gr,
    inv.mtl_system_items_b msi,
    inv.mtl_material_transactions mmt,
    inv.mtl_transaction_types mtt
where
    mmt.transaction_source_type_id = 5
    and mmt.trx_source_line_id = gmd.material_detail_id
    and mmt.transaction_source_id = gbh.batch_id
    and gmd.batch_id = gbh.batch_id
    and gmd.inventory_item_id=msi.inventory_item_id
    and gbh.organization_id=msi.organization_id
    and gbh.routing_id=gr.routing_id
    and mmt.transaction_type_id=mtt.transaction_type_id
    and gbh.organization_id=606
    and trunc(mmt.transaction_date) between '01-JUL-2014' and '31-JUL-2014'
    and gbh.BATCH_STATUS<>-1
--    and gr.routing_no='CAST PIECE FORMATION'
--    and gbh.batch_no=5429
group by
    gr.ROUTING_NO,
    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')),
    gbh.batch_no,
    gbh.BATCH_STATUS,
    gmd.line_type,
    mtt.transaction_type_name,
    mmt.transaction_date,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description
order by 2,3

    
select * from gmd.gmd_routings_b 
where 
    OWNER_ORGANIZATION_ID=99
    and rownum<10    
    
    
select * 
from 
--    gme.gme_material_details
    gme.gme_batch_header 
where rownum<10        