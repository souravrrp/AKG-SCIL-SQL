SELECT
*
FROM
APPS.fnd_lookup_types_vl

select
*
from
apps.fnd_application_tl

select
*
from
apps.fnd_common_lookup_types     

select
*
from
apps.fnd_lookups


select
*
from
apps.fnd_lookup_VALUES
WHERE 1=1
--AND LOOKUP_CODE='DO/SCOU/1013953'


SELECT   fcl.lookup_type            "Type" 
,        fcl.lookup_code            "Code" 
-- ,        fcl.meaning                "Meaning"
,        to_char(fcl.creation_date)          "Created"
,        fu.user_name               "Created by" 
FROM     apps.fnd_common_lookup_types     fclt 
,        apps.fnd_common_lookups          fcl 
,        apps.fnd_user                    fu 
WHERE    trunc(NVL(end_date_active 
                  ,sysdate)) 
>=       trunc(SYSDATE) 
AND      fcl.lookup_type           = fclt.lookup_type(+) 
AND      fu.user_id                = fcl.created_by 
AND      fcl.created_by            NOT IN (2,1,-1) 
ORDER BY fcl.lookup_type 
,        fcl.lookup_code




select * 
  from apps.fnd_lookup_types flt
 where exists ( select 1 from apps.fnd_lookup_values flv1
                 where flv1.lookup_type = flt.lookup_type
                   and flv1.lookup_code = 'F'
              )
   and exists ( select 1 from apps.fnd_lookup_values flv2
                 where flv2.lookup_type = flt.lookup_type
                   and flv2.lookup_code = 'M'
              )
 order by lookup_type
 
 
 select
 *
 from
 apps.FND_ATTACHED_DOCUMENTS
 where 1=1
 and last_updated_by='8824'
 
 select
 *
 from
 apps.FND_DATABASES
 
 
 select
 *
 from
 apps.FND_DATABASE_INSTANCES
 
 select
 *
 from
 apps.FND_FLEX_VALUES
 
 
 select
 *
 from
 apps.fnd_menus
 
 select
 *
 from
 apps.FND_REQUEST_SETS
 
 select
 *
 from
 apps.FND_RESP_FUNCTIONS
 where 1=1
 
 select
 *
 from
 apps.FND_APP_SERVERS