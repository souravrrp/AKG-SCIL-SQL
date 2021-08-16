select
--    fv.value_category,
--    fv.PARENT_FLEX_VALUE_LOW,
    fv.flex_value,
    fv.FLEX_VALUE_MEANING,
    fv.DESCRIPTION--,
--    fv.attribute44 raiser_limit,
--    fv.attribute45 dept_head_limit,
--    fv.attribute46 dept_head,
--    fv.attribute47 plant_head,
--    fv.attribute48 operating_unit,
--    fv.attribute49 hr_location
from
    apps.FND_FLEX_VALUE_SETS fvs, 
    apps.FND_FLEX_VALUES_VL fv
where
    fvs.flex_value_set_name like 'AKG%Cost%'-- 'XXAKG_MO_APPROVAL_VS'
    and fvs.flex_value_set_id=fv.flex_value_set_id
--    and fv.PARENT_FLEX_VALUE_LOW='WIPR'
--    and fv.FLEX_VALUE='ROD.'
--    and rownum<10
    and fv.FLEX_VALUE_MEANING like '%6HI%'


select
    distinct fvs.flex_value_set_name
from
    apps.FND_FLEX_VALUE_SETS fvs
where fvs.flex_value_set_name like 'AKG%'
             