select
    geh.*
from
    gmf.gmf_xla_extract_headers geh--,
--    gmf.gmf_xla_extract_lines gel
where
--    geh.header_id=gel.header_id
--    and 
    geh.transaction_id in (153434)    


select
    *
from
    xla.xla_ae_headers
where
    event_id=16731414
--    rownum<10    


select
    *
from
    xla.xla_ae_lines
where
    ae_header_id= 81211125   


select
    geh.entity_code,
    geh.source_document_id,
    pha.segment1 PO_NUMBER,
    rsh.receipt_num,
    ood.organization_code,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    geh.transaction_id voucher_number,
    xel.ACCOUNTING_DATE,
    rt.transaction_type,
    rt.destination_type_code,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account_code_combination,
    xel.accounting_class_code,
    sum(nvl(xel.ACCOUNTED_DR,0)) Debits,
    sum(nvl(xel.ACCOUNTED_CR,0)) Credits,
    sum(nvl(xel.ACCOUNTED_DR,0)-nvl(xel.ACCOUNTED_CR,0)) Balance
from
    gmf.gmf_xla_extract_headers geh,
    po.rcv_shipment_headers rsh,
    po.rcv_transactions rt,
    po.po_headers_all pha,
    po.po_lines_all pla,
    po.po_distributions_all pda,
    xla.xla_ae_headers xeh,
    xla.xla_ae_lines xel,
    gl.gl_code_combinations gcc,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood
where
    geh.event_id=xeh.event_id
    and xeh.ae_header_id=xel.ae_header_id
    and xel.code_combination_id=gcc.code_combination_id
    and geh.organization_id=ood.organization_id
    and ood.organization_code=:org_code
    and ood.operating_unit=:operating_unnit
    and geh.organization_id=ood.organization_id
    and geh.organization_id=rt.organization_id
    and geh.source_document_id=rsh.shipment_header_id
    and geh.organization_id=rsh.ship_to_org_id
    and rt.transaction_type in ('DELIVER','RETURN TO RECEIVING')
    and rt.shipment_header_id=rsh.shipment_header_id
    and rt.po_header_id=pha.po_header_id
    and rt.po_line_id=pla.po_line_id
    and pha.po_header_id=pla.po_header_id
    and pda.po_header_id=pha.po_header_id
    and pda.po_line_id=pla.po_line_id
    and geh.inventory_item_id=pla.item_id
    and geh.organization_id=pda.destination_organization_id
    and geh.inventory_item_id=msi.inventory_item_id
    and geh.organization_id=msi.organization_id
    and geh.entity_code='PURCHASING'
    and rsh.receipt_num=:grn_number
--    and geh.event_class_code='ACTCOSTADJ'
--    and trunc(geh.transaction_date) between '01-JUN-2014' and '30-NOV-2014'
--    and geh.transaction_id in (40271092)
--    and geh.ENTITY_CODE='PURCHASING'
--    and geh.source_document_id in (30453031)    ---- Shipment_header_id
--    and gcc.segment3='2050110'
group by
    geh.entity_code,
    geh.source_document_id,
    pha.segment1 ,
    rsh.receipt_num,
    ood.organization_code,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    geh.transaction_id,
    xel.ACCOUNTING_DATE,
    rt.transaction_type,
    rt.destination_type_code,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5,
    xel.accounting_class_code--,
order by     
    geh.source_document_id--,
--    geh.transaction_id