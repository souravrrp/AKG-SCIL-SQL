select oh.*
from
    xxakg_w_onhand_dtl_f oh,
    xxakg_w_item_master_d im
where
--    inventory_item_id=25758
   im.row_wid=oh.item_master_wid
   and im.inventory_item_id= 25758
   and im.organization_id=93
    and trunc(oh.transaction_date) between '01-APR-2015' and '30-APR-2015'
--   rownum<10    