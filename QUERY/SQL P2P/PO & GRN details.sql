select distinct
pha.segment1 "PO Number",
rsh.receipt_num "GRN Number",
rt.transaction_id,
ood.organization_code,
pla.purchase_basis "Line Type",
pda.destination_type_code,
pha.type_lookup_code "PO Type",
pha.authorization_status,
TO_CHAR (TRUNC(pha.creation_date), 'DD-MON-RR') CREATION_DATE,
        TO_CHAR (TRUNC(pha.last_update_date), 'DD-MON-RR') LAST_UPDATE_DATE,
        TO_CHAR (TRUNC(pha.approved_date), 'DD-MON-RR') APPROVED_DATE,
        decode(pll.match_option,
                    'R', 'Receipt',
                    'P', 'PO') invoice_match_option,
        pll.receipt_required_flag,
        pda.accrue_on_receipt_flag,
rsh.shipment_num,
rt.subinventory,
rt.transaction_id,
rt.parent_transaction_id,
rt.transaction_type,
rt.quantity,
TO_CHAR (TRUNC(rsh.creation_date), 'DD-MON-RR') GRN_CREATION,
TO_CHAR (TRUNC(rt.transaction_date), 'DD-MON-RR') transaction_date,
ppf.employee_number,
ppf.full_name,
--pha.approved_date,
pv.segment1 "Supplier ID",
pv.vendor_name "Supplier Name",
pla.line_num,
msi.segment1||'.'||msi.segment2||'.'||msi.segment3 "Item Code",
pla.item_description,
pla.unit_meas_lookup_code "UOM",
pha.currency_code,
pla.quantity,
pla.unit_price,
pla.quantity*pla.unit_price amount,
gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 "Natural Accounts"
from
 apps.po_headers_all pha,
 apps.po_lines_all pla,
 apps.po_distributions_all pda,
 apps.po_line_locations_all pll,
 apps.mtl_system_items_vl msi,
 apps.gl_code_combinations gcc,
 apps.rcv_transactions rt,
 apps.rcv_shipment_headers rsh,
 apps.org_organization_definitions ood,
 apps.ap_suppliers pv,
 apps.fnd_user fu,
 apps.per_people_f ppf
where
 pha.po_header_id=pla.po_header_id
 and pla.po_header_id=pda.po_header_id
 and pla.po_line_id=pda.po_line_id
 and pha.po_header_id=pll.po_header_id
 and pla.po_line_id=pll.po_line_id
 and pla.item_id=msi.inventory_item_id(+)
 and pda.destination_organization_id=msi.organization_id
 and pda.code_combination_id=gcc.code_combination_id
 and pla.po_line_id=rt.po_line_id(+)
 and rt.shipment_header_id=rsh.shipment_header_id(+)
-- and pv.segment1 in (4800)
-- and rt.transaction_date between '01-JAN-2011' and '16-MAY-2018'
 and pha.segment1 in ('I/SCOU/002616')
-- and rsh.receipt_num in (2701)
-- and rt.shipment_header_id=768930
-- and ood.organization_name like '%Marble%'
-- and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('PACK.MAT0.0142')
--'ELEC.ELEC.2716',
--'ELEC.ELEC.2730',
--'ELEC.ELEC.2722',
--'ELEC.ELEC.2722',
--'ELEC.ELEC.2731',
--'ELEC.ELEC.2731',
--'ELEC.ELEC.2716',
--'ELEC.ELEC.2721',
--'ELEC.ELEC.2721')
-- and pla.line_num=1
-- and rt.transaction_type='RECEIVE'
 and ood.organization_id=pda.destination_organization_id
 and pda.destination_organization_id=rsh.ship_to_org_id
 and pha.vendor_id=pv.vendor_id
-- and ood.organization_code='SCS'
 and rt.created_by=fu.user_id
 and fu.user_name=ppf.employee_number
 and sysdate between ppf.effective_start_date and ppf.effective_end_date
order by pla.line_num,
rsh.receipt_num,
            rt.transaction_id


select * from apps.rcv_shipment_headers




select 
--    rsh.*
    rsh.shipment_num
    ,rsh.receipt_num
    ,rsh.attribute_category
    ,rsh.attribute1
    ,rt.transaction_type
    ,rt.transaction_date
    ,rt.quantity
from
    apps.rcv_shipment_headers rsh
    ,apps.rcv_transactions rt
where 1=1
    and rsh.receipt_num = 40116
    and rsh.receipt_source_code = 'INVENTORY'
    and rsh.shipment_header_id = rt.shipment_header_id
    and rsh.ship_to_org_id = rt.organization_id
order by
    rt.transaction_id