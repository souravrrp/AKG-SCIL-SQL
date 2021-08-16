/* Formatted on 2/24/2015 2:06:23 AM (QP5 v5.136.908.31019) */
  SELECT a.FORMULA_ID,
         a.formula_no,
         a.formula_vers,
         a.FORMULA_DESC1,
        b.formulaline_id,
         b.INVENTORY_ITEM_ID,
         c.description,
         b.organization_id,
         DECODE (b.line_type, -1, 'Ingredient','1', 'Product','2','By_Prod') TYPE
    FROM apps.FM_FORM_MST a, apps.FM_MATL_DTL b, inv.mtl_system_items_b c
   WHERE     a.formula_id = b.FORMULA_ID
--    and a.formula_no like 'FORMULA FOR  WB SOFIA A PACK%'
--    and a.formula_vers='2'
         AND b.ORGANIZATION_ID = :your_Org_id
--         AND a.FORMULA_CLASS <> 'COSTING'
         AND b.INVENTORY_ITEM_ID = c.inventory_item_id
         AND b.ORGANIZATION_ID = c.organization_id
         and c.segment1||'.'||c.segment2||'.'||c.segment3 in ('INDI.SPPP.0001')
--         and a.formula_no in ()
ORDER BY a.FORMULA_ID