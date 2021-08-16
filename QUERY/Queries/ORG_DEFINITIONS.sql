select 
--    *
    ood.ORGANIZATION_ID,
    ood.ORGANIZATION_CODE,
    ood.ORGANIZATION_NAME,
    oap.OPEN_FLAG,
    ood.OPERATING_UNIT,
    ood.SET_OF_BOOKS_ID,
    ood.LEGAL_ENTITY,
    ood.*
from 
    INV.ORG_ACCT_PERIODS oap,
    APPS.ORG_ORGANIZATION_DEFINITIONS ood
where
    ood.disable_date is null
    and ood.SET_OF_BOOKS_ID=2022
    and oap.organization_id=ood.organization_id
    and ood.organization_code='MLT'
--    and oap.PERIOD_NAME='FEB-15'
--    and oap.OPEN_FLAG
--    AND 
--    ORGANIZATION_ID=
--    AND 
--    and ORGANIZATION_CODE='DL9'
order by
        ood.ORGANIZATION_ID
        