select
    reason_id,
    reason_name,
    description,
    disable_date,
    attribute1 From_Org,
    attribute2 To_Org
from
    inv.mtl_transaction_reasons
where
--    reason_id in (100)
    attribute1='SCI' and attribute2 like 'AKC'
--    reason_name in ('299')
order by reason_name    