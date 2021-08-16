select
    period_year,
    period_num,
    period_desc,
    sl.item_catg,
--    sl.item_type,
--    sl.item_code,
--    sl.item_description,
--    sl.organization_code,
--    sl.subinventory_code,
    sum(sl.primary_quantity*sl.item_cost) Period_Value
--    sl.*
from
    xxakg_inv_pbal_wcstc sl,
    apps.org_organization_definitions ood
where
    sl.ITEM_CATG in ('ELECTRICAL')--('INGREDIENT','INDIRECT MATERIAL','WIP','FINISH GOODS')
    and sl.organization_id=ood.organization_id
    and ood.LEGAL_ENTITY=23279
    and ood.operating_unit=85
--    and sl.inventory_item_id=24409
--    and sl.period_year=2014
--    and sl.period_num=4
--    and sl.organization_id=101
--    and period_desc='APR-14'
--    and rownum<10
group by
    period_year,
    period_num,
    period_desc,
    sl.item_catg--,
--    sl.item_type,
--    sl.item_code,
--    sl.item_description--,
--    sl.organization_code,
--    sl.subinventory_code
order by
    to_date(PERIOD_DESC,'MON-YY')    