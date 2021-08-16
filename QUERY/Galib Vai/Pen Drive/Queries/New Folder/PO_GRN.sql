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
    rsh.shipment_header_id,
    ph.po_header_id,
    ph.segment1 PO_NUMBER,
    lc.lc_number,
    pl.closed_code,
    mc.segment1 Item_category,
    mc.segment2 Item_type,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    msi.description,
    msi.primary_uom_code,
    ood.organization_id,
    ood.organization_code,
    rt.transaction_id,
    rt.transaction_date,
    TO_CHAR(TRUNC(rt.transaction_date),'MON-YY') GRN_PERIOD,
    rsh.receipt_num GRN_NUMBER,
    pl.unit_price,
    ph.CURRENCY_CODE,
    decode(ph.CURRENCY_CODE,'BDT',pl.unit_price,pl.unit_price*ph.rate) unit_price_BDT,
    pl.quantity PO_QTY,
    rt.transaction_type,
    rt.quantity GRN_QTY
from
    PO.PO_HEADERS_ALL ph,
    PO.PO_LINES_ALL pl,
    PO.RCV_TRANSACTIONS rt,
    PO.RCV_SHIPMENT_HEADERS rsh,
    INV.MTL_SYSTEM_ITEMS_B msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood,
    apps.xxakg_lc_details lc
where
    ph.po_header_id=rt.po_header_id
    and ph.po_header_id=pl.po_header_id
    and rt.shipment_header_id=rsh.shipment_header_id
    and rt.organization_id=ood.organization_id
    and ood.organization_id=msi.organization_id
--    and ood.legal_entity=24273
--    and ood.operating_unit=584
--    and ood.organization_code='CER'
    and ph.segment1=lc.po_number(+)
--    and rt.organization_id=965
--    and pl.closed_code not in ('CLOSED')
    and rt.po_line_id=pl.po_line_id
    and pl.item_id=msi.inventory_item_id
--    and ph.segment1 in ()
--    and ph.po_header_id=756316
--    and rt.transaction_type='DELIVER'
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_set_id=1
    and mic.category_id=mc.category_id
--    and ph.segment1 in ('L/SCOU/011721')
--    and rt.shipment_header_id in ()
--    and ph.segment1 in ('L/COU/004508')
--    and to_char(rt.transaction_date,'MON-YY') in ('JAN-16')
--    and trunc(rt.transaction_date) between '01-JAN-2016' and '31-JAN-2016'---<'01-DEC-2015'--
--    and rsh.receipt_num in (18)
    and rt.transaction_id in (1101470)
--    and ph.po_header_id in ()
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3  in ('PACK.MAT0.0149')
group by
    ph.po_header_id,
    ood.organization_id,
    ph.segment1,
    lc.lc_number,
    mc.segment1,
    mc.segment2,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    rt.transaction_id,
    pl.closed_code,
    rt.transaction_date,
    TO_CHAR(TRUNC(rt.transaction_date), 'MON-YY'),
--    TO_CHAR(TRUNC(rt.transaction_date),'MON-YY'),
    ood.organization_code,
    rsh.receipt_num,
    ph.CURRENCY_CODE,
    ph.rate,
    pl.unit_price,
    pl.quantity,
    msi.primary_uom_code,
    rt.transaction_type,
    rt.quantity,
    ph.po_header_id,
    rsh.shipment_header_id
order by 9