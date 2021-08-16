select
    gr.recipe_no,
--    decode(PROCESS,
--    'CONDENSED FILLING UNIT-1','CONDENSED FILLING',
--    'CONDENSED FILLING UNIT-2','CONDENSED FILLING') Process,
    to_char(cgd.production_date,'MON-YY') Production_Period,
--    PROCESS,
    case when cgd.line_type='2.Product' then cgd.concatenated_segments else null end Prod_Item,
    case when cgd.line_type='2.Product' then cgd.description else null end Prod_Item_Desc,
    case when cgd.line_type='2.Product' then cgd.PRIMARY_UOM_CODE else null end Prod_Item_UoM,
    sum(case when cgd.line_type='2.Product' then nvl(cgd.primary_quantity,0) else 0 end) Prod_Qty,
    case when cgd.line_type='2.Product' then apps.fnc_get_item_cost(cgd.organization_id,cgd.inventory_item_id,to_char(cgd.production_date,'MON-YY')) else 0 end Prod_Cost,
    sum(case when cgd.line_type='2.Product' then nvl(cgd.primary_quantity,0) else 0 end)*(case when cgd.line_type='2.Product' then apps.fnc_get_item_cost(cgd.organization_id,cgd.inventory_item_id,to_char(cgd.production_date,'MON-YY')) else 0 end) Prod_Value,
    case when cgd.line_type='1.Ingredients' then cgd.concatenated_segments else null end Ing_Item,
    case when cgd.line_type='1.Ingredients' then cgd.description else null end Ing_Item_desc,
    case when cgd.line_type='1.Ingredients' then cgd.PRIMARY_UOM_CODE else null end Ing_Item_UoM,
    sum(case when cgd.line_type='1.Ingredients' then nvl(cgd.primary_quantity,0) else 0 end) Ing_Qty,
    case when cgd.line_type='1.Ingredients' then apps.fnc_get_item_cost(cgd.organization_id,cgd.inventory_item_id,to_char(cgd.production_date,'MON-YY')) else 0 end Ing_Cost,
    sum(case when cgd.line_type='1.Ingredients' then nvl(cgd.primary_quantity,0) else 0 end)*(case when cgd.line_type='1.Ingredients' then apps.fnc_get_item_cost(cgd.organization_id,cgd.inventory_item_id,to_char(cgd.production_date,'MON-YY')) else 0 end) Ing_Value,
    case when cgd.line_type='3.By Product' then cgd.concatenated_segments else null end By_Prod_Item,
    case when cgd.line_type='3.By Product' then cgd.description else null end By_Prod_Item_desc,
    case when cgd.line_type='3.By Product' then cgd.PRIMARY_UOM_CODE else null end By_Prod_Item_UoM,
    sum(case when cgd.line_type='3.By Product' then nvl(cgd.primary_quantity,0) else 0 end) By_Prod_Qty,
    case when cgd.line_type='3.By Product' then apps.fnc_get_item_cost(cgd.organization_id,cgd.inventory_item_id,to_char(cgd.production_date,'MON-YY')) else 0 end By_Prod_Cost,
    sum(case when cgd.line_type='3.By Product' then nvl(cgd.primary_quantity,0) else 0 end)*(case when cgd.line_type='3.By Product' then apps.fnc_get_item_cost(cgd.organization_id,cgd.inventory_item_id,to_char(cgd.production_date,'MON-YY')) else 0 end) By_Prod_Value 
from
    apps.xxakg_cgd_prod_info cgd,
    gmd.gmd_recipe_validity_rules grvr,
    gme.gme_batch_header gbh,
    gmd.gmd_recipes_b gr
where
    cgd.batch_id=gbh.batch_id
    and gbh.recipe_validity_rule_id=grvr.recipe_validity_rule_id
    and grvr.recipe_id=gr.recipe_id
--    and gr.recipe_no in ('COND.CMRG.0397')
--    and cgd.process like 'CONDENSED FILLING%'
    and to_char(cgd.production_date,'MON-YY')='APR-15'
group by
    gr.recipe_no,
    cgd.production_date,
    cgd.line_type,
    cgd.organization_id,
    cgd.inventory_item_id,
    cgd.concatenated_segments,
    cgd.description,
    cgd.primary_uom_code        