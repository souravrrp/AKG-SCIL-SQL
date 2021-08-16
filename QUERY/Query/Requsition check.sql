select
prha.segment1 "Requisition Number",
prha.org_id,
prha.creation_date,
prha.authorization_status "Requisition Status",
msi.segment1||'.'||msi.segment2||'.'||msi.segment3 "Item Code",
msi.description "Item Name",
prla.quantity ,
prla.unit_price
from
apps.po_requisition_headers_all prha,
apps.po_requisition_lines_all prla,
apps.mtl_system_items_b msi
where prha.requisition_header_id=prla.requisition_header_id
and prla.item_id=msi.inventory_item_id
and prla.destination_organization_id=msi.organization_id
and  prha.segment1='120120582'  --you can use this line as  a parameter
--and prha.authorization_status='APPROVED'  --you can use this line as a parameter
--and msi.segment1||'.'||msi.segment2||'.'||msi.segment3='DRCT.STNE.0001'  --you can use this line as a parameter
--and prha.creation_date between '01-JAN-2016'  and '20-JUL-2016'  --you can use this line as a parameter
--and prha.org_id=84  --you can use this line as a parameter

select prha.*,prla.*
-- prha.segment1 requisition_number ,
-- prha.creation_date , 
-- prha.authorization_status Requisition_status,
-- prha.org_id,
-- prla.item_id,
-- item_description
 from 
 apps.po_requisition_headers_all prha,
 apps.po_requisition_lines_all prla
where prha.requisition_header_id=prla.requisition_header_id
and prha.org_id=prla.org_id
and TRUNC (TO_DATE (prha.CREATION_DATE,  'RRRR/MM/DD HH24:MI:SS')) BETWEEN '01-JAN-2016' AND '30-JUL-2016'
and DESTINATION_ORGANIZATION_ID = 101
--and prha.segment1='120114459'
--and prha.org_id=85