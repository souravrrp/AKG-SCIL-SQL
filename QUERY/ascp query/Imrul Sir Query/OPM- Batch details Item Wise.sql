--select
--    distinct
--    organization_code,
--    process--,
--    batch_id,
--    batch_no
--    to_char(trunc(production_date),'MON-YYYY') Consumption_Period,
--    organization_id,
--    CONCATENATED_SEGMENTS,
--    DESCRIPTION,
--    LOT_NUMBER,
--    TRANS_UOM,
--    trans_qty,
--    trans_qty*ITEM_COST txn_value
--from (    


SELECT 
    r.ROUTING_NO as Process ,
    h.ACTUAL_START_DATE,
    h.actual_cmplt_date,
    h.batch_close_date, 
    h.attribute3 as Shift,
    to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS') as Production_Date,
    to_char(to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS'),'MON-YY') production_period,
    h.attribute11 Heat_number,
    t.transaction_id,
    to_char(t.transaction_date, 'DD-MON-YYYY HH24:MI:SS') as trans_date,
--t.transaction_id ,
    DECODE(h.batch_status,-1,'Cancelled',1,'Pending',2,'WIP',3,'Completed',4,'Closed') as batch_status, h.batch_id, h.batch_no as batch_no,
--t.transaction_source_id as trans_source_id, 
    decode(d.line_type,
        -1,'Ingredients',
        1,'Product',
        2,'By Product') as Line_type ,-- t.trx_source_line_id as material_detail_id,
--    t.organization_id,
    ood.organization_id,
    ood.organization_code, 
    t.subinventory_code,mc.segment1 item_category,mc.segment2 item_type,msi.inventory_item_id,msi.concatenated_segments ,msi.description,msi.primary_uom_code, mtt.transaction_type_name ,
--t.subinventory_code, 
--t.locator_id, 
    lt.lot_number as lot_number,
    lt.attribute2,lt.attribute3,lt.attribute12,
t.primary_quantity, 
case when lt.lot_number is not null then lt.transaction_quantity else t.transaction_quantity end as trans_qty,-- lt.transaction_quantity as lot_qty,
apps.fnc_get_item_cost(t.organization_id,t.inventory_item_id,to_char(trunc(t.transaction_date),'MON-YY')) item_cost,
--apps.fnc_get_item_cost(msi.organization_id,msi.inventory_item_id,to_char(trunc(to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS')),'MON-YY')) item_cost,
t.transaction_uom as trans_uom,
nvl(lot.attribute1 ,0) as "Length",lot.grade_code as "GRADE",
t.secondary_transaction_quantity as sec_qty, t.secondary_uom_code--,
--d.*
FROM 
        apps.mtl_material_transactions t, 
        apps.gme_material_details d,
        apps.gme_batch_header h,
        apps.mtl_transaction_lot_numbers lt,
        apps.mtl_lot_numbers lot,
        apps.gmd_routings_b r ,
--        apps.FM_FORM_MST ffm,
        apps.mtl_system_items_kfv msi,
        apps.mtl_transaction_types mtt,
        apps.org_organization_definitions ood,
        inv.mtl_item_categories mic,
        inv.mtl_categories_b mc
WHERE t.transaction_source_type_id = 5
--AND t.organization_id in (99)
--AND h.batch_id in (1416203)
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
and msi.inventory_item_id=mic.inventory_item_id
and msi.organization_id=mic.organization_id
and mic.category_set_id=1
and mic.category_id=mc.category_id
--and lot.grade_code ='AKS'
--and t.subinventory_code in ('WSTG C GRD')
--and d.line_type=1 
--AND H.BATCH_NO in (106084)
--and h.batch_id in ()
-- and h.attribute11='150200010'
 AND H.organization_id =ood.organization_id
-- and lt.lot_number like ('16SR15F1%')
-- and ood.operating_unit=605
 and ood.organization_code in ('CER')
 and (trunc(h.ACTUAL_START_DATE) between '01-JAN-2017' and '31-JAN-2017')-- or trunc(h.batch_close_date) between '01-SEP-2016' and '30-SEP-2016')
 --and mtt.transaction_type_name in ('WIP Issue','WIP Return') 
--    h.actual_cmplt_date,
--    h.batch_close_date,
-- and lt.attribute12 is not null
 --and msi.concatenated_segments in ('CPPD.OCTV.0001')
--and h.batch_status=2
--and r.ROUTING_NO like '%PACK%'
    --and mc.segment2 like '%RE FIRE%'
--    and mc.segment2 like '%ZINC%'
--and trunc(to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS')) between '01-JUN-2016' and '30-JUN-2016'--->'31-DEC-2015'--
--    and trunc(to_date(h.attribute4,'RRRR/MM/DD HH24:MI:SS')) between :from_date and :to_date
--and trunc(t.transaction_date) between '01-SEP-2016' and '02-SEP-2016'---<'01-AUG-2016'---
--and r.ROUTING_NO like '%BLCK%CUTTING%'
ORDER BY t.transaction_date--,h.batch_no, d.line_type , msi.concatenated_segments ,msi.description



--)
--    where
--        LINE_TYPE='Ingredients'