select 
    mt.TRANSACTION_ID, rt.transaction_type
from 
    po.rcv_shipment_headers rsh,
    po.rcv_transactions rt,
    inv.mtl_material_transactions mt
where 
    rsh.receipt_num=9611 and rt.organization_id=101
    and rsh.shipment_header_id=rt.SHIPMENT_HEADER_ID and RT.TRANSACTION_ID = mt.RCV_TRANSACTION_ID
    and DESTINATION_TYPE_CODE in ('INVENTORY') and rt.creation_date>='16-SEP-2013'

