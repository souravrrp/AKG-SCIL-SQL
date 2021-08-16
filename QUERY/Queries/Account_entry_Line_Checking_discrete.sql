select
--    *
    mta.transaction_id,
    ood.organization_code,
    mc.segment1 item_category,
    mc.segment2 item_type,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_Code,
    msi.description,
    mta.ACCOUNTING_LINE_TYPE,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account_code_combination,
    sum(nvl(mta.PRIMARY_QUANTITY,0)) txn_qty,
    sum(nvl(mta.BASE_TRANSACTION_VALUE,0)) txn_value
from
    inv.mtl_transaction_accounts mta,
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood,
    gl.gl_code_combinations gcc
where
    mta.inventory_item_id=msi.inventory_item_id
    and mta.organization_id=msi.organization_id
    and msi.organization_id=ood.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and mmt.transaction_id=mta.transaction_id
--    and mmt.transaction_source_name='CST Account Correction'
    and mta.reference_account=gcc.code_combination_id
    and mta.transaction_id in (47702745)    
group by
    mta.transaction_id,
    ood.organization_code,
    mc.segment1,
    mc.segment2,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    mta.ACCOUNTING_LINE_TYPE,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5