--select distinct routing_no from (
select
    gr.routing_no,
    mmt.transaction_id,
    trunc(mmt.transaction_date) txn_date,
    to_char(trunc(mmt.transaction_date),'MON-YY') txn_period,
    mmt.organization_id,
    ood.organization_code,
    mtst.transaction_source_type_name,
    mtt.transaction_type_name,
    gbh.batch_id,
    gbh.batch_no,
         DECODE(gbh.BATCH_STATUS,
         -1,'CANCELED',
          1,'PENDING',
          2,'WIP',
          3,'COMPLETED',
          4,'CLOSED') BATCH_STATUS,
    mc.segment1 item_category,
    mc.segment2 item_type,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
    msi.description Item_description,
    msi.primary_uom_code,
    mmt.primary_quantity,
    apps.fnc_get_item_cost(mmt.organization_id,mmt.inventory_item_id,to_char(trunc(mmt.transaction_date),'MON-YY')) Item_Cost
from
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood,
    inv.mtl_txn_source_types mtst,
    inv.mtl_transaction_types mtt,
    gme.gme_batch_header gbh,
    apps.gmd_routings_b gr
where
    mmt.inventory_item_id=msi.inventory_item_id
    and mmt.organization_id=msi.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and mmt.transaction_source_type_id=mtst.transaction_source_type_id
    and mmt.transaction_type_id=mtt.transaction_type_id
    and mmt.organization_id=ood.organization_id
    and mmt.transaction_source_id=gbh.batch_id
    and mmt.organization_id=gbh.organization_id
    and gbh.routing_id=gr.routing_id
    and ood.operating_unit=83
    and trunc(mmt.transaction_date) between '17-APR-2015' and '27-APR-2015'
--    and to_char(trunc(mmt.transaction_date),'MON-YY')='DEC-14'
--    and trunc(mmt.transaction_date) <'01-JAN-2015'
    and mmt.transaction_source_type_id=5
    and gbh.BATCH_STATUS<>-1
    and mtt.transaction_type_name in ('WIP Issue','WIP Return')
--    and mc.segment1 in ('INGREDIENT','INDIRECT MATERIAL','LAB AND CHEMICAL')
--    and mc.segment1 in ('INGREDIENT','INDIRECT MATERIAL')
--    and mc.segment2 like 'HR%COIL%'
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('DRCT.ALUM.0001')    
--    and gr.routing_no not in ('CASE MOULD MIXTURE PREPARATION','WRK MOULD MIXTURE PREPARATION')
--    and gr.routing_no in ('SLIP PREPARATION','GLAZE PREPARATION- NORMAL')
--    and gr.routing_no like ('CAST%')
--    )
