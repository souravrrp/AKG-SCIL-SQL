select
 msi.segment1||'.'||msi.segment2||'.'|| msi.segment3 item_code,
 msi.description,
 mc.segment1||'|'||mc.segment2 Item_category,
 gl.segment1 company,
 gl.segment2 cost_center,
 gl.segment3 Natarul_account,
 gl.segment4 Inter_company,
 gl.segment5 Future_Value,
 gl.concatenated_segments
FROM
apps.mtl_system_items_b msi, 
inv.mtl_item_categories mic ,
apps.mtl_categories mc,
apps.mtl_system_items_fvl msf,
apps.gl_code_combinations_kfv gl,
apps.fnd_flex_values_vl flex
where 
      msi.inventory_item_id=mic.inventory_item_id
and msi.organization_id=mic.organization_id
and msi.inventory_item_id=msf.inventory_item_id
and msi.organization_id=msf.organization_id
and mic.category_id=mc.category_id
and gl.code_combination_id =msi.cost_of_sales_account
and gl.segment3=flex.flex_value_meaning
and mic.organization_id=99
and mc.segment1 not in ('FINISH GOODS',  'WIP')
order by 1





SELECT MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE, 
    MSI.DESCRIPTION, 
    MC.SEGMENT1||'|'||MC.SEGMENT2 ITEM_CATEGORY, 
    MIC.ORGANIZATION_ID,
    MSF.SALES_ACCOUNT,
    MSF.COST_OF_SALES_ACCOUNT,
    MSF.EXPENSE_ACCOUNT
--     GL.CODE_COMBINATION_ID,
--     GL.CONCATENATED_SEGMENTS,
--     GL.SEGMENT2 cost_center,
--     GL.SEGMENT3 natural_account
FROM APPS.MTL_SYSTEM_ITEMS_B MSI,
          APPS.MTL_ITEM_CATEGORIES MIC,
          APPS.MTL_CATEGORIES_B MC,
          APPS.MTL_SYSTEM_ITEMS_FVL MSF
--          APPS.GL_CODE_COMBINATIONS_KFV GL
----          INV.MTL_TXN_REQUEST_LINES LNS
WHERE MSI.ORGANIZATION_ID=MIC.ORGANIZATION_ID
AND     MSI.INVENTORY_ITEM_ID=MIC.INVENTORY_ITEM_ID
AND     MSI.INVENTORY_ITEM_ID=MSF.INVENTORY_ITEM_ID
AND     MSF.ORGANIZATION_ID=MIC.ORGANIZATION_ID
AND     MIC.CATEGORY_ID=MC.CATEGORY_ID
----AND     LNS.ORGANIZATION_ID=MSI.ORGANIZATION_ID
--AND     GL.ROW_ID = MSF.ROW_ID
AND     MIC.ORGANIZATION_ID=99
----AND     MC.SEGMENT1 = 'FINISH GOODS'
----AND     MC.SEGMENT2 LIKE 'PD%'
----AND     MSI.DESCRIPTION LIKE '%YELLOW%'
----AND     MSI.SEGMENT1 LIKE 'RFWC%'
----AND     MSI.SEGMENT2 = 'LILY'
----AND     MSI.SEGMENT1 LIKE 'PANA%'
AND     MC.SEGMENT1 <> 'FINISH GOODS'
AND     MC.SEGMENT1 <> 'WIP'