SELECT 
    r.ROUTING_NO as Process ,
    h.ACTUAL_START_DATE,
    h.actual_cmplt_date,
    h.batch_close_date, 
    h.attribute3 as Shift,
    to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS') as Production_Date,
    t.transaction_id,
    to_char(t.transaction_date, 'DD-MON-YYYY HH24:MI:SS') as trans_date,
--t.transaction_id ,
    DECODE(h.batch_status,-1,'Cancelled',1,'Pending',2,'WIP',3,'Completed',4,'Closed') as batch_status, h.batch_no as batch_no,
--t.transaction_source_id as trans_source_id, 
    decode(d.line_type,
        -1,'Ingredients',
        1,'Product',
        2,'By Product') as Line_type ,-- t.trx_source_line_id as material_detail_id,
    t.organization_id, msi.concatenated_segments ,msi.description, mtt.transaction_type_name ,
--t.subinventory_code, 
--t.locator_id, 
    lt.lot_number as lot_number,
--t.primary_quantity, 
case when lt.lot_number is not null then lt.transaction_quantity else t.transaction_quantity end as trans_qty,-- lt.transaction_quantity as lot_qty,
apps.fnc_get_item_cost(msi.organization_id,msi.inventory_item_id,to_char(trunc(to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS')),'MON-YY')) item_cost,
t.transaction_uom as trans_uom,
nvl(lot.attribute1 ,0) as "Length",lot.grade_code as "GRADE",
t.secondary_transaction_quantity as sec_qty, t.secondary_uom_code
FROM 
        apps.mtl_material_transactions t, 
        apps.gme_material_details d,
        apps.gme_batch_header h,
        apps.mtl_transaction_lot_numbers lt,
        apps.mtl_lot_numbers lot,
        apps.gmd_routings_b r ,
        apps.mtl_system_items_kfv msi,
        apps.mtl_transaction_types mtt
WHERE t.transaction_source_type_id = 5
--AND t.organization_id in (99)
--AND h.batch_id in (XXXXXX)
AND t.transaction_source_id = h.batch_id
AND t.organization_id = h.organization_id
AND d.batch_id = h.batch_id
AND d.material_detail_id = t.trx_source_line_id
AND lt.transaction_id(+) = t.transaction_id 
AND lot.lot_number(+) = lt.lot_number 
AND lot.organization_id(+) = lt.organization_id
AND lot.inventory_item_id(+) = lt.inventory_item_id
AND r.routing_id =h.routing_id 
AND r.owner_organization_id =h.organization_id 
AND d.inventory_item_id =msi.inventory_item_id 
and d.organization_id =msi.organization_id
AND t.transaction_type_id =mtt.transaction_type_id 
AND H.BATCH_NO in (30859)
--and h.batch_id in (715021)
 AND H.organization_id in (99)
-- and msi.concatenated_segments='EBAG.SBAG.0001'
and h.batch_status<>-1
--and r.ROUTING_NO in ('CAN BODY MAKING-1',
--'CAN BODY MAKING-2',
--'CAN TOP BOTTOM MAKING -1',
--'CAN TOP BOTTOM MAKING -2')
--and trunc(to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS')) between '01-OCT-2014' and '31-OCT-2014'
    and trunc(to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS')) between :from_date and :to_date
--and to_char(t.transaction_date, 'DD-MON-YYYY HH24:MI:SS')>'30-NOV-2013 23:59:59'
--and r.ROUTING_NO='SPRAY'
ORDER BY h.batch_no,  line_type , msi.concatenated_segments ,msi.description