select
    ood.organization_id,
    ood.organization_code,
    rsh.shipment_header_id,
    rsl.shipment_line_id,
    mc.segment1 item_category,
    mc.segment2 item_type,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    rt.source_document_code,
    pha.po_header_id,
    pha.segment1 po_number,
    rsh.receipt_num,
    rt.transaction_id rcv_transaction_id,
    rt.parent_transaction_id,
    decode(rt.parent_transaction_id,
                -1,null,
                rt1.transaction_type) parent_transaction_type,
    rt.transaction_type,
    rt.destination_type_code,
    rt.transaction_date,
    rt.quantity transaction_qty,
    rt.unit_of_measure txn_uom,
    rt.primary_quantity,
    rt.PRIMARY_UNIT_OF_MEASURE,
    (select
        gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5
    from gl.gl_code_combinations gcc
    where
        code_combination_id=pda.code_combination_id)
     charge_account,
     (select
        gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5
    from gl.gl_code_combinations gcc
    where
        code_combination_id=pda.ACCRUAL_ACCOUNT_ID)
     acrual_account--,
--    gcc1.segment1||'.'||gcc1.segment2||'.'||gcc1.segment3||'.'||gcc1.segment4||'.'||gcc1.segment5 acrual_account--,
--    rt.*
--    rsh.*
from
    po.rcv_shipment_headers rsh,
    po.rcv_shipment_lines rsl,
    po.rcv_transactions rt,
    po.rcv_transactions rt1,
    inv.mtl_system_items_b msi,
    inv.mtl_categories_b mc,
    po.po_headers_all pha,
--    po.po_lines_all pla,
    po.po_distributions_all pda,
--    gl.gl_code_combinations gcc,
--    gl.gl_code_combinations gcc1,
    apps.org_organization_definitions ood
where
    rsh.receipt_num in (1599)
--    rsh.shipment_header_id=599470
    and 
    rsh.shipment_header_id=rsl.shipment_header_id
    and rt.shipment_header_id=rsh.shipment_header_id
    and rt.shipment_line_id=rsl.shipment_line_id
    and rt.parent_transaction_id=rt1.transaction_id(+)
    and rt.destination_type_code='DELIVER'
    and rsl.category_id=mc.category_id
    and rsl.item_id=msi.inventory_item_id
    and msi.organization_id=rsh.ship_to_org_id
    and pha.po_header_id=rt.po_header_id
    and pda.po_distribution_id(+)=rt.po_distribution_id
--    and pda.code_combination_id=gcc.code_combination_id(+)
--    and pda.ACCRUAL_ACCOUNT_ID=gcc1.code_combination_id(+)
    and ship_to_org_id=ood.organization_id    
    and ood.organization_code='CON'
order by
     rt.transaction_id   
    

select
from
    po.rcv_transactions
where
        