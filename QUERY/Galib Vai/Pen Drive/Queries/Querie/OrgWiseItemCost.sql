select 
--* 
    ITEM_CATEGORY,
    ITEM_TYPE,
    ORGANIZATION_CODE,
    sum(ITEM_COST) ITEM_COST
from apps.akg_bi_item_cost_details
where 
--organization_id =:p_org
--and item_code =:item_code
--and 
OPERATING_UNIT=:OPERATING_UNIT
and PERIOD_DESC='JUNE -13'
--and ITEM_CATEGORY in ('INGREDIENT','FINISH GOODS')
group by
    ITEM_TYPE,
    ITEM_CATEGORY,
    ORGANIZATION_CODE
order by
    ITEM_CATEGORY,
    ITEM_TYPE,
    ORGANIZATION_CODE
    
    
    
select distinct ITEM_CATEGORY from apps.akg_bi_item_cost_details
