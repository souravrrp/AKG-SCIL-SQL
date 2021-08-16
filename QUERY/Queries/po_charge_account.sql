select
    rsh.shipment_header_id,
    pha.segment1 po_number,
    rsh.receipt_num,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 po_charge_account
from
    po.rcv_shipment_headers rsh,
    po.rcv_shipment_lines rsl,
    po.po_headers_all pha,
    po.po_lines_all pla,
    po.po_distributions_all pda,
    gl.gl_code_combinations gcc,
    inv.mtl_system_items_b msi
where
    rsh.shipment_header_id=rsl.shipment_header_id
    and rsl.po_header_id=pha.po_header_id
    and pha.po_header_id=pla.po_header_id
    and rsl.po_line_id=pla.po_line_id
    and pda.po_header_id=pha.po_header_id
    and pda.po_line_id=pla.po_line_id
    and msi.inventory_item_id=pla.item_id
    and msi.organization_id=pda.destination_organization_id
    and pda.code_combination_id=gcc.code_combination_id
--    and pha.segment1 in ('L/CGOU/002658')
    and gcc.segment1='5112'    