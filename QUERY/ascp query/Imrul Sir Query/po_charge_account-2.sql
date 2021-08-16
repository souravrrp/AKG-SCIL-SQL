select
    pha.segment1 po_number,
    pha.po_header_id,
    pla.po_line_id,
    pda.po_distribution_id,
    msi.organization_id,
    ood.organization_code,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description ,
    pda.code_combination_id,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 po_charge_account
--    pda.*
from
    po.po_headers_all pha,
    po.po_lines_all pla,
    po.po_distributions_all pda,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood,
    gl.gl_code_combinations gcc
where
    pha.segment1 in ('L/COU/003643')
     and pha.po_header_id=pla.po_header_id
    and pla.item_id=msi.inventory_item_id
    and pla.po_line_id=pda.po_line_id
    and msi.organization_id=pda.destination_organization_id
    and msi.organization_id=ood.organization_id
    and pda.code_combination_id=gcc.code_combination_id
    and pda.GL_CANCELLED_DATE is null    