select 
--    distinct
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    mmt.transaction_source_type_id,
    mtt.transaction_type_id,
    mtt.transaction_type_name,
    mmt.transaction_id,
    mmt.parent_transaction_id,
    mmt.*
--    distinct mmt.LOGICAL_TRANSACTION
from
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood,
    inv.mtl_transaction_types mtt
where
--    transaction_id=34061084
--    TRANSACTION_SOURCE_ID=648300
--    transfer_transaction_id=34061084
    msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and msi.organization_id=ood.organization_id
    and mmt.transaction_type_id=mtt.transaction_type_id
    and ood.organization_code='BFD'
    and ood.operating_unit=665
    and mmt.transaction_type_id in (15)
--    and mmt.transaction_source_type_id=12
--    and trunc(mmt.transaction_date) between '01-FEB-2015' and '28-FEB-2015'
--    and logical_transaction=1
--    and PARENT_TRANSACTION_ID=34061084
order by mmt.transaction_source_type_id





select *
from
    inv.mtl_material_transactions
where
    transaction_id=34164617
--    transaction_set_id=34164615
        
    
    
select *
from
    gl.gl_code_combinations
where
    code_combination_id=408385        