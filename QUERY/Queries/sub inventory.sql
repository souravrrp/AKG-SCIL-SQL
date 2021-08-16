MTL_SECONDARY_INVENTORIES_FK_V 


select
--    *
    secondary_inventory_name,
    description 
from INV.MTL_SECONDARY_INVENTORIES 
where 
    organization_id=101
    and secondary_inventory_name like 'LN%'
--    and rownum<10