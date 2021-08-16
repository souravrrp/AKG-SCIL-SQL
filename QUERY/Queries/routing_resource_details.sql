select
    distinct
    grc.recipe_no,
    grc.recipe_version,
    grc.formula_id,
    ffm.formula_no,
    ffm.formula_vers,
--    ffm.formula_desc_1,
--    ffm.formula_desc_2,
    grt.routing_no,
    grt.routing_vers,
    grt.routing_desc ,
    grt.routing_qty,
    grt.routing_uom,
    grt.*
from
    apps.gmd_recipes grc,
    apps.fm_form_mst ffm,
    apps.gmd_routings_b grt,
    apps.org_organization_definitions ood
where
    grc.formula_id=ffm.formula_id
    and grc.routing_id=grt.routing_id
--    and grt.routing_no like '%STLP%'
    and grc.owner_organization_id=grt.owner_organization_id
--    and grt.owner_organization_id=93
    and grt.EFFECTIVE_END_DATE is null
--    and rownum<10  
    
    
    
    
select 
    ood.organization_code,
    ood.organization_id,
    grt.routing_id,
    grt.routing_no,
    grt.routing_vers,
    grt.routing_uom,
    grt.routing_qty,
    gor.resources,
    rsc.COST_CMPNTCLS_ID,
    gor.resource_usage,
    gor.RESOURCE_USAGE_UOM,
    gor.process_qty,
    gor.RESOURCE_PROCESS_UOM,
    rsc.min_capacity,
    rsc.max_capacity
--    gor.*
--    rd.*
from
    apps.gmd_routings grt,
    apps.FM_ROUT_DTL rd,
    apps.GMD_OPERATION_ACTIVITIES goa,
    apps.GMD_OPERATION_RESOURCES gor,
    apps.CR_RSRC_MST_B rsc,
    apps.org_organization_definitions ood
where
    grt.routing_id=rd.routing_id
    and grt.owner_organization_id=ood.organization_id
    and rd.oprn_id=goa.oprn_id
    and goa.oprn_line_id=gor.oprn_line_id
    and gor.resources=rsc.resources
    and ood.legal_entity=23280
--    and ood.operating_unit=87
--    and rownum<10    
    
    
              