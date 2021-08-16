/* Formatted on 7/7/2014 9:54:34 AM (QP5 v5.136.908.31019) */
SELECT a.FORMULA_ID,
       a.formula_no,
       a.FORMULA_DESC1,
       b.INVENTORY_ITEM_ID,
       c.segment1||'.'||c.segment2||'.'||c.segment3 item_code,
       c.description,
       b.organization_id,
       DECODE (b.line_type,
               -1, 'Ingredient',
               1, 'Product') Type
from 
    GMD.FM_FORM_MST_B a,
    GMD.FM_MATL_DTL b,
    inv.mtl_system_items_b c
where a.formula_id=b.FORMULA_ID
and b.ORGANIZATION_ID=:your_Org_id
--and a.FORMULA_CLASS<>'COSTING'
and b.INVENTORY_ITEM_ID=c.inventory_item_id
and b.ORGANIZATION_ID=c.organization_id
and a.formula_no like '%WB%SOFIA%PACK%'
order by a.FORMULA_ID