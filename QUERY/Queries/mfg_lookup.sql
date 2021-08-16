select 
    lookup_type,
    lookup_code,
    meaning,
    description,
    attribute1,
    attribute2,
    enabled_flag,
    start_date_active,
    end_date_active
--    mlv.*
from
    apps.FND_LOOKUP_VALUES_VL mlv
where
--    ATTRIBUTE_CATEGORY='AKG_BATCH_SUBINVENTORY_RES'
--    and 
    LOOKUP_TYPE='AKG_BATCH_SUBINVENTORY_RES'
    and attribute1='CER'
    and ATTRIBUTE2 ='CER-FG STR'
    and end_date_active is null
--    and description in ('WB','PD')
--    and rownum<10    