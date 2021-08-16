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
    (SELECT r.ROUTING_NO AS Process,
          h.ACTUAL_START_DATE,
          h.actual_cmplt_date,
          h.RECIPE_VALIDITY_RULE_ID,
          h.batch_close_date,
          h.attribute3 AS Shift,
          h.attribute2 AS TO_OR_REMARKS,
          h.ATTRIBUTE1 AS Sales_Order_Number,
          APPS.get_ename_frm_enum (h.attribute6) AS Shift_Incharge,
          apps.xxakg_com_pkg.GET_EMP_NAME_FROM_USER_ID (h.attribute7)
             AS Operator_Name,
          apps.xxakg_com_pkg.GET_EMP_NAME_FROM_USER_ID (h.attribute8)
             AS Asst_operator,
          TO_DATE (h.attribute4, 'RRRR/MM/DD HH24:MI:SS') AS Production_Date,
          t.transaction_date AS trans_date,
          DECODE (h.batch_status,
                  -1, 'Cancelled',
                  1, 'Pending',
                  2, 'WIP',
                  3, 'Completed',
                  4, 'Closed')
             AS batch_status,
          h.batch_no AS batch_no,
          h.batch_id AS batch_id,
          DECODE (h.terminated_ind, 0, 'No', 'Yes') AS Terminated_Ind,
          DECODE (d.line_type,
                  -1, '1.Ingredients',
                  1, '2.Product',
                  2, '3.By Product')
             AS Line_type,
          t.organization_id,
          msi.concatenated_segments,
          msi.inventory_item_id,
          t.transaction_id,
          msi.description,
          (SELECT SEGMENT1
             FROM APPS.MTL_ITEM_CATEGORIES_V
            WHERE     INVENTORY_ITEM_ID = t.INVENTORY_ITEM_ID
                  AND ORGANIZATION_ID = t.ORGANIZATION_ID
                  AND CATEGORY_SET_NAME = 'Inventory')
             ITEM_CATEGORY,
          (SELECT SEGMENT2
             FROM APPS.MTL_ITEM_CATEGORIES_V
            WHERE     INVENTORY_ITEM_ID = t.INVENTORY_ITEM_ID
                  AND ORGANIZATION_ID = t.ORGANIZATION_ID
                  AND CATEGORY_SET_NAME = 'Inventory')
             ITEM_TYPE,
          mtt.transaction_type_name,
          t.subinventory_code,
          lt.lot_number AS lot_number,
          CASE
             WHEN lt.lot_number IS NOT NULL THEN lt.primary_quantity
             ELSE t.primary_quantity
          END
             AS primary_quantity,
          msi.PRIMARY_UOM_CODE,
          d.PLAN_QTY,
          d.wip_plan_qty,
          d.ACTUAL_QTY,
          D.ATTRIBUTE_CATEGORY,
          D.ATTRIBUTE1,
          D.ATTRIBUTE2,
          D.ATTRIBUTE3,
          D.ATTRIBUTE4,
          D.ATTRIBUTE5,
          lot.grade_code AS GRADE,
          t.secondary_transaction_quantity AS sec_qty,
          t.secondary_uom_code,
          lot.gen_object_id,
          mtr.reason_name
     FROM inv.mtl_material_transactions t,
          gme.gme_material_details d,
          gme.gme_batch_header h,
          inv.mtl_transaction_lot_numbers lt,
          inv.mtl_lot_numbers lot,
          gmd.gmd_routings_b r,
          apps.mtl_system_items_kfv msi,
          inv.mtl_transaction_types mtt,
          inv.MTL_TRANSACTION_REASONS mtr,
          apps.org_organization_definitions odd
    WHERE     t.transaction_source_type_id = 5
          AND odd.operating_unit = 84
          --AND h.batch_id in (XXXXXX)
          AND t.transaction_source_id = h.batch_id
          AND t.organization_id = h.organization_id
          AND d.batch_id = h.batch_id
          AND d.material_detail_id = t.trx_source_line_id
          AND lt.transaction_id(+) = t.transaction_id
          AND lot.lot_number(+) = lt.lot_number
          AND lot.organization_id(+) = lt.organization_id
          AND lot.inventory_item_id(+) = lt.inventory_item_id
          AND r.routing_id = h.routing_id
          AND r.owner_organization_id = h.organization_id
          AND d.inventory_item_id = msi.inventory_item_id
          AND d.organization_id = msi.organization_id
          AND t.transaction_type_id = mtt.transaction_type_id
          AND T.organization_id = odd.organization_id
          AND t.reason_id = mtr.reason_id(+)) cgd,
    gmd.gmd_recipe_validity_rules grvr,
    gme.gme_batch_header gbh,
    gmd.gmd_recipes_b gr
where
    cgd.batch_id=gbh.batch_id
    and gbh.recipe_validity_rule_id=grvr.recipe_validity_rule_id
    and grvr.recipe_id=gr.recipe_id
--    and gr.recipe_no in ('COND.CMRG.0397')
--    and cgd.process like 'CONDENSED FILLING%'
    and to_char(cgd.production_date,'MON-YY')='NOV-15'
group by
    gr.recipe_no,
    cgd.production_date,
    cgd.line_type,
    cgd.organization_id,
    cgd.inventory_item_id,
    cgd.concatenated_segments,
    cgd.description,
    cgd.primary_uom_code        