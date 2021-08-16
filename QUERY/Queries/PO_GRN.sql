select
    *
from PO.RCV_SHIPMENT_HEADERS rsh
where
    rownum<10
    
select
    *
from PO.RCV_TRANSACTIONS rt
where
    rownum<10   
    
select
    *
from PO.PO_HEADERS_ALL ph
where
    ph.segment1 like 'L/SCOU/%'
    and rownum<10
    
    
select
    *
from PO.PO_LINES_ALL
where
    po_header_id=256141        
    
    
select
--    rt.*
    ph.segment1 PO_NUMBER,
    pl.closed_code,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    msi.description,
    ood.organization_code,
    TO_CHAR(TRUNC(rt.transaction_date),'MON-YY') GRN_PERIOD,
    rsh.receipt_num GRN_NUMBER,
    pl.unit_price,
    pl.quantity PO_QTY,
    rt.quantity GRN_QTY
from
    PO.PO_HEADERS_ALL ph,
    PO.PO_LINES_ALL pl,
    PO.RCV_TRANSACTIONS rt,
    PO.RCV_SHIPMENT_HEADERS rsh,
    INV.MTL_SYSTEM_ITEMS_B msi,
    apps.org_organization_definitions ood
where
    ph.po_header_id=rt.po_header_id
    and ph.po_header_id=pl.po_header_id
    and rt.shipment_header_id=rsh.shipment_header_id
    and rt.organization_id=ood.organization_id
    and ood.organization_id=msi.organization_id
    and rt.organization_id=113
--    and pl.closed_code not in ('CLOSED')
    and rt.po_line_id=pl.po_line_id
    and pl.item_id=msi.inventory_item_id
--    and rt.transaction_type='DELIVER'
--    and rt.shipment_header_id=215704
--    and ph.segment1 in ('I/SCOU/000868')
--    and to_char(rt.transaction_date,'MON-YY') in ('FEB-15','MAR-15')
    and rsh.receipt_num in (3549)
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('SERV.REPR.0607')
group by
    ph.segment1,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    pl.closed_code,
    TO_CHAR(TRUNC(rt.transaction_date),'MON-YY'),
    ood.organization_code,
    rsh.receipt_num,
    pl.unit_price,
    pl.quantity,
    rt.quantity
order by 3                                 