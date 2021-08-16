select 
    ood.organization_code,
    rsh.receipt_num,
    rt.transaction_id,
    rt.parent_transaction_id,
    rt.transaction_type,
    rt.transaction_date,
    rt.quantity
from
    po.rcv_shipment_headers rsh,
    po.rcv_transactions rt,
    apps.org_organization_definitions ood
where
    rsh.receipt_num in (9378)    
    and rsh.ship_to_org_id=ood.organization_id
    and rt.shipment_header_id=rsh.shipment_header_id
    and ood.organization_code='SPL'
    and regexp_like (rt.transaction_type,'REC|RETURN|DEL')
--    and trunc(rt.transaction_date) between '01-MAR-2015' and '31-MAR-2015'
    
    
    
select *
from
    po.rcv_transactions
where
    shipment_header_id=323237
    and transaction_type='DELIVER'        