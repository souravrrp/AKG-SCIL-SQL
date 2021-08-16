

select
    ood.organization_code,
    ood.organization_id,
    ffm.formula_id,
    ffm.formula_no,
    ffm.formula_vers,
    case when fmd.line_type=1 then msi.segment1||'.'||msi.segment2||'.'||msi.segment3 else null end PRODUCT_ITEM_CODE,
    case when fmd.line_type=1 then msi.description else null end PRODUCT_ITEM_DESC,
    case when fmd.line_type=1 then fmd.detail_uom else null end PRODUCT_ITEM_UOM,
    sum(case when fmd.line_type=1 then nvl(fmd.qty,0) else 0 end) PROD_QTY,
    case when fmd.line_type=-1 then msi.segment1||'.'||msi.segment2||'.'||msi.segment3 else null end ING_ITEM_CODE,
    case when fmd.line_type=-1 then msi.description else null end ING_ITEM_DESC,
    case when fmd.line_type=-1 then fmd.detail_uom else null end ING_ITEM_UOM,
    sum(case when fmd.line_type=-1 then nvl(fmd.qty,0) else 0 end) ING_QTY,
    case when fmd.line_type=2 then msi.segment1||'.'||msi.segment2||'.'||msi.segment3 else null end BY_PRODUCT_ITEM_CODE,
    case when fmd.line_type=2 then msi.description else null end BY_PRODUCT_ITEM_DESC,
    case when fmd.line_type=2 then fmd.detail_uom else null end BY_PRODUCT_ITEM_UOM,
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
    and fmd.organization_id=msi.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and msi.organization_id=ood.organization_id
    and ood.legal_entity=23279
    and ood.operating_unit=83
    and ood.organization_code='CER'
    and ffm.formula_no like 'CPWB%'
group by
        ood.organization_code,
        ood.organization_id,
        ffm.formula_id,
    ffm.formula_no,
    ffm.formula_vers,
    fmd.line_type,
    msi.segment1,msi.segment2,msi.segment3,msi.description,
    fmd.detail_uom
order by
    formula_no,
    line_type    
