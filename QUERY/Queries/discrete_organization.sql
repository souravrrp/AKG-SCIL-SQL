    
select
    ood.operating_unit,
--    decode(ood.operating_unit,
--    82,'AKCOU',
--    83,'COU',
--    84,'RMCOU',
--    85,'SCOU',
--    86,'FSOU',
--    87,'LSOU',
--    189,'SPOU',
--    )
    ood.organization_id,
    ood.organization_code,
    ood.organization_name
from
    apps.org_organization_definitions ood,
    inv.mtl_parameters mp
where
    ood.legal_entity=23280
--    and ood.operating_unit=82  
    and mp.PROCESS_ENABLED_FLAG='N'
    and ood.organization_id=mp.organization_id
    and ood.disable_date is null
              