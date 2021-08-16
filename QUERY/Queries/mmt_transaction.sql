select
--    *
    mmt.transaction_id,
    mtt.transaction_type_name,
    mmt.transaction_source_id,
    mmt.transaction_source_name,
    mc.segment1 item_category,
    mc.segment2 item_type,
    mmt.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
    mtln.lot_number,
    ood1.organization_code,
    ood2.organization_code transfer_organization,
    mmt.subinventory_code,
    mmt.transfer_subinventory,
    mmt.transaction_date,
    to_char(trunc(mmt.transaction_date),'MON-YY') Txn_period,
--    mmt.transaction_quantity,
    mmt.primary_quantity--,
--    apps.fnc_get_item_cost(mmt.organization_id,mmt.inventory_item_id,to_char(trunc(mmt.transaction_date),'MON-YY')) item_cost--,
--    nvl(mmt.transaction_cost,mmt.actual_cost) txn_cost
--    mmt.*
from
    inv.mtl_material_transactions mmt,
    inv.mtl_transaction_lot_numbers mtln,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    inv.mtl_transaction_types mtt,
    apps.org_organization_definitions ood1,
    apps.org_organization_definitions ood2
where
--    mmt.transaction_id in ()
--    and 
--    ood1.legal_entity=ood2.legal_entity
--    and ood1.legal_entity=23279
    ood1.operating_unit=83
    and msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and ood1.organization_id=mmt.organization_id
--    and mmt.organization_id=93
    and ood1.organization_code='CER'
    and mmt.transaction_type_id=mtt.transaction_type_id
    and mmt.transfer_organization_id=ood2.organization_id(+)
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and mmt.transaction_id=mtln.transaction_id
--    and mc.segment1 in ('WIP')
--    and mc.segment2 like 'UNPACKED%'
--    and mmt.transaction_source_type_id=5
--    and mmt.transaction_source_name ='CGD SALES PROMOTION ADJ'
--    and mmt.transaction_source_id=888846
    and trunc(mmt.transaction_date) between '19-MAY-2015' and '19-MAY-2015'
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('DRCT.CLAY.0005')
    and mmt.subinventory_code='CER-SP FLR'
--    and logical
--    and mmt.transaction_type_id=3
--    and trunc(mmt.creation_date)>'30-APR-2015'
--    and trunc(mmt.transaction_date)='30-APR-2015'
--    and mmt.transaction_type_id=32
--    and to_char(trunc(mmt.transaction_date),'MON-YY')='MAY-15'
--    and mtt.TRANSACTION_TYPE_NAME = 'Sales order issue'
--    and mmt.logical_transaction is null
--    and mmt.transaction_type_id=42--32--105
--    transaction_set_id=2278720
--    and mmt.transaction_id in  (select distinct voucher_number--*
--from
--    apps.xxakg_gl_details_statement_mv
--where
--    company='5331'
--    and account='4020101'
--    and je_category='OPM Shipments'--'OPM/OM Shipments'
--    and trunc(voucher_date) <'01-MAR-2015'
--    )
--    and mmt.transfer_transaction_id in (41478739)
--    and mmt.transaction_source_type_id=5
--    and mtt.transaction_type_name like 'Misc%'
--    and transaction_source_id=824428
--    and mmt.transaction_source_name='GL vs SL Reconciliation'
--    and mmt.transaction_source_name='Physical vs Oracle Adj'
--    and  mmt.transaction_id in (2232947)
--    and mmt.inventory_item_id=241594
--    and mmt.transaction_id in () 
--    and rownum<10    
order by mmt.transaction_id
