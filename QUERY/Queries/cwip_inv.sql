select
    ood1.organization_code,
    ood2.organization_code transfer_organization,
    mmt.subinventory_code,
    mmt.transfer_subinventory,
    mmt.transaction_id,
    mtst.transaction_source_type_name,
    mtt.transaction_type_name,
    mmt.SOURCE_CODE,
    mmt.rcv_transaction_id,
    mmt.transaction_source_id,
    mc.segment1 category_code_segment1,
    mc.segment2 category_code_segment2,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    nvl(mmt.transaction_quantity,mmt.primary_quantity) txn_quantity,
    nvl(mmt.transaction_cost,mmt.actual_cost) txn_unit_cost,
    mmt.*
from
    inv.mtl_material_transactions mmt,
    inv.mtl_txn_source_types mtst,
    inv.mtl_transaction_types mtt,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood1,
    apps.org_organization_definitions ood2,
    pa.pa_projects_all pja,
    pa.pa_tasks pt,
    gl.gl_code_combinations gcc
where
    mmt.organization_id=ood1.organization_id
    and ood1.organization_code='AKM'
    and mmt.transaction_source_type_id=mtst.transaction_source_type_id
    and mmt.transaction_type_id=mtt.transaction_type_id
    and msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_set_id=1
    and mic.category_id=mc.category_id
    and mmt.source_project_id=pja.project_id(+)
    and mmt.source_task_id=pt.task_id(+)    
    and mmt.transfer_organization_id=ood2.organization_id
    and mmt.distribution_account_id=gcc.code_combination_id