select ood.organization_id, ood.organization_code
from APPS.ORG_ORGANIZATION_DEFINITIONS ood, inv.mtl_parameters mp 
where mp.organization_id=ood.organization_id
and mp.process_enabled_flag= 'Y'
and ood.legal_entity=23279