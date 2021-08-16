select
    *
--    a.FLEX_VALUE,
--    a.FLEX_VALUE_MEANING,
--    a.DESCRIPTION
from 
    APPS.FND_FLEX_VALUES_VL a,
    APPLSYS.FND_FLEX_VALUE_SETS b
where
    A.FLEX_VALUE_SET_ID=B.FLEX_VALUE_SET_ID
    and B.FLEX_VALUE_SET_NAME = 'AKG_ITEM_TYPE'
--    and a.flex_value like '%SEAT%' 
--    or 
--    and  regexp_like (a.flex_value,'PED.*|WASH BASIN.*')
--    and rownum<10  
order by
    a.flex_value  
    
    
select
    *
from APPLSYS.FND_FLEX_VALUES_TL
where
    rownum<10   
    
    
select
    *
from APPLSYS.FND_FLEX_VALUES
where
    flex_value like '%SEAT%'
    and rownum<10
    
select
    *
from APPLSYS.FND_FLEX_VALUE_SETS
where
    FLEX_VALUE_SET_NAME like '%AKG_ITEM_TYPE%'
    and rownum<10             