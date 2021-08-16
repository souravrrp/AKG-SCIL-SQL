select
    mmtt.transaction_temp_id,
    ood.set_of_books_id,
    ood.organization_code,
    mmtt.organization_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    mtst.transaction_source_type_name,
    mmtt.transaction_source_id,
    gbh.batch_no
from
    inv.mtl_material_transactions_temp mmtt,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood,
    inv.mtl_txn_source_types mtst,
    gme.gme_batch_header gbh
where
    trunc(mmtt.transaction_date) between '01-AUG-2015' and '31-AUG-2015'
    and mmtt.organization_id=ood.organization_id
    and mmtt.inventory_item_id=msi.inventory_item_id
    and mmtt.organization_id=msi.organization_id
    and ood.organization_code='CER'
    and mmtt.transaction_source_type_id=mtst.transaction_source_type_id
   -- and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('RPWC.VRNW.0001')
    and mmtt.organization_id=gbh.organization_id
    and mmtt.transaction_source_id=gbh.batch_id
    and transaction_source_type_name in ('Job or Schedule')
--    and gbh.batch_no=50875