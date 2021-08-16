select * from (
select
    frm.ORGANIZATION_CODE,
    grc.recipe_id,
    grc.recipe_no,
    grc.recipe_version,
    rt.ROUTING_NO,
rt.ROUTING_VERS,
rt.ROUTING_UOM,
rt.ROUTING_QTY,
rt.RESOURCES,
rt.RESOURCE_USAGE,
rt.RESOURCE_USAGE_UOM,
rt.PROCESS_QTY,
rt.RESOURCE_PROCESS_UOM,
frm.FORMULA_NO,
frm.FORMULA_VERS,
frm.item_category,
frm.PRODUCT_ITEM_CODE,
frm.PRODUCT_ITEM_DESC,
frm.PRODUCT_ITEM_P_UOM,
frm.PRODUCT_ITEM_S_UOM,
frm.PRODUCT_ITEM_F_UOM,
frm.PROD_QTY,
frm.ING_ITEM_CODE,
frm.ING_ITEM_DESC,
frm.ING_ITEM_P_UOM,
frm.ING_ITEM_S_UOM,
frm.ING_ITEM_F_UOM,
frm.ING_QTY,
frm.BY_PRODUCT_ITEM_CODE,
frm.BY_PRODUCT_ITEM_DESC,
frm.BY_PRODUCT_ITEM_P_UOM,
frm.BY_PRODUCT_ITEM_S_UOM,
frm.BY_PRODUCT_ITEM_F_UOM,
frm.BY_PROD_QTY
from
    apps.gmd_recipes grc,
    (select
    ood.organization_code,
    ood.organization_id,
    ffm.formula_id,
    ffm.formula_no,
    ffm.formula_vers,
    mc.segment1 item_category,
--    ood.organization_code owner_organization_id,
    case when fmd.line_type=1 then msi.segment1||'.'||msi.segment2||'.'||msi.segment3 else null end PRODUCT_ITEM_CODE,
    case when fmd.line_type=1 then msi.description else null end PRODUCT_ITEM_DESC,
    case when fmd.line_type=1 then msi.primary_uom_code else null end PRODUCT_ITEM_P_UOM,
    case when fmd.line_type=1 then msi.secondary_uom_code else null end PRODUCT_ITEM_S_UOM,
    case when fmd.line_type=1 then fmd.detail_uom else null end PRODUCT_ITEM_F_UOM,
    sum(case when fmd.line_type=1 then nvl(fmd.qty,0) else 0 end) PROD_QTY,
    case when fmd.line_type=-1 then msi.segment1||'.'||msi.segment2||'.'||msi.segment3 else null end ING_ITEM_CODE,
    case when fmd.line_type=-1 then msi.description else null end ING_ITEM_DESC,
    case when fmd.line_type=-1 then msi.primary_uom_code else null end ING_ITEM_P_UOM,
    case when fmd.line_type=-1 then msi.secondary_uom_code else null end ING_ITEM_S_UOM,
    case when fmd.line_type=-1 then fmd.detail_uom else null end ING_ITEM_F_UOM,
    sum(case when fmd.line_type=-1 then nvl(fmd.qty,0) else 0 end) ING_QTY,
    case when fmd.line_type=2 then msi.segment1||'.'||msi.segment2||'.'||msi.segment3 else null end BY_PRODUCT_ITEM_CODE,
    case when fmd.line_type=2 then msi.description else null end BY_PRODUCT_ITEM_DESC,
    case when fmd.line_type=2 then msi.primary_uom_code else null end BY_PRODUCT_ITEM_P_UOM,
    case when fmd.line_type=2 then msi.secondary_uom_code else null end BY_PRODUCT_ITEM_S_UOM,
    case when fmd.line_type=2 then fmd.detail_uom else null end BY_PRODUCT_ITEM_F_UOM,
    sum(case when fmd.line_type=2 then nvl(fmd.qty,0) else 0 end) BY_PROD_QTY--,
from
    apps.FM_FORM_MST ffm,
    apps.FM_MATL_DTL fmd,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood
where
    ffm.formula_id=fmd.formula_id
    and fmd.inventory_item_id=msi.inventory_item_id
    and ffm.owner_organization_id=fmd.organization_id
    and fmd.organization_id=msi.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and mic.category_set_id=1
    and msi.organization_id=ood.organization_id
--    and mc.segment1 in ('PROCESS SCRAP','GENERAL SCRAP')
    and ood.legal_entity=23279
    and ood.operating_unit=83
    and ffm.delete_mark=0
    and ood.organization_code='CER'
group by
        ood.organization_code,
        ood.organization_id,
        ffm.formula_id,
    ffm.formula_no,
    ffm.formula_vers,
    fmd.line_type,
    mc.segment1,
    msi.segment1,msi.segment2,msi.segment3,msi.description,msi.primary_uom_code,msi.secondary_uom_code,
    fmd.detail_uom ) frm,
    (select 
    ood.organization_code,
    ood.organization_id,
    grt.routing_id,
    grt.routing_no,
    grt.routing_vers,
    grt.routing_uom,
    grt.routing_qty,
    gor.resources,
    gor.resource_usage,
    gor.RESOURCE_USAGE_UOM,
    gor.process_qty,
    gor.RESOURCE_PROCESS_UOM
from
    apps.gmd_routings grt,
    apps.FM_ROUT_DTL rd,
    apps.GMD_OPERATION_ACTIVITIES goa,
    apps.GMD_OPERATION_RESOURCES gor,
    apps.org_organization_definitions ood
where
    grt.routing_id=rd.routing_id
    and grt.owner_organization_id=ood.organization_id
    and rd.oprn_id=goa.oprn_id
    and goa.oprn_line_id=gor.oprn_line_id
--    and gor.cost_cmpntcls_id=6
    and ood.legal_entity=23279
--    and grt.routing_id=1189
    and ood.operating_unit=83
    and ood.organization_code='CER'
    ) rt
where
    grc.formula_id=frm.formula_id
    and grc.routing_id=rt.routing_id    
    and grc.owner_organization_id=frm.organization_id
    and grc.owner_organization_id=rt.organization_id
    and grc.owner_organization_id=99
--    and grc.recipe_id=605
)
where
--    regexp_like(routing_no,'%%')
    organization_code in ('CER')
    and 
    routing_no='CAST'
--    and substr(recipe_no,8,1)='M'
--    and recipe_id in ()
   -- and FORMULA_NO='UWBA.SMNW.0001'
--    and formula_vers=2
--    and recipe_no='CPAP.LOTS.0001_CAST'
order by
    recipe_version    