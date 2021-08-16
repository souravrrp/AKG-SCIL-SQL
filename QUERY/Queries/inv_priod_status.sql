select 
    ood.organization_code,
    oap.OPEN_FLAG,
    oap.*
from
    inv.ORG_ACCT_PERIODS oap,
    apps.org_organization_definitions ood,
    inv.mtl_parameters mp
where
    oap.organization_id=ood.organization_id
    and ood.organization_id=mp.organization_id
    and mp.process_enabled_flag='Y'
    and ood.legal_entity=23279
    and oap.PERIOD_SET_NAME='AKG_CAL'
    and oap.period_year='2015'
    and oap.period_num=5
--    rownum<10
    
    
    
select *
from
    all_objects
where
    object_name like '%ACCT%PERIOD%'
    and object_type='TABLE'            