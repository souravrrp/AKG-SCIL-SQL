SELECT
       xep.legal_entity_id        "Legal Entity ID",
       xep.name                   "Legal Entity",
       hr_outl.name               "Organization Name",
       hr_outl.organization_id    "Organization ID",
       hr_loc.location_id         "Location ID",
       hr_loc.country             "Country Code",
       hr_loc.location_code       "Location Code",
       glev.flex_segment_value    "Company Code"
  FROM
       apps.xle_entity_profiles            xep,
       apps.xle_registrations              reg,
       --
       apps.hr_operating_units             hou,
       -- hr_all_organization_units      hr_ou,
       apps.hr_all_organization_units_tl   hr_outl,
       apps.hr_locations_all               hr_loc,
       --
       apps.gl_legal_entities_bsvs         glev
 WHERE
       1=1
   AND xep.transacting_entity_flag   =  'Y'
   AND xep.legal_entity_id           =  reg.source_id
   AND reg.source_table              =  'XLE_ENTITY_PROFILES'
   AND reg.identifying_flag          =  'Y'
   AND xep.legal_entity_id           =  hou.default_legal_context_id
   AND reg.location_id               =  hr_loc.location_id
   AND xep.legal_entity_id           =  glev.legal_entity_id
   --
   -- AND hr_ou.organization_id         =  hou.business_group_id
   AND hr_outl.organization_id       =  hou.organization_id
 ORDER BY hr_outl.name

--------------------------------------------------------------------------------

select
*
from
apps.xle_entity_profiles
where 1=1
and LEGAL_ENTITY_ID='23279'

select
*
from
apps.gl_legal_entities_bsvs