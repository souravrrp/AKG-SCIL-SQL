select
    pha.segment1 PO_NUMBER,
    rsh.receipt_num,
    trunc(mmt.transaction_date) GRN_DATE,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
    msi.description,
    lt.lot_number,
    pla.quantity,
    mmt.primary_quantity,
    mmt.transaction_quantity,
    lt.transaction_quantity lot_quantity,
    pla.unit_price,
    mmt.transaction_cost
--    mmt.*
from
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    apps.org_organization_definitions ood,
    apps.mtl_transaction_lot_numbers lt,
    po.rcv_shipment_headers rsh,
    po.rcv_transactions rt,
    po.po_headers_all pha,
    po.po_lines_all pla
where
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('DCTB.FPDC.0001','DCTB.TPDC.0001','DCTB.THDC.0001')
    and msi.inventory_item_id=mmt.inventory_item_id
     and msi.organization_id=mmt.organization_id
     and msi.organization_id=ood.organization_id
     and ood.operating_unit=665
     and mmt.transaction_id=lt.transaction_id
     and mmt.organization_id=lt.organization_id
     and mmt.inventory_item_id=lt.inventory_item_id
     and mmt.transaction_type_id=18   
     and mmt.transaction_source_id=pha.po_header_id
     and pha.po_header_id=pla.po_header_id
     and msi.inventory_item_id=pla.item_id
     and rt.po_header_id=pha.po_header_id
     and rt.po_line_id=pla.po_line_id
     and rt.transaction_id=mmt.rcv_transaction_id
     and rsh.shipment_header_id=rt.shipment_header_id